;+
;-
;- CREATED:
;-   07 August 2018
;-
;- LAST MODIFIED:
;-
;-   07 August 2024
;-     [] Merge with plot_goes.pro ??
;-  
;-   09 August 2022
;-     Merged with ML code in "my_goes.pro"
;-  
;-   08 July 2021
;-     Subroutine that calls OGOES(), external routine that creates goes object.
;-     Don't really need a subroutine for this, mostly commented, but maybe useful
;-     for playing with different date/times or whatever else it can be used for.
;-
;-   12 August 2018
;-
;-
;- PURPOSE:
;-   Get GOES time series data to plot light curves.
;-
;- USEAGE:
;-    Function creates goes object at specified start and end times
;-      (kws 'tstart' and 'tend')
;-
;- INPUT KEYWORDS:
;-   tstart = 'dd-Mon-yyyy hh:mm:ss'
;-   tend   = 'dd-Mon-yyyy hh:mm:ss'  (same form as tstart...)
;-   sat    = 'goesN' where N = 15 by default.
;-
;- OUTPUT:
;-   GOES data (time series, I assume...)
;-
;- TO DO:
;-   [] Merge with plot_goes.pro ??
;-   []
;-


;----------------------------------------------------------------------------------------
;--+

; Extracting and plotting GOES data.

; Object parameters ( = defaults):

    ; tstart  = start of day two days ago
    ; tend    = end of day two days ago
    ; sat     = most recent that contains tstart:tend
    ; sdac    = 2 (YOHKOH, then SDAC if YOHKOH not available)
    ; mode    = 0
    ; euv = (?) set to 1|2|3 for EUV A|B|E; set to 0 for XRS data
    ;                                         via sdac and mode
    ; clean = 1
    ; showclass = 1 (show classes on right side of plot)
    ; markbad = 1
    ; abund ; for calculation of temp and EM... ignore for now.
    ; itimes ; integration interval for E loss calcs... also ignore.

  ; Background
    ; bsub = 0 (subtract background - btimes required!)
    ; bfunc = 0poly (option to use 1poly, 2poly, 3poly, exp)
    ; btimes = 2 x N array of start/end times, for N time segments
    ; b0times ; channel 0 background
    ; b1times ; channel 1 background
    ; b0user = user defined background for channel 0
    ; b1user = user defined background for channel 1

; Data parameters (example from website):
    ;** Structure <70774e0>, 15 tags, length=3936, data length=3928, refs=1:
    ;UTBASE STRING '22-Mar-2002 18:00:00.000' ; utbase time
    ;TARRAY LONG Array[61]         ; time array in seconds relative to utbase
    ;YDATA FLOAT Array[61, 2]      ; 2 channels of GOES data in watts/m^2
    ;YCLEAN FLOAT Array[61, 2]     ; 2 channels of cleaned GOES data in watts/m^2
    ;YBSUB FLOAT Array[61, 2]      ; 2 channels of cleaned background-subtracted data in watts/m^2
    ;BK FLOAT Array[61, 2]         ; 2 channels of computed background in watts/m^2
    ;BAD0 INT -1                   ; indices for channel 0 array that were bad
    ;BAD1 INT -1                   ; indices for channel 1 array that were bad
    ;TEM DOUBLE Array[61]          ; temperature array in MK
    ;EM DOUBLE Array[61]           ; emission measure array in cm^-3 * 10^49
    ;LRAD DOUBLE Array[61]         ; total radiative energy loss rate (or integral) array in erg/s
    ;LX FLOAT Array[61]            ; radiative energy loss rate in X-rays (or integral) array in erg/s
    ;INTEGRATE_TIMES STRING Array[2]   ; integration time interval
    ;YES_CLEAN INT 1               ; 0/1 means data wasn't / was cleaned
    ;YES_BSUB INT 1                ; 0/1 means background wasn't / was subtracted
; set using, e.g. a->set, kw=value

function GOES, tstart=tstart, tend=tend, sat=sat

    ;Copied code from interwebs, along with explanations of how to use it (commented)
    ;OGOES() --> external routine.



    ;TVLCT, 255, 255, 255, 254
    ;TVLCT, 0, 0, 0, 253
    ;!P.Color = 253
    ;!P.Background = 254

    ;!P.Color = '000000'x
    ;!P.Background = 'ffffff'x

    ; GOES satellite preference (15 is the latest, at the time of writing).
    if not keyword_set(sat) then sat = 'goes15'

    ;- User specified start and end times.
    if not keyword_set(tstart) then tstart = '15-Feb-2011 00:00:03'
    if not keyword_set(tend)   then tend   = '15-Feb-2011 04:59:59'

    ; My times for BDA coverage of the 2011 February 15 flare
    ;tstart = '15-Feb-2011 00:00:03'
    ;tend   = '15-Feb-2011 04:59:59'

    ; times covered in Milligan2017 (to start)
    ;tstart = '15-Feb-2011 01:40:00'
    ;tend   = '15-Feb-2011 02:10:00'

    ; Create object
    a = OGOES()

    ; set parameters
    a->SET, tstart=tstart, tend=tend, sat=sat
    ;a->plot, charsize=1.5

    ; Show current parameter values
    a->help

    ;-- extract data and derived quantities into a structure
    data = a->getdata(/struct)
    ;- PROBLEM: "No GOES/Yohkoh data available for specfied times"...

    ;xst0 = data.utbase
    ;ex2int, anytim2ex(xst0), xst_msod, xst_ds79
    ;xst = [xst_msod, xst_ds79]
    ;utstring = anytim2utplot(xst)

    ;utplot, data.tarray, data.ydata[*,0], data.utbase, /sav

    ;help, data, /struct
    ;return, data

    ;plot, data.ydata[*,0];, linestyle=1
    ;oplot, data.ydata[*,1];, linestyle=2

    ; set parameters and plot at the same time:
;    a->plot, tstart=tstart, tend=tend, sat=sat
;    print, a[0].title
;    print, a[0].xtitle
;    print, a[0].ytitle

    ; GETDATA args/keywords, all of which are included with /struct:
    ;low = a->getdata( /low )       ; low channel only (1-8 A, or 0.5-4 A?)
    ;high = a->getdata( /high )     ; high channel only (ditto)
    ;times = a->getdata( /times )   ; time array and UTBASE
    ;deri=deriv(times,high)   ; ??
    ;utbase = a->getdata( /utbase )

    ;UTPLOT, times, high, utbase

    ;TOGGLE, /landscape, filename='goes.ps'
    ;a->plot, xcharsize=1.25, ycharsize=1.25
    ;TOGGLE

    return, data

end



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

@main

;@parameters
@par2
;flare = multiflare.c30


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
save2, filename

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
