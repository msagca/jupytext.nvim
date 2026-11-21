# jupytext.nvim

Open [Jupyter notebooks](https://jupyter.org) in Neovim as plain text and
write your edits back to the notebook on save. The conversion is done by
[jupytext](https://github.com/mwouts/jupytext).

This is a fork of
[GCBallesteros/jupytext.nvim](https://github.com/GCBallesteros/jupytext.nvim),
a Lua port of [goerz/jupytext.vim](https://github.com/goerz/jupytext.vim).

## Requirements

Neovim 0.11 or later and the `jupytext` CLI on your `PATH`:

```sh
pip install jupytext
```

Run `:checkhealth jupytext` to check that Neovim can find it.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "msagca/jupytext.nvim", lazy = false, opts = {} }
```

> Load the plugin at startup. If it loads after a notebook is opened, the
> buffer shows the notebook's raw JSON.

Without a plugin manager, call `setup` from your config:

```lua
require("jupytext").setup()
```

## Usage

Opening `notebook.ipynb` converts it to a text file next to it, such as
`notebook.py`, and loads that into the buffer. Writing the buffer updates the
notebook with `jupytext --update`, which keeps the cell outputs. If the text
file didn't exist before, it is deleted when the buffer is unloaded.

## Configuration

These are the defaults:

```lua
require("jupytext").setup({
  style = "hydrogen",
  output_extension = "auto",
  force_ft = nil,
  custom_language_formatting = {},
})
```

| Option | Description |
| --- | --- |
| `style` | jupytext format, e.g. `hydrogen`, `percent`, `light`, `markdown`, `quarto` |
| `output_extension` | Text file extension. `auto` picks it from the notebook's language. |
| `force_ft` | Buffer filetype. `nil` uses the notebook's language. |
| `custom_language_formatting` | Per-language settings, keyed by the notebook's language |

> If the notebook's metadata doesn't name a language, set
> `output_extension` to open it.

Some style and extension pairs are rejected by jupytext, such as the `md`
extension with the `quarto` style.

### Per-language settings

Each entry sets `extension`, `style` and, optionally, `force_ft`. This opens
Python notebooks as Quarto documents:

```lua
custom_language_formatting = {
  python = {
    extension = "qmd",
    style = "quarto",
    force_ft = "quarto",
  },
}
```

> Without `force_ft`, the buffer gets the notebook's language as its filetype
> (`python` here). Set it for document formats so that plugins such as
> [otter.nvim](https://github.com/jmbuhr/otter.nvim) see the right filetype.
