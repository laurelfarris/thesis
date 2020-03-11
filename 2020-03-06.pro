;+
;- 06 March 2020
;-



;+
;- Today's project: create global mask where any pixel that saturates
;-  even once during entire 5-hour time series is set = 0.
;-  Code in current directory called "mask.pro" that's over a year old,
;-  but looks to do almost exactly this.
;-


resolve_routine, 'read_my_fits'
READ_MY_FITS, index, data, $
    instr='aia', $
    channel=1600, $
    ind=[280], $
    nodata=0, $
    prepped=1


print, index.date_obs
print, index.nsatpix
print, index.nspikes
print, index.missvals

print, index.pixlunit


im = image2( data )

;--

threshold = 10000.


mask = fltarr(500,330,2)

z_ind = [0:264]

for cc = 0, 1 do begin

    mask_cube = A[cc].data[*,*,z_ind] lt threshold/A[cc].exptime

    mask[*,*,cc] = product( mask_cube, 3 ) 
endfor


file = 'sat_hmi_contour'
save2, file
stop

zz = 201
win = window( dimensions=[8.5,11.0]*dpi )

for cc = 0, 1 do begin

    im = image2( $
        alog10(A[cc].map[*,*,zz]), $
        /current, $
        /device, $
        layout=[1,2,cc+1], $
        margin=1.25*dpi, $
        rgb_table=A[cc].ct, $
        title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + $
            ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')' )

         c_data = get_contour_data( time[zz+(dz/2)], channel='mag' )
         c = contours( c_data, target=im, channel='mag' )


        sat_contour = contour2( $
            mask[*,*,cc], $
            c_value=[1], $
            color=['red'])
            stop
endfor

stop


start:


;----------
file = 'sat_contour'

z_start = [75, 201, 250, 320, 387, 675]


for cc = 0, 1 do begin

    im = objarr(6)
    win = window( dimensions=[8.5,11.0]*dpi )

    foreach zz, z_start, ii do begin

        im[ii] = image2( $
            alog10(A[cc].map[*,*,zz]), /current, /device, $
            rgb_table=A[cc].ct, $
            layout=[2,3,ii+1], $
            margin=1.00*dpi, $
            title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + $
            ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')' $
            )


        if ii eq 0 OR ii eq 2 OR ii eq 4 then $
            im[ii].position = im[ii].position + [0.10, 0.0, 0.10, 0.0]

        sat_contour = contour2( $
            mask[*,*,cc], $
            c_value=[1], $
            color=['black'])

            
    endforeach
    save2, file, /append
endfor




end

end
