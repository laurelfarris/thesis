;+
;- LAST MODIFIED:
;-   28 July 2022
;-     Copied to plot_rhessi_20210907 (date in ls output) so that today
;-     I can make changes with abandon.
;-
;- PURPOSE:
;-   Plot RHESSI light curves, oplot GOES
;-
;- TO DO:
;-   [] Change RHESSI lightcurves to log scale, add remaining E-ranges, ...
;-          COMPLETE for A2
;-   [] Separate GOES routine from RHESSI
;-   [] Define time series start/end INDEPENDENTLY, instead of pulling obs times
;-        from headers of specific instruments (shouldn't have to run struc_aia
;-        or waste time defining paths, fits file names, etc. just so I can reference
;-        index.date_obs or w/e... MAKE THINGS AS EASY AS POSSIBLE!
;-   [] Replace hardcoded crap with something better



@main

;= RHESSI

;- text file with rhessi data
;infile = './Lightcurves/' + class + '_rhessi_lightcurve_corr.txt'
;infile = path + 'thesis/Lightcurves/' + class + '_rhessi_lightcurve_corr.txt'

; Renamed .txt files, and moved to ../RHESSI/
infile = path + 'thesis/RHESSI/rhessi_' + class + '_lightcurve_corr.txt'

READCOL, infile, time, v1, v2, v3, v4, atten, eclipse, $
    format='A,F,F,F,F,I,I', delimiter=','
;
help, time
;
rhessi_filename = class + '_rhessi_lightcurve'
print, rhessi_filename


;- HARDCODING: matched correct format, filled in START TIME for goes
if class eq 'c83' then begin
    jdbase_hardcopied = GET_JD('2013-08-30T02:03:26.089Z')
    impulsive = ['02:06:14','02:15:55']
    peak = ['02:15:57','02:19:55']
    decay = ['02:24:53','02:28:47']
endif
if class eq 'm73' then begin
    jdbase_hardcopied = GET_JD('2014-04-18T12:50:02.815Z')
    impulsive = ['12:50:32','12:54:48'] + '.000'
    peak = ['12:54:48','12:59:04'] + '.000'
    decay = ['13:03:20','13:07:36'] + '.000'
endif
if class eq 'x22' then begin
    jdbase_hardcopied = GET_JD('2011-02-15T01:26:37.429Z')
    impulsive = ['01:48:08','01:52:28']
    peak = ['01:52:28','01:57:12']
    decay = ['02:06:44','02:13:23']
endif


;================================================
;= GOES

; uses 'time' var defined by reading RHESSI data from text files
;   (i.e. can't put GOES code above RHESSI, unless define tstart and tend
;   INDEPENDENTLY from any one instrument's time series.

sat = 'goes15'
goesobj = OGOES()
goesobj->SET, tstart=time[0], tend=time[-1], sat=sat
goesobj->help
;
goesdata = goesobj->getdata(/struct)
;help, goesdata
;
print, 'Start time = ', time[ 0]
print, '  End time = ', time[-1]
;
print, goesdata.utbase

;=
;================================================


;
goesjd = goesdata.tarray/(60.*60.*24.) + jdbase_hardcopied[0]
;help, goesjd
; ==>> get_jd returns ARRAY now instead of single value since I changed it
;   to allow array of timestrings as input... Adding array of 1 caused goesjd to
;   be an array of 1 ... not what we want.  -- 07 September 2021


;====

r1 = { ydata:v1, name:'6-12 keV', color:'blue' }
r2 = { ydata:v2, name:'12-25 keV', color:'green' }
r3 = { ydata:v3, name:'25-50 keV', color:'orange' }
r4 = { ydata:v4, name:'50-100 keV', color:'red' }
;
rhessi = [ r1, r2, r3, r4 ]
rhessi_ydata = rhessi.ydata
sz = size(rhessi_ydata,/dimensions)
;
;  Array [902,4] ==> Correct dimensions! same as ydata=[[v1],[v2],...]
;
;== PLOT lightcurves
; [] NEW subroutine here? START with new plot, then easier to run bits at a time,
;     or all the way through w/o constantly breaking up into individ parts for
;  mcb and then going through and merging again, then breaking up again to find
;  source of error or whatever... too tedious. Create data, manipulate it, group
;  into a structure, sort out TIME arrays, etc. as a sepaerate thing, THEN
;  make pretty plots
;
rhessi_xdata = GET_JD( time + 'Z' )
rhessi_xdata = rebin(rhessi_xdata, sz[0], sz[1])

stop

; modified batch_plot_2 to rebin rhessi_xdata to match ydata (02 Sep 2021)
;  May not have worked, or changed after this... [] double check and update comments.
;   (03 Sep 2021)
;
;format = '(F0.9)'
;print, goesjd[0], format=format
;print, rhessi_xdata[0,0], format=format
;print, rhessi_xdata[0,1], format=format

xtickformat = '(C(CHI2.2, ":", CMI2.2))'
;
xtitle = 'Start Time (' + goesdata.utbase + ')'
ytitle = 'Count rate (s$^{-1}$ detector$^{-1}$)'

dw
resolve_routine, 'batch_plot_2', /either
plt = BATCH_PLOT_2(  $
    rhessi_xdata, rhessi_ydata, $
    axis_style=1, $
    overplot=1, $
    ylog=1, $
;    xrange=[0,n_obs-1], $
;    thick=[0.5, 0.8], $
;    xtickinterval=xtickinterval, $
;    xminor=xminor, $
    ;yticklen=yticklen, $
    xtickformat=xtickformat, $
    xtickinterval=5, $
    xtitle=xtitle, $
    ytitle=ytitle, $
    color=rhessi.color, $
    name=rhessi.name, $
    buffer=buffer $
)
;
;
;== OPLOT vertical lines for flare phases
;resolve_routine, 'oplot_flare_lines_2', /is_function
;vert = OPLOT_FLARE_LINES_2( flare, plt, start_ind=1 )
;
;testvar='THATCHED ROOF COTTAGEEESSSS!!!!'
;for testtest = 0, n_elements(testvar)-1 do print, testvar[0]
;



yrange = plt[0].yrange

resolve_routine, 'get_jd', /is_function
x_vertices = [ $
    [GET_JD(flare.year+'-'+flare.month+'-'+flare.day+'T'+impulsive+'Z')], $
    [GET_JD(flare.year+'-'+flare.month+'-'+flare.day+'T'+peak+'Z')], $
    [GET_JD(flare.year+'-'+flare.month+'-'+flare.day+'T'+decay+'Z')] $
]
;help, x_vertices
;print, x_vertices

; Created subroutine to plot shaded areas -- July 2022
shaded = OPLOT_SHADED( x_vertices, plt )


format = '(F0.15)'
;
;for ii = 0, n_elements(shaded)-1 do begin
;    shaded[ii] = plot( [ x_vertices[0,ii], x_vertices[1,ii] ], $
;        [ yrange[0], yrange[0] ], $
;        /overplot, linestyle='', xstyle=1, ystyle=1, $
;        /fill_background, fill_level=yrange[1], fill_color=fill_color[ii] )
;    shaded[ii].Order, /send_to_back
;endfor
;
;win = GetWindows(/current)
;win.save, '~/Figures/' + rhessi_filename + ".png"
;
;== OPLOT GOES lightcurve
;
;plt[0].xtickname = strmid( time[ plt[0].xtickvalues ], 11, 5 )
;
;result = label_date( date_format='%H:%I' )
;plot, time, v1, xtickformat='label_date'
;plt[0].xtickunits = 'time'
;
pltg = plot2( $
    goesjd, $
    goesdata.ydata[*,0], $
    /current, $
    position=plt[0].position, $
    xstyle=1, $
    ystyle=1, $
    axis_style=4, $  ; No axes (want curve on top of RHESSI w/o actually "overplotting")
    linestyle=[1,'3C3C'X], $
    name='GOES 1-8$\AA$', $
    buffer=buffer $
)
;
ax = axis2( 'Y', $
    location='right', $
    target=pltg, $
    title='W m$^{-2}$', $
    showtext=1 $
    ;buffer=buffer $
)
;
; Add top axis to complete the square grid (no extra data here tho)
ax2 = axis2( 'X', location='top', target=plt[0], showtext=0 )
;
plt = [plt, pltg]
;plt = [plt, pltg, vert]
;
;leg.delete
;
if class eq 'c83' then leg = legend2( target=plt, /lowerright )
if class eq 'm73' then leg = legend2( target=plt, /upperright )
if class eq 'x22' then leg = legend2( target=plt, /upperleft )
;
;leg = legend2( target=plt, legend_pos=legend_pos )
;
save2, rhessi_filename


;== AIA lightcurves below RHESSI/GOES (share x-axis)

;aia_ydata = [ $
;    [ A[0].flux / A[0].exptime ], $
;    [ A[1].flux / A[1].exptime ] $
;]
;
;aia1600ind = where( A[0].jd ge rhessi_xdata[0,0] AND A[0].jd le rhessi_xdata[-1,0] )
;aia1700ind = where( A[1].jd ge rhessi_xdata[0,0] AND A[1].jd le rhessi_xdata[-1,0] )
;  Not same size; 150 and 151... may not play nice. Fix later.

;aia_xdata = [ [A[0].jd[aia1600ind]], [A[0].jd[aia1600ind]]  ]

end
