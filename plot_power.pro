; Last modified:   05 June 2018

; Always give input in frequencies (Hz), e.g. vert = 1./[180,300]

pro compare_power_spectra
    ; power from total flux vs. power summed over power map
    ; test using corner of AIA 1700 (non-flaring)
    ; Plotting P(\nu)
    crop = 10
    testdata = A[1].data[ 0:crop-1, 0:crop-1, * ]
    testz = [0:600]

    ; power from total flux
    testflux = total( total( testdata,1 ), 1 )
    testpower1 = []

    foreach z, testz, i do begin
        result = fourier2( testflux[z:z+dz-1], 24, /NORM )
        power = reform( result[1,*] )
        testpower1 = [ testpower1, MEAN( power[ind] ) ]
    endforeach

    ; power from sum of power map
    testmap = power_maps( testdata, z=testz, dz=64, cadence=24 )
    testpower2 = total( total( testmap,1 ), 1 )

    testx = indgen(601)
    p = plot2( testx, testpower1, color='blue' )
    p = plot2( testx, testpower2, /overplot, color='red' )
end


pro compare_power_time
    ; May 15, 2018
    ; /NORM vs. no norm
    ; Plotting P(t)

    ; This gives power 749 elements, but will only have values for 749 - 64.
    ; The rest will = 0.0
    ;power = fltarr(n_elements(A[0].flux))
    ;aia1600 = create_struct( aia1600, 'power', power )
    ;aia1700 = create_struct( aia1700, 'power', power )
    ;A = [ aia1600, aia1700 ]

    y1 = A[0].flux
    y2 = A[0].flux_norm
    struc = { $
        xdata : A[0].time, $
        ydata : [ [y1], [y1], [y2], [y2] ], $
        norm : [0,1,0,1], $
        title : [ $
            'flux; NORM=0', $
            'flux, NORM=1', $
            'flux_norm; NORM=0', $
            'flux_norm, NORM=1'] }

    ; Calculate possible frequencies for dz.
    frequency = (reform( fourier2( $
        indgen(dz), A[0].cadence, NORM=NORM )))[0,*]
    ind = where( frequency ge f_min AND frequency le f_max )

    ; Calculate power for time series between each value of z and z+dz
    dz = 64
    f_min = 0.005
    f_max = 0.006

    ; ydata
    power_total = fltarr( 4, n_elements(A[0].flux) )
    z_start = [0 : n_elements(power_total)-dz]

    ; Should have subroutine that does this...
    for j = 0, 3 do begin
        foreach z, z_start, i do begin
            input = struc.ydata[*,j]
            result = fourier2( input[z:z+dz-1], NORM=struc.norm[i], 24 )
            frequency = reform(result[0,*])

            ; MEAN power over frequency[ind] (freq. bandpass)
            ind = where( frequency ge 0.005 AND frequency le 0.006 )
            power = reform( result[1,*] )
            power_total[j,i] = MEAN( power[ind] )
        endforeach
    endfor
    p = objarr(4)
    for i = 0, 3 do $
        p[i] = plot2( struc.xdata, power_total[i,*], title=struc.title[i])
end


pro total_power_two_ways
    ;; Last modified:   15 May 2018 20:36:15
    ; snippets of code from when I was testing plots of total
    ; power from total flux vs. total(powermaps),
    ; and plotting in same window as lightcurve.

    ; k is a counter used to access the various arrays
    for k = 0, n_elements(p)-1 do begin  ;***

        ; shift power to plot as function of CENTRAL time
        ; power calculated from total(maps)
        if k eq 2 then begin
            p0 = A[0].power2 * good_pix
            p1 = A[1].power2 * good_pix
            p_tot_map = [ [p0], [p1] ]
            ydata = shift(p_tot_map,  (dz/2) )
        endif

        ; power calculated from total(flux)
        if k eq 1 then begin
            ydata = shift(A.power,  (dz/2) )
            bottom = 0.0
        endif

        if k ge 1 then begin
            top = 0.0
            ytitle = 'power (normalized)'
            ; Trim zeros from edges of power.
            ; --> ONly need to do this for full light curve!
            ydata = ydata[32:716, *]
            xdata = [32:716]

            ; Only cover desired time
            ;ydata = ydata[i1:i2,*]

            ; normalize
            y0 = ydata[*,0]
            y0 = y0 - min(y0)
            y0 = y0/max(y0)
            y1 = ydata[*,1]
            y1 = y1 - min(y1)
            y1 = y1/max(y1)
            ydata = [ [y0], [y1] ]
        endif

        ; This requires k to start at 0, otherwise xdata is not defined.
        ; Lightcurves
        if k eq 0 then begin
            bottom = 0.0
            xdata = [i1:i2]
            ydata = A.flux_norm
            ytitle = 'counts (normalized)'
        endif
    endfor ;***
end

function plot_vertical_lines

    ; Vertical lines at periods of interest
    v = objarr(n_elements(period))
    for i = 0, n_elements(v)-1 do $
        v[i] = plot_vline( $
            1./period[i], $
            p.yrange, $
            color='grey' $
            ;name=strtrim( fix(1./vert[i]),1) + ' sec' $
            )
    ;leg = legend2(target = v, position = [0.9,0.8])
    leg = legend2( target=p,  position = [0.9,0.8])
    return, p
end

function plot_ft, frequency, power, $
    period=period, $
    _EXTRA=e

    common defaults

    w = window(dimensions=[8.5,3.0]*dpi)

    p = plot2(  $
        frequency, $
        power, $
        /current, $
        xtitle = 'frequency (Hz)', $
        ytitle='Power', $
        _EXTRA=e )

    ;if keyword_set(period) then begin
    ;    ax = p.axes
    ;    ;values = ax[0].tickvalues
    ;    ax[2].tickvalues = 1./period
    ;    ;ax[2].tickname = strtrim( fix(1./values), 1 )
    ;    ax[2].tickname = strtrim( reverse(period[sort(period)]), 1 )
    ;    ax[2].title = 'period (s)'
    ;    ax[2].showtext = 1
    ;endif
end

pro CALC_FT, flux, cadence, frequency, power, df=df, _EXTRA=e
; band could be range of frequencies to show on x-axis for power spectrum,
; or narrow bandwidth to average over, centered at freq. of interest.

    ;; Calculate FT here, as called by most of these subroutines.
    result = fourier2( flux, 24, norm=1 )
    frequency = reform(result[0,*])
    power = reform(result[1,*])

    if n_elements(df) ne 0 then begin
        ind = where(frequency ge df[0] AND frequency le df[1])
        frequency = frequency[ind]
        power = power[ind]
    endif
end

function POWER_VS_TIME, flux, cadence, df, dz, z_start=z_start, _EXTRA=e
; Input:    flux, cadence
;           dz = sample length for fourier2.pro (data units)
;           frequency bandwidth: band=[fmin,fmax]
; Output:   Returns power as function of time for integrated flux.
; To do:    Add test codes

    n = n_elements(flux)

    if n_elements(z) eq 0 then z = indgen(n-dz)

    ; Calculate possible frequencies for dz.
    frequency = reform( (fourier2( indgen(dz), cadence ))[0,*] )
    bandpass = where( frequency ge df[0] AND frequency le df[1] )

    ; Power at each timestep, from integrated flux
    power_time = fltarr(n)

    ; Calculate power for time series between each value of z and z+dz
    ;for i = 0, n-1-dz do begin
    foreach z, z_start do begin
        result = fourier2( flux[z:z+dz-1], cadence, NORM=1, _EXTRA=e )
        power = reform(result[1,*])
        ; MEAN power over frequency bandpass
        power_time[i] = MEAN( power[bandpass] )
    endforeach
    return, power_time
end

goto, start

; Structure of user-input values. Mostly just examples.
; Bandwidth is either xrange for power spectra, or frequency bandwidth
;  for calculating total (mean) power to represent "3-min power".
; Probably only use one or the other, never both.
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

dz = 64
df = [0.005,0.006]
flux = A[i].flux
power = POWER_VS_TIME( flux, cadence, df, dz )
help, power

; plot power vs. time

;aia1600 = create_struct( aia1600, 'power', power )
;aia1700 = create_struct( aia1700, 'power', power )

end
