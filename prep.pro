;; Last modified:   05 February 2018 15:29:56

;+
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
;-




function restore_data, channel, index
    ; Restore data in variable called 'cube'
    savedfiles = '../Sav_files/aia_' + channel + '_aligned.sav'
    restore, savedfiles
    ; Crop data array in x & y
    ;arcsec = 200. ; length of side in arcseconds
    ;resolution = index[0].cdelt1  ; arcsecnds per pixel
    ;r = (arcsec/resolution)/2
    ;x = 365 & y = 440  ;center coordinates
    ;return, cube[ x-r:x+r-1, y-r:y+r-1, * ]
    x1 = 115 
    x2 = 615
    y1 = 245
    y2 = 575
    return, cube[ x1:x2-1, y1:y2-1, *]
end

pro getJD, index, jd
    ; Use observation time from header to get individual time values
    timestamptovalues, index.t_obs, $
        day=day, $
        hour=hour, $
        minute=minute, $
        month=month, $
        offset=offset, $
        second=second, $
        year=year
    ; Covert observations times to JD
    jd = julday(month, day, year, hour, minute, second)
end

pro read_my_fits, channel, index=index, data=data
    ; Read headers
    path = '/solarstorm/laurel07/Data/AIA/'
    files = '*aia*' + channel + '*.fits'
    fls = (file_search(path + files))
    if arg_present(data) then nodata=0 else nodata=1
    READ_SDO, fls, index, data, nodata=nodata
end


function align_data, data

    r = 500

    ; Center coordinates of AR
    xc = 2400
    yc = 1650
    cube = data[ xc-r:xc+r-1, yc-r:yc+r-1, * ]

    ; Center coordinates of quiet region
    xc = 2000
    yc = 2400
    quiet = data[ xc-r:xc+r-1, yc-r:yc+r-1, * ]

    sdv = []
    print, "Start:  ", systime()
    repeat begin
        align_cube3, quiet, cube, shifts
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()

    print, sdv

    xstepper, cube, xsize=512, ysize=512

    return, cube

end

GOTO, START
; Read headers (and data, if desired) from fits files.
read_my_fits, '1600', index=a6index, data=a6data
read_my_fits, '1700', index=a7index, data=a7data

; Align data
a6 = align_data( a6data )
a7 = align_data( a7data )

a6data = restore_data('1600', a6index)
a7data = restore_data('1700', a7index)

START:
read_my_fits, '1700', index=a7index, data=a7data
getJD, a6index, a6jd
getJD, a7index, a7jd

linear_interp, header=a7index, array=a7data, jd=a7jd, cadence=24



end
