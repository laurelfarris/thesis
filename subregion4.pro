
goto, start

;; Image first power map for 1700

dz = 64 ; just in case
time = strmid(A[ii].time,0,8)

xc = 75
yc = 115
r = 100

ii = 1

dat = CROP_DATA( A[ii].data, dimensions=[r,r], center = [xc,yc] )
map = CROP_DATA( A[ii].map, dimensions=[r,r], center = [xc,yc] )
sz = size(dat, /dimensions)
n_pixels = float(sz[0]) * sz[1]

dw
;win = window( dimensions=[8.5,11.0]*dpi, /buffer)
win = window( /buffer)

;result = AIA_INTSCALE(temp,wave=1700,exptime=A[ii].exptime)
im_dat = dat[*,*,0]
im_map = map[*,*,0]
im = image2( $
    aia_intscale(im_dat, wave=1700, exptime=A[ii].exptime), $  ;<2500, $
    /current, layout=[1,2,1], margin=0.1, rgb_table=A[ii].ct )
im = image2( $
    aia_intscale(im_map, wave=1700, exptime=A[ii].exptime), $  ;<2500, $
    /current, layout=[1,2,2], margin=0.1, rgb_table=A[ii].ct )
save2, 'bp_map.pdf';, /add_timestamp
c = contour( $
    im_dat, $
    color='white', c_thick=2, /overplot )
c = contour( $
    im_map, $
    color='white', c_thick=1, /overplot )

stop

;; Plot LC for subregion
start:

dw
win = window( dimensions=[8.5,8.0]*dpi, /buffer)
;p = plot2( bp_flux[0,*], /current, name='flux $\ge 1\sigma$'

flux = total(total(dat,1),1)
flux = flux / n_pixels

lc = plot2( [0:748], flux, /current, layout=[1,3,1], $
    name = 'DN s$^{-1}$', $
    title = 'AIA 1700$\AA$ Localized power enhancement')

power1 = GET_POWER_FROM_FLUX(flux=flux, cadence=24, dz=dz, fmin=0.005, fmax=0.006, data=data )
p1 = plot2( [32:748-32], power1, /current, layout=[1,3,2], $
    name = 'power (total flux)' )

power2 = total(total(map,1),1)
p2 = plot2( [32:748-32], power2, /current, layout=[1,3,3], $
    name = 'power (total maps)' )

save2, 'bp_plots.pdf';, /add_timestamp
stop


;; 2xN array = TOTAL flux from "bright point" above 1 and 2 \sigma

bp_flux = fltarr(2, sz[2])

for i = 0, sz[2]-1 do begin

    temp = data[*,*,i]
    meann = (MOMENT(temp))[0]
    stdev = sqrt( (MOMENT(temp))[1] )

    data1 = temp > (meann + 1.0*stdev)
    data2 = temp > (meann + 2.0*stdev)

    bp_flux[0,i] = total( total( data1, 1), 1)
    bp_flux[1,i] = total( total( data2, 1), 1)

endfor

meann = (moment(im_dat))[0]
stdev = sqrt( (MOMENT(im_dat))[1] )
sigma1 = meann + stdev
sigma2 = meann + stdev*2.

c = contour( $
    im_dat, $
    ;c_value = [meann, sigma1, sigma2], $
    color='white', $
    ;c_color='', $
    ;c_linestyle=[1,2,3], $
    c_thick=2, $
    ;/c_label_show, $
    /overplot )

stop


;; plot same frequency range as WA plots for BDA


end
