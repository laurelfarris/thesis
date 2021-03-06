;+
;- LAST MODIFIED:
;-   14 March 2020
;-     Changed code so that appropriate scaling of threshold by exptime
;-       is accomplished without modifying threshold iteself;
;-     new value was unknowingly returned to caller, causing
;-       all kinds of confusion until finally figured it out.
;-   IMPORTANT:
;-     ==>>> NEVER update value of variable by operating on itself unless value
;-     is RESET at the beginning, EVERY. SINGLE. TIME.
;-
;-
;- ROUTINE:
;-   powermap_mask.pro
;-   -- copied bit of code inside function def from bda.pro (14 December 2018)
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-   Calculate (and return) saturation mask.
;-   At first, took map as arg, multiplied map by mask after computing, and
;-    returned sat-corrected map, instead of raw map_mask,
;-   but those are two different procedures, and may want map_mask alone, or
;-    preserve copy of original mask... either way, caller needs to correct map
;-    themselves by multiplying returned mask by their map.
;-
;-  Mask can be multiplied by powermaps to set locs of all sat. to 0
;-     (improves contrast, except according to A1 Ref, this shouldn't be the case
;-     b/c 3-minute signal wouldn't be detected from sat. pixels... signal should
;-     be buried somehow, or too weak, or not present at all?
;-   Similar to computing data mask based on saturation threshold alone,
;-     but sets ANY pixel in each NxMxdz array = 0 if pixel loc at (x,y) is saturated
;-     in even one image in each set of 64 images (or whatever value dz is set to).
;-     Mask used for power maps, which were computed from subsets of data cube
;-     where z-dimensions = dz.
;-
;- USEAGE:
;-   map_mask = POWERMAP_MASK( data, dz=dz, exptime=exptime, threshold=threshold )
;-
;- INPUT:
;-   data   3D data cube (values are used to determine whether each pixel in
;-            mask is set to 0 or 1, dep on whether data value is > or < thresh.
;-
;- KEYWORDS (optional):
;-   dz     = integer number of consecutive images, aka sample number.
;-              dz * cadence = total time (seconds) of observations
;-   threshold
;-     = max value pixel can have, contaminated via saturation or bleeding
;-   exptime
;-     = exposure time (seconds) --> see header.
;-     If data is exptime-corrected, set kw to divide threshold by
;-     exptime before computing mask of 1s and 0s.
;-    NOTE: this routine does NOT apply exptime-correction to data...
;-            assumes this has been done before passing data to this routine.
;-
;- OUTPUT:
;-   map_mask     3D array of 1s and 0s. Should have same dimensions as
;-                 powermap
;-
;- TO DO:
;-   [] figure out how saturation is expected to affect FT power of input signal.
;-        Depends on period of interest? Or should sat pixels not osc at all?
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+

function POWERMAP_MASK, $
    data, $
    dz=dz, $
    ;exptime=exptime, $
    threshold=threshold

    @parameters

    start_time = systime(/seconds)

    ;- Default dz = value I've been using the most
    if not keyword_set(dz) then dz = 64

    ;+
    ;- 14 March 2020
    ;-
    ;-
    ;- Default threshold = saturation level for AIA data (see SDO_guide for data analysis)
    if not keyword_set(threshold) then threshold = 15000.
    ;print, "threshold set to ", threshold, threshold
    ;-
    ;----------
    ;-
    ;- 08 April 2020 --> no longer correcting for exptime in this subroutine.
    ;-  Up to user to apply corrections either to both input args, or neither.
    ;-
    ;- Apply exptime correction to threshold:
    ;if keyword_set(exptime) then threshold = threshold/exptime
    ;data_mask = data lt threshold
    ;if not keyword_set(exptime) then exptime = 1.0
    ;data_mask = data lt (threshold/exptime)
    ;- Better way to correct threshold value for exptime
    ;-  (doesn't pass modified variable back to caller).
    ;-
    ;--------



    data_mask = data lt threshold

    ;-
    ;- 13 August 2019
    ;-  Initialize map_mask variable using dimensions of data arg.
    ;-  map_mask should have same dimensions as power map,
    ;-  but since maps are not input option,
    ;-  have to use data dimensions and subtract from z-dimension using dz.
    ;- 19 January 2020
    ;-  In call to this subroutine, get_power_from_maps.pro passes kw
    ;-    sz=SIZE(A[cc].map, /dimensions)
    ;-  I'm guessing this was before I added lines below to adjust
    ;-    data size to map size, since map cubes have dz fewer elements
    ;-    in the z-direction... makes the main routines simplier when
    ;-    messy code is put in subroutines wherever possible...
    sz = size(data_mask, /dimensions)

    
;    if flare_num eq 0 then $
;        sz[2] = sz[2]-dz $
;    else sz[2] = sz[2]-dz+1
      ;-  sz[2]-dz+1 is correct EXCEPT X2.2 flare... missing last map
      ;-     Maps were re-computed at some point, should have all maps
      ;-      (26 February 2020)
    sz[2] = sz[2]-dz+1

    map_mask = fltarr(sz)

    ; Create power map mask (this takes a while to run...)
    ;-  Actually computed pretty quick today: less than 40 seconds for each channel
    for ii = 0, sz[2]-1 do $
        map_mask[*,*,ii] = PRODUCT( data_mask[*,*,ii:ii+dz-1], 3 )

    print, "Finished computing mask in ", $
        (systime(/seconds)-start_time)/60., $
        " minutes."
;    print, " ( = ", $
;        (systime(/seconds)-start_time), $
;        " seconds)."

    return, map_mask
end


;+
;- ML code - relatively simple to run this alone, instead of
;-  dealing with my messy, convoluted subroutines...
;-



;-
;- Restore maps from .sav files,
;- Compute MAP_MASK from data cube,
;-   saturation/bleeding threshold,
;-   and exptime (if desired).
;- Multiply maps in structure by saturation mask (from bda.pro)
;-

;IDL> .RUN restore_maps
;-

dz = 64
threshold = 10000.

;-
;- 14 April 2020:
;-   Copied the following 2 lines from article1_maps.pro,
;-   independent variables for the masks so
;-   I can avoid modifying A.maps directly, preserve the original vlaues
;-   as restored from .sav files to make sure I don't screw anything up.
;- --> DO NOT ".continue" when prompted! Masks are defined at ML, so
;-  we're done with this routine.
aia1600mask = powermap_mask( A[0].data, dz=dz, threshold=threshold )
aia1700mask = powermap_mask( A[1].data, dz=dz, threshold=threshold )

print, ''
print, ' Type ".CONTINUE" to apply saturation mask to powermaps.'
print, ''
stop

for cc = 0, 1 do begin
    map_mask = POWERMAP_MASK( $
        A[cc].data, $
        dz=dz, $
        ;exptime=A[cc].exptime, $
        threshold=threshold $
    )
    A[cc].map = A[cc].map * map_mask
endfor

end
