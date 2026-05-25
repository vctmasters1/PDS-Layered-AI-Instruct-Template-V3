// The ONLY place that touches the database. Throws domain errors, not HTTP.
// Per .ai/instruct.md → Module-Specific Rules § Layering.

export interface UserRow {
  id: string;
  email: string;
  passwordHash: string;
}

// Stub. Real impl would use the data-layer module's repository base class.
export const userRepository = {
  async findByEmail(email: string): Promise<UserRow | null> {
    // SELECT id, email, password_hash FROM users WHERE email = $1
    void email;
    return null;
  },
};
