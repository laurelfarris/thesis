



goto, start


flux = A[0].flux[262:301]

zeroes = [ 10, 100, 1000 ] 

color = ['royal blue', 'dark red', 'dark green']

w = window()
foreach n, zeroes, i do begin

    result = fourier2( [ flux, fltarr(n) ], 24, /norm )
    frequency = reform(result[0,*])
    f1 = (where( frequency ge (1./500) ))[0]
    f2 = (where( frequency le (1./50) ))[-1]
    frequency = frequency[f1:f2]
    power = reform(result[1,*])
    power = power[f1:f2]
    p = plot2( frequency, power+i, /current, /overplot, color=color[i] )

endforeach



color = ['royal blue', 'crimson', 'green']
w = window()
for i = 0, 1 do begin
    ;flux = A[i].flux[262:301]
    flux = A[i].flux[0:39]
    result = fourier2( [flux, fltarr(1000)], 24, /norm )
    frequency = reform(result[0,*])
    f1 = (where( frequency ge (1./500) ))[0]
    f2 = (where( frequency le (1./50) ))[-1]
    frequency = frequency[f1:f2]
    power = reform(result[1,*])
    power = power[f1:f2]
    p = plot2( frequency, power+i, /current, /overplot, color=color[i] )

endfor


vx = 1./[ 120, 180, 200 ]

for i = 0, 2 do $
    v = plot2( [vx[i],vx[i]], [-0.1,2.1], /overplot, linestyle='--' )


color = ['royal blue', 'crimson', 'green']


;START:;---------------------------------------------------------------------------------

k = 0


dz = 25
dz = 18
dz = 64
;zstart = [224:313]
;zstart = [225-dz:376]
zstart = [0:749-dz-1]


period_center = 3
f_center = 1./(period_center*60.)
df = 0.00004

w = window()
for k = 0, 1 do begin

    power = fltarr( n_elements(zstart) )
    for i = 0, n_elements(zstart)-1 do begin

        flux = A[k].flux
        result = fourier2( [flux[i:i+dz-1], fltarr(1000)], 24, /norm )

        frequency = reform(result[0,*])
        f1 = (where( frequency ge f_center - df ))[ 0]
        f2 = (where( frequency le f_center + df ))[-1]
        frequency = frequency[f1:f2]
        power[i] = mean((reform(result[1,*]))[f1:f2])
        ;power = power[f1:f2]
        ;power_3min = [ power_3min, mean(power) ]

    endfor

    power_avg = fltarr( n_elements( power ))
    for i = 0, n_elements(power)-dz-1 do $
        power_avg[i] = mean(power[i:i+dz-1])
        
    xdata = [224:376]

    ydata = shift( power, dz/2 )
    ydata = ydata[xdata]
    ;xdata = indgen(n_elements(ydata))
    p = plot2( $
        xdata, ydata, /current, $
        layout=[1,2,k+1], $
        ;xtickvalues = [0:376-224:25], $
        xmajor = 7, $
        xtitle = "time", $
        ytitle = strtrim(period_center,1) + "-minute power", $
        title = A[k].name + '  ' + 'dz = ' + strtrim(dz,1) $
        )

    ydata = shift( power_avg, dz )
    ydata = ydata[xdata]
    ;xdata = indgen(n_elements(ydata))
    p = plot2( $
        xdata, ydata, /overplot, color=color[1] )

    ;ind = ; + zstart[0+dz]
    p.xtickname = time[fix(p.xtickvalues)]

endfor

stop


n = n_elements(zstart)
power_array = fltarr( n + dz, n )

for i = 0, n-1 do $
    power_array[i:i+dz-1,i] = power_3min[i]


power_avg = mean( power_array, dimension=2 )
sz = size(power_avg, /dimensions)
ydata = power_avg[dz:sz[0]-dz-1]
xdata = indgen(n_elements(ydata))

p = plot2( xdata, ydata )


ind = fix(p.xtickvalues) + zstart[0]+dz
p.xtickname = time[ind]


; Switching gears - going to test aia_prep.pro

read_my_fits, '1600', aia1600index, aia1600data, /aia, nodata=0, sub=[0:9]
read_my_fits, '1600', hmiBLOSindex, hmiBLOSdata, /hmi, nodata=0, sub=[0:9]




stop

; AIA

aia_prep, aia1600index, aia1600data, aia1600index_out, aia1600data_out

temp = [ $
    [[ aia1600data[*,*,0:4] ]], $
    [[ aia1600data_out[*,*,0:4] ]] $
    ]
aia_lct, r, g, b, wave=1600, /load
ct = [[r],[g],[b]]

w = window( dimensions=[1500,600] , location=[500,0])
for i = 0, 9 do begin
    im = image2( $
        temp[*,*,i]^0.5, /current, layout=[5,2,i+1], margin=0.05, $
        rgb_table=ct, $
        axis_style=0)
endfor

; HMI
aia_prep, hmiBLOSindex, hmiBLOSdata, hmiBLOSindex_out, hmiBLOSdata_out

temp = [ $
    [[ hmiBLOSdata[*,*,0:4] ]], $
    [[ hmiBLOSdata_out[*,*,0:4] ]] $
    ]



w = window( dimensions=[1500,600] , location=[500,0])
for i = 0, 9 do begin
    dat = temp[*,*,i]
    im = image2( $
        dat, $
        /current, $
        layout=[5,2,i+1], $
        margin=0.05, $
        max_value=300, $
        min_value=-300, $
        axis_style=0)
endfor




; image AIA and HMI full disk

; reset session and ran prep and prep_hmi, so
; variable names are a little different.

;aia_prep, hmiindex, hmi.data, hmiindex_out, hmiBLOSdata_out


read_my_fits, '1600', index1, data1, nodata=0, sub=[0:1], /aia
aia_prep, index1, data1, index1_out, data1_out

read_my_fits, '1700', index2, data2, nodata=0, sub=[0:1], /aia
aia_prep, index2, data2, index2_out, data2_out



START:;---------------------------------------------------------------------------------
aia1 = { $
    name : aia1600.name, $
    data : data1_out[*,*,0], $
    time : strmid(index1_out[0].date_obs, 11, 11), $
    ct : aia1600.ct $
    }


aia2 = { $
    name : aia1700.name, $
    data : data2_out[*,*,0], $
    time : strmid(index2_out[0].date_obs, 11, 11), $
    ct : aia1700.ct $
    }


hmi2 = { $
    name : hmi.name, $
    data : hmi.data, $
    time : strmid(hmiindex.date_obs, 11, 11), $
    ct : 0 $
    }


aia1.data = (data1_out[*,*,0])^0.5
aia2.data = (data2_out[*,*,0])^0.5
hmi2.data = hmi.data<300>(-300)
S = { aia1:aia1, aia2:aia2, hmi2:hmi2 }
stop

wx = 8.5
wy = wx/3
im = objarr(3)
w = window( dimensions=[wx,wy]*dpi, location=[500,0] )

for i = 0, n_tags(S)-1 do begin

    
        data = S.(i).data
        im[i] = image2( $
            data, $
            /device, $
            /current, $
            layout=[3,1,i+1], $
            margin=0.25*dpi, $
            rgb_table=S.(i).ct, $
            title=S.(i).name + ' 2011-February-15 ' + $
                S.(i).time[0], $
            xtitle='X (arcseconds)', $
            ytitle='Y (arcseconds)', $
            name=S.(i).name $
        )
endfor


image_color, S
stop


wx = 8.5
wy = 6.0
w = window( dimensions=[wx,wy]*dpi, location=[500,0] )
graphic = plot2( $
        xdata, ydata, /nodata, $
        /current, $
        layout=[1,2,1], $
        xtitle='Start time', $
        ytitle='Counts (DN)' $
        )
for i = 1, 1 do begin

    ydata = A[i].flux[224:376]
    xdata = indgen(n_elements(ydata))
    p = plot2( $
        xdata, ydata, /overplot, $
        stairstep = 1, $
        color=A[i].color $
        )

endfor




trend = fltarr(n_elements(ydata))
for i = 1, n_elements(ydata)-2 do begin
    trend[i] = mean(ydata[i-1:i+1])
endfor

;trend = ydata - shift(ydata, 1)


    p = plot2( $
        xdata[1:-2], (ydata[1:-2]-trend[1:-2]), /current, $
        layout=[1,2,2], $
        stairstep = 1, $
        color=A[1].color $
        )

color = ['royal blue', 'dark red', 'dark green']

temp = ydata[1:-2]-trend[1:-2]
result = fourier2( [ydata[1:-2], fltarr(100)], 24, /norm )
;result = fourier2( [temp, fltarr(100)], 24, /norm )
frequency = reform(result[0,*])
f1 = (where( frequency ge (1./500) ))[0]
f2 = (where( frequency le (1./50) ))[-1]
frequency = frequency[f1:f2]
power = reform(result[1,*])
power = power[f1:f2]

p = plot2( frequency, power, color=color[2] )
v = plot2( [0.0055, 0.0055], p.yrange, /overplot, linestyle='--' )

end
