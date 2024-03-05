return {
   -- Surround functionality
     'kylechui/nvim-surround',
     version = '*',
     event = "VeryLazy",
     config = function()
       require('nvim-surround').setup()
      end,

  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
