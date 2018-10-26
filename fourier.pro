;---------------------------------------------------------------------------------;
;-  18 October 2018
;-  Combined all codes that performed some kind of Fourier analysis calculation.
;---------------------------------------------------------------------------------;


;- File:  "calc_ft.pro"  -->  standalone subroutine


; TO-DO: issue with freq[1] - freq[0] = resolution if freq only has one value
;  20 July 2018 - moved line to calculate resolution BEFORE cropping frequency,
;    since spacing should be the same over the entire array (if not, something
;    was not calculated correctly).

; input: flux, cadence
; output: frequency, power
; kws: fmin and/or fmax if want only a certain range of frequencies returned

; 29 June 2018
; return structure with output from fourier2.pro, along with every
; quantity of interest I could think of.


function CALC_FT, $
    flux, $
    cadence, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm, $
    _EXTRA=e

    result = fourier2( flux, cadence, norm=norm )
    frequency = reform(result[0,*])
    power = reform(result[1,*])
    ;print, 'frequency resolution = ', strtrim(1000*resolution,1), ' mHz'
    resolution = frequency[1] - frequency[0]

    if not keyword_set(fmin) then fmin = frequency[ 0]
    if not keyword_set(fmax) then fmax = frequency[-1]

    ind = where(frequency ge fmin AND frequency le fmax)
    frequency = frequency[ind]
    power = power[ind]

    ;print, 'frequencies (mHz):'
    ;print, frequency*1000, format='(F0.2)'

    struc = { $
        frequency : frequency, $
        bandpass : [fmin,fmax], $
        bandwidth : fmax - fmin, $
        resolution : resolution, $
        power : power, $
        mean_power : mean(power) $
        }

    ;help, struc
    return, struc

    response = ''
    READ, response, prompt='Plot power spectrum? [y/n] '
    ;if response eq 'y' then begin
    ;endif
end

;---------------------------------------------------------------------------------;
pro FT
    ;- "ft.pro" appears to have been a stand-alone subroutine, with no ML code below.

    ; Last modified:   29 June 2018

    ; Structure of user-input values. Mostly just examples.
    ; Use short variable/tag names to just feed individual values into routines,
    ; E.G. plot, ft.flux, xrange=ft.xrange...
    FT = {$
        flux: A[0].flux, $
        norm: 1, $
        cadence: 24, $
        fcenter: 1./180, $
        fwidth: 1./(170) - 1./(190), $
        fmin: 0.004, $
        fmax: 0.006, $
        ;fmin: 1./50, $
        ;fmax: 1./400, $
        z_start: [0:200:5], $
        dz: 64, $
        time: ['01:30','02:30'], $
        periods: [120, 180, 200, 300] $
    }
    ; NOTE: regarding fwidth,
     ; period width not constant as frequency resolution,
     ; but this is based on specific central period, so others don't matter.

end
;---------------------------------------------------------------------------------
;- fourier_test.pro
;-

pro main_level_code

    ; Test all kinds of FT scenerios
    ;   dz
    ;   constant vs. changing signal
    ;   damping
    ;   normalizing

    ; Real data:
    ;   quiet vs. flaring region (subregion)
    ;   central frequency/period
    ;   bandpass


    ; 22 August 2018
    ; Test to see how variability in 3-minute power with time, P(t),
    ;   changes for different time segment lengths (dz)


    ; (dz*cadence)/180 = # cycles in dz = 8.53 for dz=64
    ; 1 full 3-min cycle --> dz = 7.5
    ; 2 cycles --> dz = 15.

    j = 1
    time = strmid(A[j].time,0,5)
    dz_values = [0:15:3] + 60
    cadence = 24

    ;f_center = 1./300
    f_center = 1./180
    bandwidth = 0.001
    fmin = f_center - (bandwidth/2)
    fmax = f_center + (bandwidth/2)
    ;fmin = 0.005
    ;fmax = 0.006

    colors = [ $
        ; 'black', $
        'blue', 'red', 'green', $
        'deep sky blue', 'dark orange', 'dark cyan', $
        'purple', 'saddle brown', 'deep pink' ]


    p = objarr(n_elements(dz_values))
    N = n_elements(A[j].flux)

    wx = 8.5
    wy = 11.0

    dw
    ;window_title = $
    ;    '3-minute power vs. time from integrated AR emission for various time segment lengths'
    ;win = WINDOW2( title=window_title, buffer=1, font_style='bold')
    win = WINDOW2( buffer=1, font_style='bold')

    height = 5.0

    x1 = 1.0
    x2 = wx - 1.0
    y2 = wy - 1.5
    y1 = y2 - height
    position = [x1,y1,x2,y2]

    foreach dz, dz_values, i do begin

        z_start = indgen(N-dz)
        power = fltarr(N-dz)

        foreach z, z_start, k do begin
            struc = CALC_FT( A[j].flux[z:z+dz-1], cadence, fmin=fmin, fmax=fmax )
            power[k] = struc.mean_power
        endforeach

        n_minutes = strtrim((dz*cadence)/60., 1)
        name = $
            'dz = ' + strtrim(dz,1) + $
              ' = ' + strmid( n_minutes, 0, 4) + ' minutes'

        ydata = NORMALIZE(power) + i
        xdata = [ 0 : n_elements(ydata)-1] $
            + round(dz/2.)

        ;xrange = [ 0, N-1 ]
        ;xrange = [225, 375]
        ;xmajor = 7

        xrange = [225, 350]
        xmajor = 6

        p[i] = plot2( $
            xdata, $
            ydata, $
            /current, $
            /device, $
            position = position*dpi, $
            overplot = i<1, $
            xmajor = xmajor, $
            ymajor = 0, $
            xrange = xrange, $
            xshowtext = 1, $
            ytitle = '3-minute power (normalized)', $
            symbol = '.', $
            sym_size = 4.0, $
            thick = 0.0, $
            color = colors[i], $
            name = name )
    endforeach

    ydata = NORMALIZE(A[j].flux) + i
    xdata = [ 0 : N-1 ]

    lc = plot2( $
        xdata, $
        ydata, $
        overplot=1, $
        xrange=xrange, $
        stairstep = 1, $
        thick = 0.0, $
        name = 'intensity (normalized)' )

    ax = p[0].axes
    ax[0].tickname = time[ ax[0].tickvalues ]
    ax[0].title = 'Start time (UT) on 15-Feb-2011 00:00'
    ax[2].title = 'Index (aka frame number)'
    ax[2].showtext = 1

    lx = position[0]
    ly = position[1] - 0.5
    leg = legend2( $
        target=[p,lc], $
        /device, $
        sample_width=0.10, $
        horizontal_alignment = 'Left', $
        vertical_alignment = 'Top', $ ; default?
        position = [lx,ly]*dpi )

    save2, 'fourier_test.pdf', /add_timestamp

end
;---------------------------------------------------------------------------------


pro fourier_time_segment, dz, desired_frequency

    ; (dz*cadence)/180 = # 3-minute (or whatever the desired frequency is)
    ;                      cycles in time segment

    cadence = 24
    period = 180
end
;---------------------------------------------------------------------------------


;; Last modified:   09 May 2018 10:00:03


;-  This one was ALL main level code.
;-  Wrapping it up in a (probably non-functioning) subroutine.

pro fourier_normalization

    ; Layout of code to check for correct normalization.

    flux = A[0].flux
    result = fourier2( flux, 24, NORM=0 )
    power = reform( result[1,*] )

    ; These should be equal... I think.
    print, n_elements( flux )/2
    print, n_elements( power )

    ; 11 May --- They are!

    ; Check on normalization:
    ; by Parseval's theorem, these should be the same because of
    ; conservation of energy.
    print, total( power )
    print, ( moment(flux) )[1]

    ; Only getting equal values if /norm kw is NOT set.
end
;---------------------------------------------------------------------------------
;---------------------------------------------------------------------------------
