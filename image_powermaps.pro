

;- 25 November 2018

;- One image/map per file?
;- Or create arrays of images?
;- Keep each channel separate?

;- Loop through image data, plus titles, rgb_tables, filename to save, ...

pro image_powermaps, struc, _EXTRA = e

    imdata = alog10(struc.imdata)

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        title = struc.title, $
        xshowtext=0, yshowtext=0, $
        rows = 1, $
        cols = 1, $
        wx = 4.0, $
        buffer = 0, $
        left = 0.10, right = 0.10, bottom = 0.10, top = 0.50, $
        ;left = 0.25, right = 0.25, bottom = 0.25, top = 0.50, $
        _EXTRA = e )
end

goto, start
start:;---------------------------------------------------------------------------------
cc = 0

dz = 64
time = strmid(A[cc].time,0,5)
;z_start = 197 ;- pre-flare
;z_start = 204 ;- pre-flare/impulsive
z_start = 450 ;- post-flare



zz = z_start

;- Intensity
intensity = { $
    imdata : mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    ;imdata : aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime ), $
    title : A[cc].name + ' (' + A[cc].time[zz] + '-' + A[cc].time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_image' }

;- Maps
map = { $
    imdata : A[cc].map[*,*,z_start], $
    title : A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_map' }


IMAGE_POWERMAPS, intensity, rgb_table = A[cc].ct
IMAGE_POWERMAPS, map, rgb_table = A[cc].ct

end
