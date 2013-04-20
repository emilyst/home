if !has('conceal')
        finish
endif


syntax clear perlOperator
syntax keyword perlOperator is

syntax match perlLambda       /\(=>\?\s*\)\@<=sub\(\W\)\@=/ conceal cchar=λ
syntax match perlNiceOperator /\<in\>/                      conceal cchar=∈
syntax match perlNiceOperator /\<or\>/                      conceal cchar=∨
syntax match perlNiceOperator /\<and\>/                     conceal cchar=∧
syntax match perlNiceOperator /\<not\>/                     conceal cchar=¬
syntax match perlNiceOperator /\<foreach\>/                 conceal cchar=∀
syntax match perlNiceOperator /\<for\>/                     conceal cchar=∀
syntax match perlNiceOperator /\<exists\>/                  conceal cchar=∃
syntax match perlNiceOperator containedin=ALL /<=/          conceal cchar=≤
syntax match perlNiceOperator containedin=ALL />=/          conceal cchar=≥
syntax match perlNiceOperator containedin=ALL /==/          conceal cchar=≡
syntax match perlNiceOperator containedin=ALL /!=/          conceal cchar=≠
syntax match perlNiceOperator containedin=ALL /=\~/         conceal cchar=≅
syntax match perlNiceOperator containedin=ALL /!\~/         conceal cchar=≆
syntax match perlNiceOperator containedin=ALL /=>/          conceal cchar=»
syntax match perlNiceOperator containedin=ALL /\->/         conceal cchar=›

hi  link perlNiceOperator  Operator
hi  link perlNiceStatement Statement
hi! link Conceal           Operator

setl conceallevel=2
