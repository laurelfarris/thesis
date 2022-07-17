;+
;- CREATED:
;-   22 June 2022
;-
;- LAST MODIFIED:
;-   13 July 2022
;-
;- ROUTINE:
;-   sav_files.pro
;-
;- PURPOSE(S):
;-   QUICKLY save and/or restore .sav files. Tasks should include:
;-     • Save newly aligned data cube subsets to NEW sav files
;-     • Restore exisiting .sav files, examine contents, and possibly re-save modified version
;-        to add, change, and/or delete variables, e.g.
;-         re-saving files with aligned data cubes to include headers (variable "index") from level 1.5 fits files
;-         so don't have to use READ_SDO to read from fits files in location I have to look up every time.
;-     • 
;-     • 
;-     • 
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
;- Variables for EVERY flare (should be consistent!), using M7.3 flare in AIA 1600 channel as example:
;-    m73_aia1600header.sav  ->  index
;-    m73_aia1600aligned.sav ->  cube
;-    m73_aia1600map.sav     ->  map
;-
;- NOTE: 'cube' should be ALIGNED, CROPPED / TRIMMED, and INTERPOLATED to replace missing images.
;-


;=
;= Fits files - naming syntax for 1.0 and 1.5 level data
;=
;=
;= AIA: unprepped fits (level 1.0):
;=        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;=
;= AIA: prepped fits (level 1.5):
;=        'AIA20131228_100000_1600.fits'
;=        'AIA20131228_100000_0304.fits'
;=
;=
;= HMI: unprepped (level 1.0):
;=        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;=        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;=        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;=
;= HMI: prepped fits (level 1.5)
;=        'HMIyyyymmdd_hhmmss_cont.fits'
;=        'HMIyyyymmdd_hhmmss_*?*.fits'
;=        'HMIyyyymmdd_hhmmss_mag.fits'
;=        'HMIyyyymmdd_hhmmss_dop.fits'




@path_temp

instr = 'aia'
cadence = 24

channel = '1600'
;channel = '1700'


;-  Will probably end up passing instr, channel, etc. to a function that
;-    does all the filename definition, manipulating strings, all that messy
;-    stuff out of the way, just returns values, or just creates them like vsoget.




;- Define path to .sav files for individual flares

;flare_path = path_temp + 'flares/' + class + '_' + date + '/'
flare_path = path_temp + 'flares/' + class + '/'
;- 13 July 2022 -- removed date from directory names, e.g. "c83_20130830/" is now simply "c83/"
print, flare_path

;- file names for aligned data cube and/or header
data_file = flare_path + class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
header_file = flare_path + class + '_' + strlowcase(instr) + strtrim(channel,1) + 'header.sav'

if FILE_EXIST(data_file) then begin
    restore, data_file
endif else begin
    print, ''
    print, '======= WARNING! ==>  "',  data_file, '" DOES NOT EXIST!! ========'
    print, ''
    STOP
endelse


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

if FILE_EXIST(flare_path + header_file) then begin
    restore, flare_path + header_file
endif else begin
    print, "Header file does not exist."
endelse

sObj = OBJ_NEW('IDL_Savefile', flare_path + header_file)
sNames = sObj->Names()
print, sNames  ; => 'INDEX'
help, sNames  ; => SNAMES   STRING  = Array[1]
help, index    ; =>  INDEX   STRUCT =  -> <Anonymous>  Array[749]


;==================================================================================
;-
;- save multiflare_struc to .sav files ??
;-

;restore, '../multiflare_struc.sav'
;S = multiflare_struc
;undefine, multiflare_struc
;
;help, S.s1[0]
;help, S.s1[1]
;- NOTE: s1, s2, and s3 are ARRAYs corresponding to three flares.
;-  Each consists of two structures, one for each channel (~A for single flare).
;-
;- For each flare, should have one main structure/dictionary/array/whatever
;-   with simple, single-value tags that are constant regardless of instr/channel
;-  (e.g. flare date, AR #, GOES start/peak/end times, GOES class, etc.)
;-  Final tag(s) has a value that is another structure that is unique to a
;-   specific instr/channel (e.g. HMI B_LOS or AIA 1700Å continuum emission).
;-
;-

;- Add tag/value to existing structure:
;-   struc = CREATE_STRUCT( struc, 'new_tag', new_value )

;S = create_struct( S, 'AR', '11158' )


end
