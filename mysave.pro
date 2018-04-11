;; Last modified:   07 February 2018 13:36:18

pro mysave, basename

    path = "/home/users/laurel07/Dropbox/Figures/Thesis_project/"
    ;fwin = getwindows( names=basename )
    filename = basename + '.pdf'

;    for i = 0, n_elements(filename)-1 do begin

        ;; fls will return a string array of 1, or an empty string
        fls = file_search( path + filename )

        ; while fls ne "" ; i = i + 1 ; filename = basename + '_' + strtrim(i,1)
        ; keep appending _1, _2, etc. until no other file matches
        ; Set these equal to same values used when determining position?
        ; That only applies to individual panels, not entire figure.
        fwin = getwindows(/current)
        dims = fwin.dimensions/96
        width = dims[0]
        height = dims[1]

        if fls eq '' then begin
            ;result = getwindows( /current )
            fwin.save, path + filename, $
                ;/landscape, $
                border=0 ,$
                page_size=[width,height], $
                width=width, height=height
        endif else begin
            print, "File ", filename, " already exists."
        endelse

;    endfor

    return

    ;; Add option to either overwrite, or append file that already
    ;; exists with, e.g. '_old' or mark in some other way.

end
