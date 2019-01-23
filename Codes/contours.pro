;-
;- LAST MODIFIED:
;-   14 December 2018
;-
;- PURPOSE:
;-    Two subroutines, one to return contour data and one to actually plot them
;-    (image must be generated first! See ML code below).
;- INPUT:
;-    time - date_obs for which you desire your contour data.
;- KEYWORDS:
;-    channel - (not optional, despite usual kw useage).
;- OUTPUT:
;-    HMI image cropped to 500x330, to be used in CONTOUR arg.
;- TO DO:
;-    Make sure contour2.pro works... haven't tested this yet.



function GET_CONTOUR_DATA, time, channel=channel

    ;- 20 November 2018
    ;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011

    ;- 17 December
    ;- Generalizing "get_hmi" to just "get_data", even though it's still just using HMI.
    ;- All this does is return an HMI image with date_obs close to input time.
    ;- If hmi_prep routine was run, wouldn't even need this, except the part that
    ;-   extracts the IND for HMI, since cadence is different from AIA, can't use
    ;-   same z-indices.


    ;- Older comments:
    ;- Get contour data from HMI B_LOS ('mag') or HMI continuum ('cont').
    ;- input desired date_obs (hh:mm). Either single time or array, e.g.
    ;-    c_data = GET_HMI( time[zz+(dz/2)], channel='mag' )

    ;- TO DO:
    ;-   Write to only run once (currently calling this every time the graphic
    ;-      is re-created.)
    ;- Make a structure or something to keep at main level.
    ;-    Or not... this doesn't take that long to run.

    instr = 'hmi'

    READ_MY_FITS, index, instr=instr, channel=channel, $
        nodata=1, prepped=1

    hmi_time = strmid( index.date_obs, 11, 5 )

    ;- Added strmid to input time in case it's stil the full string.
    ;-  If it's not, strmid won't do anything, so doesn't hurt.
    ind = (where( hmi_time eq strmid(time,0,5) ))[0]

    ;- Returns "cube" [750, 500, 398], already centered on AR
    restore, '../hmi_' + channel + '.sav'

    ; Crop data to 500x330 (default dimensions in crop_data.pro)
    hmi = CROP_DATA( cube, offset=[-15,0] )

    c_data = hmi[*,*,ind]
    return, c_data
end


function CONTOURS, c_data, target=target, channel=channel

    sz = size(c_data, /dimensions)
    if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]
    contourr = objarr(nn)

    if channel eq 'cont' then begin
        ;- Define continuum contours relative to average in quiet sun (lower right corner).
        data_avg = mean(c_data[350:450,50:150])
        ;- Outer edges of [penumbra, umbra]
        c_value = [0.9*data_avg, 0.6*data_avg]
        c_color = ['red','red']
        c_thick = 1.0
        name = 'umbra and penumbra boundaries'
    endif

    if channel eq 'mag' then begin
        ;- min/max values used by Schrijver2011... don't know why.
        c_value = [-300, 300]
        c_color = ['black', 'white']
        ;c_value = [-1000, -300, 300, 1000]
        ;c_value = [ -reverse(c_value), c_value ]
        ;c_thick = [1.0, 2.0, 2.0, 1.0]
        ;c_color = ['black', 'black', 'white', 'white']
        rgb_table = 0 ; black --> white
        name = 'B$_{LOS} \pm 300$'
        ;title = 'B$_{LOS} \pm 300$'
    endif

;- Make structures instead, though would have to change the way c_data
;-  is retrieved.

    ;- Define continuum contours relative to average in quiet sun (lower right corner).
    ;- Outer edges of [penumbra, umbra]
    data_avg = mean(c_data[350:450,50:150])

    magnetic_field = { $
        channel : 'cont', $
        c_value : [0.9*data_avg, 0.6*data_avg], $
        c_color : ['red','red'], $
        c_thick : 1.0, $
        name : 'umbra and penumbra boundaries' }


    continuum = { $
        channel : 'mag', $
        c_value : [-300, 300], $
        c_color : ['black', 'white'], $
        ;c_value : [-1000, -300, 300, 1000]
        ;c_value : [ -reverse(c_value), c_value ]
        ;c_thick : [1.0, 2.0, 2.0, 1.0]
        ;c_color : ['black', 'black', 'white', 'white']
        rgb_table : 0, $ ; black --> white
        ;title : 'B$_{LOS} \pm 300$'
        name : 'B$_{LOS} \pm 300$' }

    ;- Return structures to main level, and then create graphic in a different routine?
    ;- Might make more sense to combine get_contour_data with the code above making
    ;- the structures (or using the 'if' statements). I dunno.


    for ii = 0, nn-1 do begin
        ;contourr[ii] = CONTOUR( $
        contourr[ii] = CONTOUR2( $
            c_data, $
            overplot=target, $
            c_value=c_value, $
            c_thick=1.0, $
            c_color=c_color, $
            c_linestyle='-', $
            c_label_show=0, $
            title = title, $
            name = name )
    endfor

    return, contourr
end


;----------------------------------------------------------------------------------
;- ML stuff... ??:

;- hmi line through middle of two sunspots (pos/neg)
;p = plot2( hmi[*,175,0] )

;file = 'HMI_BLOS_contours.pdf'
;save2, file
;c.delete
;----------------------------------------------------------------------------------

;-  READ ME!!!!!!!!!!
;- In current form, image_powermaps.pro needs to be run BEFORE contours.
;- dz and time are both defined there, and objarr "im" is returned to ML.
;- Then contours.pro (current file) overlays contours on existing image.
;-  (This is not ideal, but no time to make better subroutines right now.)

;- Name of FILE must match name of subroutine called from command line
;-  (otherwise things get messy real quick),
;- so if there are more than one routines above, need to be very explicit
;- about which one is called by usuer.


;- 1. Make image(s)
;- IDL> .run image_powermaps
;-  generate image object 'im'

;- 2. Get contour data
c_data = GET_CONTOUR_DATA( time[zz+(dz/2)], channel='mag' )
;- NOTE: get_hmi.pro uses time to get closest hmi date_obs,
;-        so the correct HMI is being used (at least I hope so...)
;- Also have the option of retrieving c_data a different way, e.g., if
;-   H is array of prepped hmi data, can just use one of those images.
;-
;- Technically should average HMI contour data over dz (whatever that is for HMI).
;- Except obviously not straightup MEAN since B_LOS would result in 0 (or close).
;- Use absolute values, or standard deviation.

;- 3. Overplot contours on image generated in step 1.
c = CONTOURS( c_data, target=im, channel='mag' )

end
