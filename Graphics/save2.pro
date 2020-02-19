;+
;- LAST MODIFIED:
;-   Fri Feb  8 12:23:50 MST 2019
;-
;- PURPOSE:
;-   Use IDL's SAVE method on current window to save graphic as pdf
;-   with date appended in the form "_yyyymmdd".
;-
;- INPUT:
;-   "filename" (NOTE: do not include extension; this routine will do that)
;-
;- KEYWORDS:
;-   CONFIRM_REPLACE
;-   stamp - Uses IDL's TEXT function to add date and filename to
;-      bottom of page
;-   IDL_CODE - name of code that generated the figure. If set, will be added
;-      to bottom of page along with date and filename. (NOTE: ignored if
;-      stamp is not set).
;-
;- OUTPUT:
;-
;- TO DO:

; _EXTRA is for keywords in call to IDL's text function.

pro SAVE2, filename, $
    confirm_replace=confirm_replace, $
    overwrite=overwrite, $
    stamp=stamp, $
    idl_code=idl_code, $
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




    CALDAT, systime(/julian), $
      month, day, year, hour, minute, second

    year = strtrim(year,1)
    month = strtrim(month,1)
    day = strtrim(day,1)

    if strlen(month) eq 1 then month = '0' + month
    if strlen(day) eq 1 then day = '0' + day

    ;---------------------------------------------------

    ;+
    ;- 18 February 2020
    ;-   IDL> help, SYSTIME(/julian)
    ;-     <Expression>  DOUBLE  =  2458898.0
    ;-   IDL> help, SYSTIME()
    ;-     <Expression>  STRING  =  "Tue Feb 18 12:14:49 2020"
    ;- Seems like it would have been easier to pull number from
    ;-  systime(), except just noticed there's no number for month.
    ;- There's probably a better way to do this, but not important enough
    ;-

    ;- Adding more hacky code to include time 
    hh = strmid( systime(), 11, 2 )
    mm = strmid( systime(), 14, 2 )
    ss = strmid( systime(), 17, 2 )


    ;---------------------------------------------------



    ;new_filename = filename + '_' + year + month + day + '.pdf'
    new_filename = filename + '_' + $
        year + month + day + $
        hh + mm + ss + $
        '.pdf'

    ; Add timestamp to figure
    if keyword_set(stamp) then begin

        if not keyword_set(idl_code) then idl_code = ''

        ;- NOTE: width and height are currently in INCHES.

        edge_offset = 0.25

        tx = [edge_offset, wx/2., wx-edge_offset]
        ty = edge_offset
        alignment = [0.0, 0.5, 1.0]

        text_string = $
            [ new_filename, idl_code, systime() ]

        for ii = 0, 2 do begin
            creation_time = text( $
                tx[ii]*dpi, ty*dpi, $
                text_string[ii], $
                /device, $
                alignment = alignment[ii], $
                ;baseline=[0.0,1.0,0.0], $
                ;updir=[-1.0,0.0,0.0], $
                color='grey', $
                font_size=8 )
        endfor
    endif

    if not keyword_set(overwrite) then begin
        if FILE_EXIST(path + new_filename) then begin
            print, ''
            print, 'File "', new_filename, '" already exists!'
            print, 'Type ".c" to overwrite.'
            print, ''
            stop
        endif
    endif

    win.SAVE, path + new_filename, $
        page_size=[wx,wy], $
        width=wx, height=wy, _EXTRA=e

    print, ''
    print, 'Saved file '
    print, '  ', new_filename
    return
end
