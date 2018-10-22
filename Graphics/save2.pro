; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

; _EXTRA is for keywords in call to IDL's text function.

pro SAVE2, filename, $
    confirm_replace=confirm_replace, $
    add_timestamp=add_timestamp, $
    _EXTRA=e

    ; Confirm saving to file
    if keyword_set(confirm_replace) then begin
        confirm = ''
        prompt = 'Save file? [y/n] '
        read, confirm, prompt=prompt
        if confirm ne 'y' then return
    endif

    common defaults
    path = '/home/users/laurel07/Figures/'

    fls = file_search( path + filename )
    if keyword_set(confirm_replace) then begin

        ; Ask if user wants to overwrite
        if fls ne '' then begin
            b = ''
            prompt = 'File ' + filename + ' already exists. Overwrite? [y/n] '
            read, b, prompt=prompt
            if b ne 'y' then return
        endif

        ; Alternatively, append counter to filename
        ; Lots of string operations that could be used here.
        ;  Work on this later...

    endif

    ; Add option to append successive numbers to file that already exists.
    ; while fls ne "" ; i = i + 1 ; filename = basename + '_' + strtrim(i,1)
    ; keep appending _1, _2, etc. until no other file matches

    w = GetWindows(/current)
    dims = w.dimensions/dpi
    width = dims[0]
    height = dims[1]

    ; Add timestamp to figure
    if keyword_set(add_timestamp) then begin
        ;tx = 0.95
        ;ty = 0.1
        tx = width - 0.2
        ty = height / 2.0
        creation_time = text( $
            tx*dpi, ty*dpi, $
            systime(), $
            /device, $
            baseline=[0.0,1.0,0.0], $
            updir=[-1.0,0.0,0.0], $
            color='grey', $
            font_size=8 )
    endif

    w.save, path + filename, $
        page_size=[width,height], $
        width=width, height=height, _EXTRA=e
    print, 'Saved file as ', path + filename
    return
end