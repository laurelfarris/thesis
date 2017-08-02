;; Last modified:   20 July 2017 19:28:21

; Wavelet analysis

binsize = 20  ;[images] = increment in for loop
N = n_elements(flux)
ps = [] ;power spectrum
for i = 0, N-1, binsize do begin
    result = fourier2( flux[i:i+binsize-1], delt, /norm  )
    ps = [ ps, result[1,*] ]
endfor

fr = result[0,*]     ;[Hz]
T_sec = (1./fr)      ;[seconds]
T_min = (1./fr)/60.  ;[minutes]
STOP


;; Tick labels
X = (45.*(indgen((i/binsize)+1)*binsize))/60.
Y = string( reform(T_min) )
Y = [Y, ""]

@graphic_configs
im = image( ps, $
    location=[800,0], dimensions=[700,500], $
    layout=[1,1,1], margin=0.1, $
    ;xtickformat='(F4.1)', $
    ;ytickformat='(F4.1)', $
    ;xtickname=string(X), $
    ;ytickname=Y, $
    xtitle="minutes since midnight, 15 Feb 2011", $
    ytitle="period [minutes]", $
    _EXTRA=image_props )


STOP

end
