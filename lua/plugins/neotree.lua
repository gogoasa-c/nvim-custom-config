return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "right", -- Keeps it on the right hand side
    },
    filesystem = {
      group_empty_dirs = true, -- THIS is the IntelliJ "Compact Middle Packages" feature
    },
  },
}
