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

    win = GetWindows(/current)
    dims = win.dimensions/dpi
    wx = dims[0]
    wy = dims[1]


    ; Add timestamp to figure
    if keyword_set(add_timestamp) then begin

        ;- NOTE: width and height are currently in INCHES.

;        tx = width - 0.2
;        ty = height / 2.0
;        alignment = 0.0

        tx = wx - 0.25
        ty = 0.25
        alignment = 1.0

;        print, tx
;        print, ty
;        print, dpi

        creation_time = text( $
            tx*dpi, ty*dpi, $
            systime(), $
            /device, $
            alignment = alignment, $
            ;baseline=[0.0,1.0,0.0], $
            ;updir=[-1.0,0.0,0.0], $
            color='grey', $
            font_size=8 )
    endif


    CALDAT, systime(/julian), $
      month, day, year, hour, minute, second

    year = strtrim(year,1)
    month = strtrim(month,1)
    day = strtrim(day,1)

    if strlen(month) eq 1 then month = '0' + month
    if strlen(day) eq 1 then day = '0' + day

    new_filename = path + filename + '_' + year + month + day + '.pdf'

    win.save, new_filename, $
        page_size=[wx,wy], $
        width=wx, height=wy, _EXTRA=e
    print, ''
    print, 'Saved file '
    print, '  ', new_filename
    return
end
