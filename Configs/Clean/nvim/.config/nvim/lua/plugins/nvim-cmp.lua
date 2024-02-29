-- Define sources outside the return statement
local sources = {
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "path" },
  { name = "emoji" },
}

-- Your LazyVim configuration
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- Include the defined sources in nvim-cmp configuration
      opts.sources = sources
    end,
  },
}
