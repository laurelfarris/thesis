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

    ;; use congrid here and create correct tick labels,
    ;;  option to create colorbar, lines marking freq of interest,
    ;;  aspect_ratio = 0.  NO WINDOW CREATION!

    common defaults
    sz = size( wmap, /dimensions )

    im = image2( $
        wmap, $
        X, Y, $
        /current, $
        /device, $
        position=position, $
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

goto, start
START:
ii = 0  ; AIA 1600
;ii = 1  ; AIA 1700

;------------------
flux = A[ii].flux
dz = 64  ; length of time segment (#images) over which to calculate FT
z_start = [ 0 : n_elements(flux)-dz-1 : dz ] ; starting indices/time for each FT (length = # resulting maps)
fmin = 0.001
flower = 0.005
fcenter = 1./180
fupper = 0.006
fmax = 0.009

CALC_WA, flux, frequency, wmap, cadence=24, z=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0

sz = size( wmap, /dimensions )
D1 = sz[0] * 100
D2 = sz[1] * 100
wmap2 = alog10( congrid(wmap, D1, D2) )

stop
X = (findgen(D1)/100)*dz
;xtickname=strtrim( [0:n_elements(flux):64], 1 )

;resolution = frequency[1] - frequency[0]
inc = (max(frequency) - min(frequency)) / (D2-1)
Y = [ min(frequency) : max(frequency) : inc ]
Y = Y * 1000

dw
wx = 7.0
wy = 4.0
win = window( dimensions=[wx,wy]*dpi, /buffer )
position = POS(layout=[0,0], width=4.0)

im = IMAGE_WA( wmap2, $
    X=X, Y=Y, $
    position=position, $
    xmajor=12, $
    ymajor=7, $
    ytickformat='(F0.2)', $
    rgb_table=34, $
    title=A[ii].name, $
    ;xtitle='Start time (2011-February-15)', $
    xtitle='image #', $
    ytitle='Frequency (mHz)' )

f1 = flower * 1000
f2 = fcenter * 1000
f3 = fupper * 1000

v = objarr(3)
v[0] = plot( im.xrange, [f1,f1], /overplot, linestyle=':', name='$\nu_{lower}$')
v[1] = plot( im.xrange, [f2,f2], /overplot, linestyle='--', name='$\nu_{center}$' )
v[2] = plot( im.xrange, [f3,f3], /overplot, linestyle=':', name='$\nu_{upper}$' )

leg = legend2( target=[v], position=[0.95,0.5] )

save2, 'wa' + A[ii].channel + '.pdf'

end
