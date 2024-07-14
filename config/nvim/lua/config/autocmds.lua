-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

local auto_close_filetype = {
  "lazy",
  "mason",
  "lspinfo",
  "toggleterm",
  "null-ls-info",
  "TelescopePrompt",
  "notify",
}

-- Auto close window when leaving
ac("BufLeave", {
  group = ag("lazyvim_auto_close_win", { clear = true }),
  callback = function(event)
    local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")

    if vim.fn.index(auto_close_filetype, ft) ~= -1 then
      local winids = vim.fn.win_findbuf(event.buf)
      for _, win in pairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

-- Disable leader and localleader for some filetypes
ac("FileType", {
  group = ag("lazyvim_unbind_leader_key", { clear = true }),
  pattern = {
    "lazy",
    "mason",
    "lspinfo",
    "toggleterm",
    "null-ls-info",
    "neo-tree-popup",
    "TelescopePrompt",
    "notify",
    "floaterm",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf, desc = "" })
    vim.keymap.set("n", "<localleader>", "<nop>", { buffer = event.buf, desc = "" })
  end,
})

-- Disable next line comments
ac("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Hyprlang LSP
-- ac({ "BufEnter", "BufWinEnter" }, {
--   pattern = { "*.hl", "hypr*.conf" },
--   callback = function(event)
--     print(string.format("starting hyprls for %s", vim.inspect(event)))
--     vim.lsp.start({
--       name = "hyprlang",
--       cmd = { "hyprls" },
--       root_dir = vim.fn.getcwd(),
--     })
--   end,
-- })
