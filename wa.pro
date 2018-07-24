; Last modified:   14 July 2018

; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change?

; Wavelet Analysis (WA) - discrete

pro CALC_WA, flux, $
    frequency, wmap, $
    cadence=cadence, $
    z=z, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

    ; Input:  flux
    ; Output: wmap (2D) and frequency (1D)

    ; Find available frequencies within bandpass
    result = fourier2( indgen(dz), cadence, norm=norm )
    frequency = reform( result[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]

    n = n_elements(z)
    m = n_elements(frequency)
    wmap = fltarr(n,m)
    step = 1

    for i = 0, n-1, step do begin
        result = fourier2( flux[ z[i] : z[i]+dz-1 ], cadence, norm=norm )
        power = (reform( result[1,*] ))[ind]
        wmap[i,*] = power
    endfor
end

function IMAGE_WA, wmap, $
    X=X, Y=Y, $
    _EXTRA=e

    ;; To Do:
    ;; use congrid here and create correct tick labels,
    ;;  option to create colorbar, lines marking freq of interest,
    ;;  aspect_ratio = 0.
    ;; Create window OUTSIDE this routine.

    common defaults
    sz = size( wmap, /dimensions )

    position=POS(layout=[0,0], width=6.0)

    im = image2( $
        wmap, $
        X, Y, $
        /current, $
        /device, $
        position=position, $
        rgb_table=34, $
        aspect_ratio=0, $
        _EXTRA=e )

    pos = im.position
    cx1 = pos[2] + 0.01
    cy1 = pos[1]
    cx2 = cx1 + 0.02
    cy2 = pos[3]
    c = colorbar2( $
        target=im, $
        ;/device, $
        position=[cx1,cy1,cx2,cy2], title='Log Power' )
    return, im
end

wx = 8.5
wy = 8.0

dz = 64  ; length of time segment (#images) over which to calculate FT
flower = 0.005
fcenter = 1./180
fupper = 0.006

; 24 July 2018
; increasing fmax to range shown by Milligan et al. 2017 (fmin is fine).
fmin = 0.001
;fmax = 0.009
fmax = 0.020

N = n_elements(A[0].flux) - dz

; starting indices/time for each FT (length = # resulting maps)
z_start = [ 0 : N-1 : dz ]

aia_wa_maps[*,*,ii] = fltarr(500,330,N)
for ii = 0, 1 do begin
    CALC_WA, A[ii].flux, $
        frequency_out, wmap_out, $
        cadence=A[ii].cadence, z=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0
    aia_wa_maps[*,*,ii] = wmap_out
endfor
min_value = min(aia_wa_maps)
max_value = max(aia_wa_maps)

dw
win = window( dimensions=[wx,wy]*dpi, buffer=0 )
for ii = 0, 1 do begin

    wmap = aia_wa_maps[*,*,ii]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    X = (findgen(D1)/100)*dz

    inc = (max(frequency) - min(frequency)) / (D2-1)
    Y = [ min(frequency) : max(frequency) : inc ]
    Y = Y * 1000

    im = IMAGE_WA( wmap2, $
        X=X, Y=Y, $
        min_value=min_value, $
        max_value=max_value, $
        ytickvalues=1000.*frequency_out, $  ; maybe not all frequencies
        ;ymajor=7, $
        ytickformat='(F0.2)', $
        title=A[ii].name, $
        ;xtitle='Start time (2011-February-15)', $
        xtitle='image #', $
        ytitle='Frequency (mHz)' )

    ; 24 July 2018 - changing x-axis to show time
    xtickname = strmid(A[ii].time,0,5)
    ax = im.axes
    xtickvalues = ax[0].tickvalues
    ax[0].tickname = xtickname[xtickvalues]
    ax[0].title = 'Start time (UT) on 2011-February-15'

    f1 = flower * 1000
    f2 = fcenter * 1000
    f3 = fupper * 1000

    resolve_routine, 'plot_lines', /either, /compile_full_file
    h = PLOT_HORIZONTAL_LINES( $
        im.xrange, [f1,f2,f3], $
        names=[ '$\nu_{lower}$', '$\nu_{center}$', '$\nu_{upper}$' ] )

    v = PLOT_FLARE_TIMES( A[ii].time, im.yrange )

    ;v = objarr(3)
    ;v[0] = plot( im.xrange, [f1,f1], /overplot, linestyle=':',  name='$\nu_{lower}$'  )
    ;v[1] = plot( im.xrange, [f2,f2], /overplot, linestyle='--', name='$\nu_{center}$' )
    ;v[2] = plot( im.xrange, [f3,f3], /overplot, linestyle=':',  name='$\nu_{upper}$'  )

    ;save2, 'wa' + A[ii].channel + '.pdf'
endfor

; May need to shorten window (wy) until this all fits nicely.
leg = legend2( $
    target=[v,h], $
    /device, $
    horizontal_alignment = 'Right', $  ; pretty sure this is the default...
    vertical_alignment = 'Bottom', $ ; default = top?
    position=[wx,0]*dpi )

save2, 'wa_plots.pdf'

end
