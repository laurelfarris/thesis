;; Last modified:   10 April 2018

; Read headers
; Channel in STRING form (e.g. '1600')

; 13 May 2018
;   Need a way to input which files to read
;   E.g. only want first one for the purpose of displaying a full disk
;   image, but otherwise want to read in everything.
;   Can't do, e.g. i=0 because keyword_set condition would be false.
; Also, this doesn't actually return the data if it's just set as
;  a kw when called (data=1). Needs work, but not top priority right now.


pro read_my_fits, index, data, $
    hmi=hmi, aia=aia, channel=channel, sub=sub, $
    _EXTRA=e

    if keyword_set(hmi) then begin
        path = '/solarstorm/laurel07/Data/HMI/'
        files = '*45s*magnetogram*.fits'
        files = '*45s*magnetogram*.fits'
        files = '*45s*magnetogram*.fits'
        files = '*45s*magnetogram*.fits'
    endif

    if keyword_set(aia) then begin
        ;path = '/solarstorm/laurel07/Data/AIA/'
        ;files = '*aia*' + channel + '*2011-02-15*.fits'
        path = '/solarstorm/laurel07/Data/AIA_prepped/'
        files = 'AIA20110215_*_' + channel + '*.fits'
    endif


    fls = (file_search(path + files))
    if keyword_set(sub) then begin
        i1 = sub[0]
        i2 = sub[1]
        fls = fls[i1:i2]
    endif

    READ_SDO, fls, index, data, _EXTRA=e

end
