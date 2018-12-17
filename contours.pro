
;- 14 December 2018


;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011


function CONTOURS, c_data, target=target, channel=channel

    ;c_data = get_hmi(time, channel=channel)

    sz = size(c_data, /dimensions)
    if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]
    contourr = objarr(nn)

    if channel eq 'cont' then begin

        ;- Define continuum contours relative to average in quiet sun (lower right corner).
        data_avg = mean(c_data[350:450,50:150])

        ;- Outer edges of [penumbra, umbra]
        c_value = [0.9*data_avg, 0.6*data_avg]

        c_color = ['red','red']
        c_thick = 1.0
        name = 'umbra and penumbra boundaries'
    endif
    if channel eq 'mag' then begin

        ;- min/max values used by Schrijver2011... don't know why.
        c_value = [-300, 300]
        c_color = ['black', 'white']

        ;c_value = [-1000, -300, 300, 1000]
        ;c_value = [ -reverse(c_value), c_value ]
        ;c_thick = [1.0, 2.0, 2.0, 1.0]
        ;c_color = ['black', 'black', 'white', 'white']

        rgb_table = 0 ; black --> white
        name = 'B$_{LOS} \pm 300$'
        ;title = 'B$_{LOS} \pm 300$'

    endif

    for ii = 0, nn-1 do begin
        contourr[ii] = CONTOUR( $
            c_data, $
            overplot=target, $
            c_value=c_value, $
            c_thick=1.0, $
            c_color=c_color, $
            c_linestyle='-', $
            c_label_show=0, $
            title = title, $
            name = name )
    endfor

    return, contourr

    ;- ML stuff:

    ;- hmi line through middle of two sunspots (pos/neg)
    ;p = plot2( hmi[*,175,0] )

    ;file = 'HMI_BLOS_contours.pdf'
    ;save2, file
    ;c.delete
end


;-  READ ME!!!!!!!!!!
;- In current form, image_powermaps needs to be run BEFORE contours.
;- dz and time are both defined there, and objarr "im" is returned to ML.
;- Then contours.pro (current file) overlays contours on existing image.
;-  (This is not ideal, but no time to make better subroutines right now.)

c_data = GET_HMI( time[zz+(dz/2)], channel='mag' )
;- NOTE: get_hmi.pro uses time to get closest hmi date_obs,
;-        so the correct HMI is being used (at least I hope so...)


c = CONTOURS( c_data, target=im, channel='mag' )


;- HMI contours ---> average stack of dz images!
;-   Except don't use average since B values are +/- N
;-   (average would give you a bunch of zeroes).
;- Use absolute values, or standard deviation.

end
