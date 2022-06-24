;+
;- CREATED:
;-   22 June 2022
;-
;- LAST MODIFIED:
;-   22 June 2022
;-
;- ROUTINE:
;-   sav_files.pro
;-
;- PURPOSE:
;-   Save aligned data cube subsets + headers (index) from level 1.5 fits files
;-   to same location (can be same variable, but may be less confusing to save header and
;-      data cube each to their own file)
;-
;- STEPS:
;-   • Read headers into "index" from level 1.5 fits files using read_sdo
;-     and save to .sav file in flare directory (same filename syntax for all flares).
;-   • Restore existing aligned data cubes from .sav files in flare sub-dir
;-   • General code to quickly restore data/headers for any flare
;-       Define path and filenames, append string variable w/ specific flare name
;-
;- TO DO:
;-   [] Organize into subroutine and main code, where ML code tests for existance of .sav files
;-       and restores header / data, QUICKLY and EASILY at beginning of each IDL session.
;-       Subroutine is only called if .sav files don't exist in path. Or something...
;-



;-- path to flare .sav files
@path_temp
print, path_temp
flare_path = path_temp + 'flares/' + class + '_' + date + '/'
print, flare_path

;-- Save aligned DATA subsets and HEADERS to .sav files --> be CONSISTENT !!
;filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;   includes date in the form yyyymmdd ... should filenames be changed to include this??
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, filename
;   m73_aia1600aligned.sav
;
if FILE_EXIST(path + filename) then begin
    restore, path + filename
endif else begin
    print, path + filename, ' does not exist.'
    STOP
endelse

; Create a savefile object.
sObj = OBJ_NEW('IDL_Savefile', path + filename)

; Retrieve the names of the variables in the SAVE file.
sNames = sObj->Names()

print, sNames ; => 'CUBE'
help, sNames  ; => SNAMES   STRING  = Array[1]
help, cube    ; => CUBE   INT  = Array[700, 500, 749]

; Can variable name be pulled straight from string?
;  help, sNames[0] ==  IDL> help, "cube"  ... not IDL> help, cube

; [] Restore HEADER from level 1.5 fits and re-save .sav file to include both 'cube' AND 'index'
header_file = 'm73_aia1600header.sav'

if FILE_EXIST(path + header_file) then restore, path + header_file else print, "Header file does not exist."

sObj = OBJ_NEW('IDL_Savefile', path + header_file)
sNames = sObj->Names()
print, sNames  ; => 'INDEX'
help, sNames  ; => SNAMES   STRING  = Array[1]
help, index    ; =>  INDEX   STRUCT =  -> <Anonymous>  Array[749]

end
