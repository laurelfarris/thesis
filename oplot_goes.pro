
;- Last modified:   17 November 2018

function OPLOT_GOES, plt, data
    ; AIA channels probably need to be normalized to overplot

    ; GOES - create struc if haven't already
    ;    make another struc for this?
    if n_elements(data) eq 0 then data = GOES()


    ;- Normalize y values
    ;-   NOTE:
    ;-     data.ydata[*,0] = 1-8 Angstrom.
    ;-     data.ydata[*,1] = 0.5-4 Angstrom.
    yy = data.ydata[*,0]
    yy = yy - min(yy)
    yy = yy / max(yy)


    ;- Set x values to overlay GOES on current LCs so that date/times 
    ;-    line up correctly.

    ;- The following only works if LCs were plotted as function of
    ;-    index, rather than JD.
    ;xx = findgen(n_elements(yy))
    ;xx = (xx/max(xx)) * 749


    ;- Use xdata from plt
    plt[0].GetData, jd, intensity
    D = n_elements(yy)
    increment = double( ( jd[-1] - jd[0] ) / D )
    start = double(jd[0])

    format = '(F0.6)'
    ;print, jd[0], format=format
    ;print, jd[-1], format=format


    ;- Hardcoded values from data.UTBASE
    mo = 2
    day = 15
    year = 2011
    hour = 0
    min = 0
    sec = 1.725

    goes_jd = dblarr(D)

    for ii = 0, D-1 do begin

        ;hour = fix(  data.tarray[ii]/3600) 
        ;min  = fix(((data.tarray[ii]/3600)-hour) * 60 )
        ;sec  = fix( $
        ;    ((((data.tarray[ii]/3600)-hour)*3600)-min) * 60 )

        hour = data.tarray[ii]/3600
        hour = fix(hour)
        min  = data.tarray[ii]/60 - hour*60
        min  = fix(min)
        sec  = data.tarray[ii] - hour*3600 - min*60
        sec  = fix(sec)

        goes_jd[ii] = julday( mo, day, year, hour, min, sec )
    endfor

    ;xx = make_array( $
    ;    D, /index, $
    ;    start = start, $
    ;    increment = increment )


    g = plot2(  $
        goes_jd, yy, $
        /overplot, $
        linestyle='__', $
        name = data.sat + ' 1-8$\AA$' )

    return, g
end
