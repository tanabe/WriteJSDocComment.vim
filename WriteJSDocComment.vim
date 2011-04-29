"insert JSDoc comment [not good]
"
"setting: 
"  1.
"    assign keymap at .vimrc
"    au FileType javascript nnoremap <buffer> <C-c>  :<C-u>call WriteJSDocComment()<CR>
"  2.
"   If cursor is on function line, call WriteJSDocComment then
"   append the JSDoc-like comment.

function! WriteJSDocComment()
  let params = []
  let line = getline('.')
  let matches = matchlist(line, '([^)]\+)')
  if (len(matches))
    let arguments = matches[0]
    let arguments = substitute(arguments, '[() ]', '', 'g')
    let params = reverse(split(arguments, ','))
  endif
  
  let c = col(".")
  let l = a:firstline - 1
  let s = ''
  while len(s) < (c - 1)
    let s = s . " "
  endwhile
  call append(l, s . ' */')
  if (len(params))
    for param in params
      call append(l, s . ' *'. ' @param ' . expand(param). ' ')
    endfor
  endif
  call append(l, s . ' *')
  call append(l, s . '/**')
endfunction
