;; Last modified:  22 May 2017 16:46:35
;; Filename:         align.pro
;; Function(s):      align_cube3.pro, alignoffset.pro, align_shift_sub.pro
;; Description:      Align images


pro ALIGN, cube


    ;; Start alignment. Note this may take a while, depending on size of cube;
    ;;      1000 x 1000 x 300 x 6 took ~4 hours.
    my_average = []
    repeat begin
        ALIGN_CUBE3, cube, avg
        my_average = [my_average, avg]
        k = n_elements(my_average)
    endrep until (k ge 2 && my_average[k-1] gt my_average[k-2])

end
