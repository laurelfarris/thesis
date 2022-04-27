; Last modified:   17 July 2018

; Expanding on first subregion code to create WA plots and lightcurves
;  for a few regions of interest.


;; WA plots
pro SUB_WA, flux, layout=layout

    dz = 64  ; length of time segment (#images) over which to calculate FT
    z_start = [ 0 : n_elements(flux)-dz-1 : dz ] ; starting indices/time for each FT (length = # resulting maps)
    fmin = 0.001
    fl = 0.005
    fc = 1./180
    fu = 0.006
    fmax = 0.009

    CALC_WA, flux, frequency, wmap, cadence=24, z=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0

    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    X = (findgen(D1)/100)*dz
    ;xtickname=strtrim( [0:n_elements(flux):64], 1 )

    ;resolution = frequency[1] - frequency[0]
    inc = (max(frequency) - min(frequency)) / (D2-1)
    Y = [ min(frequency) : max(frequency) : inc ]
    Y = Y * 1000

    im = IMAGE2( wmap2, $
        X=X, Y=Y, /current, /device, $
        layout=layout, margin=0.2*dpi, $
        xmajor=12, $
        ymajor=7, $
        ytickformat='(F0.2)', $
        aspect_ratio=0, $
        rgb_table=34, $
        ;title=A[ii].name, $
        ;xtitle='Start time (2011-February-15)', $
        xtitle='image #', $
        ytitle='Frequency (mHz)' )

    v = objarr(3)
    v[0] = plot( im.xrange, 1000*[fl,fl], /overplot, linestyle=':', name='$\nu_{lower}$')
    v[1] = plot( im.xrange, 1000*[fc,fc], /overplot, linestyle='--', name='$\nu_{center}$' )
    v[2] = plot( im.xrange, 1000*[fu,fu], /overplot, linestyle=':', name='$\nu_{upper}$' )

    leg = legend2( target=[v], position=[0.95,0.5] )
end

;; Boxed Subregions on images and/or power maps
pro SUB_IMAGE, data, coords, side=side, names=names, layout=layout, _EXTRA=e

    common defaults
    im = image2( $
        data, $
        /current, /device, $
        layout=layout, $
        margin=0.25*dpi, $
        xshowtext=0, $
        yshowtext=0, $
        _EXTRA=e )

    ; Polygons
    ;rec.delete
    N = n_elements(coords[0,*])
    rec = objarr(N)
    for jj = 0, N-1 do begin
        x1 = coords[0,jj] - side/2
        y1 = coords[1,jj] - side/2
        x2 = x1 + side
        y2 = y1 + side
        rec[jj] = POLYGON2( $
            ;[ coords[0,jj], coords[1,jj] ], $
            [x1,y1,x2,y2], side=side, $
            target=im )
        t = text( $
            ;0.0, 1.0, $
            x1, y2, $
            names[jj], $
            data=1, $
            target=im, $
            vertical_alignment=1.0, $
            alignment=1.0, $
            font_style='Bold', $
            font_size=fontsize, $
            color='black')
    endfor
end

pro SUB_LC, data, coords, side=side, names=names, layout=layout, _EXTRA=e
    ;; Lightcurves

    common defaults
    plot_color = ['blue', 'red', 'green', 'dark orange', 'purple', 'deep sky blue']

    N = ( size(coords, /dimensions) )[1]
    p = objarr(N)
    for i = 0, N-1 do begin
        x1 = coords[0,i] - side/2
        y1 = coords[1,i] - side/2
        x2 = x1 + side
        y2 = y1 + side

        ydata = (i*1000) + total( total( data[x1:x2,y1:y2,*], 1), 1)
        xdata = indgen(n_elements(ydata))
        p[i] = plot2( $
            xdata, ydata, $
            /current, /device, $
            layout=layout, $
            margin=0.50*dpi, $
            overplot=i<1, $
            color=plot_color[i], $
            linestyle=i, $
            ;symbol=i+3, sym_filled=1, sym_size=0.25, $
            xtitle='time', $
            ylog=1, $
            name=names[i], $
            ytitle='log counts (DN s$^{-1}$)' )
            ;ytitle='counts (DN s$^{-1}$)' )
    endfor
    leg = legend2( target=[p], /relative, position=[0.9,0.9] )
end

wx = 8.5
wy = 6.0
;win.erase
dw
win = window( dimensions=[wx,wy]*dpi, buffer=1 )

rows = 2
cols = 1

ii = 0

channel = A[ii].channel
ct = AIA_COLORS(wave=channel)
z_start = [0, 260, 560 ]
;map = A[ii].map[*,*,z_start[2]]
map = A[ii].map
im = AIA_INTSCALE( map, wave=fix(channel), exptime=A[ii].exptime )

names = [ $
    'AR1', $
    'AR2', $
    'AR3', $
    'quiet' ]
side = 100
coords = [ $
    [100,100], $
    [250,180], $
    [360,210], $
    [450, 50] ]

data = A[ii].data/A[ii].exptime
SUB_IMAGE, im, coords, layout=[cols,rows,1], side=side, names=names, rgb_table=ct
SUB_LC, data, coords, side=side, names=names, layout=[cols,rows,2]
;SUB_WA, data, coords, layout=[cols,rows,3]

save2, 'aia' + channel + 'subregion2.pdf', /add_timestamp
end
