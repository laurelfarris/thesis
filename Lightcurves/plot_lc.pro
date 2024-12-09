;+
;- LAST MODIFIED:
;-
;-  01/07/2024:
;-    This is a Main Level (ML) routine that
;-      • Calls script @main:  Codes/main.pro, which
;-             calls script @path_temp (backup loc when SolarStorm went kaput),
;-             sets a bunch of standard default variables like buffer, instr, cadence, etc.
;-                    ("standard" for this project anyway),
;-               calls MULTIFLARE_STRUC function according to flare_id of choice, set by variable 'class':
;-                  IDL> class = 'x22' or class = 'c30',
;-               with all lowercase, no period beteen class # and subclass #
;-           AND
;-              checks for existance of .sav files (if yes, restore struc, if not, prints error)
;-      • defines filename to save pdf of figure
;-  
;-   12/27/2023:
;-     File 'batch_plot_2.pro' no longer exists --> merged with 'batch_plot.pro'
;-     tho still defined as its own function within  'batch_plot.pro', should be able to call
;-     function BATCH_PLOT_2( ... ) for 'filename.pro' after running
;-       IDL> RESOLVE_ROUTINE, <filename>
;-  
;-   07 July 2021
;-     copied to plot_lc_20210707.pro to remove ML code that has nothing to do with LCs,
;-     but may be important and needs to be copied to more relevant routines, including:
;-       • ALIGNMENT routines: restoring and saving w/ extra variables (shifts, allshifts,..)
;-       • computes FLUX for each channel (wrote code here for this before modifying struc_aia
;-           to work with multiflare structure / @par2
;-
;- EXTERNAL SUBROUTINES:
;-     batch_plot.pro
;-     shift_ydata
;-     label_time.pro (commented, x-axis is labeled here, at ML)
;-     axis2.pro
;-     oplot_shaded.pro
;-     oplot_flare_lines.pro
;-     legend2.pro
;-
;- PURPOSE:
;-   General Lightcurve (LC) plotting routine
;-
;- TO DO:
;-   [] Generalize variables currently hardcoded:
;-       • filename  • ydata  • xtickinterval
;-   [] See older versions of similar code (plot_lc*.pro) for LOTS of comments.. 
;-           (maybe helpful, maybe time waster)
;-   [] See Lightcurves/MAKE_PLOTS.pro
;-   [] Generalize entire routine for ANY lightcurve
;-       => merge this code w/ plot_lc_GENERAL.pro:
;-            procedure + ML code,
;-         (early attempts at generalizing.. apparently didn't take.)
;-   [] Replace hardcoded values with generalized code.
;-        including computation of [xyz]tickinterval, [xyz]major[minor], etc. (using dy ??)
;-           -- 8/7/2024

; Quick IDL REF:
;    IDL> SIZE(array)
;      # dimensions, x-dim, y-dim, 'type code' (?), n_elements(test)
;    IDL> SIZE(array, /dimensions)
;      x-dim, y-dim, ... (more if n_dimensions is higher than 2)
;
; axis_style=0  ; No axes
; axis_style=1  ; single x, y axes at minimum data values (left + bottom)
; axis_style=2  ; box axes
; axis_style=3  ; crosshair axes
; axis_style=4  ; no axes (margins perserved for adding graphics later)
;+




;== Step (0):
plot_rhessi = 0
add_shading = 0

time = strmid( A[0].time, 0, 5 )

;== Step (1)
;
;IDL> .run main
;
;   @path_temp, buffer=1, define instr='aia', cadence=24, class='x22',
;     define structure 'flare' = MULTIFLARE_STRUC(class=...),
;        & restore .sav files
;        (if they exist, otherwise run appropriate Prep/ codes to create new 'A' array of structures
;           & then -->> save to new .sav files to restore next time!
;
;   ==>> NOTE: cannot run main.pro as a script (IDL> @main)
;            b/c contains if/then/else statements, and scripts are run line-by-line.
;


;restore, path + 'flares/' + class + '/' + class + '_' + 'struc.sav'
;help, A[0]
;help, A[1]
; ==>> main.pro takes care of this now (13 Dec 2022)



;== Step (2)

; Define FILENAME for flare specified in main.pro (run in step 1)
aia_lc_filename = class + '_' + strlowcase(instr) + '_lightcurve'
;
print, ""
print, "You have chosen to plot light curves for the " + class + " flare,"
print, "  to be saved under filename " + aia_lc_filename + "_<yyyymmdd>.pdf"


;- Define string variables to use in filenames (I guess)
;class = strlowcase(strjoin(strsplit(flare.class, '.', /extract)))
;- flare.class = M1.5 --> class = m15
;date = flare.year + flare.month + flare.day
;- flare.date = 12-Aug-2013 --> date = 20130812
;==>> class and date both defined in par2.pro  (07 Sep 2021)

;= RHESSI LC parameters & settings:

if plot_rhessi eq 1 then begin

    ;- 06 August 2024
    ;-   I assume this was used to define start/end times for aia lightcurves
    ;-   over same dt as RHESSI LCs for A2 (phase2) / diss chapter 5


    ;- 07 January 2024 -- Stab at what variables are for..
    ;-    aia1600ind, aia1700ind:
    ;-       both = 2-element array of INDICES corresponding to observation time
    ;-          .. used to select 𝝙t window spanned by x-axis in LCs.
    ;
    ; 07 September 2021 -- use jd instead of integers ... to do hwut, exactly? (07 January 2024)

    loc1 = (where( A[0].jd ge rhessi_xdata[0,0] ))[0]
    loc2 = (where( A[0].jd le rhessi_xdata[-1,0] ))[-1]
    ;- NOTE:  ==>>  rhessi_xdata = 2D array defined in "plot_rhessi.pro"

    ;- 07 Jan. 2024:
    ;-   loc1 & loc2 only used to define aia1600ind...
    ;-     redundant, but perhaps too messy to define aia1600ind directly.)
    ;-  The following should work;  => run in simple test code first..
    ;
    ;        aia1600ind = [ $
    ;            (where(A[0].jd ge rhessi_xdata[0,0]))[0] : (where(A[0].jd le rhessi_xdata[-1,0]))[-1] $
    ;            ]
    ; 
    ;- aia1700ind defined below using a different approach ?
    ; 
    ;AND A[0].jd le rhessi_xdata[-1,0] )
    ;-    ... ??
    ;
    ;aia1700ind = where( A[1].jd ge rhessi_xdata[0,0] AND A[1].jd le rhessi_xdata[-1,0] )
    ;  Not same size; 150 and 151... may not play nice. Fix later.
    ;   Using 1600 jd for both channels... close enough.
    ;
    ;- Appears that TIME array for LCs is the same for both 1600 and 1700 data, even though times
    ;-   should be slightly offset.
    ;- Maybe not huge deal.. but this should be a simple thing to plot..
    ;-   ==>> look up some documentation on x

endif else begin
    ;loc1 = 0
    ;loc2 = n_elements(A[0].flux)-1
    ;
    ; 12/09/2024
    ;   Hardcoded indices for RHESSI start/end times (from ../RHESSI/rhessi_x22_lightcurve_corr.txt):

    if class eq 'x22' then begin
        loc1 = (where(time eq '01:26'))[0]
        loc2 = (where(time eq '02:28'))[0]
    endif
    if class eq 'm73' then begin
        loc1 = (where(time eq '12:50'))[0]
        loc2 = (where(time eq '13:50'))[0]
    endif
    if class eq 'c83' then begin
        loc1 = (where(time eq '02:03'))[0]
        loc2 = (where(time eq '03:03'))[0]
    endif

endelse

;xtickinterval = A[0].jd[75] - A[0].jd[0]
;xtickinterval = 75   ; 30 minutes
xtickinterval = 25   ; 10 minutes
xminor = 5           ; 6 5-minute intervals (6*5 = 30)

aia1600ind = [loc1:loc2]
aia1700ind = aia1600ind
;ydata = A.flux
;
aia_ydata = [ $
    [ A[0].flux[aia1600ind] / A[0].exptime ], $
    [ A[1].flux[aia1600ind] / A[1].exptime ] $
]
; 8/7/2024 -- try this instead? simpler...
;A.flux / A.exptime
;print, ARRAY_EQUAL(aia_ydata, aia_ydata2)
; 8/12/2024 -- doesn't work -> A.flux is reduced to a 2-element array b/c dimensions don't match A.exptime
;
n_obs = (size(aia_ydata, /dimensions))[0]
;xdata = [ [indgen(n_obs)], [indgen(n_obs)] ]
; => see today.pro (21 Feb 2020)
;xdata = [ [A[0].jd[aia1600ind]], [A[0].jd[aia1600ind]]  ]
;aia_xdata = [ [(indgen(n_obs))[aia1600ind]], [(indgen(n_obs))[aia1600ind]] ]
aia_xdata = FIX( [ [aia1600ind], [aia1700ind] ] )
;xdata = A.jd
;
;[xyz]major = number of major tick marks
;[xyz]minor = number of minor tick marks (BETWEEN adjacent major tick marks? or total??)
;[xyz]tickinterval = interval BETWEEN major tick marks
;[xyz]ticklen = major tick length, relative to width or height of graphic
;[xyz]subticklen = ratio of minor tick length to major tick length
;                = 0.5 (half the length of major tick marks by default) -- typically don't need to change this
;[xyz]tickvalues = Array of tick mark locations
;[xyz]tickunits = STRING (Y, M, D, H, M, S, Time, exponent, or scientific)
;    time units -> tick VALUES are interpreted as JD date/time.
;    If more than one unit is provided, the axis will be drawn with multiple levels.
;
;help, aia_ydata
format='(E0.3)'
;print, min(aia_ydata[*,0]), format=format
;print, max(aia_ydata[*,0]), format=format
;print, min(aia_ydata[*,1]), format=format
;print, max(aia_ydata[*,1]), format=format

; 8/6/2024 --
;   Axis style = [1|2|3|4]
;       ==>> defined in batch_plot.pro according to kw_set( overplot )
;
;=

;STOP

;======================================================================
;= Plot light curves for AIA emission (integrated; the original)

resolve_routine, 'batch_plot', /either
dw
plt = BATCH_PLOT(  $
    aia_xdata, $
    aia_ydata, $
    axis_style=1, $
    ;ystyle=0, $   ; NICE range
    ;ystyle=1, $   ; EXACT data range
    ;ystyle=2, $   ; pad axes slightly BEYOND NICE range
    ;ystyle=3, $   ; pad axes slightly BEYOND EXACT range
    thick=[0.5, 0.8], $
    ;   1700 slightly thicker plot curve than 1600, for grayscale printouts :)
    ;xrange=[0,n_obs-1], $
    xtickinterval=xtickinterval, $
    xminor=xminor, $
    ;yticklen=yticklen, $
    ;stairstep=stairstep, $
    color=A.color, $
    name=A.name, $
    ;symbol="None", $
    buffer=buffer $
)

;===========================================================================================
;= Axes
;=


;- Add top & right axes (axis_style=1 only includes bottom & left axes)

resolve_routine, 'axis2', /is_function

;help, plt[0].axes
;help, plt[1].axes
ax2 = axis2( 'X', $
    location='top', $
    target=plt[1], $
    tickinterval=plt[0].xtickinterval, $
    minor=plt[0].xminor, $
    showtext=0 $
)
ax3 = axis2( 'Y', $
    location='right', $
    target = plt[1], $
    text_color = A[1].color, $
    showtext=1 $
)
;help, plt[0].axes
;help, plt[1].axes
; ==>>>  ADDS axes : plt[0] & plt[1] each have 6 now instead of 4 ...

;- Create axis object for ALL plot/graphic objects:
ax = [ plt[0].axes, plt[1].axes ]

;- LABEL x-axis with observation time
;
ax[0].tickname = time[ ax[0].tickvalues ]
;   restore, path + 'flares/' + class + '/' + class + '_aia1600header.sav'
;   aia1600index = index
;   ax[0].title = 'Start time (' + ANYTIM( aia1600index[0].t_obs, /stime ) + ')'
;resolve_routine, 'label_time', /either
;LABEL_TIME, plt, time=A.time;, jd=A.jd
ax[0].title = 'Start time (' + flare.date + ' ' + A[0].time[aia1600ind[0]] + ')'



;- SHIFT Y-data (correct offset between dY spanned by 1600 vs 1700:
resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt

;- Y-axis titles =  [ 'AIA 1600 (DN sec ⁻¹)',  'AIA 1700 (DN sec ⁻¹)' ]
;
ax[1].title = A[0].name + ' (DN s$^{-1}$)'
ax[3].title = A[1].name + ' (DN s$^{-1}$)'
;   12 August 2024 -- removed ytitle = A.name + ' (DN s$^{-1}$)' definition above call to batch_plot.pro

;- # of ymajor & yminor tickmarks ( NOTE: Multiple y-axes span different 𝞓𝙮 )
;ymajor = 4
;yminor = 3
;ax[1].minor = yminor
;ax[3].major = ymajor
;ax[3].minor = yminor


;- Color y-axes to match data
ax[1].text_color = A[0].color
ax[3].text_color = A[1].color

;- Minor tick length (relative to graphic dimensions ==>> how to RETRIEVE or VIEW graphic dimensions??)
;xticklen=0.025
;yticklen=0.010
;plt[0].xticklen = plt[0].xticklen/3.0
;plt[0].yticklen = plt[0].yticklen/4.0

;===========================================================================================
;= 12 August 2024 -- customize ymajor tick labels / intervals
;=

help, ax[1]
print, ax[1].axis_range
print, ax[1].title
print, plt[0].yrange
help, aia_ydata
print, max(aia_ydata[*,0]) - min(aia_ydata[*,0]), format=format
print, max(aia_ydata[*,1]) - min(aia_ydata[*,1]), format=format


;===========================================================================================
;= Overplot flare lines ( dotted, dashed, dot-dashed == start, peak, end )
;=

;==>> Problem w/ oplot_flare_lines... aia 1700 data is being pushed halfway across the plot..
;print, plt[1].xrange
resolve_routine, 'oplot_flare_lines', /is_function
; 8/12/2024 --
;   Set kw /COMPILE_FULL_FILE in call to IDL procedure RESOLVE_ROUTINE ?
;       -> multiple pros/funcs defined in 'file.pro'
;          some may not be compiled if "file" is encountered first.
;         This may be reason why "wrapper" is defined AFTER main module that it calls,
;           and is itself the same as the filename... hopefully
;
vert = OPLOT_FLARE_LINES( $
    plt, $
    flare=flare, $
    ;t_obs=A[0].time[aia1600ind], $
    ;t_obs=time[aia1600ind], $
    t_obs=A[0].time, $
    send_to_back=1 $
)


;===========================================================================================
;= Shade flare duration (OR individual phases defined by RHESSI):
;=

if add_shading eq 1 then begin
;
    if plot_rhessi eq 1 then begin
        x_vertices=[ $
            [ (where( strmid(A[0].time,0,5) eq strmid(impulsive[0],0,5)))[0],    $
              (where( strmid(A[0].time,0,5) eq strmid(impulsive[1],0,5)))[0]  ], $
            [ (where( strmid(A[0].time,0,5) eq strmid(     peak[0],0,5)))[0],    $
              (where( strmid(A[0].time,0,5) eq strmid(     peak[1],0,5)))[0]  ], $
            [ (where( strmid(A[0].time,0,5) eq strmid(    decay[0],0,5)))[0],    $
              (where( strmid(A[0].time,0,5) eq strmid(    decay[1],0,5)))[0]  ]  $
        ]
        name = ['impulsive', 'peak', 'end']
    endif else begin
        x_vertices=[ $
            [ (where( strmid(A[0].time,0,5) eq flare.tstart ))[0],   $
              (where( strmid(A[0].time,0,5) eq flare.tend   ))[0]  ] $
        ]
        name = ['Flare Duration']
    endelse
    ;print, strmid(A[0].time[x_vertices],0,5)
    ; 
    resolve_routine, 'oplot_shaded', /either
    shaded = OPLOT_SHADED( $
        x_vertices, $
        plt, $
        ;name=['start','end']
        ;name = ['Flare Duration'] $
        name=name $
    )
endif


;===========================================================================================
;= Legend
;=

;legend_position = 'UL'
legend_position = 'UR'
resolve_routine, 'legend2', /either
leg = LEGEND2( $
    target=plt, $
    sample_width=0.25, $
        ; kw for IDL LEGEND function -- width of line sample (default = 0.15)
    legend_position = legend_position $
    ;/upperleft $ 
    ;/upperright $
)

save2, aia_lc_filename


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 12/09/2024 -- ??????
;
;        common defaults
;        ;
;        @color
;        ;
;        ; ticklen ( ==>> default ticklen values defined in batch_plot.pro )
;        xticklen=0.025
;        yticklen=0.010
;        thick=[0.5, 0.8]
;        ;
;        wx = 8.0
;        wy = 3.0
;        left = 1.00
;        right = 1.10
;        bottom = 0.5
;        top = 0.2
;        x1 = left
;        y1 = bottom
;        x2 = wx - right
;        y2 = wy - top
;        position = [x1,y1,x2,y2]*dpi
;        ;
;        win = window( dimensions = [wx,wy]*dpi, buffer=1 )
;        sz = size(aia_ydata, /dimensions)
;        plt = objarr(sz[1])
;        ;
;        dw
;        for ii = 0, 1 do begin
;            plt[ii] = PLOT2(  $
;                aia_xdata[*,ii], $
;                aia_ydata[*,ii], $
;                /current, $
;                /device, $
;                overplot = ii<1, $
;                position = position, $
;                axis_style=1, $
;                ;ystyle=2, $ ; pad axes beyond 'nice' range
;                ;yrange=[ min(aia_ydata), max(aia_ydata) ], $
;                ;  ==>> doesn't account for offset between 1600 and 1700 flux (even if dy is roughly the same).
;                thick=thick[ii], $
;                color=A[ii].color, $
;                ;ytitle = ytitle[ii], $
;                xtickinterval=xtickinterval, $
;                ;xmajor=xmajor, $
;                ;   => xtickinterval is another way of modifying the same thing (space between major ticks)
;                xminor=xminor, $
;                xticklen=xticklen, $
;                yticklen=yticklen, $
;                name=A[ii].name, $
;                buffer=buffer, $
;                _EXTRA = e $
;            )
;        endfor
;


;= 14 March 2020 --
;
; yrange padding ;- => ensures yrange can accomodate the full range of values in both 1600 and 1700 flux
;
;;pad = 0.2
;pad = 0.05
;
;dy = [ $
;    plt[0].yrange[1] - plt[0].yrange[0], $ ; 1600Å 𝚫y
;    plt[1].yrange[1] - plt[1].yrange[0]  $ ; 1700Å 𝚫y  
;]
;
; 1600:  keep yMIN as is; ADD a fraction (1/5) of 1600 𝚫y to get new (higher) ymax
; 1700:  keep yMAX as is; SUBTRACT a fraction (1/5) of 1700 𝚫y to get new (lower) ymin
;
;dy1600 = plt[0].yrange[1] - plt[0].yrange[0]
;dy1700 = plt[1].yrange[1] - plt[1].yrange[0]
;
;;plt[0].yrange = [   plt[0].yrange[0], ( plt[0].yrange[1] + ( dy[0]*pad ) ) ]
;;plt[0].yrange = plt[0].yrange + [-(dy1600*0.05), 0.0]
;plt[0].yrange = plt[0].yrange + [ 0.0, dy[0]*pad ]
;
;;plt[1].yrange = [ ( plt[1].yrange[0] - ( dy[1]*0.2 ) ), plt[1].yrange[1] ]
;;plt[1].yrange = plt[1].yrange + [0.0, dy1700*0.05]
;plt[1].yrange = plt[1].yrange - [ dy[1]*pad, 0.0 ]

;[xyz]ticklen = major tick length, relative to width or height of graphic
;   12 August 2024 -- Can't figure out a generalized way to set this:
;plt[0].xticklen = plt[0].xticklen/1.5
;plt[0].yticklen = plt[0].yticklen/1.5


end
