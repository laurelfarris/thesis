;+
;- LAST MODIFIED:
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
;-   t_obs  -- string array of observation times from index.t_obs
;-       ... or is it just one value? plot_lc.pro set t_obs = index[0].t_obs
;-           I'm very confused on what I was trying to do here.
;-   shaded -- set to shade the portion of the plot contained within vert lines.
;-   goes   -- set if plotting data from GOES, not AIA (corrects for cadence).
;-   send_to_back -- set to plot vertical lines behind all others.
;-      Uses the IDL method for graphic objects.
;-   date = 'dd-Mon-yyyy '   -->  don't forget the last space!
;-   tstart = 'hh:mm:ss'
;-   tpeak =  'hh:mm:ss'
;-   tend =   'hh:mm:ss'
;-
;- TO DO:
;-  [] Test to see if GOES start/peak/end times have to have seven elements.
;-     Not sure why else the same lines of code appear multiple times.
;-  [] Rewrite hardcoded values for Sep 15, 2011 flare as
;-        optional kws, and set hardcoded values as defaults.
;-        (I made the same changes in goes.pro... better than nothing)
;-  [] Replace the individual variables tstart, tend, and tpeak with an array?
;-  [] Go directly from time string to jd and vice versa.
;-    Not sure what I meant by this, but jd doesn't even appear in the code...
;-      could probably remove it altogether.
;-
;- NOTE:
;-   Notes on oplot_vertical_lines in comp book p 10 -- might be helpful
;-


pro oplot_vertical_lines
;pro oplot_horizontal_lines
;pro oplot_lines

    ;- 20 April 2019
    ;- From comp book p. 10: musings about user entering 2 arrays
    ;-  and then this subroutine should figure out whether they're horizontal
    ;-  or vertical, b/c one arg would be an array and the other would be
    ;-  just the x or y coord? Not sure actually... never did write a good
    ;-  routine for general plotting of horizontal and/or vertical lines.

end

pro OPLOT_FLARE_LINES, $
    plt, $
    t_obs=t_obs, $
    ;jd=jd, $  Not used anywhere in code... only appears in one comment, but
                      ; as an actual comment, not a line of code that's been shelved.
    ;target=target, $   ; ?????
    shaded=shaded, $
    goes=goes, $
    utbase=utbase, $
    ;yrange=yrange, $   ; ?????
    send_to_back=send_to_back, $
    date=date, $
    tstart=tstart, $
    tpeak=tpeak, $
    tend=tend, $
    _EXTRA=e



    if not keyword_set(date) then date = '15-Feb-2011 '

    if not keyword_set(tstart) then tstart = '01:44:00'
    if not keyword_set(tpeak) then tpeak = '01:56:00'
    if not keyword_set(tend) then tend = '02:06:00'
    ;- Or manually append the ":00" part?
    ;-   e.g.: if STRLEN(tstart) ne 8 then tstart = tstart + ':00'

    phases = [tstart, tpeak, tend]


    ;--- GOES ----------------
    if keyword_set(goes) then begin

        flare_times = date + [ tstart, tpeak, tend ]
        flare_times = date + phases

        ;- Each element in the FLARE_TIMES array is a string of the form
        ;-      "dd-Mon-yyyy hh:mm:ss.sss"
        ;-  e.g.: "15-Feb-2011 00:00:01.725"

        nn = n_elements(flare_times)
        x_indices = fltarr(nn)

        ;- Added yet another optional kw that defaults to value for this flare.
        if not keyword_set(utbase) then utbase = '15-Feb-2011 00:00:01.725'

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

        ;flare_times = [ '01:44', '01:56', '02:06' ] ; --- HC...
        ;-
        ;- 17 April 2019
        ;-   Instead, convert each time from "hh:mm:ss" to "hh:mm".
        ;-   Variables already in the form "hh:mm" won't change.
        flare_times = [ $
            strmid( tstart, 0, 5 ), $
            strmid( tpeak, 0, 5 ), $
            strmid( tend, 0, 5 ) ]

        ;-  For GOES, flare_times is of the form: "15-Feb-2011 00:00:01.725"
        ;-  For  AIA, flare_times is of the form: "15-Feb-2011 00:00"
        ;-    (or was... before I commented the HC and used variables).

        time = strmid( t_obs, 0, 5 )
        ;-   As with start/peak/end times,
        ;-     variables already in the form "hh:mm" won't change.

        nn = n_elements(flare_times)

        ;- Extract INDICES (x_indices) for x-axis values (time) that match the
        ;-   start, peak, and end times for the flare.
        ;-  Should have 3 elements for start/peak/end.
        x_indices = intarr(nn)
        for ii = 0, nn-1 do $
            x_indices[ii] = (where( time eq flare_times[ii] ))[0]
    endelse

    flare_times = [ $
        strmid( tstart, 0, 5 ), $
        strmid( tpeak, 0, 5 ), $
        strmid( tend, 0, 5 ) ]
    name = flare_times + [ ' UT (start)', ' UT (peak)', ' UT (end)' ]


    ;plt[0].GetData, xx, yy ;- only needed when xdata = jd... I think.
    yrange = plt[0].yrange

    ;- [] Try to come up with better, more intuitive variable names here.
    ;-      These are just a mess.
    vert = objarr(nn)
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
            _EXTRA=e )
        ;if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
            ;- Apparently the user doesn't get to decide this... suck it!
        vert[jj].Order, /SEND_TO_BACK
    endforeach

    ; . . . . . . . . . . .
    vert[0].linestyle = [1, '1111'X]

    ; ....................
    ;vert[0].linestyle = [1, '5555'X]


    ; __  __  __  __  __
    ;vert[1].linestyle = [1, 'F0F0'X]
    ;vert[1].linestyle = [1, '6666'X]
    vert[1].linestyle = [1, '3C3C'X] ;- shift 'F0F0' so it's symmetric



    ; __ . __ . __ . __ . __ .
    ;vert[2].linestyle = [1, '4FF2'X]

    ; __ . . __ . . __ . . __
    ;vert[2].linestyle = [1, '23E2'X]

    ; ___ .. ___ .. ___ .. ___
    vert[2].linestyle = [1, '47E2'X]


    ; __  . . .  __  . . .  __
    ;vert[2].linestyle = [1, '48E2'X]


    ; 1  0001
    ; 2  0010
    ; 3  0011
    ; 4  0100
    ; 5  0101
    ; 6  0110
    ; 7  0111

    ; C  1100
    ; D  1101
    ; E  1110
    ; F  1111


    ;- Dots:
    ; 1111 - spread out
    ; 5555 - closer together

    ;- Dashes
    ; 3333
    ; F0F0

    ;- Dash dot
    ; 7272

    ;- Dash dot dot (IDL doesn't have a linestyle option for this...)
    ; 7F92
    ; 4FF2 --> symmetry

    ;- Dash dot dot dot
    ; 7C92


    ; Shaded region
    ;-  Given the absense of a '-' after the semi in the previous line,
    ;-    I'd say this first chunk is outdated, and can probably be removed.
    if keyword_set(shaded) then begin
        ;for ii = 0, n_elements(graphic)-1 do begin
            ;yrange = (graphic[ii]).yrange
            v_shaded = plot2( $
                [ vx[0]-32, vx[0]-32, vx[-1]+32-1, vx[-1]+32-1 ], $
                [ yrange[0], yrange[1], yrange[1], yrange[0] ], $
                /overplot, ystyle=1, linestyle=6, $
                fill_transparency=50, $
                fill_background=1, $
                fill_color='light gray' )
            v_shaded.Order, /SEND_TO_BACK
        ;endfor

        ;- Another way to shade:
        v_shaded = polygon( $
            [x1, x2, x2, x1], $
            [y1, y1, y2, y2], $
            /data, $
            linestyle = 4, $
            fill_background = 0, $
            fill_color='light gray' )
        v_shaded.Order, /send_to_back

    endif
    plt = [ plt, vert ]
    ;return, vert
end
