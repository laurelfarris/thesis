
pro shaded

; Vertical SHADED area (not lines) over main flare +/- dz
vx1 = A[0].jd[ (where( time eq flare[ 0] ))[0] - 32   ]
vx2 = A[0].jd[ (where( time eq flare[-1] ))[0] + 32-1 ]
v = plot( $
    ;[ f[0]-32, f[0]-32, f[-1]+32-1, f[-1]+32-1 ], $
    [ vx1, vx1, vx2, vx2 ], $
    [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
    /overplot, $
    ystyle=1, $
    linestyle=6, $
    fill_background=1, $
    fill_transparency=80, $
    fill_color='light gray' )

end

pro plot_vertical_lines, p

    yrange = p.yrange

    ; Flare start, peak, & end times (only for full time series...)
    flare = ['01:44', '01:56', '02:06']
    name = ['start', 'peak', 'end' ]

    ; Vertical lines showing flare start, peak, end
    for j = 0, n_elements(flare)-1 do begin
        ; TO-DO: Pull yrange straight from current plot
        ind = (where( time eq flare[j] ))[0]
        vx = A[0].jd[ind]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, color='silver' );,linestyle=3, color='grey', linestyle=i+2, name=name[i] )
        ; Call with overplot=p[i] (reference to plot... need to double check that this works.)
    endfor
    i1 = (where( time eq flare[0 ] ))[0] - 32
    i2 = (where( time eq flare[-1] ))[0] + 32-1
    ind = [i1, i2]
    for j = 0, 1 do begin
        vx = A[0].jd[ind[j]]
        v = plot( [vx,vx], yrange, overplot=1, ystyle=1, linestyle=3, color='dark gray' );, linestyle=i+2, name=name[i] )
    endfor



end
