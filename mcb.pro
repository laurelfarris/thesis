;Copied from clipboard


missing_string = $
    strmid(gaps,9,3) + '-' + strmid(gaps+1,9,3) + '     ' + $
        time[gaps] + ' - ' + time[gaps+1] + '     ' + $
        'dt = ' + strtrim(dt[gaps],1)
print, missing_string, format='(A)'
;- format='(A)' --> prints each element in array on a new line!
;-      Don't need to use a loop after all!

end

