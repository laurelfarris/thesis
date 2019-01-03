;+
;- LAST MODIFIED:
;-   Thu Dec 20 08:02:20 MST 2018
;-   Original code is kind of old (pre-dates plot2.pro);
;-     rewrote a few things, but not sure if this is useful or not.
;- ROUTINE:
;-   plot_hmi_nonflaring.pro
;- PURPOSE:
;-   Apply FT to pixel(s) in sunspot umbra, penumbra, and quiet sun
;-    at phot and chrom.
;-

pro PLOT_HMI_NONFLARING, x, y

    props = { $
        font_style : 1, $
        xtitle : "Frequency", $
        ytitle : "Power" $
        }

    sz = size( y, /dimensions)
    plt = objarr(sz[1])
    for ii = 0, n_elements(plt)-1 do begin
        plt[ii] = plot2( $
            x, y[ii,*], $
            /current, $
            overplot = ii<1, $
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
