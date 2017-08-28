;; Last modified:   25 August 2017 12:47:51

; Wavelet analysis


pro WAVELET_ANALYSIS, flux, period, delt,    fr, ps

    N = n_elements(flux)

    binsize = 30.*period/delt

    ps = [] ;power spectrum
    fr = [] ;frequency

    for i = 0, N-binsize do begin
        result = fourier2( flux[i:i+binsize-1], delt, /norm  )
        fr = [ fr, result[0,*] ]
        ps = [ ps, result[1,*] ]
    endfor

    return

    fr = result[0,*]     ;[Hz]
    T_sec = (1./fr)      ;[seconds]
    T_min = (1./fr)/60.  ;[minutes]


    ;; Tick labels
    X = (45.*(indgen((i/binsize)+1)*binsize))/60.
    Y = string( reform(T_min) )
    Y = [Y, ""]


end

goto, START
START:

;; Run subroutine above to get binned ps image, and reform frequency (fr) to a 1D array
WAVELET_ANALYSIS, hmi_flux, 180., hmi_cad,    fr, hmi_ps
fr = reform(fr[0,*])

;; Cut out really high power (due to global flare shape)
;st = 10  ; "st" = "start"
;hmi_ps = hmi_ps[*,st:*]
;fr = fr[st:*]

loc = where( fr ge (1./(5.5*60)) )
fr = fr[loc]
per = (1./fr)/60.
wa_data = hmi_ps[ *, loc]

;; Set X and Y data coordinates for image
sz = size( wa_data, /dimensions )
x = indgen(sz[0]) * (45./60.)
y = per


;; Get tick mark names for y-axis (period "per")
n_major = 5
increment = n_elements(fr)/n_major
my_tick_values = []
for i=0, n-1 do $
    my_tick_values = [my_tick_values, fr[i*increment]]


wx = 2.9*sz[0]
wy = 6.*sz[1]
w = window( dimensions=[wx,wy] )

;im = image( alog10(hmi_ps), $
im = image( wa_data, $
    x, y, $
    layout=[1,1,1], margin=0.1, /current, $
    axis_style=2, $
    ;ytickvalues=my_tick_values, $
    ymajor=n_major, $
    yminor=5, $
    ytickname=string( (1./my_tick_values)/60., format='(F4.1)'), $
    font_size=fontsize, font_name=fontname, $
    xmajor=10, $
    xtitle="time since UT 2011-02-15T00:00:27.30 [minutes]", $
    ytitle="period [min]" $
    )

;save_figs, "wa_hmi_zoom"

end
