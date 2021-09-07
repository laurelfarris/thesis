;+
;- LAST MODIFIED:
;-   10 March 2020
;-     Removed kws for confirming save to file and whether to replace
;-     if file already exists (kws not intuitive enough, never used
;-     anyway...). If user wants confirmation before saving, should
;-     add that to calling routine.
;-     Confirmation to overwrite file that already exists is done
;-     here by default.
;-
;-     Also changed kw "stamp" to "timestamp", to be more descriptive.
;-
;- PURPOSE:
;-   Use IDL's SAVE method on current window to save graphic as pdf
;-   with date appended in the form "_yyyymmdd".
;-
;- INPUT:
;-   "filename"
;-     NOTE: extension (.pdf) is appended here.
;-
;- KEYWORDS:
;-   TIMESTAMP
;-      set /timestamp to add date and filename to bottom of page.
;-   IDL_CODE
;-      set = string name of code that generated figure;
;-      appended to timestamp text.
;-        (NOTE: ignored if kw TIMESTAMP is not set).
;-   _EXTRA is for keywords in call to IDL's text function.
;-     (see documentation)
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] for filenames that exist, append "_1", "_2", etc.
;-   [] better name than "save2"? Clearly module is used to save graphics
;-        in current window to pdf files, as opposed to
;-        IDL's "save" procedure, which creates .sav files.
;-       This actually uses the save METHOD --> win.save, arg, kw=kw, ...
;-
;-

pro SAVE2, filename, $
    ;confirm_replace=confirm_replace, $
    overwrite=overwrite, $
    timestamp=timestamp, $
    idl_code=idl_code, $
    _EXTRA=e



    common defaults
    path = '/home/users/laurel07/Figures/'


    ;- Get window dimensions, used when saving figure to file,
    ;-   and if kw timestamp is set, determines location of text.
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

    ;- Include time; appended to end of new_filename after date (below).
    ;-   (commented in new_filename definition for now...
    ;-      filename got way too long and confusing).
    hh = strmid( systime(), 11, 2 )
    mm = strmid( systime(), 14, 2 )
    ss = strmid( systime(), 17, 2 )


    ;---------------------------------------------------



    new_filename = filename + '_' + $
        year + month + day + $
        ;hh + mm + ss + $
        '.pdf'

    ; Add timestamp to figure
    if keyword_set(timestamp) then begin

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



    ;+
    ;- Test for existance of file
    ;-
    ;- Old:
;    fls = file_search( path + filename )
;    if fls ne '' then begin
;        b = ''
;        prompt = 'File ' + filename + ' exists. Overwrite? [y/n] '
;        read, b, prompt=prompt
;        if b ne 'y' then return
;    endif
    ;-
    ;- New(er):
    ;- Different way to test for existance of file,
    ;-  Tells user to continue using standard IDL executive command
    ;-   ".C" rather than using the READ procedure, as done above.
    ;-
    ;-
    ;-
    if NOT keyword_set(overwrite) then begin
        ;- Have to explicitly pass overwrite kw to bypass confirmation to do so.
        ;-   Typing ".c" over and over gets really annoying when working remotely.
        ;-    (14 March 2020)
        if FILE_EXIST(path + new_filename) then begin
            print, ''
            print, 'File "', new_filename, '" already exists!'
            print, 'Type ".c" to overwrite.'
            print, ''
            ;stop
        endif
    endif
    ;-
    ;-


    ;+
    ;-
    ;- How to append next number
    ;-  (e.g. if file.pdf and file_2.pdf exist,
    ;-   update current filename to file_3.pdf).
    ;-
    ;- Lots of string operations that could be used here.
    ;-
    ;-
    ;- Ideas:
    ;-   while fls ne ""
    ;-     i = i + 1
    ;-     fname = basename + '_' + strtrim(i,1)
    ;-   ...
    ;- keep appending _1, _2, etc. until no other file matches
    ;-
    ;- ...
    ;- loc = STRPOS(filename, '.pdf')
    ;- counter = fix(filename[loc-1])
    ;-   (if filename = 'blah_2.pdf', counter should be set to 2).
    ;- updated_filename = STRJOIN( [filename, counter+1], '_'  )
    ;-   ( underscore '_' is the "delimiter", only need to worry about
    ;-       numerical value following it.)
    ;-

    win.SAVE, path + new_filename, $
        ;/antialias, $
        ;/append, /memory, /close, $
        ;/bit_depth={0|1|2}, $
        ;/bitmap, $
        ;resolution=integer, $ ;= dpi (default=600)
        ;transparent=array , $
        height=wy, width=wx, $
        ;border=0, $
        ;landscape, $
        page_size=[wx,wy], $
        ;xmargin=integer, ymargin=integer, $
        _EXTRA=e

    print, ''
    print, 'Saved file '
    print, '  ', new_filename
    return
end
