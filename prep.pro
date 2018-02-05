;; Last modified:   02 February 2018 12:49:18

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

pro DURING, index, data, $
    time=time, jd=jd, cube=cube


    ; Flare start/end times
    f1 = '01:30'
    f2 = '02:30'

    ;; Obs time in form 'hh:mm'; flare start/end & lightcurve labels
    time = strmid( index.t_obs, 11, 5 )

    ; Indices of flare start/stop
    t1 = ( where( time eq f1 ) )[ 0]
    t2 = ( where( time eq f2 ) )[-1]

    ; Crop data array in z (time)
    jd = jd[t1:t2]
    cube = data[*,*,t1:t2]

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
    fls = file_search(path + files)

    if keyword_set(data) then nodata=0 else nodata=1
    print, "nodata = ", nodata

    READ_SDO, fls, index, data, nodata=nodata

end



GOTO, START

read_my_fits, '1600', index=a6index ;, data=a6data
read_my_fits, '1700', index=a7index ;, data=a7data

START:
a6data = restore_data('1600', a6index)
a7data = restore_data('1700', a7index)


getJD, a6index, a6jd
getJD, a7index, a7jd

linear_interp, header=a7index, array=a7data, jd=a7jd, cadence=24

STOP

; Set whichever keywords need to be cropped
DURING, a6index, a6data, time=a6time, jd=a6jd, cube=a6
DURING, a7index, a7data, time=a7time, jd=a7jd, cube=a7






end
