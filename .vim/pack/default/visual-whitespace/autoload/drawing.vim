scriptencoding utf-8


" public

function! drawing#RedrawVisualWhitespace(timer)
  if s:IsVisualMode()
    if !s:DoMatchesExist()
      call s:SetConcealSettingsForVisualMode()
      call s:ConfigureConcealMatchesForWhitespace()
      call s:LinkConcealToVisualNonText()

      redraw
    endif
  else
    if s:DoMatchesExist()
      call s:RestoreConcealSettingsToOriginals()
      call s:ClearConcealMatchesForWhitespace()
      call s:UnlinkConcealFromVisualNonText()

      redraw
    endif
  endif
endfunction


" private

function! s:IsVisualMode()
  if mode(1) =~ 'v'
    return v:true
  else
    return v:false
  endif
endfunction

function! s:DoMatchesExist()
  return get(b:, 'space_match', -1) != -1
endfunction

function! s:SetConcealSettingsForVisualMode()
  let b:original_concealcursor = &l:concealcursor
  let b:original_conceallevel  = &l:conceallevel
  let &l:concealcursor         = 'v'
  let &l:conceallevel          = 2
endfunction

function! s:RestoreConcealSettingsToOriginals()
  let &l:concealcursor = get(b:, 'original_concealcursor', &l:concealcursor)
  let &l:conceallevel  = get(b:, 'original_conceallevel', &l:conceallevel)
endfunction

function! s:ConfigureConcealMatchesForWhitespace()
  let b:space_match = matchadd('Conceal', '\%V \%V', 10, -1, { 'conceal': '·' })
endfunction

function! s:ClearConcealMatchesForWhitespace()
  call matchdelete(b:space_match)
  unlet b:space_match
endfunction

function! s:UnlinkConcealFromVisualNonText()
  execute 'highlight! link Conceal NONE'
  execute 'highlight clear VisualNonText'
endfunction

function! s:LinkConcealToVisualNonText()
  let l:visual_group_details  = s:GetHighlightGroupDetails('Visual')
  let l:nontext_group_details = s:GetHighlightGroupDetails('NonText')

  " create a 'VisualNonText' (just a crude mash of the two)
  execute 'highlight VisualNonText ' . l:visual_group_details . ' ' . l:nontext_group_details
  execute 'highlight! link Conceal VisualNonText'
endfunction

" resulting highlight should have the background of the Visual group and
" the other attributes of the NonText group
function! s:GetHighlightGroupDetails(group)
  redir => l:highlight_output
  execute 'silent highlight ' . a:group
  redir END

  " recurse to find actual highlight group if needed
  while l:highlight_output =~ 'links to'
    let l:index        = stridx(l:highlight_output, 'links to') + len('links to')
    let l:linked_group = strpart(l:highlight_output, l:index + 1)

    redir => l:highlight_output
    execute 'highlight ' . l:linked_group
    redir END
  endwhile

  " extract highlight group details
  return matchlist(l:highlight_output, '\<xxx\>\s\+\(.*\)')[1]
endfunction
