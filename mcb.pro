;Copied from clipboard


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
;gpeak = get_jd('2014-04-18T' + flare.tpeak + ':00.000Z')
;gend = get_jd('2014-04-18T' + flare.tend + ':00.000Z')
;vx = [gpeak, gend]
;print, vx
;help, vx
;
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

