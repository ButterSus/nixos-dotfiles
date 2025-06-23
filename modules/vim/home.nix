{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.vim;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-highlightedyank
        catppuccin-vim
        lightline-vim
        vim-sensible
        vim-surround
        vim-commentary
        vim-repeat
        vim-wordmotion
        vim-slash
        vim-wayland-clipboard
        vim-vinegar
        fzf-vim
        indentLine
      ];
      settings = {
        number = true;
        relativenumber = true;
        mouse = "a";
        expandtab = true;
        tabstop = 4;
      };
      extraConfig = ''
        set autoindent
        set smartindent
        set clipboard=unnamedplus
        set cursorcolumn
        set cursorline
        set formatoptions-=co
        set scrolloff=5
        set shortmess-=S
        set softtabstop=4

        if (has("termguicolors"))
          set termguicolors
        endif

        let &t_SI = "\<Esc>[6 q"
        let &t_SR = "\<Esc>[4 q"
        let &t_EI = "\<Esc>[2 q"
        autocmd BufEnter * setlocal formatoptions-=o
        let mapleader = " "
        nnoremap <silent> <leader>Q :wqa<CR>
        nnoremap <silent> <leader>q :close<CR>
        nnoremap <silent> <leader>c :bd<CR>
        nnoremap <silent> <leader>/ :Commentary<CR>
        vnoremap <silent> <leader>/ :Commentary<CR>
        nnoremap <silent> <Tab> :bnext<CR>
        nnoremap <silent> <S-Tab> :bprev<CR>
        xnoremap <Tab> >gv
        xnoremap <S-Tab> <gv
        nnoremap <silent> <leader>j :m .+1<CR>==
        nnoremap <silent> <leader>k :m .-2<CR>==
        vnoremap <silent> <leader>j :m '>+1<CR>gv=gv
        vnoremap <silent> <leader>k :m '<-2<CR>gv=gv
        map <ScrollWheelUp>   k
        map <ScrollWheelDown> j
        map <S-ScrollWheelUp>   <C-U>
        map <S-ScrollWheelDown> <C-D>
        " FZF and fuzzy finder mappings
        nnoremap <silent> <leader>ff :Files<CR>
        nnoremap <silent> <leader>f: :History:<CR>
        nnoremap <silent> <leader>f/ :History/<CR>
        nnoremap <silent> <leader>fu :Changes<CR>
        nnoremap <silent> <leader>fw :Rg<CR>
        nnoremap <silent> <leader>fb :Buffers<CR>
        nnoremap <silent> <leader>ft :Tags<CR>
        nnoremap <silent> <leader>gc :Commits<CR>
        nnoremap <silent> <leader>gf :GFiles<CR>
        nnoremap <silent> <leader>gt :GFiles?<CR>
        " Center search
        nnoremap n nzz
        nnoremap N Nzz
        " IndentLine config
        let g:indentLine_setColors = 0
        let g:indentLine_char = '¦'
        " lightline config
        let g:lightline = {'colorscheme': 'catppuccin_mocha'}
        " Highlighted yank config
        let g:highlightedyank_highlight_duration = 300
        " Colorscheme
        colorscheme catppuccin_mocha
      '';
    };
  };

in {
  # Module Options
  options.modules.vim = {
    enable = mkEnableOption "Enable vim module";
  };
  
  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
    