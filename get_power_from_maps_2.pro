;+
;- LAST MODIFIED:
;-   18 August 2019
;-
;- ROUTINE:
;-   get_power_from_maps.pro
;-
;- EXTERNAL SUBROUTINES:
;-   powermap_mask.pro
;-   plot_pt.pro
;-
;- PURPOSE:
;-   Create 1D array of length = ~ n_elem(flux) - dz +1
;-     of power as function of time: P(t)
;- P(t) pix^{-1} = 1D array created by summing over x & y in each map.
;-   Steps:
;-     • MAPS: Restore powermaps from .sav files
;-          and add to each structure in array 'A' (if not done already).
;-     • MASK: multiply by map to set sat. pixels = 0 (powermap_mask.pro)
;-     • P(t): sum over all pixels in each power map and
;-          divide power by n_pix to get units of power PER (unsat) PIXEL
;-          (where n_pix is obtained directly from MASK).
;-     • PLOT P(t) curves for all channels, overplotted using batch_plot
;-          (or batch_plot_2 for unshared axes...)
;-     •
;-
;- USEAGE:
;-   IDL> .RUN get_power_from_maps
;-
;- INPUT:
;-   N/A (is a Main Level (ML) routine)
;-
;- KEYWORDS:
;-   N/A
;-
;- OUTPUT:
;-   N/A
;-
;- TO DO:
;-   [] write subroutine with data as input argument
;-   [] Add test codes
;-   [] Create new saturation routine (this currently addresses
;-      saturation and calculation of total power with time.
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;- If large number of variables needs to be passed, and/or size of variables
;-  is large, passing back and forth to subroutine may be too slow, or too
;-   complicated to be worthwhile (have to look up calling syntax every time)
;-


function GET_POWER_FROM_MAPS, data, map, $
    exptime, channel, $
    dz, threshold, $


    sz = size( map, /dimensions )

    ;- MAP mask (same dimensions as maps)
    resolve_routine, 'powermap_mask', /either

;    map_mask = fltarr(sz)
;    for cc = 0, n_elements(A) do begin
;        map_mask[*,*,*,cc] = POWERMAP_MASK( $
;            A[cc].data, exptime=A[cc].exptime, dz=dz, threshold=threshold)
;    endfor

    ;- Don't loop in subroutine if CALLED in a loop, one 'A' struc at a time...
    map_mask = POWERMAP_MASK( $
        data, exptime=exptime, dz=dz, threshold=threshold)

    ;- IDL> help, map_mask
    ;-     MAP_MASK  FLOAT  = Array [500, 330, 686, 2]

    ;- Multiply power maps by mask to set saturated pixels = 0.
    new_map = map * map_mask
        ;- NOTE: Don't update variable like e.g. X = X*mask...
        ;-   need to preserve original values in case code is run again,
        ;-   may get incorrect values if calculatoin is done using
        ;-   previously updated values rather than original ones.
        ;- (18 August 2019)
        ;-

    ;- Use MASK to compute array with number of unsaturated pixels in each map.
    n_pix = total(total(map_mask,1),1)
    ;- IDL> help, n_pix
    ;-     N_PIX  FLOAT  = Array[686, 2]   (for 15 Feb 2011 flare)
    ;-   should be 1D now
    ;- Test n_pix
    if (where(n_pix eq 0.0))[0] ne -1 then begin
        print, "Problem: n_pix = 0 somewhere, which should be impossible. "
        stop
    endif

    ;- Compute 1D power array (z-dim matches that of map and map_mask).
;    power = fltarr( sz[2], sz[3] )
;    for cc = 0, n_elements(A)-1 do begin
;        power[*,cc] = (total(total(A[cc].map,1),1)) / n_pix[*,cc]
;    endfor
    power = (total(total(map,1),1)) / n_pix

    return, power

end;--------------------------------------------------------------------------------


dz = 64
threshold = 10000.

;---

;- Restore AIA powermaps from .sav files and read into A[0].map and A[1].map.
@restore_maps

sz = size(A.map, /dimensions)
power = fltarr( sz[2], sz[3] )
for cc = 0, 1 do begin
    power[*,cc] = GET_POWER_FROM_MAPS( $
        A[cc].data, A[cc].map, $
        A[cc].exptime, A[cc].channel[cc], $
        dz, threshold $
        )
endfor

;- TEST (of sorts): Print min/max values of power for each channel
for cc = 0, n_elements(A)-1 do begin
    print, ""
    print, A[cc].channel, ":"
    print, "  min P(t) = ", min(power[*,cc])
    print, "  max P(t) = ", max(power[*,cc])
endfor


;- PLOT_PT -- a not-so-general subroutine to create plots of P(t).
;-  Calls BATCH_PLOT, which IS a general routine for setting up loops and
;-   plotting multiple curves on top of each other (same axes or not...)
;-  Mostly serves as a place to dump plotting commands that may be
;-   specific to P(t), but want to keep this
;-   ML routine clean and simple, and clearly showing all the steps
;-   involved in creating P(t) plots - from obtaining the values to begin with,
;-   to showing them in a plot

;-
;- Purpose of defining "props" structure to pass to PLOT_PT
;-   may have been a way to define this routine with get_power_from_flux,
;-   if each has different properties for the plots, but rest of code
;-   is the same... see previous version of _maps.
;-

resolve_routine, 'plot_pt', /is_function
plt = PLOT_PT( $
    power, dz, A[0].time, buffer=1, $
    name = A.name )

file = 'time-3minpower_maps'
save2, file

end
