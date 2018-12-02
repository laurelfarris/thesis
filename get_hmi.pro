
;- 20 November 2018


;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011


function GET_HMI, time, channel=channel

    ;- Get contour data from HMI B_LOS ('mag') or HMI continuum ('cont').
    ;- input desired date_obs (hh:mm). Either single time or array, e.g.
    ;-    c_data = GET_HMI( time[zz+(dz/2)], channel='mag' )

    ;- TO DO:
    ;- --> write to only run once;
    ;- make a structure or something to keep at main level.
    ;- Or not... this doesn't take that long to run.


    instr = 'hmi'

    READ_MY_FITS, index, instr=instr, channel=channel, $
        nodata=1, prepped=1

    hmi_time = strmid( index.date_obs, 11, 5 )
    ind = (where( hmi_time eq time ))[0]

    ;- Returns "cube" [750, 500, 398], already centered on AR
    restore, '../hmi_' + channel + '.sav'

    ; Crop data to 500x330 (default dimensions in crop_data.pro)
    hmi = CROP_DATA( cube, offset=[-15,0] )
    c_data = hmi[*,*,ind]

    return, c_data
end
