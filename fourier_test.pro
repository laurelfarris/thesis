;; Last modified:   26 September 2017 01:47:28

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


pro fourier_test, x, y

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
umb = [50, 50]
pen = [60, 60]
quiet = [90, 90]

; Cadence for HMI
delt = 45.0

umb_result = fourier2( cube[ umb[0], umb[1], * ], delt )
pen_result = fourier2( cube[ pen[0], pen[1], * ], delt )
quiet_result = fourier2( cube[ quiet[0], quiet[1], * ], delt )



; Plot 3 curves from ~2 minutes to ~8 minutes, or whatever range looks best.
; Bigger time series --> better looking curve (I think).

arr = [ $
    umb_result[1,*], $
    pen_result[1,*], $
    quiet_result[1,*] $
    ]

fourier_test, umb_result[0,*], arr

end
