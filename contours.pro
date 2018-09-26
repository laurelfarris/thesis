; Last modified:   26 September 2018


; Also see Old/plot_contours_old.pro, journal.pro, 
;    subregion3.pro, and subregion4.pro


; What values does HMI B_LOS data have?
; Neg. vs. positive polarity...


; randomly chosen indices for developing code:
ind = [50, 300, 500]

aia = A[0].data[*,*,ind]


; fraction of pixel values to include in each contour
c2 = quiet_avg * 0.6
c1 = quiet_avg * 0.9

; First argument - data used to create contours.
; Then overplot c on top of another image
c = contour( $
    hmi[*,*,0], $
    c_value=[c1,c2], $
    c_color=['black','white'], $
    c_label_show=0, $
    ;n_levels=6,
    /overplot )

end
