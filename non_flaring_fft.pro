;; Last modified:   29 January 2018 17:31:40

;+
; ROUTINE:      fourier_test.pro
;
; PURPOSE:      Test FFT codes by running on phot and chrom in sunspot umbra,
;                   penumbra, and quiet sun.
;
; USEAGE:
;
; INPUT:        N/A
;
; KEYWORDs:     N/A
;
; OUTPUT:       N/A
;
; TO DO:
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:
;-


pro NON_FLARING_FFT, x, y

    props = { $
        font_name : "Times", $
        font_size : 12, $
        font_style : 1, $
        xtitle : "Frequency", $
        ytitle : "Power" $
        }

    sz = size( y, /dimensions)
    p = objarr(sz[1])
    for i = 0, sz[1]-1 do begin
        p[i] = plot( x, y[i,*], /current, /overplot, $
            _EXTRA=props $
            )
    endfor

end


; Data cube
;  As example - pretend I've got a 100x100 data cube centered on a sunspot.
cube = hmi[1000:1099,1000:1099,*]

; Coordinates for each location
umbra = [50, 50]
penumbra = [60, 60]
quiet_sun = [90, 90]

; Cadence for HMI
delt = 45.0

umbra_result   = FOURIER2( cube[ umbra[0], umbra[1], * ], delt )
penumbra_result   = FOURIER2( cube[ penumbra[0], penumbra[1], * ], delt )
quiet_sun_result = FOURIER2( cube[ quiet_sun[0], quiet_sun[1], * ], delt )



; Plot 3 curves from ~2 minutes to ~8 minutes, or whatever range looks best.
; Bigger time series --> better looking curve (I think).

arr = [ $
    umbra_result[1,*], $
    penumbra_result[1,*], $
    quiet_sun_result[1,*] $
    ]

NON_FLARING_FFT, umbra_result[0,*], arr

end
