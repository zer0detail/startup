-- :help options
local options =  {
  backup 		= false,				-- creates a backup file
  clipboard 	= "unnamedplus",			--allows nvim to access the system clipboard
  cmdheight 	= 2,				-- more space in nvim command line for displaying messages
  completeopt 	= { "menuone", "noselect" }, 	-- mostly just for cmp
  conceallevel 	= 0,				-- so that `` is visible in markdown files
  fileencoding 	= "utf-8",			-- the encoding written to a file
  hlsearch 	= true,				-- highlight all matches on previous search pattern
  ignorecase 	= true,				-- ignore case in search patterns
  mouse 		= "a",				-- allow the mouse to be used in nvim
  pumheight 	= 10,				-- pop up menu height
  showmode 	= true,				-- dont show the mode e.g. INSERT
  showtabline 	= 2,				-- always show tabs
  smartcase 	= true,				-- smart case
  smartindent 	= true,				-- smart indent
  splitbelow 	= true,				-- force all horizontal splits to go below current window
  splitright 	= true,				-- force all vertical spltis to go to the right of current window
  swapfile 	= false,				-- creates a swapfile
  termguicolors 	= true,				-- set term gui colors
  timeoutlen 	= 1000,				-- time to wait for mapped sequence to compelte (in ms)
  undofile 	= true,				-- enable persistent undo
  updatetime 	= 300,				-- faster completion (4000ms default)
  writebackup	= false,				-- if a file is being edited byu another program blah
  expandtab	= true,				-- convert tabs to spaces
  shiftwidth	= 2,				-- the number of spaces inserted for each tab
  tabstop		= 2,				-- insert 2 spaces for a tab
  cursorline	= true,				-- highlight the current line
  number		= true,				-- set numbered lines
  relativenumber	= true,				-- relative line numbers
  numberwidth	= 4,				-- set number column width 
  signcolumn	= "yes",				-- always show the sign column, otherwise it would shift the text each time
  wrap		= false,				-- dont wrap text
  scrolloff	= 8,				-- ?
  sidescrolloff	= 8,				-- ?
  guifont		= "monospace:h17",		-- the font used in graphical neovim applications
}

vim.opt.shortmess:append "c"


for k, v in pairs(options) do
  vim.opt[k] = v
end


vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesnt seem to work
