; Last modified:   26 September 2018


; Also see Old/plot_contours_old.pro, journal.pro, 
;    subregion3.pro, and subregion4.pro


; What values does HMI B_LOS data have?
; Neg. vs. positive polarity...


; randomly chosen index to develop code for non-flaring time:
ind = 50

; restore UN-aligned data
;restore, '../aia1600data.sav'
;restore, '../hmi_mag.sav'



read_my_fits, aiaindex, aiadata, instr='aia', channel='1600', $
    ind=ind, prepped=1
read_my_fits, hmiindex, hmidata, instr='hmi', channel='mag', $
    ind=ind, prepped=1

x0 = 2445
y0 = 1645
width = 800
height = 800

aia = crop_data( aiadata, dimensions=[width,height], center=[x0,y0] )
hmi = crop_data( hmidata, dimensions=[width,height], center=[x0,y0] )

; need subroutine like "image_hmi" with keyword for data type.
; Use it to set color table/scale, name and/or title of graphic, etc.

im = image2( hmidata, layout=[1,2,1], /current )


stop

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
