# validate-instructions.ps1
# Lint the AI-INSTRUCT system for common drift issues.
# Run from the project root:  pwsh .github/scripts/validate-instructions.ps1
#
# Checks:
#   1. No live instruction file leaves `[DATE]` as a literal placeholder
#      (template-scaffold files inside .github/prompts/ are exempt).
#   2. No file uses the retired `§` cross-reference syntax.
#   3. Any .ai/instruct.md or .ai/*.md with 5+ `##` sections has a `## Contents` table.
#   4. Frontmatter sanity: every *.prompt.md declares a `mode:` field;
#      every *.agent.md declares `description:` and (recommended) `tools:`.
#   5. Relative markdown links resolve. Every `](path)` link (skipping http,
#      https, mailto, and pure `#anchor` links) is resolved against the
#      containing file's directory and flagged if the target does not exist.
#      (node_modules/ directories are excluded from this check.)
#
# Exit code is 0 on success, 1 on any failure. Safe to wire into a pre-commit hook.

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path "$PSScriptRoot/../..").Path
Set-Location $root

$problems = New-Object System.Collections.Generic.List[string]

function Add-Problem([string]$msg) { $problems.Add($msg) | Out-Null }

# Files to scan: every markdown under .ai/ and every */.ai/instruct.md and the meta file.
$instructionFiles = @(
  Get-ChildItem -Path . -Recurse -Force -File -Filter '*.md' |
  Where-Object {
    $rel = $_.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    ($rel -like '.ai/*' -or $rel -like '*/.ai/*' -or $rel -eq '.github/copilot-instructions.md') -and
    $rel -notlike '*/.dev-docs/.old/*' -and
    $rel -notlike '.archive/*'
  }
)

foreach ($f in $instructionFiles) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $text = Get-Content -Raw -LiteralPath $f.FullName
  $isTemplate = $rel -like '.github/prompts/*'

  # 1. [DATE] placeholder check (skip template scaffolds).
  #    Match only at the start of a line so prose mentions like `**Last Updated**: [DATE]`
  #    inside backticks (used to *describe* the rule) are not flagged.
  if (-not $isTemplate -and $text -match '(?m)^\*\*Last Updated\*\*:\s*\[DATE\]') {
    Add-Problem "[DATE] placeholder unfilled: $rel"
  }

  # 2. § syntax check
  if ($text -match '\.md\s*§\s') {
    Add-Problem "Retired \u00a7 cross-reference syntax: $rel"
  }

  # 3. TOC requirement
  $h2Count = ([regex]::Matches($text, '(?m)^## ')).Count
  if ($h2Count -ge 5 -and $text -notmatch '(?m)^## Contents\b') {
    Add-Problem "Missing '## Contents' table (file has $h2Count sections): $rel"
  }
}

# 4. Frontmatter sanity for prompts and agents
$promptFiles = Get-ChildItem -Path .github/prompts -Filter '*.prompt.md' -File -ErrorAction SilentlyContinue
foreach ($f in $promptFiles) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $head = (Get-Content -LiteralPath $f.FullName -TotalCount 10) -join "`n"
  if ($head -notmatch '(?m)^mode:\s*(ask|edit|agent)\s*$') {
    Add-Problem "Prompt missing 'mode: ask|edit|agent' in frontmatter: $rel"
  }
  if ($head -notmatch '(?m)^description:\s*\S') {
    Add-Problem "Prompt missing 'description:' in frontmatter: $rel"
  }
}

$agentFiles = Get-ChildItem -Path .github/agents -Filter '*.agent.md' -File -ErrorAction SilentlyContinue
foreach ($f in $agentFiles) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $head = (Get-Content -LiteralPath $f.FullName -TotalCount 30) -join "`n"
  if ($head -notmatch '(?m)^description:') {
    Add-Problem "Agent missing 'description:' in frontmatter: $rel"
  }
}

# 5. Relative link checker. Scan every .md file (excluding archives) and resolve
#    relative `](target)` links against the linking file's directory.
$allMdFiles = Get-ChildItem -Path . -Recurse -Force -File -Filter '*.md' |
Where-Object {
  $rel = $_.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $rel -notlike '.archive/*' -and $rel -notlike '*/.dev-docs/.old/*' -and $rel -notlike '*/node_modules/*'
}

$linkRegex = [regex]'\]\(([^)\s]+?)(?:\s+"[^"]*")?\)'
$fenceRegex = [regex]'(?ms)(^|\n)```.*?(\n```|\z)'
# Path fragments that always indicate an illustrative example, not a real link.
$placeholderFragments = @(
  'path/to/',
  'relative/path',
  'new/path/',
  'path\to\',
  '/some-module/',
  '<file>',
  '<path>'
)
foreach ($f in $allMdFiles) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  $text = Get-Content -Raw -LiteralPath $f.FullName
  # Strip fenced code blocks so example links inside ``` ... ``` are not checked.
  $textNoFences = $fenceRegex.Replace($text, '')
  $dir = Split-Path -Parent $f.FullName

  foreach ($m in $linkRegex.Matches($textNoFences)) {
    $target = $m.Groups[1].Value
    # Skip URLs, mailto, pure anchors, code-like fragments
    if ($target -match '^(https?:|mailto:|#|tel:|ftp:)') { continue }
    # Strip any #anchor fragment from the target before resolving.
    $pathPart = ($target -split '#', 2)[0]
    if (-not $pathPart) { continue }
    # Skip targets that look like placeholders or shell snippets.
    if ($pathPart -match '[<>`*\s]' -or $pathPart -match '\[.*\]') { continue }
    $isPlaceholder = $false
    foreach ($frag in $placeholderFragments) {
      if ($pathPart.IndexOf($frag, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $isPlaceholder = $true; break
      }
    }
    if ($isPlaceholder) { continue }

    try {
      $full = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($dir, $pathPart))
    }
    catch {
      Add-Problem "Unresolvable link '$target' in $rel"
      continue
    }
    if (-not (Test-Path -LiteralPath $full)) {
      Add-Problem "Broken link '$target' in $rel"
    }
  }
}

if ($problems.Count -eq 0) {
  Write-Host "OK: AI-INSTRUCT validation passed ($($instructionFiles.Count) files scanned)." -ForegroundColor Green
  exit 0
}
else {
  Write-Host "FAIL: $($problems.Count) issue(s) found:" -ForegroundColor Red
  foreach ($p in $problems) { Write-Host "  - $p" -ForegroundColor Yellow }
  exit 1
}
