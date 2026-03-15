return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      cucumber_language_server = {
        settings = {
          cucumber = {
            -- Tell the LSP where your feature files are located
            features = { "src/test/resources/**/*.feature" },
            -- Tell the LSP where your Java step definitions (glue) are located
            glue = { "src/test/java/**/*.java" },
          },
        },
      },
    },
  },
}
