;+

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
;- TO DO:
;-  []
;-  []
;-  []
;-  []
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



end
