;+
;- LAST MODIFIED:
;-   08 July 2021
;-
;- PURPOSE:
;-   ML code that creates GOES object (  = OGOES()   ), and plots the LCs.
;-
;- TO DO:
;-   [] Fix hardcoded crap toward the end when calling oplot_flare_lines
;-   []
;-




;=================================================================

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

;=================================================================


;@parameters
@par2
flare = multiflare.c30
;- IDL> .run struc_aia
;-   Actuallyshouldn't have to... values in multiflare structure(s) should suffice, since only
;0    need start/end times of time series and flare phases, nothing from AIA is needed here.
;- IDL> .run my_goes

;------


buffer=1


sat = 'goes15'

;+
;- Step 1 : Create GOES object
;-

;tstart = flare.ts_start
;tend = flare.ts_end
;
print, aia1600index[ 0].t_obs
print, aia1700index[ 0].t_obs
print, aia1600index[-1].t_obs
print, aia1700index[-1].t_obs


time = strmid(aia1600index.t_obs, 11, 5)
print, time[0]
;tstart = flare.date + ' ' + '08:15:00'
;tend   = flare.date + ' ' + '13:14:59'
;
tstart = flare.date + ' ' + time[ 0] + ':00' 
tend   = flare.date + ' ' + time[-1] + ':00' 
print, tstart
print, tend



goesobj = OGOES()
; set parameters
goesobj->SET, tstart=tstart, tend=tend, sat=sat
;a->plot, charsize=1.5
goesobj->help
;
;
;
;-
;- Extract data and derived quantities into a structure
;-  NOTE: this may take a few minutes..
goesdata = goesobj->getdata(/struct)

;-
;- Copy the following to ML in goes.pro maybe?
;d = GOES( $
;    tstart = date + ' ' + '10:00:00', $
;    tend = date + ' ' + '14:59:59' $
;    )
;-
;goesdata = GOES( tstart=tstart, tend=tend )
;-


help, goesdata

stop

print, ''
print, 'Seriously, stop.'
print, ''

stop


;gdata = GOES()

;- 20 April 2019
;-  Multiple flares now... need to specify date/times.
;;tstart = '28-Dec-2013 10:00:00'
;;tend   = '28-Dec-2013 13:59:59'
;;gdata = GOES( tstart=tstart, tend=tend )

;;tstart = date + ' 10:00:00'
;;tend = date + ' 14:59:59'
;tstart = date + ' ' + ts_start
;tend = date + ' ' + ts_end
;if typename(gdata) eq "UNDEFINED" then $
;    gdata = GOES( tstart=tstart, tend=tend )



;+
;- Step 2 : plot GOES lightcurves
;-

;- UTPLOT procedure:
;-   set /SAV kw to save system variables: !x.tickv and !x.tickname
;-   (used for xtickvalues and xtickname in PLOT_GOES routine above).
;UTPLOT, gdata.tarray, gdata.ydata[*,0], gdata.utbase, /sav
;oplot, gdata.tarray, gdata.ydata[*,1], color='FF0000'X
;- --> oplot the other GOES channel.

;filename = strlowcase(flare.class) + '_lc_goes'
;filename = 'm10_lc_goes'
;filename = 'm15_lc_goes'

filename = strlowcase( (flare.class).Replace('.','') ) + '_lc_goes'
print, filename
;
dw
plt = PLOT_GOES(goesdata, buffer=buffer)
;
ax = plt[0].axes
ax[3].tickname = ['A', 'B', 'C', 'M', 'X']
ax[3].title = ''
ax[3].showtext = 1
leg = legend2( target=plt, /upperleft, sample_width=0.25 )
;
save2, filename


stop

;+
;- overplot flare lines to match LCs from AIA
;-

resolve_routine, 'oplot_flare_lines', /is_function
    ;-  currently residing in '../Lightcurves/'
vert = OPLOT_FLARE_LINES( $
    plt, t_obs=A[0].time, $
    /goes, $
    utbase=flare.date + ' ' + A[0].time[0] + '0', $
    /send_to_back )


;+
;- 04 August 2019
;- Shaded region:
;-  compare to code in oplot_flare_lines, runs if kw "shaded" is set
;-   (tho pretty sure that version is old, based on the comments)

yrange = plt[0].yrange
x_indices = [150,300]
p = plot( x_indices, [yrange[0],yrange[0]], /overplot, $
    /fill_background, $
    fill_color = 'white smoke', $
    fill_level = yrange[1] )
p.Order, /send_to_back


;+
;- Vertical lines to indicate times of each phase of 'BDA'.
;-   (see oplot_flare_lines.pro for more info).

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
