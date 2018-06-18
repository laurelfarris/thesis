; Last modified:   13 June 2018


pro SAVE_DATA_CUBES, channel


    ; 2018-06-13
    ; Crop data cubes and save to .sav file.
    ; Intentionally made saved data cubes larger than AR because
    ;  they haven't been aligned yet.


    read_my_fits, 'aia', channel, index, data, /prepped, nodata=0

    x0 = 2410
    y0 = 1660
    xl = 750
    yl = 500

    ; make sure center coords are correct
    im = image2( crop_data(data[*,*,sz[2]/2], center=[x0,y0]))
    stop

    data = crop_data( data, center=[x0,y0], dimensions=[xl,yl] )
    save, data, filename='aia' + channel + 'data.sav'


end

SAVE_DATA_CUBES, '1600'
;SAVE_DATA_CUBES, '1700'

end
