setlocal spell
setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt

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
