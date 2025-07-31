vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        if vim.fn.winwidth(0) > 200 then
            vim.cmd("wincmd L")
        end
    end,
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('lsp-attach-format-on-save', {}),
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if not client then return end
--
--         ---@diagnostic disable-next-line: param-type-mismatch
--         if client.supports_method('taxtDocument/farmatting', 0) then
--             -- Format the current buffer on save
--             vim.api.nvim_create_autocmd('BufWritePre', {
--                 buffer = args.buf,
--                 callback = function()
--                     vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
--                 end,
--             })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

-- Automatically set filetype and start LSP for specific systemd unit file patterns
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.service", "*.mount", "*.device", "*.nspawn", "*.target", "*.timer" },
    callback = function()
        vim.bo.filetype = "systemd"
        vim.lsp.start({

            name = 'systemd_ls',
            cmd = { '~/.cargo/bin/systemd-lsp' }, -- Update this path to your systemd-lsp binary

            root_dir = vim.fn.getcwd(),
        })
    end,
})
---------------------------------------------------------------------------------
----- Open Neo-tree if nvim is launched with a directory
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local dir = vim.fn.argv(0)
        if dir and vim.fn.isdirectory(dir) == 1 then
            vim.cmd("Neotree dir=" .. dir)
        end
    end
})
