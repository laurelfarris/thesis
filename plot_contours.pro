; Last modified:   05 June 2018


; What values does HMI B_LOS data have?
; Neg. vs. positive polarity...

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
