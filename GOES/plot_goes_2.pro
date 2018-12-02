
;- Last updated:    25 November 2018

;- See "Make_plots.pro" for more GOES routines
;-  (or probably copies of stuff that's already in here).

function PLOT_GOES, gdata

    if n_elements(gdata) eq 0 then gdata = GOES()
    ;- If this routine hits an error further down, gdata might not
    ;- be returned, and will have to do this every time anyway.
    ;- Though it seems that it was updated in ML as soon as this ran,
    ;- even after running into error and doing RETALL, so maybe this is fine.

    common defaults
    dw
    wx = 8.0
    wy = 3.50
    win = window( dimensions=[wx,wy]*dpi, buffer=0 )

    ;- 25 November 2018 - changed to match margins of AIA light curves.
    left = 1.00
    bottom = 0.5
    right = 1.00
    top = 0.2
    margin = [left,bottom,right,top]

    width = wx - (left + right)
    height = wy - (top + bottom)
    xticklen = width / 250.
    yticklen = height / 250.

    plt = objarr(2)

    color = [ 'black', 'orchid' ]
    name = 'GOES ' + ['1.0-8.0 $\AA$', '0.5-4.0 $\AA$']

    xtickvalues = !x.tickv[0:4]
    xtickname = !x.tickname[0:4]

    for ii = 0, 1 do begin

        ydata = reform(gdata.ydata[*,ii])
        ;ydata = (ydata-min(ydata))/(max(ydata)-min(ydata))

        ;- Xdata =
        xdata = indgen(n_elements(ydata))
        xdata = gdata.tarray

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
            name=name[ii] )
    endfor
    ;print, plt[0].xtickvalues
    ;print, plt[0].xtickname
    return, plt
end

goto, start

start:;---

;gdata = GOES()
;utplot, gdata.tarray, gdata.ydata[*,0], gdata.utbase, /sav
;oplot, gdata.tarray, gdata.ydata[*,1], color='FF0000'X

plt = plot_goes(gdata)

resolve_routine, 'oplot_flare_lines', /either
oplot_flare_lines, plt, /send_to_back

ax = plt[0].axes
ax[3].tickname = ['A', 'B', 'C', 'M', 'X']
ax[3].title = ''
ax[3].showtext = 1


leg = legend2( target=plt, $
    position=[0.02, 0.96], horizontal_alignment=0.0)


end
