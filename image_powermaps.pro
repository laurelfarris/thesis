;+
;- LAST MODIFIED:
;-   29 April 2019
;-
;-

pro image_powermaps, imdata, cols, rows

    sz = size(imdata, /dimensions)


    ;- Set common min/max values for all maps
    min_array = fltarr(sz[2])
    max_array = fltarr(sz[2])
    for ii = 0, sz[2]-1 do begin
       min_array[ii] = min(imdata[*,*,ii]) 
       max_array[ii] = max(imdata[*,*,ii]) 
    endfor
    min_value = max(min_array)
    max_value = min(max_array)


    left = 0.01
    right = 0.01
    bottom = 0.01
    top = 0.1

    im = objarr(sz[2])

    wx = 8.5
    wy = 11.0
    win = window( dimensions=[wx, wy]*dpi, location=[600,0] )
    for ii = 0, n_elements(im)-1 do begin
        im[ii] = image2( $
            imdata[*,*,ii], $
            current=1, $
            layout=[cols,rows,ii+1], $
            margin=[left,bottom,right,top], $
            min_value=min_value, $
            max_value=max_value, $
            axis_style = 0, $
            ;rgb_table = AIA_COLORS( wave=A[cc].channel ), $
            title=title[ii], $
            buffer=0, $
            _EXTRA=e )
    endfor


end

goto, start
start:;-------------------------------------------------------------------------------


;- Syntax
;-   imdata = AIA_INTSCALE( data, wave=wave, exptime=exptime )

@restore_maps

cc = 1
dz = 64
time = strmid(A[cc].time,0,5)



rows=6
cols=4

z_ind = 20 * indgen(rows*cols)
title = time[z_ind] + '-' + time[z_ind+dz-1]

;r = 600
;dimensions = [r, r]
;center=[1700,1650]

;imdata = []
;foreach zz, z_ind, ii do $
;    imdata = [ [[imdata]], [[ alog10(total( A[cc].data[*,*,zz:zz+dz-1], 3)) ]] ]


imdata = alog10(A[cc].map[*,*,z_ind])

image_powermaps, imdata, cols, rows, rgb_table=A[cc].ct


end
