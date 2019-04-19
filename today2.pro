
;- Fri Apr 19 17:43:28 MDT 2019
;- copied today.pro content for creating graphics.
;-  This should be separate from reading fits and restoring data from .sav files.

ct = AIA_COLORS( wave=channel )

xx = 525
yy = 400
dimensions = [xx, yy]
center=[1675,1600]

;- NOTE: 500x330 dimensions are HARD-CODED in crop_data routine!
;-         Possibly set as "defaults" using some hacky if statements...
;-        Look into this later.

resolve_routine, 'crop_data', /either
imdata = CROP_DATA( $
    data, $
    center=center, dimensions=dimensions )
stop

zz = 246
;imdata = AIA_INTSCALE( $ data[*,*,zz], $ wave=1700, exptime=index[zz].exptime )


im = image2( imdata[*,*,zz], /buffer, rgb_table=ct )
;@image_quick

save2, 'sol2013_aia' + string(channel)
stop


;-   Lightcurves
;-   (NOTE: If alignment hasn't been done yet,
;-         need to use big enough box to contain AR throughout time.)

flux = total( total( imdata, 1), 1 )
help, flux

common defaults
color = ['blue']
name = ['AIA ' + string(channel)]


dw
win = window( dimensions=[8.0, 3.0]*dpi, buffer=1 )
ii=0
;for ii = 0, 1 do begin
    plt = plot2( $
        ;mynorm(flux), $
        flux[50:*], $
        ylog=1, $
        ;(flux-min(flux))/(max(flux)-min(flux)), $
        ;flux[*,ii], $
        current = 1, $
        overplot = ii<1, $
        layout = [1,1,1], $
        margin = 0.1, $
        name = channel[ii], $
        color = color[ii] )
;endfor

save2, 'lc2'


end
