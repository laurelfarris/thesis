; Last modified:    06 April 2018
; Programmer:       Laurel Farris
; Description:      subroutines with custom default configurations

; _EXTRA is for keywords in call to IDL's text function.

pro SAVE2, filename, add_timestamp=add_timestamp, _EXTRA=e


    common defaults
    path = '/home/users/laurel07/'

    fls = file_search( path + filename )
    if fls ne '' then begin
        b = ''
        prompt = 'File ' + filename + ' already exists. Overwrite? [y/n] '
        read, b, prompt=prompt
        if b ne 'y' then return
    endif

    ; Add option to append successive numbers to file that already exists.
    ; while fls ne "" ; i = i + 1 ; filename = basename + '_' + strtrim(i,1)
    ; keep appending _1, _2, etc. until no other file matches

    ; Add timestamp to figure
    ;if keyword_set(add_timestamp) then $
        ;creation_time = text2( $
            ;0.95,  0.1, $
            ;systime(), $
            ;baseline=[0.0,1.0,0.0], updir=[-1.0,0.0,0.0], $
            ;color='grey', $
            ;font_size=8 )

    w = getwindows(/current)
    dims = w.dimensions/dpi
    width = dims[0]
    height = dims[1]

    w.save, path + filename, $
        page_size=[width,height], $
        width=width, height=height, _EXTRA=e
    return
end
