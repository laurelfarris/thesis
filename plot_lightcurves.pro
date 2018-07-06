; Last modified:   29 June 2018

; should have no problem running this, even if spontaneously reading
; random data from a few fits files and want to plot it.
; No loops here; call this routine INSIDE loops.

; Also see aia_prep documentation on plotting light curves.


function PLOT_LIGHTCURVES, x, y, _EXTRA=e

    common defaults
    dw
    wx = 8.5
    wy = 3.0; * 2
    win = window( dimensions=[wx,wy]*dpi, buffer=1 );,location=[600,0] )

    ; Margin values for axes that are not on top of other axes.
    ; These are all you should have to change to adjust margins.
    left = 1.00
    bottom = 0.75
    right = 1.00
    top = 0.75
    margin = [ left, bottom, right, top ] * dpi


        p = plot2( $
            x, y, /current, /device, $
            ;current = ... something similar to i<1 for multi-panel figures
            layout = [1,1,1], $
            margin = margin, $
            xticklen = 0.05, $
            yticklen = 0.015, $
            ystyle = 2, $
            xminor = 4, $
            yminor = 4, $
            xtitle='Start time (UT) on 2011-February-15', $
            stairstep = 1, $
            _EXTRA=e $
            )
    return, p
end

; show every 30 minutes on x-axis
ind = [74:748:75]
time = strmid(A[0].time,0,5)
xtickvalues = A[0].jd[ind]
xtickname = time[ind]

p = objarr(n_elements(A))

for i = 0, n_elements(p)-1 do begin

    x = A[i].jd
    y = A[i].flux / A[i].exptime

    if i eq 0 then begin
        p[i] = PLOT_LIGHTCURVES( $
            x, y, $
            ytitle = 'counts (DN s$^{-1}$)', $
            xtickvalues = xtickvalues, $
            xtickname = xtickname, $
            color = A[i].color )
     endif else begin
        p[i] = plot2( x, y, /overplot, color=A[i].color )
     endelse

endfor

resolve_routine, 'save2'
file = 'lc_dn_per_second.pdf'
save2, file, /add_timestamp

    ; keyword? Set by setting equal to struture with extra stuff?
    ; Can't use variable 'e' twice...
    ;leg = legend2( target=p )

    ; TO-DO: Input current plot and pull yrange straight from that.
    ;        Figure out a way to run this first, so they're in background
    ;        'Hide' method?

    ;v = plot( [x,x], yrange, /overplot, ystyle=1, _EXTRA=e )
    ; Could also call with overplot=reference_to_plot

    ; Vertical lines at periods of interest
    ;v = objarr(n_elements(period))
    ;for i = 0, n_elements(v)-1 do $
    ;    v[i] = plot_vline( $
    ;        1./period[i], $
    ;        p.yrange, $
    ;        color='grey' $
            ;name=strtrim( fix(1./vert[i]),1) + ' sec' $
    ;        )
    ;leg = legend2(target = v, position = [0.9,0.8])
    ;leg = legend2( target=p,  position = [0.9,0.8])

end
