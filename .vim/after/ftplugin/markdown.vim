setlocal commentstring=<!--\ %s\ -->
setlocal comments=b:>,b:*,b:+,b:-,s:<!--,m:\ \ \ \ ,e:-->

setlocal formatlistpat=
setlocal formatlistpat+=^\\s*
setlocal formatlistpat+=[
setlocal formatlistpat+=\\[({]\\?
setlocal formatlistpat+=\\(
setlocal formatlistpat+=[0-9]\\+
setlocal formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+
setlocal formatlistpat+=\\\|[a-zA-Z]
setlocal formatlistpat+=\\)
setlocal formatlistpat+=[\\]:.)}
setlocal formatlistpat+=]
setlocal formatlistpat+=\\s\\+
setlocal formatlistpat+=\\\|^\\s*[-+o*]\\s\\+
setlocal formatoptions-=q

setlocal shiftwidth=4 tabstop=4 expandtab

setlocal wrap
setlocal breakindent
setlocal breakindentopt=list:-1

if has('spell')
  setlocal spell
endif

function! s:Thesaurus(findstart, base) abort
  if a:findstart
    return searchpos('\<', 'bnW', line('.'))[1] - 1
  endif
  let res = []
  let h = ''
  for l in systemlist('aiksaurus ' .. shellescape(a:base))
    if l[:3] == '=== '
      let h = '(' .. substitute(l[4:], ' =*$', ')', '')
    elseif l ==# 'Alphabetically similar known words are: '
      let h = "\U0001f52e"
    elseif l[0] =~ '\a' || (h ==# "\U0001f52e" && l[0] ==# "\t")
      call extend(res, map(split(substitute(l, '^\t', '', ''), ', '), {_, val -> {'word': val, 'menu': h}}))
    endif
  endfor
  return res
endfunc

if exists('+thesaurusfunc') && executable('aiksaurus')
  setlocal thesaurusfunc=s:Thesaurus
else
  setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
endif

if executable('dict')
  setlocal keywordprg=dict
endif
