local autocmd = vim.api.nvim_create_autocmd

-- Create an augroup for the buffer update autocommands
local augroup = vim.api.nvim_create_augroup("UpdateBufs", { clear = true })

local function update_bufs()
    vim.t.bufs = vim.api.nvim_list_bufs()
end

local function add_buf(bufnr)
    if not vim.tbl_contains(vim.t.bufs, bufnr) then
        table.insert(vim.t.bufs, bufnr)
    end
end

local function remove_buf(bufnr)
    for i, buf in ipairs(vim.t.bufs) do
        if buf == bufnr then
            table.remove(vim.t.bufs, i)
            break
        end
    end
end

-- Autocommand to add buffer to vim.t.bufs when a buffer is added
autocmd("BufAdd", {
    group = augroup,
    callback = function(args)
        add_buf(args.buf)
    end,
})

-- Autocommand to remove buffer from vim.t.bufs when a buffer is deleted
autocmd("BufDelete", {
    group = augroup,
    callback = function(args)
        remove_buf(args.buf)
    end,
})

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

-- Initial update of buffer list at startup
update_bufs()
