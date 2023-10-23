return {
  -- This is for LSP, check :Mason to look for available LSP servers. Has to be full name in white.
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "bash-language-server",
        "ansible-language-server",
        "css-lsp",
      },
      automatic_installation = true,
    },
  },

  -- add pyright to lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- pyright will be automatically installed with mason and loaded with lspconfig
  --       pyright = {},
  --     },
  --   },
  -- },
}
