;-
;- LAST MODIFIED:
;-   Thu Jan 24 15:35:04 MST 2019
;-     Added "ind" keyword to set z-indices if only subset is desired.
;-
;- PURPOSE:
;-   Read HMI headers and restore .sav files (data)
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] edit to call separate routines to
;-   calculate interpolation indices (missing_obs.pro), and
;-   apply interpolation to arrays USING interp indices (linear_interp.pro)
;-

function STRUC_HMI, index, cube, $
    cadence=cadence, instr=instr, channel=channel, $
    ind=ind



    ;- Parameters specific to individual flare
    @parameters


    ; Read headers
    if n_elements(index) eq 0 then begin
        resolve_routine, 'read_my_fits'
        READ_MY_FITS, index, $
            instr=instr, $
            channel=channel, $
            nodata=1, $
            ;ind=ind, $
            prepped=1
    endif

    print, 'Reading header for level ', $
        strtrim(index[0].lvl_num,1), ' data.'




    ; Restore data
    ; "../hmi_mag.sav"  --> variable "cube", dimensions [750,500,400]
    ; "../hmi_cont.sav" --> variable "cube", dimensions [750,500,398]
;    restore, '/solarstorm/laurel07/hmi_' + channel + '.sav'
;    restore, '/solarstorm/laurel07/' + instr + '_' + channel + '.sav'


    path = '/solarstorm/laurel07/' + year + month + day + '/'
    restore, path + strlowcase(instr) + '_' + channel + '.sav'


    ; Interpolate to get missing data and corresponding timestamp,
    ;   then crop data to pixel dimensions [500,330,*].
    ; Can't skip this (e.g. "if n_elements(cube eq 0) then...") because
    ; the same code that crops and interpolates cube also generates
    ;   variables 'time' and 'jd', which are needed for structure

    time = strmid(index.date_obs,11,11)
    jd = GET_JD( index.date_obs + 'Z' )

    resolve_routine, 'linear_interp', /either
    LINEAR_INTERP, cube, jd, cadence, time
    cube = crop_data(cube)
    ;cube = fix( round( cube ) )

    sz = size( cube, /dimensions )

    ; X/Y coordinates of AR (lower left corner),
    ;    converted from pixels to arcseconds
    ; NOTE: Hard coded coords;
    ;   can't automatically generate these values unless I somehow
    ;    save them when aligning or prepping the data.
    x1 = 2150
    y1 = 1485
    X = ( (indgen(sz[0]) + x1) - index[0].crpix1 ) * index[0].cdelt1
    Y = ( (indgen(sz[1]) + y1) - index[0].crpix2 ) * index[0].cdelt2


    ;- Test to make sure crpix and crdelt are the same for all files.
    ;- test_arr = Nx4 array, where N = number of data points
    ;-   (N shouldn't change...)
    ;test_arr = []
    ;test_arr = [ [test], [index.crpix1 - shift(index.crpix1, 1)] ]
    ;test_arr = index.crpix2 - shift(index.crpix2, 1)
    ;test_arr = index.cdelt1 - shift(index.cdelt1, 1)
    ;test_arr = index.cdelt2 - shift(index.cdelt2, 1)
    ;test_ind =  where( test_arr ne 0.0 )
    ;if test_ind ne -1 then begin
    ;   print, "Inconsistency in cdelt and/or crpix header keywords."
    ;   stop
    ;endif


    ;- Total flux summed over AR
    flux = total( total( cube, 1), 1 )

    ct = 0
    if channel eq 'mag' then name = 'HMI B$_{LOS}$'
    if channel eq 'cont' then name = 'HMI intensity'

    struc = { $
        data: cube, $
        X: X, $
        Y: Y, $
        flux: flux, $
        time: time, $
        jd: jd, $
        cadence: cadence, $
        color: '', $
        ct: ct, $
        channel: channel, $
        name: name $
    }
    return, struc
end
