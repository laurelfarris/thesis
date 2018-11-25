
;- Last updated:    25 November 2018

;- See "Make_plots.pro" for more GOES routines
;-  (or probably copies of stuff that's already in here).

pro PLOT_GOES, A, gdata

    if n_elements(gdata) eq 0 then gdata = GOES()
    ;- If this routine hits an error further down, gdata might not
    ;- be returned, and will have to do this every time anyway.
    ;- Though it seems that it was updated in ML as soon as this ran,
    ;- even after running into error and doing RETALL, so maybe this is fine.

    common defaults
    dw
    wx = 8.0
    wy = 4.0
    win = window( dimensions=[wx,wy]*dpi, buffer=0 )

    left = 0.75
    bottom = 0.5
    right = 0.5
    top = 0.5
    margin = [left,bottom,right,top]

    width = wx - (left + right)
    height = wy - (top + bottom)
    xticklen = width / 200.
    yticklen = height / 200.

    p = objarr(2)

    color = [ 'black', 'pink' ]
    name = ['1.0 - 8.0 $\AA$', '0.5 - 4.0 $\AA$']

    for ii = 0, 1 do begin

        ydata = reform(gdata.ydata[*,ii])
        ydata = (ydata-min(ydata))/(max(ydata)-min(ydata))

        ;- Xdata =
        xdata = indgen(n_elements(ydata))
        xdata = gdata.tarray

        p[i] = plot2( $
            xdata, ydata, $
            /current, $
            /device, $
            overplot=ii<1, $
            layout=[1,1,1], $
            margin=margin*dpi, $
            xmajor=10, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='Start Time ' + gdata.utbase, $
            ytitle='GOES flux (W m$^{-2}$)', $
            color=color[ii], $
            name=name[ii] )
    endfor
end
