
;- 20 November 2018

;- "saturates at +/- 1500 Mx cm^{-1}" -Schrijver2011

function get_hmi, time, channel=channel

    ;- HMI B_LOS or continuum

    instr = 'hmi'

    READ_MY_FITS, index, instr=instr, channel=channel, $
        nodata=1, prepped=1, ind
    hmi_time = strmid( index.date_obs, 11, 5 )
    ind = (where( hmi_time eq time ))[0]

    ;- Returns "cube" [750, 500, 398]
    restore, '../hmi_' + channel + '.sav'

    hmi = crop_data( cube, offset=[-15,0] ) ; default dimensions = [500,330]
    c_data = hmi[*,*,ind]

    return, c_data
end

pro CONTOURS, contourr, time=time, target=target, channel=channel

    c_data = get_hmi(time, channel=channel)

    nn = n_elements(time)
    contourr = objarr(nn)

    if channel eq 'cont' then begin
        data_avg = mean(c_data[350:450,50:150])

        ;- Outer edges of [penumbra, umbra]
        c_value = [0.9*data_avg, 0.6*data_avg]

        c_color = ['red','red']
        c_thick = 1.0
        name = 'umbra and penumbra boundaries'
    endif
    if channel eq 'mag' then begin

        c_value = [-300, 300]
        c_color = ['black', 'white']
        c_thick = 0.5
        ;c_value = [-1000, -300, 300, 1000]
        ;c_value = [ -reverse(c_value), c_value ]

        ;c_thick = [1.0, 2.0, 2.0, 1.0]
        ;c_color = ['black', 'black', 'white', 'white']
        name = 'B$_{LOS} \pm 300$'

    endif

    for ii = 0, nn-1 do begin
        contourr[ii] = CONTOUR( $
            c_data, $
            overplot=target, $
            c_value=c_value, $
            ;c_thick=c_thick, $
            c_color=c_color, $
            c_linestyle='-', $
            c_label_show=0, $
            name = name )
    endfor

;- hmi line through middle of two sunspots (pos/neg)
;p = plot2( hmi[*,175,0] )


;file = 'HMI_BLOS_contours.pdf'
;save2, file
;c.delete
end
