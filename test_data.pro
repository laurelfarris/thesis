
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

; Setting, e.g. time=time[ind] will return cropped string back
; to main level and cause all kinds of problems... create new
; variables if want to do this.


function MAKE_WINDOW, _EXTRA=e

    common defaults

    wx = 11.0
    wy = 8.0

    win = window( $
        Name='Test Data', $
        ;window_title="Window_title", $
        ;title="Test flare data", $
        dimensions=[wx,wy]*dpi, $
        ;location=[500,0], $
        buffer=1, $
        _EXTRA=e )
    return, win
end


function PLOT_TEST_DATA, xdata, ydata, time, _EXTRA=e

    common defaults

    dims = ( GetWindows(/current) ).dimensions
    dims = dims/dpi

    left = 0.75
    bottom = 1.5
    right = 0.75
    top = 1.5

    width = dims[0] - (right+left)
    height = dims[1] - (top+bottom); - 4

    position = [left, bottom, left+width, bottom+height] * dpi

    xticklen = ( width^0.3)/100.
    yticklen = (height^0.3)/100.

    p = plot2( $
        xdata, ydata, $
        /current, $
        /device, $
        position=position, $
        thick=0, $
        ;xmajor=13, $
        xminor=4, $
        yminor=3, $
        xtickinterval=10, $
        xtitle='index', $
        xticklen=xticklen, $
        yticklen=yticklen, $
        xshowtext=1, $
        symbol='.', $
        sym_size=4.0, $
        _EXTRA=e )

    ax = p.axes

    tickvalues = round(ax[0].tickvalues)
    ax[0].tickname = strtrim( round(time[tickvalues]/60.), 1 )
    ax[0].title = '# minutes'

    return, p
end

pro TEST_POWER_AVERAGED, lc1, time, power, arr, ind=ind

    N = n_elements(lc1)
    if not keyword_set(ind) then ind = [0:N-1]

    dz = 64
    arr = WA_AVERAGE( lc1, power, dz=dz )

end


pro TEST_POWER, lc1, time, power, dz=dz, ind=ind

    cadence = time[1]-time[0]
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

    return
end

;win = MAKE_WINDOW()
win.erase

; Save file returns variables 'time' and 'lc1'
if (n_elements(lc1) eq 0) OR (n_elements(time) eq 0) then $
    restore, '../test_data.sav'
N = n_elements(lc1)

;ind = [150:450]
ind = [0:N-1]

;xdata = time[ind]
xdata = ind
ydata = normalize(lc1[ind])


;xrange=[190,270]
xrange=[270,400]

p = objarr(3)
p[0] = PLOT_TEST_DATA( xdata, ydata, time, xrange=xrange, $
    name = 'flux' )

;dz = [ 64, 100, 200, 500 ]
dz = 64

; Calculate 3-minute power
TEST_POWER, lc1, time, power, dz=dz, ind=ind

i1 = ind[0] + dz/2
i2 = ind[-1] - (dz/2)
ydata = normalize(power)

p[1] = PLOT_TEST_DATA( $
    [i1:i2], ydata, time, $
    overplot=1, $
    ;symbol='.', $
    color='red', $
    name='3-minute power' )


; Average power for each timestep
TEST_POWER_AVERAGED, lc1, time, power, arr, ind=ind

i1 = ind[0] + dz
i2 = ind[-1] - (dz)
;ind2 = [ dz-1 : N-dz ]
ydata = normalize(arr)

p[2] = PLOT_TEST_DATA( $
    [i1:i2], ydata, time, $
    overplot=1, $
    ;symbol='.', $
    color='dodger blue', $
    name='3-minute power, averaged' )


;; Legend

lx = 0.40
;lx = 0.95
ly = 0.90
leg = legend2( position=[lx,ly], /relative )

filename = 'test_data_averaged'
save2, filename+'.pdf', /add_timestamp

end
