# maytech-labs/homebrew-tap

Homebrew formulae for maytech-labs tools.

```sh
brew tap maytech-labs/tap
brew trust maytech-labs/tap
brew install arm-tools
```

Or in one step: `brew install maytech-labs/tap/arm-tools`, after trusting the tap.

| Formula | What it is |
|---|---|
| [`arm-tools`](Formula/arm-tools.rb) | [arm-tools](https://github.com/maytech-labs/arm-tools): language server, linter, and formatter for AArch64 assembly. Apple silicon. |

## Updating a formula

Each tool's release workflow commits its own formula bump here, as `chore(<formula>): X.Y.Z`. Edit a formula by hand only for changes a release doesn't make, and check it with:

```sh
brew style Formula/<formula>.rb
brew audit --strict maytech-labs/tap/<formula>
brew reinstall maytech-labs/tap/<formula> && brew test <formula>
```
