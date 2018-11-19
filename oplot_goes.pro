
;- Last modified:   17 November 2018

;function OPLOT_GOES, plt, goes, _EXTRA=e

pro OPLOT_GOES, plt, goes, $
        _EXTRA=e

    ; GOES - create struc if haven't already
    ;    make another struc for this?
    if n_elements(goes) eq 0 then goes = GOES()


    ;- NOTE:
    ;-   goes.ydata[*,0] = 1.0-8.0 Angstroms
    ;-   goes.ydata[*,1] = 0.5-4.0 Angstroms
    yy = goes.ydata[*,0]



    ;- Subtract min instead of mean to avoid problems with ylog=1
    ;yy = yy - min(yy)



    ;- Normalize y values
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


    ;- Hardcoded values from goes.UTBASE
    mo = 2
    day = 15
    year = 2011
    hour = 0
    min = 0
    sec = 1.725

    goes_jd = dblarr(D)

    for ii = 0, D-1 do begin

        ;hour = fix(  goes.tarray[ii]/3600)
        ;min  = fix(((goes.tarray[ii]/3600)-hour) * 60 )
        ;sec  = fix( $
        ;    ((((goes.tarray[ii]/3600)-hour)*3600)-min) * 60 )

        hour = goes.tarray[ii]/3600
        hour = fix(hour)
        min  = goes.tarray[ii]/60 - hour*60
        min  = fix(min)
        sec  = goes.tarray[ii] - hour*3600 - min*60
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
        LINESTYLE = [1, 'FCFC'X], $
        name = goes.sat + ' 1-8$\AA$', $
        _EXTRA = e )

    plt = [ plt, g ]
    ;plt[2] = g
    ;return, g
end
