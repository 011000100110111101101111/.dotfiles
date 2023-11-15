return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_filetypes = { "markdown", "html" }
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 1
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
