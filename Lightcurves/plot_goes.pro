;+
;- LAST MODIFIED:
;-   08 July 2021
;-
;- PURPOSE:
;-   Plot GOES data using my pretty plotting adjustments.
;-   NOTE: currently written to create new window and plot GOES lightcurve
;-     as the primary plot (i.e. not to overplot on an existing lc for
;-     RHESSI or AIA or whatev.
;-
;- INPUT:
;-   gdata = goesdata, retrieved from OGOES()
;-
;- KEYWORDS:
;-   buffer = 0|1 (set = 1 if working remotely!)
;-
;- OUTPUT:
;-   IDL graphics object 'plt'
;-
;- TO DO:
;-



function PLOT_GOES, gdata, buffer=buffer

    if n_elements(gdata) eq 0 then gdata = GOES()
    ;- If this routine hits an error further down, gdata might not
    ;- be returned, and will have to do this every time anyway.
    ;- Though it seems that it was updated in ML as soon as this ran,
    ;- even after running into error and doing RETALL, so maybe this is fine.

    common defaults
    dw
    wx = 8.0
    ;wy = 3.50
    wy = 3.0 ;- match to height for AIA light curve window (10 Sep 2019)
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer )

    ;- 25 November 2018 - changed to match margins of AIA light curves.
    left = 1.00
    bottom = 0.5
    right = 1.00
    top = 0.2
    margin = [left,bottom,right,top]

    width = wx - (left + right)
    height = wy - (top + bottom)
    ;xticklen = width / 200.
    ;yticklen = height / 200.
    xticklen = width / 250.
    yticklen = height / 250.

    plt = objarr(2)

    ;color = [ 'black', 'orchid' ]
    color = [ 'dark cyan', 'black' ]
    thick = [ 1.5, 0.5 ]
    name = 'GOES ' + ['1.0-8.0 $\AA$', '0.5-4.0 $\AA$']

    ;- Thu Jan 24 20:29:18 MST 2019
    ;-   See ML below on where these came from.
    xtickvalues = !x.tickv[0:4]
    xtickname = !x.tickname[0:4]

    for ii = 0, 1 do begin

        ;xdata = indgen(n_elements(ydata))
        xdata = gdata.tarray
        ;- NOTE: tarry has units = SECONDS

        ydata = reform(gdata.ydata[*,ii])
        ;ydata = (ydata-min(ydata))/(max(ydata)-min(ydata))

        plt[ii] = plot2( $
            xdata, ydata, $
            /current, $
            /device, $
            overplot=ii<1, $
            layout=[1,1,1], $
            margin=margin*dpi, $
            ylog=1, $
            yminor=9, $
            xmajor=10, $
            xminor=5, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtickvalues=xtickvalues, $
            xtickname=xtickname, $
            xtitle='Start Time (' + strmid(gdata.utbase,0,20) + ')', $
            ytitle='watts m$^{-2}$', $
            color=color[ii], $
            thick=thick[ii], $
            name=name[ii] )
    endfor
    ;print, plt[0].xtickvalues
    ;print, plt[0].xtickname
    return, plt
end
