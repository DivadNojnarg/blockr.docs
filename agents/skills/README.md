# Skills

A collection of optional Claude Code skills for the blockr ecosystem. Each is self-contained — install only what you want.

## Install

```sh
cp -r blockr.docs/agents/skills/<name> ~/.claude/skills/
```

Restart Claude Code (or wait for skill auto-discovery). To uninstall, delete the folder under `~/.claude/skills/`.

## Available

| Skill | When to use |
|---|---|
| [blockr-spec](./blockr-spec/) | Writing or continuing a design spec. Enforces the four-phase flow (motivation → requirements → design → implementation) and stops you jumping ahead. |
| [blockr-block](./blockr-block/) | Adding a new block to a blockr package. Walks through the R-driven vs JS-driven choice, starts new packages from the [scaffolds](../../scaffolds/), writes the matching tests, hands off to Playwright for verification. |

## Browser verification

`blockr-block` finishes by verifying the block in a real board, which needs a
skill that can drive a running Shiny app. It does not ship here. Any of these
works:

- A Playwright MCP setup, driving the app the skill starts.
- The `shiny-chromote-inspect` skill, or `{chromote}` directly.

Whichever you use, verify against the **board demo** (`app.R` in the scaffold),
not a standalone `shiny::runApp()` of the block on its own. A block that works
in isolation and breaks in a board is the common failure, and only the board
catches it.

## Coming later

- **blockr-workflow** — drives the dashboard-building workflow (discover → add
  → configure → serve), currently shipped by `blockr.mcp::install_skill()`.
  Deferred until `blockr.mcp` is restructured around live Shiny app control.
