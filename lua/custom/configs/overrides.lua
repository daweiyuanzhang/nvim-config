local M = {}

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
  vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts "Up")
end

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "cpp",
    "markdown",
    "markdown_inline",
    "regex",
    "bash",
    "go",
    "python",
    "java",
  },
  indent = {
    enable = false,
  },
}

M.mason = {
  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = false,
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },
  ensure_installed = {
    -- Lua
    "lua-language-server",
    "vimls",
    "stylua",

    -- web dev
    -- "css-lsp",
    -- "html-lsp",
    -- "typescript-language-server",
    -- "deno",
    -- "prettier",

    -- C/C++
    "clangd",
    "clang-format",

    -- Python
    "pyright",
    -- Go
    -- "gopls",

    -- C#
    -- "omnisharp",
  },
}

M.colorizer = {
  filetypes = {
    css = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- "Name" codes like Blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    },
    html = { mode = "background" },
    markdown = { names = false },
    lua = { names = false },
    "*",
  },
}

M.telescope_pickers = {
  oldfiles = {
    prompt_title = "Recent Files",
  },
}

M.nvimtree = {
  on_attach = on_attach,
  diagnostics = {
    enable = false,
    icons = {
      hint = "󰌵",
      info = "",
      warning = "",
      error = "",
    },
  },
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 5000,
  },
  view = {
    cursorline = false,
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },

  renderer = {
    highlight_git = false,
    root_folder_label = false,
    -- root_folder_label = ":~:s?$?/..?",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },

        git = {
          unstaged = "",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

M.toggleterm = {
  size = 10,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_terminals = false,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  autochdir = true,
  highlights = {
    NormalFloat = {
      link = "Normal",
    },
    FloatBorder = {
      link = "FloatBorder",
    },
  },
  float_opts = {
    border = "rounded",
    winblend = 0,
  },
}

M.todo_comments = {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = "󰥔 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "󱞁 ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}

M.lspsaga = {
  preview = {
    lines_above = 0,
    lines_below = 10,
  },

  code_action = {
    num_shortcut = true,
    keys = {
      quit = ";",
      exec = "<CR>",
    },
  },

  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  request_timeout = 2000,

  lightbulb = {
    enable = false,
    enable_in_insert = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },

  rename = {
    quit = ";",
    exec = "<CR>",
    in_select = false,
  },

  finder = {
    edit = { "o", "<CR>" },
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = { ";", "<ESC>" },
  },

  diagnostic = {
    insert_winblend = 0,
    jump_num_shortcut = true,
    on_insert = false,
    on_insert_follow = false,
    show_code_action = true,
    show_source = true,
    custom_fix = nil,
    custom_msg = nil,
    text_hl_follow = false,
    border_follow = true,
    keys = {
      exec_action = "o",
      quit = ";",
    },
  },

  symbol_in_winbar = {
    enable = false,
    separator = "  ",
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
  },

  definition = {
    edit = "<C-c>o",
    vsplit = "<C-c>v",
    split = "<C-c>i",
    tabe = "<C-c>t",
    quit = ";",
    close = "<Esc>",
  },

  ui = {
    theme = "round",
    border = "rounded",
    winblend = 0,
    expand = "",
    collaspe = "",
    preview = " ",
    code_action = "󱧣 ",
    diagnostic = "🐞",
    hover = " ",
    kind = {},
  },

  outline = {
    win_position = "right",
    win_with = "",
    win_width = 30,
    show_detail = true,
    auto_preview = true,
    auto_refresh = true,
    auto_close = true,
    custom_sort = nil,
    keys = {
      jump = "o",
      expand_collaspe = "u",
      quit = ";",
    },
  },

  callhierarchy = {
    show_detail = false,
    keys = {
      edit = "e",
      vsplit = "s",
      split = "i",
      tabe = "t",
      jump = "o",
      quit = ";",
      expand_collaspe = "u",
    },
  },
}

M.flash = {
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    -- search/jump in all windows
    multi_window = true,
    -- search direction
    forward = true,
    -- when `false`, find only matches in the given direction
    wrap = true,
    -- Each mode will take ignorecase and smartcase into account.
    -- * exact: exact match
    -- * search: regular search
    -- * fuzzy: fuzzy search
    -- * fun(str): custom function that returns a pattern
    --   For example, to only match at the beginning of a word:
    --   mode = function(str)
    --     return "\\<" .. str
    --   end,
    mode = "exact",
    -- behave like `incsearch`
    incremental = true,
    -- Excluded filetypes and custom window filters
    exclude = {
      "notify",
      "noice",
      "cmp_menu",
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
    -- Optional trigger character that needs to be typed before
    -- a jump label can be used. It's NOT recommended to set this,
    -- unless you know what you're doing
    trigger = "",
  },
  jump = {
    -- save location in the jumplist
    jumplist = true,
    -- jump position
    pos = "start", ---@type "start" | "end" | "range"
    -- add pattern to search history
    history = false,
    -- add pattern to search register
    register = false,
    -- clear highlight after jump
    nohlsearch = true,
    -- automatically jump when there is only one match
    autojump = false,
  },
  modes = {
    -- options used when flash is activated through
    -- a regular search with `/` or `?`
    search = {
      enabled = true, -- enable flash for search
      highlight = { backdrop = false },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        -- `forward` will be automatically set to the search direction
        -- `mode` is always set to `search`
        -- `incremental` is set to `true` when `incsearch` is enabled
      },
    },
    -- options used when flash is activated through
    -- `f`, `F`, `t`, `T`, and `,` motions
    char = {
      enabled = false,
      -- by default all keymaps are enabled, but you can disable some of them,
      -- by removing them from the list.
      keys = { "f", "F", "t", "T", "," },
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    -- options used for remote flash
    remote = {},
  },
}

M.neodev = {
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = false,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
}

return M