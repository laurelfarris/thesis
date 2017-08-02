;; Last modified:   20 July 2017 15:33:52

goto, START


;; Headers
@main.pro
fls = file_search(hmi_path + "*hmi*.fits")
fls = fls[22:*]
read_sdo, fls, index, data, /nodata

;; find coordinates of images during flare
times = strmid(index.date_obs, 11, 5)
t1 = (where( times eq '01:20' ))[0]
t2 = (where( times eq '03:10' ))[-1]
STOP

restore, 'hmi_aligned.sav'


;; Interpolate, using z-coordinates of missing images (minus first 22)
interp_coords = [215, 246, 277, 324] - 22
cube2 = linear_interp( cube, [interp_coords] )
    ; --> Add "fake" headers for missing data!
    ; interp coords are after flare end



;; Crop image
cube_all = cube2[200:650, 200:500, *]
cube_during = cube_all[*,*,t1:t2]


; Fourier analysis

sz = size(cube_all, /dimensions)

flux_all = []
for i = 0, sz[2]-1 do begin
    flux_all = [flux_all, total(cube_all[*,*,i]) ]
endfor
flux_during = []
for i = t1, t2  do begin
    flux_during = [flux_during, total(cube_all[*,*,i]) ]
endfor


;; Data: cube_all, cube_during, flux_all, flux_during

delt = 45

ps_all = FA_2D( cube_all, delt )
ps_during = FA_2D( cube_during, delt )


START:;-------------------------------------------------------------------------------------------
w = window( dimensions=[0.9*451, 0.9*3.*301]) 
im = image( cube_all[*,*,0], layout=[1,3,1], margin=0.05, /current )
im1 = image( ps_all, layout=[1,3,2], margin=0.05 , /current )
im2 = image( ps_during, layout=[1,3,3], margin=0.05, /current )
; add text! (a), (b), (c)
save_figs, "hmi_images"

STOP


;; Plots


dw
resolve_routine, 'plot_power_spectrum', /either
plot_power_spectrum, flux_during, delt
plot_power_spectrum, flux_all, delt

STOP


;; Wavelet analysis

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

; Tick labels
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
