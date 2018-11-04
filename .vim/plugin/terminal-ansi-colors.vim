" if the terminal feature is available, and if termguicolors is set or
" if the GUI is running, and if the base16-ocean dark colorscheme is in
" use, try to use the proper colors for the first 16 ANSI colors.
"
" I repeat the first eight for the second eight colors, since Vim
" appears to use the "bright" colors for bold, and that looks weird.

if has('terminal')
      \ && ((has('termguicolors') && &termguicolors) || has('gui_running'))
      \ && exists('g:colors_name') && g:colors_name ==? 'base16-ocean' && &background ==? 'dark'
  let g:terminal_ansi_colors =
        \ [
        \   '#2b303b',
        \   '#bf616a',
        \   '#a3be8c',
        \   '#ebcb8b',
        \   '#8fa1b3',
        \   '#b48ead',
        \   '#96b5b4',
        \   '#c0c5ce',
        \   '#2b303b',
        \   '#bf616a',
        \   '#a3be8c',
        \   '#ebcb8b',
        \   '#8fa1b3',
        \   '#b48ead',
        \   '#96b5b4',
        \   '#c0c5ce'
        \ ]
endif

        " \   '#2b303b',
        " \   '#bf616a',
        " \   '#a3be8c',
        " \   '#ebcb8b',
        " \   '#8fa1b3',
        " \   '#b48ead',
        " \   '#96b5b4',
        " \   '#c0c5ce',
        " \   '#65737e',
        " \   '#d08770',
        " \   '#343d46',
        " \   '#4f5b66',
        " \   '#a7adba',
        " \   '#dfe1e8',
        " \   '#ab7967',
        " \   '#eff1f5'
