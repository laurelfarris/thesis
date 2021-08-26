;+
;- 02 July 2021
;-   • Restored powermaps for M7.3 flare, renamed variables (map + index), saved new .sav files,
;-       & compressed into .tar.gz file in flare subdirectory to send to Sean S.
;-   • 
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
;+
;- Select flare in ML of struc_aia prior to creating array of structures 'A',
;- then shouldn't have to define 'flare' as one of the structure elements in multiflare
;- in any other routine.. already defined at ML by struc_aia.pro at beggining of ssw session.
;-



buffer = 1
@par2

instr = 'aia'
;
channel = '1600'
;channel = '1700'


class = 'm15'
date = flare.year + flare.month + flare.day
print, date

path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;
print, file_exist(path+filename)

restore, path + filename


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



;========================================================================

;+
;- IDL_Savefile => get information about .sav file without restoring
;-


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

;========================================================================


end
