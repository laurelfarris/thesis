
; Created:        14 August 2018



; Better way to view !PATH

; result = STRSPLIT( string, [delimiter, other kws] )
;    delimiter = whitespace by default
; STRSPLIT returns positions (~index) of substrings,
;   not the substrings themselves.
;   Set length=length to get array of substring lengths.
; Can use STRMID with result and length to extract substrings, or just
;   set /EXTRACT to return substrings in result.
; count=variable containing # of matching substrings...
;      may be useful if the same directory is added multiple times.
;      Never mind... this is just the number of elements in result.

pro mypath, result

    test = '/path/to/dir1/:/path/to/dir2/'
    result = strsplit( test, ':', count=count, length=length, /extract )
    ;for i = 0, count-1 do print, result[i]

    result = strsplit( !PATH, ':', count=count, length=length, /extract )
    ; This returns an array with 591 elements! That's a lot of directories.

    for i = 0, count-1 do begin
        num_occurrances = n_elements( where( result eq result[i] ) )
        ;print, num_occurrances
        if num_occurrances ne 1 then print, result[i]
    endfor
    ; Looks like there are no repeats, assuming I set this up correctly.

end
