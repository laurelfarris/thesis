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


;==========================================================================================================================
;+
;- 15 March 2021
;-
;=  fits filenames for, e.g. AIA 1600\AA{}
;=
;=    AIA
;=      UNprepped fits (level 1.0):
;=        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=
;=      PREPPED fits (level 1.5):
;=        'AIA20131228_100000_1600.fits'
;=        'AIA20131228_100000_0304.fits'
;=
;=
;=    HMI
;=      UNprepped (level 1.0):
;=        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;=        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;=
;=      PREPPED fits (level 1.5)
;=        'HMIyyyymmdd_hhmmss_cont.fits'
;=        'HMIyyyymmdd_hhmmss_*?*.fits'
;=        'HMIyyyymmdd_hhmmss_mag.fits'
;=        'HMIyyyymmdd_hhmmss_dop.fits'
;=
;==========================================================================================================================

@path_temp
print, path_temp

instr = 'aia'
cadence = 24

;- edit main.pro to set flare and variables for "class" and "date"
;- IDL> .run main

channel = '1600'
;channel = '1700'

;-- path to flare .sav files
flare_path = path_temp + 'flares/' + class + '_' + date + '/'

;- file names for aligned data cube and/or header
data_file = flare_path + class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
header_file = flare_path + class + '_' + strlowcase(instr) + strtrim(channel,1) + 'header.sav'

if FILE_EXIST(data_file) then begin
    restore, data_file
endif else begin
    print, ''
    print, '=======  "',  data_file, '" DOES NOT EXIST!! ========'
    STOP
endelse

stop

; Create a savefile object.
sObj = OBJ_NEW('IDL_Savefile', data_file)

; Retrieve the names of the variables in the SAVE file.
sNames = sObj->Names()

print, sNames ; => 'CUBE'
help, sNames  ; => SNAMES   STRING  = Array[1]
help, cube    ; => CUBE   INT  = Array[700, 500, 749]

; Can variable name be pulled straight from string?
;  help, sNames[0] ==  IDL> help, "cube"  ... not IDL> help, cube

; [] Restore HEADER from level 1.5 fits and re-save .sav file to include both 'cube' AND 'index'
header_file = class + '_' + instr + channel + 'header.sav'
print, header_file

if FILE_EXIST(flare_path + header_file) then restore, flare_path + header_file else print, "Header file does not exist."

sObj = OBJ_NEW('IDL_Savefile', flare_path + header_file)
sNames = sObj->Names()
print, sNames  ; => 'INDEX'
help, sNames  ; => SNAMES   STRING  = Array[1]
help, index    ; =>  INDEX   STRUCT =  -> <Anonymous>  Array[749]

end
