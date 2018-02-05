; Last modified:    Mon Mar 27
; Filename:         read_my_sdo.pro
; Programmer:       Laurel Farris


pro READ_MY_SDO, index, data, wave

    ;; Returns header and desired data cube

    ;; Note: Written to correct for shifts using header info,
    ;;   since corrections were not made before aligning.
    ;; Need to redo all data to correct from the beginning.

    common BP_BLOCK

    ;; Read in header info
    fls = ( file_search( path + "*" + wave + "A*.fits" ) )[0:z-1]
    READ_SDO, fls, index, cube, nodata=1

    ;; Restore aligned data (1000x1000; variable name = cube)
    restore, path + "aligned_" + wave + ".sav"

    ;; shift in x and y based on header (index.xcen, index.ycen).
    x_center = x_ref - round(index[0].xcen)
    y_center = y_ref - round(index[0].ycen)

    ;; Trim cube to desired range.
    data = cube[ $
        x_center - (x/2)  :  x_center + (x/2)-1, $
        y_center - (y/2)  :  y_center + (y/2)-1, $
        0:z-1 ]

    ;; Shift cube according to header information
    data = shift( cube, -round(index[0].xcen), -round(index[0].ycen), 0 ) 


    ;; Correct shift in each bandpass using header values
    ;;  (check to see if these change from one image to the next for a given wave
    ;;  and/or if arrays can be used to shift like this.
    ;; Shifting data itself instead of moving location of reference pixel...
    ;data = shift( temporary(data), index[0].xcen, index[0].ycen )

end
