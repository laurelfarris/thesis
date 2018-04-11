
; 06 April 2018


pro image_powermaps, map, name, time
    ; No science here! Just graphics

    rows = 5
    cols = 5

    wx = 1000
    wy = wx
    win = window( dimensions=[wy,wx], name=name )
;    fwin = getwindows( names=basename )

    im = objarr(rows*cols)

    for i = 0, rows*cols-1 do begin
        im[i] = image2( $
            map[*,*,i], $
            /current, $
            layout=[cols, rows, i+1], $
            margin=0.01, $
            rgb_table=39, $
            xshowtext=0, $
            yshowtext=0 $
        )
        t = text2(  $
            0.1, 0.9, $
            time[i], $
            relative=1, $
            target=im[i], $
            color='white' $
        )
    endfor
end


pro plot_power_vs_time, z, map

    ;; map = 3D array of maps (x,y,t)

    win = window( dimensions=[1200, 800] )

    xdata = z
    ydata = total( total( map, 1), 1 )

    p = plot2( $
        xdata, ydata, /current, $
        xtickvalues=[0:199:25], $
        xtickname=time[0:199:25], $
        xtitle='observation time (15 February 2011)', $
        ytitle='3-minute power' $
    )
end

goto, start

; image sub-region to make sure I am where I think I am.
data = S.(1).data[40:139,90:189,*]
im = image2(data[*,*,0])
stop

; indices of power/frequency arrays within desired range.
ind = [5,6]

; # images (length of time) over which to calculate each FT.
dz = 50


; starting indices/time for each FT (length = # resulting maps)
z = [0:199:1]


; Calculate power maps
aia1600map = power_maps( $
    S.(0).data[40:139,90:189,*], z=z, dz=dz, ind=ind, cadence=24. )
aia1600 = create_struct( aia1600, 'map', aia1600map )
aia1700map = power_maps( $
    S.(1).data[40:139,90:189,*], z=z, dz=dz, ind=ind, cadence=24. )
aia1700 = create_struct( aia1700, 'map', aia1700map )
stop


; Image power maps
time = aia1600.time[z]
image_powermaps, aia1600map^0.5, 'powermaps_AIA1600_zoomed', time
mysave, 'powermaps_AIA1600_zoomed'
image_powermaps, aia1700map^0.5, 'powermaps_AIA1700_zoomed', time
mysave, 'powermaps_AIA1700_zoomed'


; Plot total power as a function of time.
start:;----------------------------------------------------------------------------------

win = window( dimensions=[9.0, 5.0]*72 )
p = objarr(4)

y0 = S.(0).flux[z]
y0 = y0-min(y0)
y0 = y0/max(y0)

p[0] = plot2( $
    z, y0, $
    /current, $
    /device, $
    position=72*[1.0, 2.5, 8.8, 4.8], $
    stairstep=1, $
    color=S.(0).color, $
    name=S.(0).name, $
    xshowtext=0, $
    ytitle='Normalized intensity' $
)

y1 = S.(1).flux[z]
y1 = y1-min(y1)
y1 = y1/max(y1)
p[1] = plot2( $
    z, y1, /overplot, $
    stairstep=1, $
    name=S.(1).name, $
    color=S.(1).color $
)

y2 = total( total( aia1600.map, 1), 1 )
p[2] = plot2( $
    z, y2, /current, $
    /device, $
    position=72*[1.0, 0.5, 8.8, 2.5], $
    stairstep=1, $
    name=S.(0).name, $
    color=S.(0).color, $
    xtickvalues=[0:199:25], $
    xtickname=S.(0).time[0:199:25], $
    xtitle='observation start time (2011 February 15)', $
    ytitle='3-minute power' $
)
y3 = total( total( aia1700.map, 1), 1 )
p[3] = plot2( z, y3, /overplot, color=S.(1).color, $
    stairstep=1, $
    name=S.(0).name $
)
leg = legend2( $
    target=[p[0],p[1]], $
    position=[0.9,0.9], /relative $
)

stop


power = []

for i = 0, 149 do begin

    subarr = fltarr(200)
    subarr[i:i+dz-1] = y2[i]
    power = [ [power], [subarr] ]

endfor



w = window( dimensions=[1500,800] )

plt = plot2( indgen(200), power[*,i], /current, /nodata )

for i = 0, 149 do begin

    plt = plot2( power[*,i], /overplot, linestyle=6, symbol='_' )
endfor

full_power = power[49:149,*]
avg_pow = mean( full_power, dimension=2 )


w = window( dimensions=[1500,800] )
avg_pow = mean( power, dimension=2 )
plt = plot2( avg_pow, /current )

end
