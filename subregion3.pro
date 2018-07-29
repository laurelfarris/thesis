

pro subregion3, data



end
goto, start

center_coords = [ $
    [100,100], $
    [250,180], $
    [360,210], $
    [450, 50] ]

x0 = reform(center_coords[0,*])
y0 = reform(center_coords[1,*])

;----------------------------
start:

r = 25
xc = 25
yc = 75

ii = 1

;; Add option to give cropped z-dimension to crop_data.pro
data = CROP_DATA( A[ii].map, dimensions=[r,r], center = [xc,yc] )
sz = size(data, /dimensions)

;; Image power map first, make sure bp is roughly centered
dw
;win = window( dimensions=[8.5,11.0]*dpi, /buffer)
win = window( /buffer)
temp = A[ii].data
;temp = A[ii].map < 2500

time = strmid(A[ii].time,0,8)
z_start = [8, 200, 400, 600]
dz = 64

;result = AIA_INTSCALE(temp,wave=1700,exptime=A[ii].exptime)
foreach z, z_start, i do begin
    result = aia_intscale( mean(temp[*,*,z:z+dz-1], dimension=3), $
        wave=1700, exptime=A[ii].exptime )
    im = image2( result, $
        /current, $
        layout=[2,2,i+1], margin=0.1, rgb_table=A[ii].ct, $
        title=time[z] + '-' + time[z+dz-1] + ' (' + strtrim(z,1) + $
            '-' + strtrim(z+dz-1,1) + ')' $
            )
endforeach
save2, 'test_im.pdf', /add_timestamp
;save2, 'test_map.pdf', /add_timestamp
stop
c = contour( $
    temp, $
    /overplot, $
    c_value = mean(temp), $
    color='white', $
    c_thick=2, /c_label_show )

save2, 'bp_map.pdf', /add_timestamp
stop


    ;; 2xN array = TOTAL flux from "bright point" above 1 and 2 \sigma
    bp_flux = fltarr(2, sz[2])


    ;; Coord at 360, 210 to start
    for i = 0, sz[2]-1 do begin

        ;temp = data[ x0[2]-r:x0[2]+r-1, y0[2]-r:y0[2]+r-1, i ]

        meann = (MOMENT(temp))[0]
        stdev = sqrt( (MOMENT(temp))[1] )

        data1 = temp > (meann + 1.0*stdev)
        data2 = temp > (meann + 2.0*stdev)

        bp_flux[0,i] = total( total( data1, 1), 1)
        bp_flux[1,i] = total( total( data2, 1), 1)

    endfor



;; plot same frequency range as WA plots for BDA


end
