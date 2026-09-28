local M = {}

-- Mirrors the languages jupytext supports (jupytext/languages.py), so the
-- plugin expects the same file jupytext writes. Looked up case-insensitively
local language_extensions = {
  python = "py",
  python2 = "py",
  python3 = "py",
  pypy = "py",
  julia = "jl",
  r = "r",
  bash = "sh",
  sh = "sh",
  ["c++"] = "cpp",
  ["c#"] = "cs",
  cs = "cs",
  csharp = "cs",
  ["f#"] = "fsx",
  fs = "fsx",
  fsharp = "fsx",
  clojure = "clj",
  coconut = "coco",
  gnuplot = "gp",
  go = "go",
  groovy = "groovy",
  haskell = "hs",
  idl = "pro",
  java = "java",
  javascript = "js",
  js = "js",
  logtalk = "lgt",
  lua = "lua",
  matlab = "m",
  octave = "m",
  maxima = "mac",
  ocaml = "ml",
  powershell = "ps1",
  q = "q",
  robotframework = "robot",
  rust = "rs",
  sage = "sage",
  sas = "sas",
  scala = "scala",
  scheme = "ss",
  sos = "sos",
  stata = "do",
  tcl = "tcl",
  typescript = "ts",
  ["wolfram language"] = "wolfram",
  xonsh = "xsh",
}

local language_names = {
  python3 = "python",
}

M.get_ipynb_metadata = function(filename)
  -- Close the handle explicitly: a leaked handle is inherited by every process
  -- spawned afterwards (e.g. LSP servers) and on Windows it blocks jupytext from
  -- replacing the notebook on write
  local file = assert(io.open(filename, "r"))
  local content = file:read "a"
  file:close()
  -- Notebooks that were never run with a kernel may lack kernelspec and/or
  -- language_info
  local metadata = vim.json.decode(content)["metadata"] or {}
  local kernelspec = metadata.kernelspec or {}
  local language_info = metadata.language_info or {}

  local language = kernelspec.language or language_names[kernelspec.name] or language_info.name
  local extension = language and language_extensions[language:lower()]
  if extension == nil and language_info.file_extension then
    extension = language_info.file_extension:gsub("^%.", "")
  end

  return { language = language, extension = extension }
end

M.get_jupytext_file = function(filename, extension)
  if extension == nil then
    error(
      "jupytext.nvim: couldn't determine the language of "
        .. filename
        .. ", set output_extension to open it (e.g. output_extension = \"py\")",
      0
    )
  end
  local fileroot = vim.fn.fnamemodify(filename, ":r")
  return fileroot .. "." .. extension
end

-- Use the notebook language as filetype when Neovim knows it (e.g. "bash"),
-- otherwise detect it from the jupytext file (e.g. "c++" -> "cpp")
M.get_filetype = function(language, filename)
  if language and vim.list_contains(vim.fn.getcompletion("", "filetype"), language) then
    return language
  end
  return vim.filetype.match({ filename = filename })
end

M.check_key = function(tbl, key)
  for tbl_key, _ in pairs(tbl) do
    if tbl_key == key then
      return true
    end
  end

  return false
end

return M
