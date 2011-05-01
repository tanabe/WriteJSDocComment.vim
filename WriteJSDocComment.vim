" WriteJSDocComment.vim
" write JSDoc comment macro
" *this script need perl interface
" 
" Author: Hideaki Tanabe <tanablog@gmail.com>
"
" Setting: 
"  1.
"   install in ~/.vim/ftplugin/javascript/
"  2.
"   assign keymap at .vimrc for example
"   au FileType javascript nnoremap <buffer> <C-c>  :<C-u>call WriteJSDocComment()<CR>

function! WriteJSDocComment()
if has('perl')
perl << EOF
  @pos = $curwin->Cursor();
  $row = @pos[0];
  $col = @pos[1];
  $line = $curbuf->Get($row);
  @params = $line =~ /\((.*)\)/g;
  @params = split(/\s*,\s*/, @params[0]);
  @params = map {' * @param ' . $_ . " "} @params;
  @comments = map {" " x $col . $_} ("/**" , " * ", @params, " */");
  $curbuf->Append(@pos[0] - 1, @comments);
EOF
endif
endfunction
