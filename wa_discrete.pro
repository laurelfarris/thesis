;; Last modified:   20 April 2018 04:23:39

; Wavelet Analysis (WA) - discrete

function WA_DISCRETE, $
    data, $
    cadence=cadence, $
    z=z, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax

    frequency = reform( (fourier2( indgen(dz), cadence ))[0,*] )

    n = n_elements(z)
    m = n_elements(frequency)
    wmap = fltarr( n, m )

    for i = 0, n-1 do begin

        flux = data[ z[i] : z[i]+dz-1 ]

        power = reform( (fourier2( flux, cadence ))[1,*] )
        wmap[i,*] = power

    endfor


    return, wmap

end


; This is probably a great example of a repetitive subroutine,
; that could really use a general routine..
; Seems like something that could be called by power_maps
; in the intermost part of the for loop.

; Also, same values for z, dz, etc. are used for several routines.
; Define those somewhere other than each individual file.


goto, start

start:;--------------------------------------------------------------------

; # images (length of time) over which to calculate each FT.
dz = 64

; starting indices/time for each FT (length = # resulting maps)
z = [0:680:5]

aia1600wmap = wmaps( A[0].flux, z=z, dz=dz )
aia1700wmap = wmaps( A[1].flux, z=z, dz=dz )

aia1600 = create_struct( aia1600, 'WA', wmap )
aia1700 = create_struct( aia1700, 'WA', wmap )

A = [aia1600,aia1700]
stop

ct = color_tables()

dpi = 96
wx = 8.5
wy = wx/2
w = window( dimensions=[wx,wy]*dpi )

im = image2( A[0].WA, $
    /current, $
    /device, $
    position=[1.0, 0.5, 7.0, 3.5]*dpi, $
    ;layout=[1,1,1], $
    ;margin=[1.00,0.50,0.75,0.5]*dpi, $
    xtitle='Central time (2011-February-15)', $
    ytitle='Frequency (Hz)', $
    rgb_table=ct $
)


c = colorbar()

end
