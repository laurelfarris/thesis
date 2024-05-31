;+
;- LAST MODIFIED
;-   02 August 2022
;-
;- CALLING SYNTAX:
;-   IDL> @main
;-     run as a script, i.e. no 'end' statement at bottom of file.
;-
;- REFERENCE CODES
;-   • ./today.pro
;-   •
;-   • Modules/stats.pro -- computes min, max, mean, variance, stddev, and returns structure
;-   •
;-   • Images/scaling_snippets.pro
;-   • Images/difference_images.pro
;-   •
;-   • Spectra/
;-
;- TO DO
;-   [] 29 May 2024 -- After restoring contents of .sav files, display what exactly was restored
;-        It's been so long, I have no idea what surprises "x22_struc.sav" may contain...
;-



;+
;= Startup variables (sort of... tend to change during a single coding session)

@path_temp

buffer = 1
;display = 0
;   What does this do?

;instr = 'hmi'
;channel = 'mag'
;channel = 'cont'
;channel = 'dop'

instr = 'aia'
;channel = '1600'
;channel = '1700'

cadence = 24
;cadence = 45

;class = 'c30'
;class = 'c46'
;class = 'm10'
;class = 'm15'

;class = 'c83'
;class = 'm73'
class = 'x22'


;+
;= Restore flare structure(s) from .sav files

;flare = multiflare_struc(flare_id=class)  ;-  ????
flare = MULTIFLARE_STRUC( flare_id=class )

flare_path = path + 'flares/' + class + '/'

if FILE_EXIST(flare_path + class + '_' + 'struc.sav') then begin
    print, '===='
    print, flare_path + class + '_' + 'struc.sav'
    restore, flare_path + class + '_' + 'struc.sav', /VERBOSE
endif
print, '===='
stop

; 12 December 2022
;  Restore .sav file with variable "A" saved with two structures, one for each AIA UV channel
if FILE_EXIST(flare_path + class + '_' + 'struc.sav') then begin
    restore, flare_path + class + '_' + 'struc.sav', /VERBOSE
    ;- /VERBOSE prints infromation for restored object in case one forgets...
endif else begin
    print, '  "A".sav either does not exist, or '
    print, '     filename/location is inconsistent with that of X2.2 flare.'
endelse


; 30 August 2022
;  [] flare.path? Could add specific path to each structure,
;      OR combine all flare .sav files into one directory...

;= restore "A", array of structures created with ./Prep/struc_aia.pro
;restore, '../flares/' + class + '/' + class + '_struc.sav'

;=
;= Define / re-format strings for 'class' and 'date'
;=

; 13 July 2022
;   Must define 'flare' structure variable (following multiflare_struc call...)
;   before 'class' and 'date' can be accessed by calling flare.class and flare.date


;= Change 'class' format from, e.g. flare.class = 'M1.5' to class = 'm15'
;
;class = strsplit(flare.class, '.', /extract)
;class = strlowcase(class[0] + class[1])
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
;class = strlowcase((flare.class).Replace('.',''))

;= Date: change format to 'yyyymmdd' for beginning of filenames so files are ordered by flare date.
;=   e.g. flare.date = '12-Aug-2013' --> date = '20130812'
;
;date = flare.year + flare.month + flare.day


END
