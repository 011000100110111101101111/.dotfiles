return {
  { --📰 Pretty-fold {{{
    "anuvyklack/pretty-fold.nvim",
    opts = {
      sections = {
        left = {
          "╘╾",
          "content",
          "⮯ ",
        },
        right = {
          " ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          " ╼╕",
        },
      },
      fill_char = "⋅",
      process_comment_signs = "delete",
    },
  }, -- }}}
}
