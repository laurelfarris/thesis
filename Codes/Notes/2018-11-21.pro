


goto, start

start:;---------------------------------------------------------------------------------


cc = 1
time = strmid(A[cc].time,0,5)
dz = 64

;z_start=[16, 58, 196]
z_start=[0, 1, 2] * dz

fmin = 0.0025
fmax = 0.02

fcenter=0.0039

color = [ 'black', 'red', 'blue'  ]

win = window( dimensions=[7.0, 4.0]*dpi )
p = objarr(3)

foreach zz, z_start, ii do begin


    flux = (A[cc].flux[zz:zz+dz-1])/(500.*330)
    result = fourier2( flux, 24 )
    frequency = reform( result[0,*] )
    power = reform( result[1,*] )
    ind = where( frequency ge fmin and frequency le fmax )

    p[ii] = plot2( frequency[ind], power[ind], /current, overplot=ii<1, $
        ylog = 1, $
        symbol='Circle', $
        xtitle='frequency (Hz)', $
        ytitle='power (per pixel)', $
        color=color[ii], $
        name = time[zz] + '-' + time[zz+dz-1] )


endforeach
v = plot2( [fcenter,fcenter], p[0].yrange, /overplot, linestyle='--', ystyle=1 )
leg = legend2( target=p )

stop


dw


map = powermaps( A[cc].data, 24, z_start=z_start, dz=dz, $
    fcenter=fcenter, $
    bandwidth=0.001 )

win = window( dimensions=[8.0, 11.0]*dpi )
imdata = alog10(map)
foreach zz, z_start, ii do begin
im = image2( $
    imdata[*,*,ii], $
    /current, $
    layout=[1,3,ii+1], $
    margin=0.1, $
    min_value = min(imdata), $
    max_value = max(imdata), $
    title = time[zz] + '-' + time[zz+dz-1], $
    xshowtext=0, yshowtext=0, $
    rgb_table=A[cc].ct )

endforeach



stop


imdata = []
restore, '../hmi_cont.sav'
imdata = [ [[imdata]], [[crop_data(cube[*,*,0])]] ]
restore, '../hmi_mag.sav'
imdata = [ [[imdata]], [[crop_data(cube[*,*,0])]] ]

avg_cont = mean( imdata[350:450,50:150,0] )

c_value = [ [[0.6, 0.9]*avg_cont], [[-300,300]] ]
c_color = [ ['red', 'blue'], ['red', 'blue'] ]
stop



;title = []
read_my_fits, index, instr='hmi', channel='cont', ind=[0], nodata=1, prepped=1
print, index.date_obs
;title = [ title, 'HMI continuum (' + index.date_obs + ')' ]
read_my_fits, index, instr='hmi', channel='mag', ind=[0], nodata=1, prepped=1
print, index.date_obs
;title = [ title, 'HMI B$_{LOS}$ (' + index.date_obs + ')' ]
stop


dw
win = window( dimensions=[8.5, 11.0]*dpi, location=[500,0] )
im = objarr(2)
for ii = 0, 1 do begin
    im[ii] = image2( $
        imdata[*,*,ii], $
        /current, $
        layout=[2,2,ii+3], $
        margin=0.1, $
        title = title[ii], $
        xshowtext=0, yshowtext=0 )

    ;continue
    c = contour( $
        imdata[*,*,ii], $
        /overplot, $
        c_label_show=0, $
        c_thick=0.0, $
        c_value=c_value[*,ii], $
        c_color=c_color[*,ii], $
        c_linestyle='-')

endfor

yoffset = 0.2
im[0].position = im[0].position + [0.0, yoffset, 0.0, yoffset]
im[1].position = im[1].position + [0.0, yoffset, 0.0, yoffset]

end
