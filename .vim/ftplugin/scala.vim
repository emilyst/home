if exists(":RainbowParentheses")
  RainbowParentheses
endif

autocmd BufWritePre *.scala :Autoformat
