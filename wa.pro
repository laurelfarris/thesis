; Last modified:   14 July 2018

; This is an example of a repetitive subroutine, needs a general routine..
; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change

; Wavelet Analysis (WA) - discrete

pro CALC_WA, flux, $
    frequency, wmap, $
    cadence=cadence, $
    z=z, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

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

pro IMAGE_WA, wmap;, X=X, Y=Y

    common defaults
    sz = size( wmap, /dimensions )

    dw
    wx = 8.5
    wy = 4.0
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    left = 0.75
    bottom = 0.5
    right = 1.75
    top = 0.5

    width = 6.0
    height = 3.0

    x1 = left
    y1 = bottom
    x2 = x1 + width
    y2 = y1 + height
    position = [ x1, y1, x2, y2 ] * dpi

    im = image2( $
        wmap, $;  X, Y, $
        ;/buffer, $
        ;layout=[1,1,1], $
        ;margin=0.1, $
        position=position, $
        /current, $
        /device, $
        ;xmajor=sz[0]-1, $
        ;ymajor=sz[1]-1, $
        aspect_ratio=0, $
        xtitle='Start time (2011-February-15)', $
        ytitle='Frequency (mHz)')
    v = plot( im.xrange, [5.6,5.6], /overplot, linestyle=2 )
    v = plot( im.xrange, [fmin,fmin], /overplot, linestyle=4 )
    v = plot( im.xrange, [fmax,fmax], /overplot, linestyle=4 )
    c = colorbar2( /device, position=[x2+0.1,y1,x2+0.3,y2]*dpi, title='Log Power')
end


; AIA 1600
flux = A[0].flux

; length of time segment (#images) over which to calculate FT
dz = 64

; starting indices/time for each FT (length = # resulting maps)
z_start = [ 0 : n_elements(flux)-dz-1 : dz ]
fmin = 0.001
fmax = 0.009

CALC_WA, flux, frequency, wmap, cadence=24, z=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0
;wmap = fix(round(alog10(wmap)))
sz = size( wmap, /dimensions )
D1 = sz[0] * 100
D2 = sz[1] * 100

IMAGE_WA, congrid(wmap, D1, D2);, X=z_start, Y=frequency*1000

save2, 'wa2.pdf'

end
