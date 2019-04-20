;+
;- LAST MODIFIED:
;-   17 April 2019
;-
;- PURPOSE:
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-
;- NOTE:
;-    Didn't really change any of the fundamentals of the code,
;-      just copied content from file "plot_goes.pro" (subroutine and ML code)
;-      into this file (plot_goes_2.pro) to declutter and de-confuse.
;-    Also renamed to PLOT_GOES to more easily tell my routines apart
;-      from ones I downloaded.
;-    Original file was deleted, and probably don't need to keep the subroutine
;-    in here, but of course I'm reluctant to permanently delete codes...
;- NOTE AGAIN:
;-   Original file and subroutine names were quoted above
;-    (since they were current at the time of merging),
;-    but names have since been modified.


pro PLOT_GOES_old, A, gdata
    ;- Originally wrote this as a procedure, with structure A as an input arg,
    ;-    then apparently gave up on that...


    if n_elements(gdata) eq 0 then gdata = GOES()
    ;- If this routine hits an error further down, gdata might not
    ;- be returned, and will have to do this every time anyway.
    ;- Though it seems that it was updated in ML as soon as this ran,
    ;- even after running into error and doing RETALL, so maybe this is fine.

    common defaults
    dw
    wx = 8.0
    wy = 4.0 ;- Set to 3.5 in other routine...
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


    p = objarr(3)

    for i = 0, 1 do begin
        flux = A[i].flux - min(A[i].flux)
        flux = flux / max(flux)

        ;- Xdata =
        xdata = findgen(n_elements(flux)) * A[i].cadence

        p[i] = plot2( $
            xdata, flux, $
            /current, $
            /device, $
            overplot=i<1, $
            layout=[1,1,1], $
            margin=margin*dpi, $
            xmajor=10, $
            xticklen=xticklen, $
            yticklen=yticklen, $
            xtitle='Start Time ' + gdata.utbase, $
            ytitle='intensity (normalized)', $
            color=A[i].color, $
            name=A[i].name )
    endfor

    goesflux = gdata.ydata[*,0] - min(gdata.ydata[*,0])
    goesflux = goesflux / max(goesflux)


    p[2] = plot2( $
        gdata.tarray, $
        goesflux, $
        /overplot, $
        linestyle='--', $
        name = 'GOES 1-8$\AA$')

    xtickvalues = round(p[0].xtickvalues/24)
    xtickname = strmid( A[0].time, 0, 5 )
    p[0].xtickname = xtickname[ xtickvalues ]

    pos = p[2].position * [wx,wy,wx,wy]
    xx = pos[2] - 0.25
    yy = pos[3] - 0.25

    leg = legend2( $
        target=[p], $
        /device, $
        position=[xx,yy]*dpi )
    ;save2, 'test.pdf'
end

;- ML code used for PLOT_GOES procedure:
;!P.Color = '000000'x
;!P.Background = 'ffffff'x
;gdata = GOES()
;PLOT_GOES_old, A, gdata
;xdata = gdata.tarray
;ydata = gdata.ydata
;ytitle = gdata.utbase
;ylog = 1
;win = window(dimensions=[8.0,4.0]*dpi )
;plt = plot2( xdata, ydata[*,0], /current, ylog=ylog )
;-
;-
;- PLOT_GOES function (not procedure)
;-   is most current version --> use that one.
;-


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

goto, start

;- GOES() contains commented lines from website explaining keywords and such.
;- Creates object, sets parameters (defaults are for the 2011-Feb-15 flare), and
;- returns structure with data and derived quantities.
;-    (see goes.pro for details).
gdata = GOES()


start:;----------------------------------------------------------------------------

;- 20 April 2019
;-  Multiple flares now... need to specify date/times.
tstart = '28-Dec-2013 10:00:00'
tend   = '28-Dec-2013 13:59:59'
gdata = GOES( tstart=tstart, tend=tend )

stop

;- UTPLOT procedure:
;-   set /SAV kw to save system variables: !x.tickv and !x.tickname
;-   (used for xtickvalues and xtickname in PLOT_GOES routine above).
UTPLOT, gdata.tarray, gdata.ydata[*,0], gdata.utbase, /sav
;oplot, gdata.tarray, gdata.ydata[*,1], color='FF0000'X
;- --> oplot the other GOES channel.
stop

plt = PLOT_GOES(gdata)
stop

resolve_routine, 'oplot_flare_lines', /either
    ;-  currently residing in '../Lightcurves/'

OPLOT_FLARE_LINES, plt, /goes, /send_to_back

ax = plt[0].axes
ax[3].tickname = ['A', 'B', 'C', 'M', 'X']
ax[3].title = ''
ax[3].showtext = 1

leg = legend2( target=plt, /upperleft, sample_width=0.25 )

p = plot( x_indices, [yrange[0],yrange[0]], /overplot, $
    /fill_background, $
    fill_color = 'white smoke', $
    fill_level = yrange[1] )
p.Order, /send_to_back

;file = 'lc_goes'
file = 'test'
save2, file

stop

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
