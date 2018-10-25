
goto, start

;- 23 October 2018

;- eventually name this "image_powermaps"

;- get_image_data.pro reads appropriate fits file, but still need to crop data,
;- which means I need to know the center coordinates of the AR.
;-  ('IMAGE_AR_SUBROUTINE' actually does this...)
;- --> Update imaging_general.pro when finished with this.


; call routine to save single image in each channel in structure S
;resolve_routine, 'get_image_data', /either
;S = get_image_data()

;S.(2).data
test = S.(2).data<300>(-300)

S.(2).data = test

IMAGE_STRUCTURE, S


; Creating new set of powermaps now




; HMI contours for power maps of interest

z_start = [ 16, 58, 196, 216, 248, 280, 314, 386, 450, 525, 600, 658 ]
t_start = time[z_start]
t_mid = time[z_start+32]
nz = n_elements(z_start)

read_my_fits, index, data, instr='hmi', channel='mag', /nodata, prepped=1
hmi_time = strmid( index.date_obs, 11, 5 )
hmi_ind = intarr(nz)

for ii = 0, nz-1 do $
    hmi_ind[ii] = (where( hmi_time eq t_mid[ii]))[0]

print, hmi_ind

read_my_fits, index, data, instr='hmi', channel='mag', nodata=0, prepped=1, ind=hmi_ind

y0 = 1660
x0 = 2375

hmi = fltarr( 500, 330, nz )
for ii = 0, nz-1 do begin
    xshift = round(((hmi_ind[ii]*45.)/3600.)*14)
    hmi[*,*,ii] = crop_data( $
        data[*,*,ii], $
        center = [x0+xshift, y0] )
endfor
stop

bda = fltarr( 500, 330, nz, 2 )

restore, '../aia1600map_2.sav'
for ii = 0, nz-1 do bda[*,*,ii,0] = map[*,*, z_start[ii]]

restore, '../aia1700map_2.sav'
for ii = 0, nz-1 do bda[*,*,ii,1] = map[*,*, z_start[ii]]



restore, '../aia1600map_2.sav'
aia1600map = map
restore, '../aia1700map_2.sav'
aia1700map = map
stop

spike = A[0].data[244,120:140,270]
print, spike
stop


w = window(/buffer)
im = image2( A[0].data[235:255,80:195,270], /current, layout=[1,1,1], margin=0.1, rgb_table=A[0].ct)
save2, 'test.pdf'

stop

map = fltarr( 500, 330, 686, 2 )

threshold = 8000

aia1600mask = MASK( A[0].data, threshold/A[0].exptime, 64 )
aia1700mask = MASK( A[1].data, threshold/A[1].exptime, 64 )

map[*,*,*,0] = aia1600map*aia1600mask
map[*,*,*,1] = aia1700map*aia1700mask

dz = 64

dat = fltarr( 500, 330, nz, 2 )
for cc = 0, 1 do $
    for ii = 0, nz-1 do dat[*,*,ii,cc] = map[*,*,z_start[ii],cc]

;resolve_routine, 'colorbar2', /either
resolve_routine, 'get_position', /either

rows = 4
cols = 3

start:;------------------------------------------------------------------------------------------------
max_value = [50, 4500]

for cc = 0, 1 do begin

    dw
    wx = 8.5
    wy = 8.0
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    im = objarr(cols*rows)
    c = objarr(cols*rows)

    time = strmid(A[cc].time, 0, 5)

    image_data = dat[*,*,*,cc]>0.001

    for ii = 0, n_elements(im)-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            wy=wy, $
            width = 2.1, $
            height = width*(330./500), $
            xgap = 0.2, $
            ygap = 0.2, $
            left = 0.75, $
            top = 0.5, $
            bottom=0.5 )

        ti = time[z_start[ii]]
        tf = time[z_start[ii]+(dz-1)]
        title = alph[ii] + ' ' + A[cc].name + ' (' + ti + '-' + tf + ' UT)'

        im[ii] = image2( $
            image_data[*,*,ii], $
            ;(image_data[*,*,ii])^0.1, $
            ;alog10(image_data[*,*,ii]), $
            /current, $
            /device, $
            position=position*dpi, $
            rgb_table = A[cc].ct, $
            xshowtext = 0, $
            yshowtext = 0, $
            max_value = max_value[cc], $
            title = title, $
            _EXTRA=e )
        c[ii] = contour( $
            hmi[*,*,ii], $
            c_value = [ -1000, -300, 300, 1000 ], $
            color = 'yellow', $
            c_thick = 0, $
            c_label_show = 0, $
            overplot=im[ii] )
    endfor




    file = 'aia' + A[cc].channel + 'maps.pdf'
    save2, file
endfor

stop











dw
win = window(/buffer)
im = image2( aia1600mask[*,*,40], /current, $
    layout=[1,2,1], margin=0.1, $
    rgb_table=A[0].ct )
im = image2( aia1600mask[*,*,240], /current, $
    layout=[1,2,2], margin=0.1, $
    rgb_table=A[0].ct )

file = 'test.pdf'
save2, file


test = aia1600map[*,*,120] ; quiet, I think
;frac = findgen(10)/10
frac = [50:100:5]/100.
for ii = 0, 9 do begin
    ;sig = where( test ge frac[ii]*max(test)  )
    sig = where( test ge frac[ii]*mean(test)  )
    print, float(n_elements(sig))/n_elements(test)
endfor
stop


;image_data = alog10( reform(map[*,*,196,*]))

print, max_value


print, max(image_data)
std = stddev(image_data)
print, mean(test) + 2*std
print, mean(test) + 3*std

stop


dw
win = window(/buffer)
for ii = 0, 1 do begin
    image_data = reform(map[*,*,196,ii])
    max_value = 0.1 * max(image_data)
    im = image2( $
        image_data, $
        /current, layout=[1,2,ii+1], $
        margin=0.1, $
        max_value = max_value, $
        rgb_table=A[ii].ct )
endfor
file = 'test.pdf'
save2, file



end
