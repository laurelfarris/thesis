;; Last modified:   05 February 2018 09:36:22

PRO save_figs, filename

    fig_path = "/home/users/laurel07/Dropbox/Figures/Thesis_project/"
    filename = filename + ".pdf"

    ;; fls will return a string array of 1, or an empty string
    fls = file_search( fig_path + filename )
    
    if fls[0] eq "" then begin
        result = getwindows( /current )
        result.save, fig_path + filename
    endif else begin
        print, "File ", filename, " already exists."
    endelse


END
