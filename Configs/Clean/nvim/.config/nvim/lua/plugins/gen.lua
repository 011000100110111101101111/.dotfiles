return {
  -- Lazy
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    keys = function()
      return {
        { "<leader>cs", "<cmd>ChatGPT prompt_prefix=💭<cr>", desc = "ChatGPT Prompt" },
        {
          "<leader>ce",
          "<cmd>ChatGPTRun explain_code prompt_prefix=🧠<cr>",
          mode = "v",
          desc = "ChatGPT Explain Code",
        },
        { "<leader>cc", "<cmd>ChatGPTRun add_tests prompt_prefix=🧪<cr>", desc = "ChatGPT Add Tests" },
        {
          "<leader>ci",
          "<cmd>ChatGPTEditWithInstructions prompt_prefix=🏗️<cr>",
          desc = "ChatGPT Interactive Edit",
        },
      }
    end,

    config = function()
      require("chatgpt").setup({
        api_key_cmd = "op read op://Personal/openaiapikey/password --no-newline",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
