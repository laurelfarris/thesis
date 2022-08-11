;+
;- LAST MODIFIED
;-   08 August 2022
;-
;- PURPOSE
;-   Script to define temporary path (solarstorm still down...)
;-
;- CALLING SYNTAX
;-   @path_temp
;-


;============================================================================
;= "mypath.pro"
;=   old code w/ short procedure and ML code.. don't remember what it's for.
;=  -- 08 August 2022
;=

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
;
;pro mypath, result
;
;    test = '/path/to/dir1/:/path/to/dir2/'
;    result = strsplit( test, ':', count=count, length=length, /extract )
;    ;for i = 0, count-1 do print, result[i]
;
;    result = strsplit( !PATH, ':', count=count, length=length, /extract )
;    ; This returns an array with 591 elements! That's a lot of directories.
;
;    for i = 0, count-1 do begin
;        num_occurrances = n_elements( where( result eq result[i] ) )
;        ;print, num_occurrances
;        if num_occurrances ne 1 then print, result[i]
;    endfor
;    ; Looks like there are no repeats, assuming I set this up correctly.
;
;end
;
;
;;- Mon Jan 28 08:07:31 MST 2019
;;- Cleaning up:
;;-   copied the lines below from "my_own_path.pro", and deleted that file.
;
;fls = file_search( 'Modules/*.pro' )
;print, fls
;
;foreach subroutine, fls do begin
;
;    resolve_routine, subroutine
;
;endforeach
;
;end

;============================================================================

;path_temp='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'

;path='/solarstorm/laurel07/'
;path_temp='/home/astrobackup3/preupgradebackups' + path

; 18 July 2022 --
;  Decided it's better (probably?) to keep the same variable name ('path')
;  so don't have to change it in every code / module / subroutine.
path_temp='/home/astrobackup3/preupgradebackups/'
path = path_temp + 'solarstorm/laurel07/'
