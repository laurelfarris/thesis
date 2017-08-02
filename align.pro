;; Last modified:   15 July 2017 19:33:17
;; Filename:        align.pro
;; Function(s):     align_cube3.pro, alignoffset.pro, align_shift_sub.pro
;; Description:     Align images using the center image as a reference
;;                      Reference can be changed in align_cube3.pro
;;                      Images should shift more in x than y since this
;;                      is primarily correcting for rotation of sun.



pro ALIGN, cube

    ;; Start alignment. Note this may take a while, depending on size of cube;
    ;;      1000 x 1000 x 300 x 6 took ~4 hours.
    ;;      Should probably rewrite so my_average isn't being copied back and forth each time.
    my_average = []
    sdv = []
    repeat begin
        ALIGN_CUBE3, cube, x_sdv, y_sdv
        ;my_average = [my_average, avg]
        ;k = n_elements(my_average)
        sdv = [sdv, x_sdv]
        k = n_elements(sdv)
    endrep until (k ge 2 && sdv[k-1] gt sdv[k-2])

end


pro ALIGN_HMI, cube
    ;; Coords for flare in HMI data (roughly in the middle of group of sunspots)
    ;; Relative to (unrotated) 4096 x 4096 full disk image
    ;;   r is the "radius", or perpendicular distance from center to edge of square
    ;; Note: These will need to be corrected when hmi images are properly rotated 180 degrees.

    x = 1650
    y = 2450
    r = 500

    ;; Cut out r x r data cube centered at x, y (variables declared above)

    cube = hmi_data[ x-r:x+r-1, y-r:y+r-1, 22:* ]


    ;; Run alignment

    ALIGN, cube

    ;; Save, cutting out edges where alignment routine caused wrapping.
    save, cube[100:899, 100:899, *], 'hmi_aligned.sav'
end


pro ALIGN_AIA, data, cube

    x = 2445
    y = 1645
    r = 500

    cube = data[x-r:x+r-1,y-r:y+r-1, *]
    align, cube

end


pro SAVE_ALIGN, cube

    cube = cube[100:899, 100:899, *]
    save, cube, filename="aia_1700_aligned.sav"
end



;ALIGN_AIA, data, cube
; Will stop when shift is higher than previous, but may be worth running this again...
; Went to even tinier shifts with aia_1700_data
SAVE_ALIGN, cube


;; Where should these steps be done?
;;   In read_fits after reading?
;;   In align routine before aligning?
;; data read in from fits
;; trimmed to area of interest to reduce align time
;; trimmed again to get rid of edges
;; saved
end
