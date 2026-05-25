import { describe, it, expect, vi } from 'vitest';
import { authService } from '../../src/services/auth.service.js';
import { InvalidCredentialsError } from '../../src/lib/errors.js';

// Demonstrates the rule: unit tests mock the repository.
vi.mock('../../src/repositories/user.repository.js', () => ({
  userRepository: {
    findByEmail: vi.fn().mockResolvedValue(null),
  },
}));

describe('authService.login', () => {
  it('throws InvalidCredentialsError when user does not exist', async () => {
    await expect(authService.login('nobody@example.com', 'correct-horse-battery-staple'))
      .rejects.toBeInstanceOf(InvalidCredentialsError);
  });
});
