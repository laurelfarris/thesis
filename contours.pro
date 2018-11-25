
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

function CONTOURS, c_data, contourr, target=target, channel=channel

    ;c_data = get_hmi(time, channel=channel)

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
        title = 'B$_{LOS} \pm 300$'

    endif

    for ii = 0, nn-1 do begin
        contourr[ii] = CONTOUR( $
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

    ;- ML stuff:

    ;- hmi line through middle of two sunspots (pos/neg)
    ;p = plot2( hmi[*,175,0] )

    ;file = 'HMI_BLOS_contours.pdf'
    ;save2, file
    ;c.delete
end
