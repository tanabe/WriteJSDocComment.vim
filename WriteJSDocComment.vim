" WriteJSDocComment.vim
" write JSDoc comment
" Caution: this script need perl interface (+perlinterp)
" 
" Author: Hideaki Tanabe <tanablog@gmail.com>
"
" setting: 
"  1.
"   install in ~/.vim/ftplugin/javascript/
"  2.
"   assign keymap at .vimrc for example
"   au FileType javascript nnoremap <buffer> <C-c>  :<C-u>call WriteJSDocComment()<CR>

function! WriteJSDocComment()
if has('perl')
perl << EOF
  sub has_return {
    my $row = shift;
    my $brace_count = 1;
    my $i = 0;
    my $limit = 200;
    $row++;
    while (($brace_count > 0) || ($limit < 0)) {
      if ($row > $curbuf->Count()) {
        #VIM::Msg("no found");
        return false;
      }
      my $line = $curbuf->Get($row);
      $brace_count++ if $line =~ /{/g;
      $brace_count-- if $line =~ /}/g;
      #VIM::Msg($brace_count);
      if ($brace_count == 1) {
        #VIM::Msg($line . "found");
        return true if $line =~ /return/g;
      }
      $limit--;
      $row++;
    }
    return false;
  }

  my @pos = $curwin->Cursor();
  my $row = @pos[0];
  my $col = @pos[1];
  my $line = $curbuf->Get($row);
  my @params = $line =~ /\((.*)\)/g;

  @params = split(/\s*,\s*/, @params[0]);
  @params = map {' * @param ' . $_ . " "} @params;
  if (has_return($row) eq 'true') {
    push(@params, ' * @return ');
  } 
  my @comments = map {" " x $col . $_} ("/**" , " * ", @params, " */");
  $curbuf->Append(@pos[0] - 1, @comments);
EOF
endif
endfunction
