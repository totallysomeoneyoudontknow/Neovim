vim.g.mapleader = " "
vim.keymap.set("n", "<leader>px", vim.cmd.Ex)
vim.keymap.set("n", "<leader>x", function()
	vim.cmd.w()
	vim.cmd.so("%")
end)

vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd.colorscheme("rose-pine-moon") 
    end
  },
  {
    "m4xshen/autoclose.nvim",
    name = "autoclose", 
    config = function()
      require("autoclose").setup({
        options = {
          disabled_filetypes = { "text", "markdown" },
        },
      })
  end
  }, 
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    name = "telescope",
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
  {"neovim/nvim-lspconfig",
  name = "lspconfig", 
  config = function()
 vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "java",
    callback = function()
        local jdtls = require("jdtls")
	jdtls.start_or_attach({
		capabilities = capabilities,
		cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
		root_dir = jdtls.setup.find_root({ "java-workspace" })
	 })
        end}
) end
      
}, 	
{ 
    "nvim-treesitter/nvim-treesitter", 
    name = "treesitter", 
    config = function()
      require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "rust" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
              end
        end,
        additional_vim_regex_highlighting = false,
    }
  
}) end
}
}



require('lazy').setup(plugins, opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


local opts = {}
