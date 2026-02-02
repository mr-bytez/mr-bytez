# PROJECT_NOTES

This repository is optimized for a Fish-first workflow (mr-bytez style).

## Fish Shell Standards
- We primarily write scripts in **Fish**.
- Avoid heredocs/EOF patterns. For generating files use **printf** + redirection.

## Tokens, Keys, and the `cat` Alias
- In this project `cat` may be aliased to `bat`.
- **Do not use the `cat` alias for reading tokens/keys** because formatting/CRLF can break secrets.
- Use `command cat` or `/usr/bin/cat` instead.
- Recommended sanitize pattern (Fish):
  - `string replace -a \r \"\" | string trim`

## Security Baseline
- No plaintext secrets in the public repo.
- Secrets live in the private submodule: `shared/.secrets`.

