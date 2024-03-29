return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "catppuccin-macchiato",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Trying to keep the neovide rememeber window size setting
    if vim.g.neovide then
      vim.g.neovide_remember_window_size = true
    end

    -- Remove trailing whitespace on save... so not to dependend on linting
    vim.api.nvim_create_autocmd ('BufWritePre',{
      pattern = "*", -- run on all filetypes
      command = [[%s/\s\+$//e]], -- remove trailing whitespace
      desc = "remove trailing whitespace",
    })

    -- Set up spec opener for Ruby files
    local setup_spec_opener = function()
      vim.keymap.set(
        'n',
        '<leader>t',
        function()
          local current_file = vim.fn.expand('%:p')
          local corresponding_file

          -- Detect if it's a source or test file
          if current_file:match('_spec%.') then
            corresponding_file = current_file:gsub('spec/', 'app/'):gsub('spec/lib/', 'lib/'):gsub('_spec%.', '.')
          else
            corresponding_file = current_file:gsub('app/', 'spec/'):gsub('lib/', 'spec/lib/'):gsub('%.%w+$', '_spec%0')
          end

          vim.cmd('edit ' .. corresponding_file)
        end,
        { desc = 'Spec opener', }
      )
    end
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'ruby',
      callback = setup_spec_opener,
      desc = 'Setup spec opener'
    })

    -- Set up Telescope live grep for selected word: better <leader>fc from astro
    vim.keymap.set('v', '<leader>f', function()
      vim.api.nvim_input('y')
      vim.api.nvim_input('<cmd> Telescope live_grep <CR>')
      vim.api.nvim_input('<c-r>')
      vim.api.nvim_input('0')
    end, { desc = 'Telescope live grep for selection' })

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
