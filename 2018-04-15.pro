;; Last modified:   15 April 2018 18:29:57

goto, start


temp = A[0].flux
ind = [190, 254, 318]
dz = 64

power = []
foreach i, ind do begin
    result = fourier2( temp[i:i+dz-1], 24 )
    frequency = result[0,*]
    power = [ power, result[1,*] ]
endforeach

aia1600power = power
;aia1600frequency = frequency

temp = A[1].flux
power = []
foreach i, ind do begin
    result = fourier2( temp[i:i+dz-1], 24 )
    frequency = result[0,*]
    power = [ power, result[1,*] ]
endforeach

aia1700power = power
;aia1700frequency = frequency

; frequency confirmed to be the same unless cadence and/or length of
; input flux is changed, so no need to assign to each channel.
; I already knew this... but doesn't hurt to check :)
stop



aia1600 = create_struct( aia1600, 'power', aia1600power )
aia1700 = create_struct( aia1700, 'power', aia1700power )
A = [aia1600, aia1700]
stop




ind = where( frequency ge (1./400) AND frequency le (1./50) )
ind = [3:31]

w = window(dimensions=[612,792])
;w = window(dimensions=[816,1056])
graphic = objarr(4)
p = objarr(2)
;ax = objarr(4,3)

xdata = frequency[ind]

for i = 0, 2 do begin

    graphic[i] = plot2( $
        xdata, A[0].power[i,ind[0]:ind[-1]], $
        /nodata, /current, $
        xtitle = 'Frequency (Hz)', $
        xshowtext = 0, $
        ytitle = 'Power', $
        xticklen = 0.050, $
        yticklen = 0.015, $
        ylog=1, $
        margin = [0.10, 0.20, 0.05, 0.20], $
        layout=[1,3,i+1] )
        ;layout=[1,4,i+1] )

    pos = graphic[i].position
    ;graphic[i].position = pos + i*[0.0, 0.075 , 0.0, 0.075 ]
    graphic[i].position = pos + i*[0.0, 0.1, 0.0, 0.1 ]

    ;if i eq 2 then graphic[xshowtext = 0, $
    for j = 0, 1 do begin
        ydata = A[j].power[i,ind[0]:ind[-1]]
        p[j] = plot2( $
            xdata, ydata, $
            ;xrange=1./[50, 400], $
            xlog=1, $
            ylog=1, $
            name = A[j].name, $
            /overplot, $
            color=A[j].color )
    endfor

    periods = [120., 180., 200.]
    f = 1./periods
    y = graphic[i].yrange

    v1 = plot2( [f[0],f[0]], [y[0],y[1]], /overplot, linestyle=':', $
        name='120s' ) 
    v2 = plot2( [f[1],f[1]], [y[0],y[1]], /overplot, linestyle='--', $
        name='180s' ) 
    v3 = plot2( [f[2],f[2]], [y[0],y[1]], /overplot, linestyle='-.', $
        name='200s' ) 

    txt = text2( 0.93, 0.89, i, /relative, target=graphic[i] )

endfor


    leg = legend2( $
        target=[p[0],p[1],v1,v2,v3], $
        position=[0.35,0.867] $
        )

    ax1 = graphic[2].axes
    ax1[0].showtext = 1

    periods = reverse( periods )
    ax = graphic[0].axes
    ax[2].tickvalues = x
    ax[2].tickname = strmid(strtrim(periods,1),0,3)
    ax[2].tickformat = '4(A3)'
    ax[2].title = 'Period (seconds)'
    ax[2].showtext = 1

stop


result = fourier2( A[0].flux[223:374], 24 )
frequency2 = result[0,*]
power1 = result[1,*]
result = fourier2( A[1].flux[223:374], 24 )
power2 = result[1,*]

graphic[3] = plot2( frequency, power1, /nodata, $
    /current, $
    xtitle = 'Frequency (Hz)', $
    xlog=1, ylog=1, $
    margin = [0.10, 0.20, 0.05, 0.20], $
    layout=[1,4,4] )
pos = graphic[3].position
graphic[3].position = pos + 3*[0.0, 0.075 , 0.0, 0.075 ]

p[0] = plot2( frequency, power1, /overplot, $
    color=A[0].color, $
    xlog=1, ylog=1, $
    name = A[0].name )
p[1] = plot2( frequency, power2, /overplot, $
    name = A[1].name, $
    xlog=1, ylog=1, $
    color=A[1].color )
y = graphic[3].yrange
    v1 = plot2( [f[0],f[0]], [y[0],y[1]], /overplot, linestyle=':', $
        name='120s' ) 
    v2 = plot2( [f[1],f[1]], [y[0],y[1]], /overplot, linestyle='--', $
        name='180s' ) 
    v3 = plot2( [f[2],f[2]], [y[0],y[1]], /overplot, linestyle='-.', $
        name='200s' ) 

    txt = text2( 0.05, 0.1, 3, /relative, target=graphic[i] )
stop


; Power maps for BDA, again.
; But these should exclude saturated pixels...

z = [190, 254, 318]
dz = 64

; 180 seconds
map1 = power_maps( A[0].data, z=z, dz=dz, T=[170,195], cadence=24. )
map2 = power_maps( A[1].data, z=z, dz=dz, T=[170,195], cadence=24. )
map180 = [ [[map1]], [[map2]] ]


; 120 seconds
map1 = power_maps( A[0].data, z=z, dz=dz, T=[115,130], cadence=24. )
map2 = power_maps( A[1].data, z=z, dz=dz, T=[115,130], cadence=24. )
map120 = [ [[map1]], [[map2]] ]


; 200 seconds
map1 = power_maps( A[0].data, z=z, dz=dz, T=[190,220], cadence=24. )
map2 = power_maps( A[1].data, z=z, dz=dz, T=[190,220], cadence=24. )
map200 = [ [[map1]], [[map2]] ]


; Scrap this... better to organize by channel.
map = { $
    map180 : map180, $
    map120 : map120, $
    map200 : map200 $
}


; Organizing maps by channel:
aia1600map2 = [ $
    [[map120[*,*,0:2]]], $
    [[map180[*,*,0:2]]], $
    [[map200[*,*,0:2]]] ]
aia1700map2 = [ $
    [[map120[*,*,3:5]]], $
    [[map180[*,*,3:5]]], $
    [[map200[*,*,3:5]]] ]
map = { $
    aia1600map2 : aia1600map2, $
    aia1700map2 : aia1700map2 }
stop

for j = 0, 1 do begin

    w = window( dimensions=[1500,990]*0.7 )
    im = objarr(9)
    for i = 0,8 do begin
        im[i] = image( map.(j)[*,*,i]^0.5, /current, $
        layout=[3,3,i+1], margin=0.05, rgb_table=39 )
    endfor

endfor

; Not much difference to see between 120, 180, and 200 seconds...
; May as well go back to just showing 180 for now.


map = [ [[map180[*,*,0:2]]], [[map180[*,*,3:5]]] ] 


start:;---------------------------------------------------------------------------------
w = window( dimensions=[1500,660]*0.7 )
im = objarr(6)
names = [ 'Before', 'During', 'After' ]

for i = 0,5 do begin
    im[i] = image2( $
        map[*,*,i]^0.5, $
        /current, $
        layout=[3,2,i+1], $
        xmajor=0, $
        ymajor=0, $
        margin=[0.1, 0.05, 0.05, 0.1], $
        rgb_table=39 )

    ax = im[i].axes
    if i le 2 then ax[2].title = names[i]
    ax[2].showtext = 1
    if i eq 0 then ax[1].title = 'AIA 1600$\AA$'
    if i eq 3 then ax[1].title = 'AIA 1700$\AA$'
endfor



end
