
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
        ;- xdata in SECONDS

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

goto, start



gdata = GOES()

;- UTPLOT procedure:
;-   set /SAV kw to save system variables: !x.tickv and !x.tickname
;-   (used for xtickvalues and xtickname in PLOT_GOES routine above).
UTPLOT, gdata.tarray, gdata.ydata[*,0], gdata.utbase, /sav
;oplot, gdata.tarray, gdata.ydata[*,1], color='FF0000'X
;- --> oplot the other GOES channel.


start:;---

plt = PLOT_GOES(gdata)


resolve_routine, 'oplot_flare_lines', /either
OPLOT_FLARE_LINES, plt, /goes, /send_to_back

ax = plt[0].axes
ax[3].tickname = ['A', 'B', 'C', 'M', 'X']
ax[3].title = ''
ax[3].showtext = 1


leg = legend2( target=plt, /upperleft, sample_width=0.25 )
    ;position=[0.02, 0.96], $
    ;horizontal_alignment=0.0)

;p.delete
p = plot( x_indices, [yrange[0],yrange[0]], /overplot, $
    /fill_background, $
    fill_color = 'white smoke', $
    ;fill_transparency = 90, $
    fill_level = yrange[1] )
p.Order, /send_to_back


;file = 'lc_goes'
file = 'test'
save2, file



stop



;vert[0].delete
;vert[1].delete


;- Vertical lines dividing up BDA.
;- See oplot_flare_lines.pro for comments on this.
BDA_times = '15-Feb-2011 ' + ['01:46:00', '02:30:00']
nn = n_elements(BDA_times)
x_indices = fltarr(nn)
utbase = '15-Feb-2011 00:00:01.725'
ex2int, anytim2ex(utbase), msod_ref, ds79_ref
for ii = 0, nn-1 do begin
    ex2int, anytim2ex( BDA_times[ii] ), msod, ds79
    x_indices[ii] = int2secarr( [msod,ds79], [msod_ref,ds79_ref] )
endfor
yrange = plt[0].yrange
vert = objarr(nn)
linestyle = '-'
foreach vx, x_indices, jj do begin
    vert[jj] = plot( $
        [vx,vx], $
        yrange, $
        ;/current, $
        /overplot, $
        ;thick = 0.5, $
        thick = 4.0, $
        linestyle = linestyle, $
        color = 'white smoke', $
        ystyle = 1 )
    vert[jj].Order, /SEND_TO_BACK
endforeach



end
