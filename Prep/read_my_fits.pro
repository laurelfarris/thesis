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
;-   index, data 
;-
;- KEYWORDS:
;-   Set 'prepped' to read data processed with aia_prep.pro
;-   Set 'ind' to array of indices if don't want to read all files.
;-   Set nodata kw to read headers only
;-   Set list_only to show filenames without reading fits files
;-
;- OUTPUT:
;-   index (and data, if nodata=0), just like READ_SDO
;-
;- TO DO (in descending order of priority):
;-   Need option to specify subset of AIA data, esp. if all in one directory.
;-    --> Added kw "files" to take care of this for now.
;-   Option to read UNprepped data from HMI
;-
;-




; For HMI, instr='hmi', channel = 'dop', 'cont', or 'mag'
; For AIA, instr='aia', channel = '1600' or '1700'



pro READ_MY_FITS, index, data, $
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=nodata, $
    prepped=prepped, $
    files=files



    ; Convert channel to string if not already.
    if not ( typename(channel) eq 'STRING' ) then begin
        ;print, 'Illegal typename for channel.'
        channel = strtrim(channel,1)
    endif

    ; 28 June 2017
    ; Want prepped=1 by default, now that I've aligned all prepped data.
    ;if not keyword_set(prepped) then prepped = 1


    ;- Set up variables


    print, '--------------------------------------------'
    case instr of

    'aia': begin
        if keyword_set(prepped) then begin
            print, 'NOTE: Reading PREPPED data.'
            path = '/solarstorm/laurel07/Data/AIA_prepped/'
            ;path = '/home/users/laurel07/Data/AIA_prepped/'

            ;- User inputs files as kw (for now)
            ;files = 'AIA20110215_*_'  +  channel  +  '*.fits'

        endif else begin
            print, 'NOTE: Reading UNPREPPED data.'
            path = '/solarstorm/laurel07/Data/AIA/'

            ;files = '*aia*' + channel + '*2011-02-15*.fits'

        endelse
        end

    'hmi': begin
        print, 'NOTE: Reading PREPPED data from HMI.'
        print, '(currently no option to read unprepped HMI data...'
        ;path = '/solarstorm/laurel07/Data/HMI/'
        path = '/solarstorm/laurel07/Data/HMI_prepped/'
        ;files = '*_45s*' + channel + '*.fits'
        files = '*_' + channel + '*.fits'
        end
    end



    ;- Confirm files with user.

    fls = file_search( path + files )
    if N_elements(ind) ne 0 then fls = fls[ind]

    print, n_elements(fls), ' file(s) returned.'
    print, 'Type .c to read files, or RETALL to return to main level.'
    stop


    ;- Read fits files
    READ_SDO, fls, index, data, nodata=nodata
    return

end
