set foldmethod=marker
set foldmarker=\begin{frame},\end{frame}


"function! MyFoldText()
"    let nl = v:foldend - v:foldstart + 1
"    let comment = substitute(getline(v:foldstart),"^ *","",1)
"    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
"    let txt = '+ ' . linetext . ' : "' . comment . '" : length ' . nl
"    return txt
"endfunction
"set foldtext=MyFoldText()


" Find the number of lines contained by the fold.
" Get the 'comment' from the line before the first folded line
"    (and remove leading spaces).
" Get the text from the first line of the fold (and remove leading spaces).
" Assemble the above information into the returned foldtext,
"    with appropriate formatting.
