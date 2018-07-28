

pro subregion3, data



end

center_coords = [ $
    [100,100], $
    [250,180], $
    [360,210], $
    [450, 50] ]

x0 = center_coords[0,*]
y0 = center_coords[1,*]
r = 25

;; Add option to give cropped z-dimension to crop_data.pro
data = CROP_DATA( A[0].data, dimensions=[r,r], center = [x0[2],y0[2]] )
sz = size(data, /dimensions)
;----------------------------

;; Image power map first, make sure bp is roughly centered
win = window(/buffer)
temp = data[*,*,645]
im = image2( temp, /current, layout=[1,1,1], margin=0.1 )
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
