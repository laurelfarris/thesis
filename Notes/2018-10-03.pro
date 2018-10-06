
goto, start

;- 03 October 2018


;- Crop all data in z-dir to beginning up through start of main flare

t_start = '00:00'
t_end = '01:44'

;- AIA

dz = 260
z = indgen(dz)
aia1600 = A[0].data[*,*,z]
aia1700 = A[1].data[*,*,z]

;- HMI

dz2 = 139
z2 = indgen(dz2)

offset = [0,0]

restore, '../hmi_cont.sav'
hmi_cont = crop_data( cube[*,*,z2], offset=offset )

restore, '../hmi_mag.sav'
hmi_mag = crop_data( cube[*,*,z2], offset=offset )

data = fltarr(500, 330, 4)
data[*,*,0] = hmi_cont[*,*,0] 
data[*,*,1] = hmi_mag[*,*,0]
data[*,*,2] = aia_intscale( aia1700[*,*,-1], wave=1700, exptime=A[1].exptime )
data[*,*,3] = aia_intscale( aia1600[*,*,0], wave=1600, exptime=A[0].exptime )

;- Crop down to one supspot
dimensions=[100,100]
center=[365,215]
offset = [-10,-2]

dw
win = window(/buffer)
im = image2( $
    crop_data(data[*,*,2], center=center, dimensions=dimensions), $
    /current, layout=[1,1,1], margin=0.1, rgb_table=A[1].ct )

plus = symbol( 55, 50, 'plus', /data, sym_color='white', sym_size=1 )
plus = symbol( 75, 50, 'plus', /data, sym_color='white', sym_size=1 )

save2, 'test_symbol.pdf'
stop


data1 = crop_data( data[*,*,0:1], center=center, dimensions=dimensions, offset=offset ) 
data2 = crop_data( data[*,*,2:3], center=center, dimensions=dimensions ) 
im_data = [ [[data1]], [[data2]] ]

start:;------------------------------------------------------------------------------------------

;- FT plots
;- Same center coords for umbra, penumbra estimated ~20 pixels below

z = [0:259]
umbra = reform( A[1].data[370,215,z] )
penumbra = reform( A[1].data[390,215,z] )

result1 = fourier2( umbra, 24 )
result2 = fourier2( penumbra, 24 )

freq1 = result1[0,*] * 1000
freq2 = result2[0,*] * 1000
power1 = result1[1,*]
power2 = result2[1,*]

power1 = power1 - min(power1)
power1 = power1 / max(power1)
power2 = power2 - min(power2)
power2 = power2 / max(power2)

dw
win = window(/buffer)
p1 = plot( freq1, power1, /current, $
    xrange=[0.0,10.0], yrange=[0.0,1.0], $
    xtitle = 'frequency (mHz)', $
    ytitle = 'power (arbitrary)', $
    name='umbra', color='blue' )
p2 = plot( freq2, power2, /overplot, name='penumbra' )
leg = legend2(target=[p1,p2])
save2, 'test_ft_1600.pdf'

stop

;- Image each data set at 00:00

;wx = 8.5
wx = 6.0
;wy = wx * (330./500.)
wy = wx

contour_colors=['red', 'red', 'black', 'white']
contour_data = im_data[*,*,0]

;- from 2017-09-29 notes
;sz = (size(contour_data, /dimensions))[0]
;quiet_avg = mean(contour_data[sz-100:sz-1,0:99])
;c2 = quiet_avg * 0.6
;c1 = quiet_avg * 0.9

dw
win = window( dimensions=[wx,wy]*dpi, /buffer )
im = objarr(4)
for ii = 0, n_elements(im)-1 do begin

    im[ii] = image2( $
        im_data[*,*,ii], $
        /current, $
        layout=[2,2,ii+1], $
        margin=0.1 )

    c = contour( $
        contour_data, $
        n_levels=2, $
        ;c_value = [c1,c2], $ ;; Ignores n_levels
        c_thick = [0.5,0.5], $
        c_color=['red','red'], $
        ;c_color=[contour_colors[ii],contour_colors[ii]], $
        c_label_show=0, $
        /overplot )

endfor
;im[3].rgb_table = A[0].ct
;im[2].rgb_table = A[1].ct

;save2, 'HMI_continuum.pdf'
save2, 'four_images.pdf'
stop

aia1600 = crop_data( A[0].data[*,*,z], dimensions=dimensions, center=center )
aia1700 = crop_data( A[1].data[*,*,z], dimensions=dimensions, center=center )
hmi_cont = crop_data( cube[*,*,z2], dimensions=dimensions, center=center+offset )
hmi_mag = crop_data( cube[*,*,z2], dimensions=dimensions, center=center+offset )

restore, '../hmi_cont.sav'
cube = crop_data(cube)
data[*,*,2] = cube[*,*,0]
restore, '../hmi_mag.sav'
cube = crop_data(cube)
data[*,*,3] = cube[*,*,0]

image_data = crop_data( $
    data, $
    dimensions=dimensions, $
    center=center )

save2, 'four_images_subregion.pdf'

stop


wx = 8.5/2
wy = wx
win = window( dimensions=[wx,wy]*dpi, /buffer )
im = image2( $
    image_data, /current, $
    margin=0.1, $
    rgb_table=A[0].ct )
save2, 'test_image.pdf'

; pre-flare data (up to but not including C-flare)
data = crop_data( A[0].data[*,*,0:125], dimensions=dimensions, center=center )

fmin = 0.005
fmax = 0.006

result = fourier2(z, 24)
frequency = result[0,*]

ind = where( frequency ge fmin AND frequency le fmax ) 

stop

journal, '2018-10-01.pro'
; What happens if journal is edited directly before closing?

;CD, 'Prep/'
;.run prep
;CD, '../'

;Result = GET_SCREEN_SIZE( [Display_name] [, RESOLUTION=variable] )

N = 330.*500.
flux = A[0].flux/N
;result = fourier2(


print, ''
print, 'Type .CONTINUE to close journal.'
stop
journal


;- Power spectra:
;-   Don't have to show full range of frequencies from Milligan2017.
;-

;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: running average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-

stop


end
