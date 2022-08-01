;+
;- LAST MODIFIED:
;-  17 January 2020
;-    Removed kw opt for "shaded". Created separate subroutine
;-    called "shade_my_plot.pro" in same directory.
;-
;-  17 April 2019
;-    Used strmid( var, 0, 5 ) instead of hardcoding flare times...
;-    Not sure why I didn't do that in the first place, unless I just didn't
;-    realize that if variable was already 5 elements long, it wouldn't cause an error.
;-    Variable would remain unchanged.

;-  25 November 2018:
;-    Made a few changes to use this with GOES data: no time array from AIA
;-    ... what exactly did I do? Previously plotting GOES over AIA's obs times?
;-    Or was there an option to use this routine to plot AIA data?
;-    I am the world's worst commenter.
;-
;- KEYWORDS:
;-   t_obs  -- string array of observation times from A[0].t_obs
;-     where A[0] is AIA 1600 -- same values are used for both channels
;-     (Tried using JD to be more scientifially correct, but too much
;-      of a pain, and the values are close enough for plotting light curves.
;-   goes   -- set if plotting data from GOES, not AIA (corrects for cadence).
;-   send_to_back -- set to plot vertical lines behind all others.
;-      Uses the IDL method for graphic objects.
;-   date = 'dd-Mon-yyyy '   -->  don't forget the last space!
;-   gstart = 'hh:mm:ss'
;-   gpeak =  'hh:mm:ss'
;-   gend =   'hh:mm:ss'
;-
;- TO DO:
;-  [] Test to see if GOES start/peak/end times have to have seven elements.
;-     Not sure why else the same lines of code appear multiple times.
;-  [] Rewrite hardcoded values for Sep 15, 2011 flare as
;-        optional kws, and set hardcoded values as defaults.
;-        (I made the same changes in goes.pro... better than nothing)
;-  [] Replace the individual variables gstart, gend, and gpeak with an array?
;-  [] Go directly from time string to jd and vice versa.
;-    Not sure what I meant by this, but jd doesn't even appear in the code...
;-      could probably remove it altogether.
;-



function OPLOT_FLARE_LINES, $
    plt, $
    flare=flare, $
    t_obs=t_obs, $
    ;jd=jd, $  Not used anywhere in code... only appears in one comment, but
                      ; as an actual comment, not a line of code that's been shelved.
    ;target=target, $   ; ?????
    goes=goes, $
    ;utbase=utbase, $
    ;yrange=yrange, $   ; ?????
    send_to_back=send_to_back, $
    ;date=date, $
       ;- date is defined in @parameters, don't need to set kw anymore (22 January 2020)
;    gstart=gstart, $
;    gpeak=gpeak, $
;    gend=gend, $
    _EXTRA=e


;    if not keyword_set(date) then date = '15-Feb-2011 '
;    if not keyword_set(gstart) then gstart = '01:44:00'
;    if not keyword_set(gpeak) then gpeak = '01:56:00'
;    if not keyword_set(gend) then gend = '02:06:00'
    ;- Or manually append the ":00" part?
    ;-   e.g.: if STRLEN(gstart) ne 8 then gstart = gstart + ':00'

    ;@parameters
    ;-   21 April 2019
    ;-     call script "parameters" to set flare-specific variables
    ;-   16 August 2019
    ;-     commented kws for gstart/peak/end since they're defined in @parameters


    ;--- GOES ----------------
    if keyword_set(goes) then begin

        flare_times = date + ' ' + [flare.tstart, flare.tpeak, flare.tend]
        print, flare_times
        stop

        ;- Each element in the FLARE_TIMES array is a string of the form
        ;-      "dd-Mon-yyyy hh:mm:ss.sss"
        ;-  e.g.: "15-Feb-2011 00:00:01.725"

        nn = n_elements(flare_times)
        x_indices = fltarr(nn)

        ;- Added yet another optional kw that defaults to value for this flare.
        ;if not keyword_set(utbase) then utbase = '15-Feb-2011 00:00:01.725'
        ;- Added utbase to @parameters... NO HARDCODING! (17 January 2020)

        ;- INPUT arg = 7xN array,
        ;-  generated using anytim2ex to convert utbase to "ex" (whatever that is)
        ;-   (two steps in one, may make more sense to create input arg separately,
        ;-    then using a single variable name as input for ex2int... meh).
        ;- OUTPUT:  msod and ds79
        ;-   (needed for int2secarr routine below).
        ex2int, anytim2ex(utbase), $
            msod_ref, ds79_ref

        ;- anytim2ex( "hh:mm:ss.sss" )
        ;-    Is arg required to have that many characters?
        for ii = 0, nn-1 do begin
            ex2int, anytim2ex( flare_times[ii] ), msod, ds79
            x_indices[ii] = int2secarr( [msod,ds79], [msod_ref,ds79_ref] )
        endfor


    ;--- AIA -----------------
    endif else begin

        flare_times = strmid( [flare.tstart, flare.tpeak, flare.tend], 0, 5 )

        ;-  For GOES, flare_times is of the form: "15-Feb-2011 00:00:01.725"
        ;-  For  AIA, flare_times is of the form: "15-Feb-2011 00:00"
        ;-    (or was... before I commented the HC and used variables).

        time = strmid( t_obs, 0, 5 )

        nn = n_elements(flare_times)

        ;- Extract INDICES (x_indices) for x-axis values (time) that match the
        ;-   start, peak, and end times for the flare.
        ;-  Should have 3 elements for start/peak/end.
        x_indices = intarr(nn)
        for ii = 0, nn-1 do $
            x_indices[ii] = (where( time eq flare_times[ii] ))[0]
    endelse

    x_indices = x_indices[ where( x_indices ne -1 ) ]
    print, x_indices
    stop

; Why is flare_times defined again?
;    flare_times = [ $
;        strmid( flare.tstart, 0, 5 ), $
;        strmid( flare.tpeak, 0, 5 ), $
;        strmid( flare.tend, 0, 5 ) ]

    name = flare_times + [ ' UT (start)', ' UT (peak)', ' UT (end)' ]

    y1 = []
    y2 = []
    for ii = 0, n_elements(plt)-1 do begin
       y1 = [y1, plt[ii].yrange[0]]
       y2 = [y2, plt[ii].yrange[1]]
    endfor
    format = '(e0.2)'
;    print, y1, format=format
;    print, y2, format=format

    ;plt[0].GetData, xx, yy ;- only needed when xdata = jd... I think.
    ;yrange = plt[1].yrange
    yrange = [ min(y1), max(y2) ]

    ;- [] Try to come up with better, more intuitive variable names here.
    ;-      These are just a mess.
    vert = objarr(n_elements(x_indices))
    linestyle = [1,2,4]
    foreach vx, x_indices, jj do begin
        vert[jj] = plot( $
            ;[ xx[vx], xx[vx] ], $
            [ vx, vx ], $
            yrange, $
            /current, $
            /overplot, $
            ;overplot = plt[0], $
            thick = 0.5, $
            linestyle = linestyle[jj], $
            ystyle = 1, $
            name = name[jj], $
            color = 'black', $
            ;color = 'dark gray', $  ;- Seems too light (22 January 2020)
            _EXTRA=e )
        if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
    endforeach

    ; 27 April 2022
    ;   Moved examples of line patterns to Evernote:
    ;   "IDL graphics - linestyle" in IDL notebook.

    plt = [ plt, vert ]
    return, vert
end
