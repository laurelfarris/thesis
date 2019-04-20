;-
;- LAST MODIFIED:
;-   Wed Mar  6 13:19:46 MST 2019
;-     -- added kw "files" to specify filenames for subset of AIA data (new flare)
;-
;- PURPOSE:
;-   Read headers and (optionally) data from fits files.
;-   Uncomment the path/files you want.
;-   NOTE: call sequence very similar to READ_SDO routine from sswidl.
;-
;- ARGUMENTS:
;-   index, data, fls  (all are OUTPUT)
;-
;- KEYWORDS:
;-   instr, channel
;-     HMI: instr='hmi', channel = 'dop', 'cont', 'mag'
;-     AIA: instr='aia', channel = '1600', '1700', '304'
;-   ind -- array of indices if don't want to read all files.
;-   nodata -- set to read headers only
;-   prepped -- set to READ fits files processed to level 1.5 with aia_prep.pro
;-    files=files
;-
;- OUTPUT:
;-   index (and data, if nodata=0), just like READ_SDO
;-
;- TO DO:
;-   [] Instead of setting "ind" kw, add option to set start/end times.
;-        User is more likely to know what time range to read around flare peak,
;-         though may use "ind" to get just the first hour of data... I dunno.
;-   [] Option to read UNprepped data from HMI
;-

pro READ_MY_FITS, index, data, fls, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=nodata, $
    prepped=prepped, $
    year=year, $
    month=month, $
    day=day


    ; Convert channel to string if not already.
    if not ( typename(channel) eq 'STRING' ) then begin
        ;print, 'Illegal typename for channel.'
        channel = strtrim(channel,1)
    endif

    ;- Is the above statement converting channel to string necessary?
    ;-   Or does STRTRIM function take care of this?
    instr = strtrim(instr, 1)
    channel = strtrim(channel, 1)
    year = strtrim(year, 1)
    month = strtrim(month, 1)
    day = strtrim(day, 1)

    ; 28 June 2017
    ; Want prepped=1 by default, now that I've aligned all prepped data.
    ;if not keyword_set(prepped) then prepped = 1


    ;- Set up variables

    print, '--------------------------------------------'
    case instr of

    'aia': begin
        if keyword_set(prepped) then begin
            print, 'NOTE: Reading PREPPED data from AIA.'
            path = '/solarstorm/laurel07/Data/AIA_prepped/'

            ;files = 'AIA20110215_*_'  +  channel  +  '*.fits'

            ;files = 'AIA' + year + month + day '_' + '125918' + '_' + channel + '.fits'
            files = 'AIA' + year + month + day + '_*_' + channel + '.fits'

                ;-   '*' to read data at all obs times from specified date.

        endif else begin
            print, 'NOTE: Reading UNPREPPED data from AIA.'
            path = '/solarstorm/laurel07/Data/AIA/'
            ;files = '*aia*' + channel + '*2011-02-15*.fits'
            files = $
                instr + '.lev1.' + channel + 'A_' + $
                year + '-' + month + '-' + day + $
                'T' + '*Z.image_lev1.fits'
        endelse
        end ;- end of 'aia' instr



    'hmi': begin
        if keyword_set(prepped) then begin
            print, 'NOTE: Reading PREPPED data from HMI.'
            path = '/solarstorm/laurel07/Data/HMI_prepped/'

        endif else begin
            print, 'NOTE: Reading UNPREPPED data from HMI.'
            ;print, '(currently no option to read unprepped HMI data...'
            path = '/solarstorm/laurel07/Data/HMI/'

            ;files = '*_45s*' + channel + '*.fits'
            ;files = '*_' + channel + '*.fits'

            files = $
                'hmi.m_45s.' + year + '.' + month + '.' + day + '*' + $
                'TAI.magnetogram.fits'
              ;- NOTE: This is specific to magnetograms! Needs to be generalized.


        endelse
        end
    end ;- end of "case" statements



    ;- Confirm files with user.

    fls = file_search( path + files )
    if N_elements(ind) ne 0 then fls = fls[ind]

    print, n_elements(fls), ' file(s) returned, in variable "fls".'
    print, 'Type .c to read files, or RETALL to return to main level.'
    stop


    ;- Read fits files
    READ_SDO, fls, index, data, nodata=nodata
    return

end
