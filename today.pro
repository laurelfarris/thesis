
; Created:        13 August 2018
; Last modified:  14 August 2018


; Investigating periodicity in power vs. time


    ; maybe all plotting routines should have two or three subroutines
    ; within the same file (create window, create panel, put curves
    ; on each panel, etc.). Not general across all plots, but will
    ; make each one easier to make, and easier to make different variations
    ; (plot every relationship you can think of! Also, remember that
    ; 'today.pro' is kind of a log, so comment away, and copy useful code to
    ; different file for cleanup and to remove babble.
; 

function MAKE_WINDOW, _EXTRA=e

    common defaults

    wx = 11.0
    ;wx = 1800.0/dpi
    wy = 8.0

    count = n_elements(GetWindows())

    win = window( $
        dimensions=[wx,wy]*dpi, $
        location=[500,0], $
        name="Name", $
        ;window_title="Window_title", $
        ;title="Test flare data", $
        buffer=0, $
        _EXTRA=e )

    print, win.name
    return, win
end


function PLOT_TEST_DATA, xdata, ydata, time, _EXTRA=e

    common defaults

    dims = ( GetWindows(/current) ).dimensions
    dims = dims/dpi

    left = 0.75
    bottom = 2.5
    right = 0.75
    top = 2.5

    width = dims[0] - (right+left)
    height = dims[1] - (top+bottom); - 4

    position = [left, bottom, left+width, bottom+height] * dpi

    xticklen = ( width^0.3)/100.
    yticklen = (height^0.3)/100.

    ;for i = 0, n_elements(time)-1 do $
    ;    result = timestamp( day=1, hour=0,  minute=0,  month=1,  second=0, year=2000 )

    filename = "fake_data_3-min_power"
    p = plot2( $
        xdata, ydata, $
        /current, $
        /device, $
        position=position, $
        thick=0, $
        ;xmajor=13, $
        xminor=3, $
        yminor=3, $
        xtickinterval=50, $
        xtitle='index', $
        xticklen=xticklen, $
        yticklen=yticklen, $
        xshowtext=1, $
        ;symbol='.', $
        sym_size=4.0, $
        _EXTRA=e )

    ax = p.axes

    tickvalues = round(ax[0].tickvalues)
    ax[0].tickname = strtrim( round(time[tickvalues]/60.), 1 )
    ax[0].title = '# minutes'

    return, p
end


pro TEST_DATA, lc1, time, ind=ind

    ; Save file returns variables 'time' and 'lc1'
    if (n_elements(lc1) eq 0) OR (n_elements(time) eq 0) then $
        restore, '../test_data.sav'
    N = n_elements(lc1)

    if not keyword_set(ind) then ind = [0:N-1]

    filename = "fake_data_lightcurve"
    dw
    win = MAKE_WINDOW( name=filename, location=[500,0] )

    ; Setting, e.g. time=time[ind] will return cropped string back
    ; to main level and cause all kinds of problems... create new
    ; variables if want to do this.

    ;xdata = time[ind]
    xdata = ind
    ydata = normalize(lc1[ind])

    p = PLOT_TEST_DATA( $
        xdata, ydata, time, $
        name = 'flux' )

end


pro TEST_DATA_POWER, lc1, time, ind=ind

    cadence = time[1]-time[0]
    ;dz = [ 64, 100, 200, 500 ]
    dz =  64
    fmin = 0.005
    fmax = 0.006

    N = n_elements(lc1)
    if not keyword_set(ind) then ind = [0:N-1]
    flux = lc1[ind]

    N = n_elements(flux)
    power = fltarr(N-dz)  ; initialize power array

    ; Calculate power for time series between each value of z and z+dz
    resolve_routine, 'calc_ft', /either
    for i = 0, N-dz-1 do begin
        struc = CALC_FT( $
            flux[i:i+dz-1], cadence, fmin=fmin, fmax=fmax )
        power[i] = struc.mean_power
    endfor

    xrange = [ ind[0], ind[-1] ]

    i1 = ind[0] + dz/2
    i2 = ind[-1] - (dz/2)
    ;new_ind = [i1:i2]

    filename = "fake_data_3-min_power"
    ydata = normalize(power)

    ;win = MAKE_WINDOW( name=filename, location=[500,450])
    p = PLOT_TEST_DATA( $
        [i1:i2], ydata, time, $
        overplot=1, $
        ;symbol='.', $
        color='red', $
        name='3-minute power' )
    return
end

goto, start


; Hard to organize these lines, need to look at LC before knowing what
; value to give ind, but then need to feed ind back into TEST_DATA,...
; maybe plot separately
; Or run TEST_data twice, first without setting ind.

TEST_DATA, lc1, time

START:;--------------------------------------------------------------------
;ind = [200:450]
TEST_DATA, lc1, time;, ind=ind
TEST_DATA_POWER, lc1, time;, ind=ind



arr1 = wa_average( lc1, power, dz=64 )
N = n_elements(lc1)
arr2 = mean(arr, dimension=2)
ind2 = [ dz-1 : N-dz ]
arr3 = arr2[ind2]

ydata = normalize(arr3)

p = PLOT_TEST_DATA( $
    ind2, ydata, time, $
    overplot=1, $
    ;symbol='.', $
    color='dodger blue', $
    name='3-minute power, averaged' )



leg = legend2( position=[ 0.85,0.80 ], /relative )


filename = 'test_data_averaged'
save2, filename+'.pdf', /add_timestamp

end
