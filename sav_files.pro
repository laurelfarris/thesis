;+
;- CREATED:
;-   22 June 2022
;-
;- LAST MODIFIED:
;-   18 July 2022
;-
;-    Merged FOUR older codes from ./Prep/ :
;-
;-      1 my_save_restore_readfits_routine.pro
;-         • ML code, indented below
;-           Created ; commented
;-      2 restore_sav.pro
;-         • ML code, indented below
;-           Created ; commented
;-      3 restore_maps.pro
;-         • FUNCTION, defined below
;-           Created ; commented
;-      4 save2_procedure.pro
;-         • PROCEDURE (defined below) + ML code (indended)
;-           Created 2020 Nov 03 ; commented 2022 April 27


;==================================================================================================
;= 1. "my_save_restore_readfits_routine.pro"

;-
;- 27 April 2022
;-   WTF is this for??
;-
;-
;- 02 July 2021
;-
;- TO DO:
;-  [] Lightcurves for all flares! (one at a time... deal with multiflare structures later)
;-  [] ==>> see ML code in ./Lightcurves/plot_lc.pro
;-
;- DONE! :)
;-  [] M7.3 power maps --> Sean S.
;-       ( or data cube? or both?? )
;-
;-
;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00
;-


;--- quick hardcoding just to restore maps & headers for Sean

flareclass = 'm73'
date = '20140418'
path = '/solarstorm/laurel07/flares/' + flareclass + '_' + date + '/'
print, path


;channel = '1600'
channel = '1700'


header_file = flareclass + '_aia' + channel + 'header.sav'
print, path + header_file
print, FILE_EXIST( path + header_file )



stop



restore, path + header_file

m73_aia1600header = index

m73_aia1700header = aia1700index

if channel eq '1600' then save, m73_aia1600header, filename = './' + header_file
if channel eq '1700' then save, m73_aia1700header, filename = './' + header_file


stop



;+
;- Define POWERMAP filename,
;-   restore current .sav file w/ variable = 'map' (no flare or channel info),
;-   copy map to more descriptive variable name ( e.g. 'm73_aia1600powermap.sav )
;-   save new variable to file with same name
;-      Replace existing?? may cause problems in generalized codes like struc_aia...
;-    ==>> Can't define variable NAMES based on, e.g. string value of channel (if channel eq '1600' ...)
;-           which is why simple generic variable names are used... 
;-          This is probably why I created sub-directories called TAR_files/ inside flare dir...
;-          only need descriptive variables names when sending to someone else via .tar[.gz] files...
;-
;-

;channel = '1600'
channel = '1700'
;
powermap_file = flareclass + '_aia' + channel + 'powermap.sav'
;
if FILE_EXIST( path + powermap_file ) then begin
    restore, path + powermap_file
endif else begin
    print, 'Cannot restore file ', powermap_file, '... file does not exist!'
endelse
;
if channel eq '1600' then begin
    m73_aia1600powermap = map
    save, m73_aia1600powermap, filename = './' + powermap_file
endif
;
if channel eq '1700' then begin
    m73_aia1700powermap = map
    save, m73_aia1700powermap, filename = './' + powermap_file
endif

stop

buffer = 1
@par2

;-
;flare = multiflare.C83
;flare = multiflare.M10
flare = multiflare.M15
;flare = multiflare.X22
;-

help, flare

instr = 'aia'
channel = 1600
;channel = 1700
;
class = 'm15'
date = flare.year + flare.month + flare.day
print, date

path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;
print, file_exist(path+filename)

restore, path + filename

flux = total(total(cube,1),1)
help, flux

plt = plot2 ( flux, buffer=buffer )

save2, "m15_lightcurve", /timestamp, idl_code="today.pro"

end


;==================================================================================================
;= 2. "restore_sav.pro"

;- 21 October 2021
;-
;- PURPOSE:
;-   Generalized module to quickly and intuitively restore .sav file for any flare,
;-    declutter routines that use these same lines over and over...
;-
;- USEAGE:
;-   IDL> .RUN restore_save
;-
;- TO DO:
;-   [] block to RE-save (under new filename or replace the current one)
;-       to include additional variables, update current ones, or remove those I don't need.
;-       (e.g. update *aligned.sav to include index variable returned from read_sdo)
;-   [] RE-save if necessary, to same filename or new one,
;-       with additional variables, updated existing ones, or exclude those no longer needed.
;-
;- Multi-flare useful reference info:
;-   C8.3 2013-08-30 T~02:04:00
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-   M7.3 2014-04-18 T~01:43:00
;-
@par2 ;   ==>> does "par2" still exist?
;
flare = multiflare.m73
print, flare.class
class = strlowcase((flare.class).Replace('.',''))
print, class
;
; Path to .sav file(s)
;
; Filename(s), old and/or new
;filenames = ['','']
filename = ''
;
restore, path + filename
;
;- Need to rename variable saved in these files for C8.3 flare...
;restore, '../flares/c83_20130830/c83_aia1700header.sav'
;index = c83_aia1700header
;help, index
;save, index, filename='c83_aia1700header.sav'
;
;path='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'
;path='/solarstorm/laurel07/'
;testfiles = 'Data/HMI_prepped/*20140418*.fits'
;if not file_test(path + testfiles) then print, 'files not found'
;
end


;==================================================================================================
;= 3. "restore_maps.pro"

function RESTORE_MAPS

    ; This is probably obsolete now that I don't think it makes sense to read huge data
    ;  arrays into structure every IDL session, especially if not even using maps. 

    ;+
    ;- LAST MODIFIED:
    ;-   13 August 2019
    ;-
    ;- WRITTEN:
    ;-   29 April 2019
    ;-
    ;- USEAGE:
    ;-   IDL> @restore_maps
    ;-
    ;- NOTE:
    ;-  Doesn't work if maps have already been added to structure;
    ;-    get "duplicate tag def." or whatever
    ;-  Pretty sure test for tagname "MAP" takes care of this, but there
    ;-    may be cases where it doesn't, so leaving this note here.
    ;-     (23 January 2020)
    ;-
    ;- OLD PATH/FILENAMES:
    ;-   restore, '/solarstorm/laurel07/aia1600map_2.sav'
    ;-   restore, '/solarstorm/laurel07/aia1700map_2.sav'
    ;-     ????????? (23 January 2020)
    ;-

    @parameters

    path = '/solarstorm/laurel07/' + year+month+day + '/'

    ;- TEST to see if struc already has tag "map"
    ;-   NOTE: structure tag strings ARE case-sensitive (i.e. "map" doesn't match)
    tagnames = tag_names(A)
    test = where(tagnames eq "MAP")
    print, tagnames
    print, test

    ;if test eq -1 then begin  -->  true even though test = 13... I don't get it.

    if (test ge 0) then begin
    ;- If map is already included in structures, simply set each A[cc].map = map,
    ;-   where "map" is name of variable that has just been freshly restored.

        print, 'Replace existing map with restored map.'

        restore, path + 'aia1600map.sav'
        ;restore, path + 'aia1600map_2.sav'
    ;    help, map
    ;    help, A[0].map
        A[0].map = map
        undefine, map
        restore, path + 'aia1700map.sav'
        ;restore, path + 'aia1700map_2.sav'
        A[1].map = map
        undefine, map
    stop
    endif else begin
        ;- If tag for "map" has not been added to structures in array "A", add them now.
        ;if (where(tagnames eq "MAP") eq -1) then begin
        print, 'Adding tag "MAP" to struc array "A", set to restored maps.'
        ;
        restore, path + 'aia1600map.sav'
        ;restore, path + 'aia1600map_2.sav'
        aia1600 = A[0]
        aia1600 = create_struct( aia1600, 'map', map )
        ;
        restore, path + 'aia1700map.sav'
        ;restore, path + 'aia1700map_2.sav'
        aia1700 = A[1]
        aia1700 = create_struct( aia1700, 'map', map )
        ;
        A = [ aia1600, aia1700 ]
        ;
        undefine, map
        undefine, aia1600
        undefine, aia1700
        ;delvar, map
        ;delvar, aia1600
        ;delvar, aia1700
        ;
        ;A[0].map = map
        ;A[1].map = map
    endelse
end


;==================================================================================================
;= 4. "save2_procedure.pro"
;
;- 03 November 2020
;-
;- UPDATED:
;-  27 April 2022 (just comments)
;-
;- ROUTINE:
;-   save2_procedure.pro
;-
;- PURPOSE:
;-  Save VARIABLES to <filename>.sav
;-    Module to call SAVE procedure AFTER checking to see if filename exists.
;-    (can't tell if existing filename is overwritten, or if default filename
;-    of idlsave.dat is used, or what's going on, but don't get message of any
;-    kind if attempt to save to file that exists...).
;-
;- NOTE: To save FIGURES as pdf files, use ./Graphics/save2.pro
;-    (uses IDL object METHOD to save graphics to file, e.g. IDL> graphic.SAVE, ... )
;-


pro SAVE2_PROCEDURE, $
    variables, $
    filename=filename, $
    _EXTRA=e
        
    if FILE_EXIST( filename ) then begin
        print, '===================================================='
        print, 'WARNING! File already exists!'
        print, 'Try saving to different filename and/or path.'
        print, '===================================================='
        STOP
    endif
    SAVE, variables, filename=filename, _EXTRA=e
end


;===
; 27 April 2022
;  Merged save2_procedure.pro (above) with ML code test_save.pro (below).
;===


;+
;- 03 November 2020
;-
;- SAVE procedure does NOT overwrite existing FILENAME, but doesn't print
;-  message saying nothing was saved... could lose a lot of work if user
;-  doesn't realize this, and then closes session after thinking variables
;-  were saved to file.
;-


;-
;- (NOTE: already have x22 1600 .sav files)
;-

;filename = 'x22_1600_header.sav'
;filename = 'x22_1600_powermap.sav'
filename = 'x22_1700_header.sav'
filename = 'x22_1700_powermap.sav'

filename = 'm73_1600_header.sav'
filename = 'm73_1600_powermap.sav'
filename = 'm73_1700_header.sav'
filename = 'm73_1700_powermap.sav'

filename = 'c30_1600_header.sav'
filename = 'c30_1600_powermap.sav'
filename = 'c30_1700_header.sav'


filename = 'x22_1600_powermap.sav'
help, FILE_TEST( filename )
help, FILE_EXIST( filename )

print, FILE_INFO(filename)

print, FILE_BASENAME(filename)

print, FILEPATH(filename)

if FILE_EXIST( filename ) then begin
    print, '===================================================='
    print, 'WARNING! File already exists! New file NOT written!'
    print, 'Try saving to different filename and/or path.'
    print, '===================================================='
    STOP
endif

path = '/solarstorm/laurel07/thesis/'
file2save = path + filename 
print, file2save
print, FILE_BASENAME( file2save )

print, FILE_INFO( file2save )

help, /structure, FILE_INFO( file2save )

filename = 'test_save_file_exists.sav'
print, file_test(filename)

testvar = 2
save, testvar, filename=filename

save, $
    /compress
    description='', $
    /verbose, $
    filename=filename

end ; ML?


;===============================================================================================================
;===============================================================================================================

;=== CURRENT file ( sav_files.pro ) starts here:


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


;=====================================================================================================
;== 18 July 2022 : Copied the following from today.pro


;- Loop through channels (eventually... need way to store variables after each iteration.)
;channel = ['1600', '1700']
;foreach cc, channel, ii do begin
;    restore, '../flares/' + class + '/' + class + '_' + instr + channel[ii] + 'cube.sav'
;    restore, '../flares/' + class + '/' + class + '_' + instr + channel[ii] + 'header.sav'
;endforeach

channel = '1600'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'cube.sav'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'header.sav'
aia1600index = index
aia1600cube = cube
print, index[0].wavelnth

channel = '1700'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'cube.sav'
restore, '../flares/' + class + '/' + class + '_aia' + channel + 'header.sav'
help, index
help, cube
print, index[0].wavelnth

aia1700index = index
aia1700cube = cube
;
undefine, cube
undefine, index

;=====================================================================================================


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

;===================================================================================================
;= IDL_Savefile => get information about .sav file without restoring


savefile = '/solarstorm/laurel07/flares/m73_20140418/m73_aia1700header.sav'
sObj = OBJ_NEW( 'IDL_Savefile', savefile )

sContents = sObj->Contents()
;sContents = sObj.Contents() ... same thing, I think
help, sContents
;- => structure

help, sContents.N_VAR
;- => LONG64 = 1

help, sObj.Contents();.N_VAR
;-  Structure

help, sContents
;- => Structure! with lots of info
print, n_tags(sContents)
print, tag_names(sContents)

sNames = sObj->Names()
print, sNames

;- The class 'IDL_Savefile' has the following Methods:
;-   • Cleanup
;-   • Contents
;-   • Init
;-   • Names
;-   • Restore
;-   • Size

;==================================================================================================

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


;=================================================================================================
;- save multiflare_struc to .sav files ??

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

;- Add tag/value to existing structure:
;-   struc = CREATE_STRUCT( struc, 'new_tag', new_value )

;S = create_struct( S, 'AR', '11158' )

end
