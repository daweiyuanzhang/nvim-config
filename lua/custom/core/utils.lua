local command = vim.api.nvim_create_user_command

function _G.format_code()
  return vim.lsp.buf.format {
    async = true,
    filter = function(client)
      local supported_formatters = list_registered_formatters(vim.bo.filetype)
      for _, formatter in pairs(supported_formatters) do
        if vim.fn.executable(formatter) == 1 then
          return client.name == "null-ls"
        end
      end

      return client.name ~= "null-ls"
    end,
  }
end

local provider_cache = {}

function _G.list_registered_providers_names(filetype)
  if not provider_cache[filetype] then
    local s = require "null-ls.sources"
    local available_sources = s.get_available(filetype)
    local registered = {}
    for _, source in ipairs(available_sources) do
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.generator.opts.command)
      end
    end
    provider_cache[filetype] = registered
  end
  return provider_cache[filetype]
end

function _G.list_registered_formatters(filetype)
  local registered_providers = list_registered_providers_names(filetype)
  local method = require("null-ls").methods.FORMATTING
  return registered_providers[method] or {}
end

command("Format", function()
  format_code()
  vim.notify("Format Done", vim.log.levels.INFO, { title = "Format" })
end, { nargs = "*", desc = "Code Format" })

command("LuaSnipEdit", function()
  require("luasnip.loaders").edit_snippet_files()
end, { nargs = "*", desc = "Edit the available snippets in the filetype" })

-- HUUUUUUUUUUUUUUUUUUUUUUUGE kudos and thanks to
-- https://github.com/hown3d for this function <3
local function substitute(cmd)
  cmd = cmd:gsub("%%", vim.fn.expand "%")
  cmd = cmd:gsub("$fileBase", vim.fn.expand "%:r")
  cmd = cmd:gsub("$filePath", vim.fn.expand "%:p")
  cmd = cmd:gsub("$file", vim.fn.expand "%")
  cmd = cmd:gsub("$dir", vim.fn.expand "%:p:h")
  cmd = cmd:gsub(
    "$moduleName",
    vim.fn.substitute(vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand "%:r", ":~:."), "/", ".", "g"), "\\", ".", "g")
  )
  cmd = cmd:gsub("#", vim.fn.expand "#")
  cmd = cmd:gsub("$altFile", vim.fn.expand "#")

  return cmd
end

function _G.run_code()
  local fileExtension = vim.fn.expand "%:e"
  local selectedCmd = ""
  local options = "bot 10 new | term "
  local supportedFiletypes = {
    html = {
      default = "%",
    },
    c = {
      default = "gcc % -o $fileBase && $fileBase",
      make = "make",
    },
    cs = {
      default = "dotnet run",
    },
    cpp = {
      default = "g++ % -o  $fileBase && $fileBase",
      debug = "g++ -g % -o  $fileBase",
      competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && $fileBase<input.txt",
      make = "make",
    },
    py = {
      default = "python %",
    },
    go = {
      default = "go run %",
    },
    java = {
      default = "java %",
    },
    js = {
      default = "node %",
      debug = "node --inspect %",
    },
    ts = {
      default = "tsc % && node $fileBase",
    },
    rs = {
      default = "rustc % && $fileBase",
    },
    php = {
      default = "php %",
    },
    r = {
      default = "Rscript %",
    },
    jl = {
      default = "julia %",
    },
    rb = {
      default = "ruby %",
    },
    pl = {
      default = "perl %",
    },
  }

  if supportedFiletypes[fileExtension] then
    local choices = {}
    for choice, _ in pairs(supportedFiletypes[fileExtension]) do
      table.insert(choices, choice)
    end

    if #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selectedCmd = supportedFiletypes[fileExtension][choices[1]]
      vim.cmd(options .. substitute(selectedCmd))
    else
      vim.ui.select(choices, { prompt = "Choose: " }, function(choice)
        selectedCmd = supportedFiletypes[fileExtension][choice]
        if selectedCmd then
          vim.cmd(options .. substitute(selectedCmd))
        end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end