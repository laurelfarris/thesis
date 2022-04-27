;+
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
;-   []
;-   []
;-   []
;-
;- Multi-flare useful reference info:
;-   C8.3 2013-08-30 T~02:04:00
;-   M1.0 2014-11-07 T~10:13:00
;-   M1.5 2013-08-12 T~10:21:00
;-   M7.3 2014-04-18 T~01:43:00
;-
;-
;-


@par2

flare = multiflare.m73

print, flare.class
class = strlowcase((flare.class).Replace('.',''))
print, class



; Path to .sav file(s)

; Filename(s), old and/or new
;filenames = ['','']
filename = ''

restore, path + filename


;- Need to rename variable saved in these files for C8.3 flare...
;restore, '../flares/c83_20130830/c83_aia1700header.sav'
;index = c83_aia1700header
;help, index
;save, index, filename='c83_aia1700header.sav'

;path='/home/astrobackup3/preupgradebackups/solarstorm/laurel07/'
;path='/solarstorm/laurel07/'
;testfiles = 'Data/HMI_prepped/*20140418*.fits'
;if not file_test(path + testfiles) then print, 'files not found'


end
