local Util = require("lazyvim.util")

return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>sf", "<cmd>Telescope find_files prompt_prefix=🔍<cr>", desc = "Find Files" },
      { "<leader>se", "<cmd>Telescope emoji prompt_prefix=🎄<cr>", desc = "Find Emojis" },
      { "<leader>sk", "<cmd>Telescope keymaps prompt_prefix=⌨️<cr>", desc = "Key Maps" },
      { "<leader>sg", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sG", Util.telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sw", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>sW", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
      { "<leader>sw", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
      { "<leader>sW", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
      { "<leader>sC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
    }
  end,
  config = function()
    require("telescope").load_extension("emoji")
  end,
}
