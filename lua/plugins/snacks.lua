return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- This explicitly moves the explorer layout to the right edge
            layout = { layout = { position = "right" } },
          },
        },
      },
    },
  },
}
