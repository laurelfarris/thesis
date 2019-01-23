;- 26 October 2018

;- Concerned that maps show power scaled with intensity, and don't
;- necessarily reflect true power of 3-min osci.
;- --> make several maps at various central frequencies, especially those
;- that shouldn't be enhanced... maybe 20 mHz? See Milligan WA plots.
;- Full AR, to compare areas of high and low emission.
;- Flare ribbons?
;-
;- should probably compare various time segment lengths and bandpasses...
;- but one thing at a time.

;- Limits on frequencies based on cadence and time segment length.
;-   fmax --> shortest period = 2*cadence
;-   fmin --> longest period = dt/2
;- 48 seconds - 13 minutes



function GET_POWER_MAPS, $
    data, $
    time, $
    channel, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    t_start=t_start, $
    dz = dz


    ;- function to calculate (or restore) power maps with various parameters.
    ;- Possible examples:
    ;-    Compare central frequencies, e.g. 120, 180, 200... second
    ;-

    if not keyword_set(dz) then dz = 64

    z_start = (where(time eq t_start[0]))[0]
    z_end = z_start + dz - 1
    t_end = time[z_end]


    data = A[cc].data[*,*,z_start:z_end]
    sz = size(data, /dimensions)

    fmin = fcenter - (bandwidth/2.)
    fmax = fcenter + (bandwidth/2.)

    nn = n_elements(fcenter)
    map = fltarr(sz[0],sz[1],nn)


    ;- "1600$\AA$ 5.6 mHz (00:00-00:25)"
    title = strarr(nn)

    for ii = 0, nn-1 do begin
        map[*,*,ii] = POWERMAPS( $
            data, A[cc].cadence, $
            fcenter=fcenter[ii], $
            bandwidth=bandwidth, $
            ;fmin=fmin, fmax=fmax, $
            z_start=z_start, $
            dz=dz )
        title[ii] = A[cc].channel + ' ' $
            + strmid(fcenter[ii],0,3) + ' mHz' $
            + ' (' + t_start + '-' + t_end + ')'
    endfor

    struc = { $
        map: map, $
        title : title }
    return, struc

end

cc = 0

S = GET_POWER_MAPS(
    A[cc].data, $
    strmid( A[cc].time, 0, 5 ), $
    A[cc].channel, $
    t_start = 01:19, $
    bandwidth = 0.001, $
    fcenter = 1./[120, 180, 200, 300, 450, 600 ], $
    dz = 64 )


im = image3( S.map, title=S.title, rows=3, cols=2 )


cbar = colorbar2( target = im )

file = 'aia' + A[cc].channel + 'fcenter.pdf'
save2, file

end
