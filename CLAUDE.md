# jupytext.nvim

Neovim plugin that opens `.ipynb` files as plain text through the `jupytext` CLI and writes edits back on save.
User docs: [README.md](README.md).

## Layout

| Path | Contents |
| --- | --- |
| `lua/jupytext/init.lua` | `setup`, the `BufReadCmd` handler `read_from_ipynb`, `write_to_ipynb`, `cleanup`, `style_and_extension` |
| `lua/jupytext/utils.lua` | Notebook metadata (`get_ipynb_metadata`), language → extension table, text file name, filetype |
| `lua/jupytext/commands.lua` | `run_jupytext_command`, which builds and runs the `jupytext` shell command |
| `lua/jupytext/health.lua` | `:checkhealth jupytext` |

Flow: opening a notebook runs `read_from_ipynb`, which converts it to a text file next to it and loads that into
the buffer, then adds buffer-local autocmds in the `jupytext-nvim` group: `BufWriteCmd`/`FileWriteCmd` run
`write_to_ipynb` (`jupytext --update --to ipynb`), and `BufUnload` runs `cleanup`, which deletes the text file if
the plugin created it.

## Where to add X

- A config option: the defaults in `M.config` and the checks in `M.setup` (`init.lua`), and the table in the
  README.
- A notebook language: `language_extensions` in `utils.lua`, kept in step with jupytext's `languages.py`.

## Checking a change

There are no tests. Open a notebook headless from the repo root, from PowerShell rather than Git Bash (Neovim
inherits Git Bash's shell and the `jupytext` call fails):

```
nvim --clean --headless --cmd "set rtp+=." -c "lua require('jupytext').setup()" -c "e test.ipynb" -c "lua print(vim.bo.filetype)" -c "qa!"
```

## Conventions

- Format with StyLua (`stylua.toml`: 2 spaces, 110 columns).
- Code must run on Neovim 0.11 or later.
- Commits use Conventional Commits (`feat:`, `fix:`, `docs:`).
