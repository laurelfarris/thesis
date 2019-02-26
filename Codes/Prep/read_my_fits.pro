; Last modified:   29 May 2018


; Read headers and (optionally) data from fits files.
; Uncomment the path/files you want.
; Set 'ind' to array of indices if don't want to read all files.
; Set nodata kw to read headers only


; For HMI, instr='hmi', channel = 'dop', 'cont', or 'mag'
; For AIA, instr='aia', channel = '1600' or '1700'



pro READ_MY_FITS, index, data, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=nodata, $
    prepped=prepped

    ; Assuming all files are properly prepped and aligned...

    ; Convert channel to string if not already.
    if not ( typename(channel) eq 'STRING' ) then begin
        ;print, 'Illegal typename for channel.'
        channel = strtrim(channel,1)
        endif

    ; 28 June 2017
    ; Want prepped=1 by default, now that I've aligned all prepped data.
    ;if not keyword_set(prepped) then prepped = 1

    case instr of

    'aia': begin
        if keyword_set(prepped) then begin
            path = '/solarstorm/laurel07/Data/AIA_prepped/'
            ;path = '/home/users/laurel07/Data/AIA_prepped/'
            files = 'AIA20110215_*_'  +  channel  +  '*.fits'
        endif else begin
            path = '/solarstorm/laurel07/Data/AIA/'
            files = '*aia*' + channel + '*2011-02-15*.fits'
        endelse
        end

    'hmi': begin
        ;path = '/solarstorm/laurel07/Data/HMI/'
        path = '/solarstorm/laurel07/Data/HMI_prepped/'
        ;files = '*_45s*' + channel + '*.fits'
        files = '*_' + channel + '*.fits'
        end
    end

    fls = file_search( path + files )
    if N_elements(ind) ne 0 then fls = fls[ind]
    READ_SDO, fls, index, data, nodata=nodata
    return
end