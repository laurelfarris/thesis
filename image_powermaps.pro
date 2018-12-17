

;- 25 November 2018

;- One image/map per file?
;- Or create arrays of images?
;- Keep each channel separate?

;- Loop through image data, plus titles, rgb_tables, filename to save, ...

;pro image_powermaps, struc, _EXTRA = e
function image_powermaps, struc, _EXTRA = e

    imdata = alog10(struc.imdata)

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        title = struc.title, $
        xshowtext=0, yshowtext=0, $
        rows = 1, $
        cols = 1, $
        ;wx = 4.0, $
        wx = 8.0, $
        buffer = 0, $
        left = 0.10, right = 0.10, bottom = 0.10, top = 0.50, $
        ;left = 0.01, right = 0.01, bottom = 0.15, top = 0.15, $
        _EXTRA = e )

;    pos = (im[0]).position
;    width = pos[2]-pos[0]
;    height = pos[3]-pos[1]
;    print, ''
;    print, im.xticklen
;    print, (sqrt(height/width))/25.
;    print, ''
;    print, im.yticklen
;    print, (sqrt(width/height))/25.
;    print, ''
;
    ;- image3 should return im as objarr with as many elements as
    ;-  matches the third dimension of struc.imdata.
    ;- But can't really access it from ML if only created here, and not returned...
    return, im
end

goto, start
start:;---------------------------------------------------------------------------------
cc = 0

dz = 64
time = strmid(A[cc].time,0,5)
z_start = 197 ;- pre-flare
;z_start = 204 ;- pre-flare/impulsive
;z_start = 450 ;- post-flare


zz = z_start

;- AIA intensity
intensity = { $
    imdata : mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    ;imdata : aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime ), $
    title : A[cc].name + ' (' + A[cc].time[zz] + '-' + A[cc].time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_image' }

;- HMI
hmi = { $
    imdata : mean(H[0].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    title : H[0].name, $
    file : 'hmi' + H[0].channel + 'big_image' }

;- Maps
map = { $
    imdata : A[cc].map[*,*,z_start], $
    title : A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_map' }


;im1 = IMAGE_POWERMAPS( intensity, rgb_table = A[cc].ct )
im = IMAGE_POWERMAPS( map, rgb_table = A[cc].ct )

end
