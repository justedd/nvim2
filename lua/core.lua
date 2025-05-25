local M = {
    mappings = {}
}

--require "lsp_signature".setup({})

require("aerial").setup({
    on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt.expandtab = false
        vim.opt.shiftwidth = 2
        vim.opt.softtabstop = 2
        vim.opt.tabstop = 2
    end,
})

function OpenRangerFloating()
  local current_file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(current_file, ":p:h")

  if vim.fn.isdirectory(dir) == 0 then
    print("Not a valid directory: " .. dir)
    return
  end

  -- Создаём буфер и окно
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Запускаем ranger и обрабатываем завершение
  vim.fn.termopen({ "bash", "-c", "cd " .. vim.fn.shellescape(dir) .. " && ranger" }, {
    on_exit = function(_, _, _)
      -- Закрываем окно и буфер после выхода
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  -- Переход в терминальный режим
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>rr", OpenRangerFloating, { noremap = true, silent = true, desc = "Open Ranger in current file directory" })


vim.keymap.set("n", "<leader>c", function()
  local filepath = vim.fn.expand("%") -- относительный путь от cwd
  local linenr = vim.fn.line(".") -- текущая строка
  local cmd = string.format("cursor . --goto %s:%d", filepath, linenr)
  vim.fn.jobstart(cmd, { detach = true })
end, { noremap = true, silent = true })


require('elements.telescope')
require('elements.indent_line')
require('elements.statusline')
require('elements.snippets')
require('elements.cmp')
require('elements.lsp')
require('elements.treesitter')

return M
