;+
;- LAST MODIFIED:
;-   19 July 2019
;-
;-
;- ROUTINE:
;-   compute_powermaps.pro
;-
;- EXTERNAL SUBROUTINES:
;-   fourier2.pro (not mine)
;-
;- PURPOSE:
;-   compute powermaps at input start times through input dt
;-   for input data cube
;-
;- USEAGE:
;-   map = compute_powermaps( data, cadence,
;-     fcenter=fcenter, bandwidth=bandwidth, threshold=threshold,
;-     z_start=z_start, dz=dz, norm=norm
;-
;- INPUT:
;-   data      3D data cube
;-   cadence   instrumental cadence at which data was sampled (seconds)
;-
;- KEYWORDS:
;-   fcenter     central frequency (Hz)
;-   bandwidth   freq width (centered on fcenter) that will contribute to power
;-   threshold*  skip pixels w/ values higher than threshold (sat)
;-   z_start     array of START indices
;-   dz          length over which to calculate FT (# images)
;-   norm        sets /NORM kw when computing power using fourier2.pro
;-
;- OUTPUT:
;-   3D power map (cube)
;-
;- TO DO:
;-   [] Make another level of subroutines for all the specifics below,
;-      one for several different situations. Each of them call the
;-      general routine above, and all return essentially the same thing.
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- NOTES:     (May 11 2018) Added /NORM keyword to fourier2.
;-            (May 13 2018) switched from TOTAL to MEAN power.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+




; 15 June 2018
; Reading in data and creating maps first, without messing with
;  structures or dictionaries (yet). Do need to interpolate though!

;   12 July 2018
;     changed threshold from hard-coded variable to optional keyword

; 23 September 2018
; Removing part that excludes saturation. Will take longer to compute,
;  but better to have extra information that can easily be excluded,
;  in this case, by using masks.

;- 19 October 2018
;- Now putting it back... only calculating four maps, which can be done
;- fast enough to test different threshold values.
;-   Added if statement to use code that manages saturated pixels
;-   only if threshold kw is set.


function COMPUTE_POWERMAPS, $
    data, $
    cadence, $
    ;fmin=fmin, $
    ;fmax=fmax, $
    fcenter=fcenter, $
    bandwidth=bandwidth, $
    threshold=threshold, $
    z_start=z_start, $
    dz=dz, $
    norm=norm, $
    syntax=syntax

    if keyword_set(syntax) then begin
        print, ''
        print, 'calling sequence, shown with default kw values:'
        print, ''
        print, 'result = COMPUTE_POWERMAPS( data, cadence, '
        print, '  fcenter='
        print, '  bandwidth=1 (Hz)'
        print, '  threshold='
        print, '  z_start='
        print, '  dz='
        print, '  norm='
        print, ''
        return, 0
    endif


    sz = size( data, /dimensions )

    ;- Number of elements in zz (z_start) will be the number of
    ;-  maps returned (just 1 by default, starting at beginning of data).
    if n_elements(z_start) eq 0 then zz=[0] else zz=z_start


    if n_elements(dz) eq 0 then dz = sz[2]

    ;- Set default bandwidth as 1 mHz
    if not keyword_set(bandwidth) then begin
        print, 'Default value of bandwidth=1 mHz, centered on fcenter.' 
        bandwidth = 0.001
    endif


    ;---------------------------------------------------------------
    ;- 31 July 2019
    ;-
    ;- fcenter not optional, so re-wrote code to make it optional
    ;-  (aka gave it a default value).
    ;-  bandwidth was already given a default value if not set (above),
    ;-    not sure why I didn't do the same for fcenter.
    ;-
    ;- No longer need conditional to set fmin and fmax,
    ;-  commenting for now, until confirm that this works.
    ;-
    ;- Set default central frequency as 5.6 mHz (3 minutes)
    if not keyword_set(fcenter) then begin
        print, 'Default value of fcenter=5.6 mHz (3 minutes).' 
        fcenter = 0.0056
    endif
    ;-
    ;if keyword_set(fcenter) and keyword_set(bandwidth) then begin
        fmin = fcenter - bandwidth/2.
        fmax = fcenter + bandwidth/2.
    ;endif
    ;---------------------------------------------------------------



    ;- Use fourier2.pro and random input array with length = dz
    ;-   to get frequencies attainable at given cadence
    ;-  (returned freqs will be the same, regardless of the actual vales
    ;-  of the input array... used one that is clearly NOT data to more
    ;-  easily distinguish between simply looking at resulting freqs
    ;-  and actual power at those freqs, which is done later.
    frequency = reform( (fourier2( indgen(dz), cadence, NORM=NORM ))[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )


    ;- Initialize map variable
    nn = n_elements(zz); - 1
    map = fltarr( sz[0], sz[1], nn )

    ;- Could use foreach i, zz... but need i increasing by 1 for map.
    ;- Add some test codes here, or some kind of error handling.
    ;- This takes way too long just to lose everything because the
    ;-  last value of i was "out of range" or whatever.
    ;- --> TEST: should produce error if z_start is out of range.
    test = intarr( sz[2] )
    for i = 0, nn-1 do test[i] = data[ 0, 0, zz[i]:zz[i]+dz-1 ]


    start_time = systime(/seconds)


    ;-
    ;-- Skip saturated pixels
    if keyword_set(threshold) then begin

        ;- Array to keep track of how many pixels saturate at each z value.
        sat_arr = fltarr( sz[2] )

        for i = 0, nn-1 do begin
            for y = 0, sz[1]-1 do begin
            for x = 0, sz[0]-1 do begin

                ;- Subtract 1 from dz so that total # images is eqal to dz
                flux = data[ x, y, zz[i]:zz[i]+dz-1 ]

                ;- z-coordinate(s) of saturated pixels in time segment
                sat = [where( flux ge threshold )]

                if sat[0] eq -1 then begin

                    power = reform( (fourier2( flux, cadence, norm=norm ))[1,*] )

                    ;map[x,y,i] = total( power[ind] )
                    map[x,y,i] = mean( power[ind] )
                    ;- MEAN is better than TOTAL,
                    ;     accounts for variation due to frequency resolution.
                endif
            endfor
            endfor
        endfor
    ;-
    ;-- Run calculations on all pixels, whether saturated or not.
    endif else begin
        for ii = 0, nn-1 do begin
            for yy = 0, sz[1]-1 do begin
            for xx = 0, sz[0]-1 do begin

                ;- Subtract 1 from dz so that total # images is eqal to dz
                flux = data[ xx, yy, zz[ii]:zz[ii]+dz-1 ]

                power = reform( (fourier2( flux, cadence, norm=norm ))[1,*] )
                map[xx,yy,ii] = mean( power[ind] )
            endfor
            endfor
        endfor
    endelse

    print, format='("Power maps calculated in ~", F0.1, " minutes.")', $
        (systime(/seconds) - start_time)/60
    return, map
end
