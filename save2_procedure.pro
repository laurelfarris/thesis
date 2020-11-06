;+
;- 03 November 2020
;-
;-  Module to call SAVE procedure AFTER checking to see if filename exists.
;-  (can't tell if existing filename is overwritten, or if default filename
;-  of idlsave.dat is used, or what's going on, but don't get message of any
;-  kind if attempt to save to file that exists...).
;-
;- ROUTINE:
;-   save2_procedure.pro (not to be confused with save2.pro, which calls
;-     IDL object METHOD for saving graphics to file, e.g. IDL> graphic.SAVE, ... ).
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
