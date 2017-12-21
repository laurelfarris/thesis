;; Last modified:   05 October 2017 15:29:18

um = [287,220]
pe = [380,245]
qs = [400,80]


; ~80 images in one hour for 45 second cadence.
t1 = 0
t2 = 119
a1 = hmi_data[ um[0]-1 : um[0]+1, um[1]-1 : um[1]+1, t1:t2 ]

test1 = total( a1, 1 )
test2 = total( test1, 1 )

; making sure I'm calculating the total correctly
print, test2[20]
print, total( a1[*,*,20] )




a1 = hmi_data[ um[0]-1 : um[0]+1, um[1]-1 : um[1]+1, t1:t2 ]
a1 = total( a1, 1 )
a1 = total( a1, 1 )
a2 = hmi_data[ pe[0]-1 : pe[0]+1, pe[1]-1 : pe[1]+1, t1:t2 ]
a2 = total( a2, 1 )
a2 = total( a2, 1 )
a3 = hmi_data[ qs[0]-1 : qs[0]+1, qs[1]-1 : qs[1]+1, t1:t2 ]
a3 = total( a3, 1 )
a3 = total( a3, 1 )

D = n_elements(a1)
a1 = reform(a1, 1, D) 
a2 = reform(a2, 1, D) 
a3 = reform(a3, 1, D) 

;arr = [ $
;    hmi_data[ um[0], um[1], t1:t2 ], $
;    hmi_data[ pe[0], pe[1], t1:t2 ], $
;    hmi_data[ qs[0], qs[1], t1:t2 ]  $
;]
;
;arr = [[a1], [a2], [a3]] --> wrong dimensions: [1,360]
arr = [a1, a2, a3];       --> right dimensions: [3, 120]  :)
;arr = reform(arr)  Don't need to do this now



titles = ['Umbra', 'Penumbra', 'Quiet sun' ]
w = window(dimensions=[1500,1200], $
    ;title = 'Pre-flare' )
    title = 'All' )

ymin = 65.
ymax = 105000.

p = objarr(3)
lc = objarr(3)
for i = 0, 2 do begin

    result = fourier2( arr[i,*], 45. )
    fr = result[0,*]
    power = result[1,*]
    period = (1./fr)/60.
    xrange = where( period ge 2.0 AND period le 8.0 )
    ;print, period[xrange]
    x = fr[ xrange ]
    y = power[ xrange ]

    ;print, min(y), max(y)
    p[i] = plot( x, y, /current, layout=[1,6,i+1], margin=0.05, $
        xstyle=1, $
;        yrange=[ymin,ymax], $
        title = titles[i] $
    )
    vert = plot( [1./300., 1./300.], [ymin,ymax], $
        linestyle=2, /overplot )


    lc[i] = plot( arr[i,*], /current, layout=[1,6,i+4] )

endfor







;; 30 Sep 2017

xstepper, a6^0.5, $ ;str, $
    xsize=2*x, ysize=2*y, start=170


str = aia_1600_index.date_obs

sz = size( a6, /dimensions )
x = sz[0]
y = sz[1]

for i = 205, 225 do print, max( a6[*,*,i] )
;; Look saturated, but values are all different...?


arr = [0,16,43,198,240,393,411,573,576,603,633,681]
foreach i, arr do print, str[i]
;; To get times that images were/weren't jumping/saturated


cadence = aia_1600_index[0].cdelt1
print, 200./cadence 
;; 200" = ~328.20621 pixels
;; My data cubes are 500x330 pixels.
;; Milligan et al. cut out more of the AR.
;; Not unreasonable, but how should one define this region?




print, "Umbra: ", hmi[384,224,0]
print, "Penumbra: ", hmi[378,243,0]
print, "Quiet: ", hmi[407, 80,0]


temp = [ $
    [[ (a6[*,*,198])^0.5 ]], $
    [[ (a6[*,*,256])^0.5 ]]  ]

w = window( dimensions=[700, 1060] )
for i = 0, 1 do begin
    im = image( temp[*,*,i], layout=[1,2,i+1], margin=0.01, /current )
endfor




arr = hmi[*,221:225,0]
arr = mean(arr, dimension=2)

p = plot( arr, xrange=[250,499], yrange=[max(arr),min(arr)] )

x1 = 345
x2 = 380
x3 = 395
x4 = 425
y1 = min(arr) 
y2 = max(arr) 
vert = plot( [x1,x1], [y1,y2], linestyle=2, /overplot )
vert = plot( [x2,x2], [y1,y2], linestyle=2, /overplot )
vert = plot( [x3,x3], [y1,y2], linestyle=2, /overplot )
vert = plot( [x4,x4], [y1,y2], linestyle=2, /overplot )


print, 57142.9/(mean(hmi[350:-1,0:120,0]))
print, quiet_avg
;; Confirms penumbra/quiet boundary is ~90% of average quiet
STOP

sz = size( hmi, /dimensions )
x = sz[0]
y = sz[1]

w = window( dimensions=[2*x,2*y] )
im = image( hmi[*,*,0], layout=[1,1,1], margin=0.0, /current )
im = image( hmi_power_image, layout=[1,1,1], margin=0.0, /current )


quiet = max(hmi[*,*,0])
umbra = min(hmi[*,*,0])

quiet_avg = mean(hmi[350:-1,0:120,0])

c2 = quiet_avg * 0.6
c1 = quiet_avg * 0.9

c = contour( hmi[*,*,0], c_value = [c1,c2], c_color=['black','white'], $
    c_label_show = 0, $
    /overplot )
;c = contour( hmi[*,*,0], n_levels = 6, /overplot )


resolve_routine, 'fa_2d', /either
hmi_power_image = fa_2d( hmi, hmi_cad, 180., 5.0 )


;result = fourier2(hmi[291,179,*], 45.0, /norm)
result = fourier2(hmi[250,186,*], 45.0, /norm)
fr = result[0,*]
pow = result[1,*]
T1 = 2.0
T2 = 6.0
f1 = 1./(T2*60.)
f2 = 1./(T1*60.)
i1 = (where( fr ge f1 ))[0]
i2 = (where( fr le f2 ))[-1]
fr = fr[i1:i2]
pow = pow[i1:i2]

period = (1./fr)/60.

;w=window( dimensions=[700,500] )
;p = plot( fr, pow, /current, layout=[1,2,1], xstyle=1, xrange=[f2,f1])
p = plot( period, pow, /current, layout=[1,2,2], xstyle=1)


w=window( dimensions=[1000,800] )

plot_fourier2, hmi[291,179,*], 45.0, fr, pow, period, /minutes
p = plot( period, pow, /current, layout=[1,2,1], xstyle=1)

plot_fourier2, hmi[250,186,*], 45.0, fr, pow, period, /minutes
p = plot( period, pow, /current, layout=[1,2,2], xstyle=1)

STOP

w = window( dimensions=[2*x,2*y] )
im = image( hmi_power_image, layout=[1,1,1], margin=0.0, /current )
c = contour( hmi[*,*,0], c_value = [c1,c2], $
    c_color=['dark blue', 'dark red'], $
    ;c_linestyle = 5, $
    c_label_show = 0,  /overplot )



STOP





;; Oct 2



cube = hmi
sz = size(cube, /dimensions)



uflux = []
pflux = []
qflux = []

upix = []
ppix = []
qpix = []

for i = 0, sz[2]-1 do begin

    d = cube[*,*,i]
    quiet_sun = mean( cube[ 350:-1,0:120,i] )
    umbra = quiet_sun * 0.6
    penumbra = quiet_sun * 0.9

    ulocs = array_indices(d, where(d le umbra))
    plocs = array_indices(d, where(d gt umbra AND d lt penumbra))
    qlocs = array_indices(d, where(d ge penumbra))

    uflux = [ uflux, total( d[ ulocs[0,*], ulocs[1,*] ]) ] 
    pflux = [ pflux, total( d[ plocs[0,*], plocs[1,*] ]) ] 
    qflux = [ qflux, total( d[ qlocs[0,*], qlocs[1,*] ]) ] 
    
    upix = [upix, n_elements( d[ ulocs[0,*], ulocs[1,*] ]) ]
    ppix = [ppix, n_elements( d[ plocs[0,*], plocs[1,*] ]) ]
    qpix = [qpix, n_elements( d[ qlocs[0,*], qlocs[1,*] ]) ]

endfor


n = 4
arr = fltarr( n, sz[2] )
arr[0,*] = uflux
arr[1,*] = pflux
arr[2,*] = qflux
arr[3,*] = qflux + uflux + pflux


w = window( dimensions=[1000,1100] )
p = objarr(n)

titles = [ "umbra lightcurve", "penumbra lightcurve", $
    "quiet sun lightcurve", "integrated lightcurve" , "hmi_flux"]

for i=0,n-1 do begin
    p[i] = plot( arr[i,*], /current, layout=[1,n,i+1], margin=0.10, $
    title = titles[i])
endfor


;; Variation in flux for all 3 components
print, max(uflux)-min(uflux)
print, max(pflux)-min(pflux)
print, max(qflux)-min(qflux)


uavg = uflux/upix
pavg = pflux/ppix
qavg = qflux/qpix

w = window( dimensions = [1000,1100] )
p = plot( uavg, layout=[1,3,1], margin=0.10, /current )
p = plot( pavg, layout=[1,3,2], margin=0.10, /current )
p = plot( qavg, layout=[1,3,3], margin=0.10, /current )

w = window( dimensions = [1000,1100] )
p = plot( upix, layout=[1,3,1], margin=0.10, /current )
p = plot( ppix, layout=[1,3,2], margin=0.10, /current )
p = plot( qpix, layout=[1,3,3], margin=0.10, /current )

START:
w = window( dimensions = [1000,1100] )

p = plot( uflux, layout=[1,3,1], margin=0.1, /current, $
    title = "Umbral flux" )
p = plot( upix, layout=[1,3,2], margin=0.1, /current, $
    title = "Number of pixels making up umbra")
p = plot( uavg, layout=[1,3,3], margin=0.1, /current, $
    title = "Average flux per pixel in umbra")

STOP



end
