;==
;== 29 October 2022
;==   Merged with (then deleted) "bda_lightcurves.pro"
;==


; 18 November 2018
;   Created LCs for B, D, A1, A2 that are in paper (at time of writing...)



goto, start
START:;---------------------------------------------------------------------------------

time = strmid(A[0].time,0,5)

before = { $
    phase : "before", $
    xtickinterval : 15, $
    ind : [0:259] }

during = { $
    phase : "during", $
    xtickinterval : 5, $
    ind : [260:344] }

after1 = { $
    phase : "after1", $
    xtickinterval : 15, $
    ind : [314:519] }

after2 = { $
    phase : "after2", $
    xtickinterval : 15, $
    ind : [520:748] }

struc = { before:before, during:during, after1:after1, after2:after2 }

for ss = 0, 0 do begin
    xdata = A.jd[struc.(ss).ind]
    ;ydata = A.flux[struc.(ss).ind]
    ydata = A.data[382,193,0:259]

    ;- Plot AIA light curves
    plt = PLOT_LIGHTCURVES( $
        xdata, ydata, $
        xtickinterval = struc.(ss).xtickinterval/(60.*24.), $
        xminor = struc.(ss).xtickinterval - 1, $
        color = A.color, $
        name = A.name )
    LABEL_TIME, plt, time=time, jd=jd

    ;- Shift curves in y by subtracting the mean.
    resolve_routine, 'shift_ydata', /either
    ;file = 'lc'
    ;file = 'lc_' + struc.(ss).phase
    file = 'lc_bp'
    SHIFT_YDATA, plt
    target=[plt]
    resolve_routine, 'legend2', /either
    leg = LEGEND2( target=target, position=[0.92,0.95], sample_width=0.40 )
    dz = 64
    x1 = A[0].jd[75]
    x2 = A[0].jd[75+dz-1]
    y1 = (plt[0].yrange)[0] * 1.1
    y2 = (plt[0].yrange)[1] * 0.9
    ;plt[0].yrange = y2 * 1.1
    ;ax1 = axis( 'x', location = y2, axis_range=[x1, x2], showtext=0, major=2, $
    ;    tickdir=1)
    ;save2, file
endfor


;============================================================================================
;==  "bda_lightcurves.pro":


;- 20 November 2018

    ;- Plot LC for subregions outlined by polygons

    nn = n_elements(x0)
    flux = fltarr( n_elements(ind), nn )

    for ii = 0, nn-1 do begin
        flux[*,ii] = total( total( $
            crop_data( $
                A[cc].data[*,*,ind], $
                center=[x0[ii],y0[ii]], $
                dimensions=[r,r] ), 1), 1)
    endfor

    continue

    resolve_routine, 'plot3', /either
    plt = plot3( $
        ;A[cc].jd[ind], $
        ind, $
        flux, $
        stairstep = 1, $
        ytitle = A[cc].channel + ' DN s$^{-1}$', $
        xmajor=7, xtitle='time (UT)', $
        linestyle='-', $
        color=color, $
        left = 1.00, right = 0.2, top = 0.2, bottom = 0.5, $
        name=name )

    plt[0].xtickname = time[plt[0].xtickvalues]
    pos = plt[0].position
    leg = legend2( target=plt, position=[pos[2], pos[3]], /relative )

    save2, 'aia' + A[cc].channel + 'lc_subregions_' + phase + '.pdf'

;end
;============================================================================================


end
