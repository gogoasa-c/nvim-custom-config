local map = vim.keymap.set

-- ==========================================
-- 1. General Settings
-- ==========================================
-- LazyVim already handles incsearch, clipboard, which-key, ignorecase, etc.
vim.opt.scrolloff = 5
map("n", "Q", "gq", { desc = "Format text block" })

-- ==========================================
-- 2. Config Navigation
-- ==========================================
map("n", "\\e", "<cmd>e ~/AppData/Local/nvim/init.lua<CR>", { desc = "Edit Neovim config" })
-- Note: Reloading config dynamically (\r) is unsafe in modern Neovim.
-- It is highly recommended to just close and reopen Neovim to apply changes.

-- ==========================================
-- 3. IDE Actions -> Neovim LSP / Window Actions
-- ==========================================
-- Go To Line (Neovim native is just typing the number and Shift+G, but we can map this to open the command line)
map("n", "<leader>gtl", ":", { desc = "Go To Line (type number and press enter)" })

-- Window Splitting (LazyVim also maps <leader>| and <leader>-)
map("n", "<leader>sv", "<C-w>v", { desc = "Split Vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split Horizontally" })

-- Close Editor / Buffer (LazyVim default is also <leader>bd)
map("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close Buffer (Editor)" })

-- Go To Implementation
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go To Implementation" })

-- Reformat Code (LazyVim default is also <leader>cf)
map("n", "<leader>rc", function()
  vim.lsp.buf.format()
end, { desc = "Reformat Code" })

-- Optimize Imports via Java LSP
map("n", "<leader>io", function()
  vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
end, { desc = "Optimize Imports" })

-- ==========================================
-- 4. Debugger & Runner (nvim-dap)
-- ==========================================
map("n", "<leader>b", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

-- WARNING: In LazyVim, `<leader>d` is the prefix for a huge menu of debug tools.
-- Overriding it to just "Start Debug" will hide that menu. If you want to keep
-- the menu, delete this line and use LazyVim's default: `<leader>dc` (Debug Continue)
map("n", "<leader>d", function()
  require("dap").continue()
end, { desc = "Start/Continue Debug" })

-- Run/Debug Project
map("n", "<leader>R", function()
  require("dap").continue()
end, { desc = "Run/Debug" })

-- ==========================================
-- 5. KJump -> Flash.nvim
-- ==========================================
-- LazyVim comes with 'flash.nvim', which is vastly superior to KJump.
-- The native way to use it is just to press 's' and type two letters of your target.
-- However, to match your old muscle memory:
local flash = require("flash")
map("n", "<leader><leader>s", function()
  flash.jump()
end, { desc = "Flash Jump" })
map("n", "<leader><leader>w", function()
  flash.jump({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Flash Jump Word" })
map("n", "<leader><leader>l", function()
  flash.jump({ search = { mode = "search", max_length = 0 } })
end, { desc = "Flash Jump Line" })

local del = vim.keymap.del

-- Disable the default <leader><space> (Find Files alias)
pcall(del, "n", "<leader><space>")

-- Disable the default <leader>sg (Live Grep)
pcall(del, "n", "<leader>sg")

-- Map <leader>fif to Find In Files (Live Grep)
map("n", "<leader>fif", LazyVim.pick("live_grep"), { desc = "Find In Files" })
-- Map <leader>ff to Find Files (what <leader><space> used to do)
map("n", "<leader>ff", LazyVim.pick("files"), { desc = "Find Files (Root Dir)" })

-- Navigate Back and Forward in Jumplist (IntelliJ style)
map("n", "<M-Left>", "<C-o>", { desc = "Navigate Back (Older Jump)" })
map("n", "<M-Right>", "<C-i>", { desc = "Navigate Forward (Newer Jump)" })

-- Jump to the beginning of ANY word on screen instantly
map("n", "<leader>jw", function()
  require("flash").jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "\\<", -- This regex matches the start of any word
  })
end, { desc = "Jump to any Word" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    local ok, jdtls_dap = pcall(require, "jdtls.dap")
    if not ok then
      return
    end

    -- Custom debug config to force DAP to stop on Windows
    local dap_config = {
      config_overrides = {
        noDebug = false,
        stopOnEntry = false,
        stepFilters = { skipClasses = { "$JDK", "junit.*" } },
      },
    }

    -- Debug nearest test method
    vim.keymap.set("n", "<leader>td", function()
      jdtls_dap.test_nearest_method(dap_config)
    end, { buffer = args.buf, desc = "Debug nearest Java test" })

    -- Debug Java test class
    vim.keymap.set("n", "<leader>tD", function()
      jdtls_dap.test_class(dap_config)
    end, { buffer = args.buf, desc = "Debug Java test class" })
  end,
})
