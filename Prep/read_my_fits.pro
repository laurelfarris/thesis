;-
;- LAST MODIFIED:
;-
;- 05 May 2020
;-   Commented conditional testing STRING data type, since STRTRIM converts
;-    arg to string anyway.
;-
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
;-   [] Better way to pad channels with leading zeros
;-   [] See code for other tasks marked with "[]"
;-   [] From Todoist :
;-       "Improve process of reading data/headers w/ read_sdo (aka read_my_fits)"
;-         - option to have multi-flares and/or multi-*inst* (HMI, ...) active at the same time,
;-           but only total flux (undefine variables containing 3D data cubes).
;-
;- User sets z_ind as kw, or better yet, input start/end times, or just a dt if
;- exact times aren't as important as total duration
;-

pro READ_MY_FITS, index, data, fls, $
    flare=flare, $ ;- Added to replace values obtained from @parameters (11 June 2021)
    instr=instr, $
    channel=channel, $
    ind=ind, $
    nodata=nodata, $
    prepped=prepped, $
    syntax=syntax


    if keyword_set(syntax) then begin
        print, ""
        print, "READ_MY_FITS, index, data, fls,"
        print, "  instr=instr,"
        print, "  channel=channel,"
        print, "  ind=ind,"
        print, "  nodata=nodata, "
        print, "  prepped=prepped,"
            ;"year=year, month=month, day=day", $
        print, "  syntax=syntax"
        print, ""
        print, "NOTE: prepped=0 by default."
        print, ""
        return
    endif


    ;@parameters


    start_time = systime()

    ;- Make sure channel is variable stype 'string'
    ;if not ( typename(channel) eq 'STRING' ) then begin
        ;print, 'Illegal typename for channel.'
        channel = strtrim(channel,1)
            ;- [] try using this line without testing input type.
            ;-     If channel already in string form, this command
            ;-     will probably have no effect. More efficient?
            ;-     Does running line every time take longer than using
            ;-     if statement to check TYPENAME?
            ;-     Probably not significant either way...
            ;-   04 April 2020
            ;-
    ;endif
    ;-  05 May 2020 -- just now commented the if statement.
    ;-   Should be fine, but make a note in today.pro so I'm aware of recent
    ;-   changes to what has otherwise been a module called and left alone.

    ;- Is the above statement converting channel to string necessary?
    ;-   Or does STRTRIM function take care of this?
    instr = strtrim(instr, 1)
    channel = strtrim(channel, 1)


;    year = strtrim(year, 1)
;    month = strtrim(month, 1)
;    day = strtrim(day, 1)
    year = flare.year
    month = flare.month
    day = flare.day

    ;- Set up variables

    print, '--------------------------------------------'
    ;case instr of
    case 1 of

    ;- IRIS
;    ( strlowcase(instr) eq 'iris' ): begin
;        end ;- end of IRIS -------------------------------------------


    ;'aia': begin
    ;(instr eq 'aia') OR (instr eq 'AIA'): begin
    strupcase(instr) eq 'AIA': begin
        if keyword_set(prepped) then begin
            print, 'NOTE: Reading PREPPED data from AIA.'
            ;path = '/solarstorm/laurel07/Data/AIA_prepped/'
            path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'

            ;- Prepped fits files pad channel with leading zeros.
            if strlen(channel) eq 3 then channel = '0' + channel
            if strlen(channel) eq 2 then channel = '00' + channel

            ;files = 'AIA20110215_*_'  +  channel  +  '*.fits'

            ;files = 'AIA' + year + month + day '_' + '125918' + '_' + channel + '.fits'
            ;files = 'AIA' + year + month + day + '_*_' + channel + '.fits'
            files = strupcase(instr) + year + month + day + '_*_' + channel + '.fits'

                ;-   '*' to read data at all obs times from specified date.

        endif else begin
            print, 'NOTE: Reading UNPREPPED data from AIA.'
            ;path = '/solarstorm/laurel07/Data/AIA/'
            path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '/'
            ;files = '*aia*' + channel + '*2011-02-15*.fits'
            files = $
                strlowcase(instr) + '.lev1.' + channel + 'A_' + $
                year + '-' + month + '-' + day + $
                'T' + '*Z.image_lev1.fits'
        endelse
        end ;- end of AIA



    ;'hmi': begin
    ;(instr eq 'hmi') OR (instr eq 'HMI'): begin
    strupcase(instr) eq 'HMI': begin

        if keyword_set(prepped) then begin
            print, 'NOTE: Reading PREPPED data from HMI.'
            ;path = '/solarstorm/laurel07/Data/HMI_prepped/'
            ;path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
            path = '/home/astrobackup3/preupgradebackups/solarstorm/laurel07/Data/'+ strupcase(instr) + '_prepped/'

            files = strupcase(instr) + year + month + day + '_*_' + channel + '.fits'

        endif else begin
            print, 'NOTE: Reading UNPREPPED data from HMI.'
            ;path = '/solarstorm/laurel07/Data/HMI/'
            path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '/'

            ;- HMI fits filenames (various channels) -- only changes are:
            ;-   • 'hmi.ic' --> 'hmi.m'
            ;-   • 'TAI.continuum.fits' --> 'TAI.magnetogram.fits'
            ;- See E-note "SDO/HMI"

            ;- Continuum/Intensity
            if channel eq 'cont' then $
                files = $
                    'hmi.ic_45s.' $
                    + year + '.' + month + '.' + day + '*' + $
                    'TAI.continuum.fits'

            ;- LOS magnetogram
            if channel eq 'mag' then $
                files = $
                    'hmi.m_45s.' $
                    + year + '.' + month + '.' + day + '*' + $
                    'TAI.magnetogram.fits'
        endelse
        end ;- end of HMI

    end ;- end of "case" statements

    if not file_test( path + files ) then begin
        print, '==========================================='
        print, 'FILES NOT FOUND! (check path ...)'
        stop
    endif

    ;- Confirm files with user.

    fls = file_search( path + files )

    if N_elements(ind) ne 0 then fls = fls[ind]
    print, '------------------------------------'
    print, n_elements(ind)
    print, '------------------------------------'

    print, ''
    print, n_elements(fls), ' file(s) returned, in variable "fls".'
    print, ''
    ;print, 'Type .c to read files, or RETALL to return to main level.'
    ;stop


    ;- Read fits files
    READ_SDO, fls, index, data, nodata=nodata

    ;-
    ;- 12 May 2020
    ;-   Do fits files remain open after running read_sdo?
    ;-   If so, how do I close them?
    ;-

    print, ''
    print, 'start time = ', start_time
    print, 'end time   = ', systime()
    print, ''

    return

end
