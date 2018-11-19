
;- 19 November 2018

goto, start

start:;-------------------------------------------------------------------------------------------------

pro image_maps, imdata

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        xshowtext=0, $
        yshowtext=0, $
        rows=2, cols=3, $
        title=title, $
        rgb_table=A[cc].ct, $
        width = 2.3, $
        left = 0.5, $
        xgap = 0.2, $
        top = 0.25, $
        ygap = 0.25, $
        wy = 4.0 )
end

journal, '2018-11-19.pro'

;- Quiescent region power maps

cc = 0
channel = A[cc].channel
restore, '../aia' + channel + 'map_2.sav'

;- Center coords (lower right corner)
x0 = 425
y0 = 75
r = 125

;- Crop both continuum image (cont) and power map (map).
;quiet_cont = crop_data( map, center=[x0,y0], dimensions=[r,r] )
;quiet_map = crop_data( map, center=[x0,y0], dimensions=[r,r] )

;- Better way: same variable for images and maps... last 63 elements of map will be zeros.
quiet = fltarr(r, r, 749, 2)
quiet[0,0,0,0] = crop_data( A[cc].data, center=[x0,y0], dimensions=[r,r] )
quiet[0,0,0,1] = crop_data( map, center=[x0,y0], dimensions=[r,r] )

;- Don't need mask because this area isn't saturated.


wx = 8.0
wy = 5.0
win = window( dimensions=[wx,wy]*dpi, /buffer )

cols = 2
rows = 1


;for cc = 0, 1 do begin

    im = image2( $
        quiet[*,*,32,0], $
        layout = [cols,rows,1], $
        margin = 0.25, $
        /current, /device, $
        title = A[cc].name + ' continuum' )

    im = image2( $
        quiet[*,*,32,1], $
        layout = [cols,rows,2], $
        margin = 0.25, $
        /current, /device, $
        title = A[cc].name + ' 3-minute power' )
;endfor


save2, 'quiet_powermaps'

end
