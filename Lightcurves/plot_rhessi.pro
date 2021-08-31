;+
;- LAST MODIFIED:
;-   30 August 2021
;-
;-   20 August 2021
;-      First LC's with RHESSI data, GOES overplotted, vertical lines
;-
;- PURPOSE:
;-   Plot RHESSI light curves, oplot GOES maybe
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] Change RHESSI lightcurves to log scale, add remaining E-ranges, ...
;-          COMPLETE for A2
;-   []
;-



;- 30 August 2021
;- Usual definnitions (buffer, class, date, flare, ... ) now in par2.pro


;= RHESSI

;- text file with rhessi data
infile = class + '_rhessi_lightcurve_corr.txt'

READCOL, infile, time, v1, v2, v3, v4, atten, eclipse, $
    format='A,F,F,F,F,I,I', delimiter=','


;= GOES

goesobj = OGOES()
goesobj->SET, tstart=time[0], tend=time[-1], sat=15
goesobj->help

goesdata = goesobj->getdata(/struct)
;help, goesdata

print, time[0]

print, goesdata.utbase

stop

;- HARDCODING: matched correct format, filled in START TIME for goes
if class eq 'c83' then utbase_hardcopied = get_jd('2013-08-30T02:03:26.089Z')
if class eq 'm73' then utbase_hardcopied = get_jd('2014-04-18T12:50:02.815Z')
if class eq 'x22' then utbase_hardcopied = get_jd('2011-02-15T01:26:37.429Z')
;
goesjd = goesdata.tarray/(60.*60.*24.) + utbase_hardcopied

;starttime = strmid( time[0], 11, 8 )
;xtitle = 'Start Time (' + flare.date + ' ' + starttime + ')'
xtitle = 'Start Time (' + goesdata.utbase + ')'
ytitle = 'Counts s$^{-1}$ detector$^{-1}$'
;
;ydata = [ [v1], [v2], [v3], [v4] ]
;name = ['6-12', '12-25', '25-50', '50-100'] + ' keV'
;color = ['black', 'gray', 'blue', 'red']
;
ydata = [ [v3], [v4] ]
sz = size(ydata,/dimensions)
;
name = ['25-50', '50-100'] + ' keV'
color = ['gray', 'black']
;
xdata = get_jd( time + 'Z' )
xdata = [ [xdata], [xdata] ]
;
xtickformat = '(C(CHI2.2, ":", CMI2.2))'


resolve_routine, 'batch_plot_2', /either
plt = BATCH_PLOT_2(  $
    xdata, ydata, $
    axis_style=1, $
    overplot=1, $
;    xrange=[0,n_obs-1], $
;    thick=[0.5, 0.8], $
;    xtickinterval=xtickinterval, $
;    xminor=xminor, $
    ;yticklen=yticklen, $
    xtickformat=xtickformat, $
    xtickinterval=5, $
    xtitle=xtitle, $
    ytitle=ytitle, $
    color=color, $
    name=name, $
    buffer=buffer $
)
;
vx = GET_JD( $
    flare.year + '-' + flare.month + '-' + flare.day + 'T' + $
    [flare.tstart, flare.tpeak, flare.tend] + $
    ':00.000Z' $
)
;
vertname = ['start', 'peak', 'end']
vert = objarr(3)
for ii = 0, n_elements(vert)-1 do begin
    vert[ii] = plot( $
        [vx[ii], vx[ii]], $
        plt[0].yrange, $
        /current, $
        /overplot, $
        ystyle=1, $
        thick=0.5, $
        color='gainsboro', $
        name=vertname[ii], $
        buffer=buffer $
    )
endfor
;
;
;plt[0].xtickname = strmid( time[ plt[0].xtickvalues ], 11, 5 )
;
;result = label_date( date_format='%H:%I' )
;plot, time, v1, xtickformat='label_date'
;plt[0].xtickunits = 'time'
;
;
pltg = plot2( $
    goesjd, $
    goesdata.ydata[*,0], $
    /current, $
    position=plt[0].position, $
    xstyle=1, $
    ystyle=1, $
    axis_style=4, $
    ;color='red', $
    linestyle=[1,'3C3C'X], $
    name='GOES 1-8$\AA$', $
    buffer=buffer $
)
;
ax = axis2( 'Y', $
    location='right', $
    target=pltg, $
    showtext=1 $
    ;buffer=buffer $
)
;
ax2 = axis2( 'X', location='top', target=plt[0], showtext=0 )
;
leg = legend2( target=[plt,pltg,vert], /upperright )
;
rhessi_filename = class + '_rhessi_lightcurve'
save2, rhessi_filename

end
