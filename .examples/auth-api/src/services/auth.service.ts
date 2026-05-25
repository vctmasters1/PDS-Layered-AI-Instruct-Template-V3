// Business logic. Calls repositories, throws DOMAIN errors (not HTTP).
// Per auth-api/.ai/instruct.md → Module-Specific Rules → Layering.

import { userRepository } from '../repositories/user.repository.js';
import { verifyPassword } from '../lib/hash.js';
import { issueAccessToken, issueRefreshToken } from './token.service.js';
import { InvalidCredentialsError } from '../lib/errors.js';
import { timingSafeEqualStr } from '../lib/timing.js';

export const authService = {
  async login(email: string, password: string) {
    const user = await userRepository.findByEmail(email);
    // Hash a dummy even on miss so attackers can't time-distinguish.
    const hash = user?.passwordHash ?? '$argon2id$v=19$m=65536,t=3,p=4$dummy$dummy';
    const ok = await verifyPassword(hash, password);

    if (!user || !ok) {
      throw new InvalidCredentialsError();
    }

    // Defence-in-depth: Security Rule 7 — timing-safe email match.
    if (!timingSafeEqualStr(user.email, email)) {
      throw new InvalidCredentialsError();
    }

    return {
      access: issueAccessToken(user.id),
      refresh: await issueRefreshToken(user.id),
    };
  },
};
