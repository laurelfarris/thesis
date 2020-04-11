;+
;- LAST MODIFIED:
;-   05 March 2020
;-    NOTE: didn't change code itself, just added headings for documentation
;-
;- ROUTINE:
;-   get_contour_data.pro
;-
;- EXTERNAL SUBROUTINES:
;-
;- PURPOSE:
;-
;- USEAGE:
;-
;- INPUT:
;-
;- KEYWORDS (optional):
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] Move comments from below this block from _template.pro and put
;-      text under relevant heading.
;-
;- KNOWN BUGS:
;-
;- AUTHOR:
;-   Laurel Farris
;-
;+




;- Get contour data from HMI B_LOS ('mag') or HMI continuum ('cont').
;- input desired date_obs (hh:mm). Either single time or array, e.g.
;-    c_data = GET_HMI( time[zz+(dz/2)], channel='mag' )

;- 20 November 2018
;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011

;- 17 December
;- Returns an HMI image with date_obs close to input time.
;- If hmi_prep routine was run, wouldn't need to restore data,
;-  but do need to extract IND for HMI - since cadence is different from AIA
;-  (can't use same z-indices).


;- TO DO:
;-   Write to only run once (currently calling this every time the graphic
;-      is re-created.)
;- Make a structure or something to keep at main level.
;-    Or not... this doesn't take that long to run.

;-
;- end of (messy) documentation
;-
;-------------------------------------------
;-

function GET_CONTOUR_DATA, time, channel=channel

    instr = 'hmi'

    @parameters
    READ_MY_FITS, index, $
        instr=instr, channel=channel, $
        nodata=1, prepped=1

    hmi_time = strmid( index.date_obs, 11, 5 )

    ;- Added strmid to input time in case it's stil the full string.
    ;-  If it's not, strmid won't do anything, so doesn't hurt.
    ind1 = (where( hmi_time eq strmid(time[0],0,5) ))[0]
    ind2 = (where( hmi_time eq strmid(time[-1],0,5) ))[0]
    ind = [ind1:ind2]



    ;- Returns "cube" [750, 500, 398], already centered on AR
    @parameters
    restore, '/solarstorm/laurel07/' + year+month+day + '/hmi_' + channel + '.sav'

    ; Crop data to 500x330 (default dimensions in crop_data.pro)
    hmi = CROP_DATA( cube, offset=[-15,0] )

    c_data = mean( hmi[*,*,ind], dimension=3 )

    return, c_data
end
