;+
;- LAST MODIFIED:
;-   dd Month yyyy
;-
;- ROUTINE:
;-   name_of_routine.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-   result = routine_name( arg1, arg2, kw=kw )
;-
;- INPUT:
;-   arg1   e.g. input time series
;-   arg2   e.g. time separation (cadence)
;-
;- KEYWORDS (optional):
;-   kw     set <kw> to ...
;-
;- OUTPUT:
;-   result     blah
;-
;- TO DO:
;-   [] item 1
;-   [] item 2
;-   [] ...
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+
;----------------------------------------------------------------------------------------

function CENTRAL_FREQ_POWERMAPS, $
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
    ;- WFT is "z_end" for?
    ;- could just do the following, and
    ;-   don't set pointless variables that confuse me later...
    ;data = A[cc].data[*,*,z_start:z_start+dz-1]

    sz = size(data, /dimensions)

    fmin = fcenter - (bandwidth/2.)
    fmax = fcenter + (bandwidth/2.)

    nn = n_elements(fcenter)
    map = fltarr(sz[0],sz[1],nn)


    ;- "1600$\AA$ 5.6 mHz (00:00-00:25)"
    title = strarr(nn)

    for ii = 0, nn-1 do begin
        ;- "z_start" can't have more than one element, otherwise returned result
        ;-   will be a 3D cube, and fill more than just the "ii-th" index in the
        ;-  z-dimension of "map"... tho it is for various "fcenter", so z_start
        ;-   is probably the same every time.
        ;- compute_powermaps.pro was written to loop through several values of
        ;-  z_ind, but since wanted to do several values of fcenter, all at the
        ;- SAME z_ind, had to put compute_powermaps on the inside of a new loop.
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

S = CENTRAL_FREQ_POWERMAPS(
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



;----------------------------------------------------------------------------------------
;- image_central_freq_powermaps.pro



;-
;- Sun Jan 27 16:55:14 MST 2019
;- Compute power maps for various central frequency values to compare
;-   3-min maps to 2-min, 5-min, etc.



goto, start;------------------------------------------------------------------------
  ;- Different file previously? Goto stmnt not usually buried in middle of code...


;- User-defined values

cc = 1
dz = 64

;- Define z index (should be the same for all maps)
z_start = 75
;z_start = [197] ;- pre-flare
;z_start = [204] ;- pre-flare/impulsive
;z_start = [450] ;- post-flare

bandwidth = 0.001  ;- Hz

;- Array of periods (seconds) -- convert to Hz before computing power maps
;-   --> compute_powermaps.pro takes freq (not period), in units of Hz (not mHz)
;period = [50, 120, 180, 200, 300, 500]
period = [120, 180, 300]


;----------------------------------------------------------------------------------

;+
;- Code that shouldn't change:
;-    Looks like my attempts to generalize this code... ha.
;-

nn = n_elements(period)

map = fltarr( 500, 330, nn )

;- Compute powermap mask (product of data mask over dz range)
map_mask = POWERMAP_MASK( A[cc].data[*,*,z_start:z_start+dz-1], dz=dz, $
    exptime=A[cc].exptime, threshold=10000. )

;start:;----------------------------------------------------------------------------------
    ;- don't need this anymore!!

;- Compute power map
;-   (don't have to do this for period=3min, just pull from existing maps).
for ii = 0, nn-1 do begin
    map[*,*,ii] = COMPUTE_POWERMAPS( $
        A[cc].data, $
        A[cc].cadence, $
        fcenter=1./period[ii], $
        bandwidth=bandwidth, $
        z_start=z_start, $
        dz=dz, $
        norm=0 ) * map_mask

endfor

print, min(map)
stop
map = map > 0

stop

;- Sun Jan 27 17:45:29 MST 2019
;-
;- What makes this code different from imaging anything else?
;-     min_value/max_value
;-     title --> range of time covered to produce power map
;-     room for colorbar


time = strmid(A[cc].time,0,5)
title = strarr(nn)
for ii = 0, nn-1 do begin


    str = strtrim( (1000./period[ii]), 1)
    str = strmid(str, 0, 3)
    title[ii] = A[cc].name + ' ' + $
        ;strtrim(fcenter[ii]*1000, 1) + ' mHz ('  + $
        '@' + str + ' mHz' + $
        ' (' + time[z_start] + '-' + time[z_start+dz-1] + ' UT)'
    print, title[ii]
endfor


resolve_routine, 'image3', /either
;- NOTE: image3 returns object array
imdata = alog10(map+0.000001)
im = IMAGE3( $
    imdata, $
    title=title, $
    rgb_table = A[cc].ct, $
    ;min_value=0.000001, $
    ;max_value=max(imdata), $
    ;max_value=4.2, $
    ;min_value=min(imdata), $
    ;max_value=max(imdata), $
    xshowtext=0, $
    yshowtext=0, $
    wx = 8.50, $
    top = 0.5, $
    ygap = 0.5, $
    rows = 2, $
    cols = 3, $
    buffer = 0 )


end
