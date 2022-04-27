;+

function OPLOT_FLARE_LINES_2, flare, plt, start_ind=start_ind

    ; Get JD for each phase using values in flare struc
    vx = GET_JD( $
        flare.year + '-' + flare.month + '-' + flare.day + 'T' + $
        [flare.tstart, flare.tpeak, flare.tend] + $
        ':00.000Z' $
    )

    vertname = ['start', 'peak', 'end']

    vert = objarr(n_elements(vertname))
    for ii = start_ind, n_elements(vert)-1 do begin
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

    return, vert

end
