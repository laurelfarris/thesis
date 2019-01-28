;-
;- Sun Jan 27 16:55:14 MST 2019
;- Compute power maps for various central frequency values to compare
;-   3-min maps to 2-min, 5-min, etc.



goto, start
start:;----------------------------------------------------------------------------------

;- User-defined values

cc = 1
dz = 64

;- Define z indices
z_start = 75
;z_start = [197] ;- pre-flare
;z_start = [204] ;- pre-flare/impulsive
;z_start = [450] ;- post-flare

bandwidth = 0.001

period = [50, 120, 180, 200, 300, 500]
nn = n_elements(period)




;----------------------------------------------------------------------------------------
;- Code that shouldn't change...




time = strmid(A[cc].time,0,5)
map = fltarr( 500, 330, nn )
title = strarr(nn)


map_mask = POWERMAP_MASK( A[cc].data[*,*,z_start:z_start+dz-1], dz=dz, $
    exptime=A[cc].exptime, threshold=10000. )


;- Compute power map
for ii = 0, nn-1 do begin
    map[*,*,ii] = COMPUTE_POWERMAPS( $
        A[cc].data, $
        A[cc].cadence, $
        fcenter=1./period[ii], $
        bandwidth=bandwidth, $
        z_start=z_start, $
        dz=dz, $
        norm=0 ) * map_mask

endfor

map = map > 0



;- Sun Jan 27 17:45:29 MST 2019
;-
;- What makes this code different from imaging anything else?
;-     min_value/max_value
;-     title --> range of time covered to produce power map
;-     room for colorbar



for ii = 0, nn-1 do begin

    title[ii] = A[cc].name + ' ' + $
        ;strtrim(fcenter[ii]*1000, 1) + ' mHz ('  + $
        strtrim(period[ii], 1) + ' sec (' + $
        time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
endfor

resolve_routine, 'image3', /either
;- NOTE: image3 returns object array
dw
imdata = alog10(map)
im = image3( $
    imdata, $
    title=title, $
    rgb_table = A[cc].ct, $
    min_value=0.000001, $
    ;max_value=max(imdata), $
    max_value=4.2, $
    xshowtext=0, $
    yshowtext=0, $
    wx = 8.50, $
    top = 0.5, $
    ygap = 0.5, $
    rows = 2, $
    cols = 3, $
    buffer = 0 )


end
