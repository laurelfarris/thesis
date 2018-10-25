

; Also see Old/plot_contours_old.pro, journal.pro, 
;    subregion3.pro, and subregion4.pro


; What values does HMI B_LOS data have?
; Neg. vs. positive polarity...

;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011


pro older
    ; Last modified:   26 September 2018

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



goto, start

resolve_routine, 'read_my_fits', /either
S = GET_IMAGE_DATA()

center = [2375, 1660] + 24
data = fltarr( 500, 330, 4 )
for ii = 0, 3 do begin
    data[*,*,ii] = crop_data( S.(ii).data, center=center )
endfor





;- HMI B_LOS contours
;file = 'contour_HMI_mag.pdf'
;gauss = 700
;c_data = data[*,*,2] < gauss > (-gauss)
;c_data = data[*,*,2]
;c_value = 0.99 * [ min(c_data), max(c_data) ]
;c_value = 0
c_value = [300, 1000 ]
c_value = [ -reverse(c_value), c_value ]
c_color = ['red','blue']


start:;

;- HMI continuum contours
file = 'contour_HMI_cont.pdf'
c_data = data[*,*,3]
avg = mean(c_data[350:450,0:150])
c_value = [ 0.6, 0.9 ] * avg
c_color = ['white','black']


dw
wx = 8.5
wy = 6.0
win = window( dimensions=[wx,wy]*dpi, /buffer)

rows = 2
cols = 2
im = objarr(rows*cols)

for ii = 0, 3 do begin
    im[ii] = image2( $
        data[*,*,ii], /current, layout=[cols,rows,ii+1], margin=0.1 )

endfor
im[0].rgb_table = S.(0).extra.rgb_table
im[1].rgb_table = S.(1).extra.rgb_table



rgb_table = 70

c = objarr(rows*cols)
for ii = 0, rows*cols-1 do begin
c[ii] = contour( $
    c_data, $
    c_value=c_value, $
    ;n_levels=8, $
    ;min_value = , $
    ;max_value = , $
    ;color='blue', $
    c_color=c_color, $
    ;rgb_table = rgb_table, $
    c_label_show=0, $
    c_thick=0, $
    overplot=im[ii] )
endfor

save2, file
;c.delete
end
