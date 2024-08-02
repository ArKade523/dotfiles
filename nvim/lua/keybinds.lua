-- define common options
local opts = {
    -- noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Nvimtree
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<Leader>e', ':NvimTreeFocus<CR>', {})

-- New Terminal
vim.keymap.set('n', '<Leader>h', function()
    require("nvchad.term").new { pos = "sp" }
end, opts)
vim.keymap.set("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, opts)
-- Toggle Terminal
vim.keymap.set({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, opts)
vim.keymap.set({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, opts)
vim.keymap.set({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, opts)

-- Clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', {})

-- tabufline
vim.keymap.set("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
vim.keymap.set("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, {})
vim.keymap.set("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, {})
vim.keymap.set("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, {})

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<C-/>', 'gc', opts)

-------------------
-- Terminal mode --
-------------------

vim.keymap.set('t', '<Leader><ESC>', '<C-\\><C-n>', opts)
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-h>', opts)
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-j>', opts)
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-k>', opts)
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-l>', opts)
