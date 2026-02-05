return {
  {
    "airblade/vim-gitgutter",
    "github/copilot.vim",
    "pangloss/vim-javascript",
    "tpope/vim-endwise",
    "tpope/vim-rails",
    "tpope/vim-repeat",
    "tpope/vim-unimpaired",
    "vim-test/vim-test",
  },
  {
    'akinsho/git-conflict.nvim', version = "*", config = true
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { 'nvim-mini/mini.operators', version = '*' },
}
