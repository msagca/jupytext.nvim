local M = {}

local language_extensions = {
  python = "py",
  julia = "jl",
  r = "r",
  R = "r",
  bash = "sh",
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
  local metadata = vim.json.decode(content)["metadata"]
  local language = metadata.kernelspec.language
  if language == nil then
    language = language_names[metadata.kernelspec.name]
  end
  local extension = language_extensions[language]

  return { language = language, extension = extension }
end

M.get_jupytext_file = function(filename, extension)
  local fileroot = vim.fn.fnamemodify(filename, ":r")
  return fileroot .. "." .. extension
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
