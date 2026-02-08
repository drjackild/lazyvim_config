local M = {}

---@alias NotesBackend "obsidian" | "zk"

-- Cache the config to avoid repeated file reads
local _config = nil

local function load_config()
  if _config ~= nil then
    return _config
  end

  _config = {}
  -- Search for .neoconf.json in current dir and parents
  -- Using vim.loop.cwd() to be explicit
  local cwd = vim.loop.cwd()
  local config_path = cwd .. "/.neoconf.json"

  -- Try to find it upward if not in cwd
  if vim.fn.filereadable(config_path) == 0 then
    local found = vim.fs.find(".neoconf.json", { upward = true, stop = vim.env.HOME })
    if #found > 0 then
      config_path = found[1]
    end
  end

  if vim.fn.filereadable(config_path) == 1 then
    local f = io.open(config_path, "r")
    if f then
      local content = f:read("*a")
      f:close()
      local ok, json = pcall(vim.json.decode, content)
      if ok and json and json.notes then
        _config = json.notes
      end
    end
  end
  return _config
end

---@return NotesBackend
function M.get_backend()
  local config = load_config()
  if config.backend then
    return config.backend
  end

  -- Fallback to global variable or default
  return vim.g.notes_backend or "obsidian"
end

---@return string
function M.get_path()
  local config = load_config()
  if config.path then
    return config.path
  end

  return vim.g.notes_path or "~/zettel"
end

---@return string
function M.get_daily_folder()
  local config = load_config()
  if config.daily_folder then
    return config.daily_folder
  end
  return vim.g.notes_daily_folder or "daily"
end

return M
