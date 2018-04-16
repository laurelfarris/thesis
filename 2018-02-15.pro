;; Last modified:   15 February 2018 19:44:21


goto, start

dat = S.(0).data[150:649, 185:514, 275:284]

; histogram
dat = S.(0).data[150:649, 185:514, * ]
pdf = histogram( dat, binsize=1000, locations=xbin )
cdf = total(pdf, /cumulative ) / n_elements(dat)

w = window(dimensions=[1400,500])
pimage = image(dat[*,*,280], /current, layout=[3,1,1])
phisto = plot(xbin, pdf, layout=[3,1,2], /current, color='red', $
    xmajor=5, $
    ;xrange=[2500,17000], $
    yrange=[0,6000])
pcumu = plot(xbin, cdf, layout=[3,1,3], /current, color='blue')


stop

dat = S.(0).data[150:649, 185:514, * ]
sz = size(dat, /dimensions)

sat = [ 8000. : 16000. : 1000. ]
sat = [ 15400. : 16200. : 100. ]


mask = fltarr( sz[0], sz[1], n_elements(sat) )

w = window( dimensions=[3*sz[0],3*sz[1]] )

for i = 0, n_elements(sat)-1 do begin

    temp = fltarr( sz ) + 1.0

    temp[ where(dat gt sat[i]) ] = 0.0
    temp = product(temp,3)
    mask = (temp-1.0)* (-1.0)

    im = image(mask, /current, layout=[3,3,i+1], margin=0.1, $
        xticklen=0.01, $
        yticklen=0.01, $
        title="Threshold = " + strtrim(sat[i],1), $
        axis_style=2)
endfor


;sat = [ 100. : 16400. : 100. ]
sat = [ 1000. : 16300. : 100. ]

hist = fltarr(2,n_elements(sat)-1)
for i = 0, n_elements(sat)-2 do begin
    hist[0,i] = [ $
        n_elements( where(dat ge sat[i] AND dat lt sat[i+1])) ]
    hist[1,i] = [ $
        n_elements(where(dat lt sat[i]))]
endfor

p = objarr(2)
w = window( dimensions=[1000,500] )
colors=['red','blue']
for i = 0, 1 do begin
    p[i] = plot( $
        sat, hist[i,*], /current, layout=[2,1,i+1], $
        stairstep=1, $
        xstyle=1, $
        ystyle=1, $
        xmajor=5, $
        color=colors[i])

endfor

p[0].yrange=[0,20000.]
p[0].xrange=[1000,17000.]



;; New data from 09 February
dat = S.(0).data

sz = size(dat, /dimensions)
sat = 15000.

mask = fltarr( sz ) + 1.0
mask[ where(dat gt sat) ] = 0.0
mask = product(mask,3)

@graphics
w = window( dimensions=[0.5*wx, wy])

props = { $
    xticklen : 0.01, $
    yticklen : 0.01, $
    xtickfont_size : 9, $
    ytickfont_size : 9, $
    axis_style : 2 $
}

;; indices for 2 separate points in space and time that have saturation.
ind = [90,280]

im = objarr(3)
for i=0,1 do begin
    im[i]= image( $
        (dat[*,*,ind[i]])^0.3, $
        /current, $
        layout=[1,3,i+1], $
        title="AIA 1600$\AA$ at " + S.aia1600.time[ind[i]], $
        _EXTRA=props)
endfor

im[2] = image( $
    mask, /current, layout=[1,3,3], $
    title="Threshold = " + strtrim(sat,1), $
        _EXTRA=props)

pos = im[1].position
im[1].position = pos + [0.0, 0.05, 0.0, 0.05]
pos = im[2].position
im[2].position = pos + [0.0, 0.1, 0.0, 0.1]


stop
c = contour( $
    mask[*,*,i], $
    /overplot $
;        c_thick=2, $
    ;color=colors[i] $
    )


    ;im = image( mask[*,*,i], layout=[1,1,1], margin=0 )





;; Histogram of data values

cube = S.(0).data


satlocs = where(a6index.nsatpix ne 0)
y = a6index.nsatpix
x = indgen(n_elements(y))

xrange = float([min(x),max(x)])
yrange = float([min(y),max(y)])
r = (xrange[1]-xrange[0])/(yrange[1]-yrange[0])


@graphics
p = scatterplot( x, y, $
    dimensions=[wx,wy], $
    aspect_ratio=r, $
    ;layout=[1,2,1], $
    xrange=xrange, yrange=yrange, $
    xticklen=0.03, $
    yticklen=0.03, $
    symbol='.', $
;    sym_increment=10, $
    sym_thick=3.0, $
    xtitle="Image number", $
    ytitle="Number of saturated pixels", $
    _EXTRA=props)

pos = p.position
p.position = pos + [0.05,0.0,0.05,0.0]
stop

w = window( dimensions=[wx,wy] )
n = 2
result = []

;for i = 0, n-1 do begin

result1 = histogram( $
    S.(0).data, $
    ;min=1000.0, $
    locations=xbins1, $
    binsize=100 )
result2 = histogram( $
    S.(1).data, $
    ;min=1000.0, $
    locations=xbins2, $
    binsize=100 )
;endfor

xbins1 = xbins1/1000.
xbins2 = xbins2/1000.

p1 = plot(  $
    xbins1, result1, $
    /current, $
    /histogram, $
    layout=[2,2,1], $
    name=S.(0).name, $
    xtitle="Intensity (x 10$^3$)", $
    ytitle="Number of pixels", $
    color=S.(0).color, $
    ylog=1, $
    xrange=[-1,17], $
    _EXTRA=plot_props )

p2 = plot( $
    xbins2, result2, $
    name=S.(1).name, $
    /overplot, $
    /histogram, $
    color=S.(1).color )

leg = legend( $
    target=[p1,p2], $
    ;/device, $
    /relative, $
    position=[0.9,0.9], $
    _EXTRA=legend_props )

stop
ax = p1.axes
ax[2].textpos = 0
ax[2].title = "(a)"
ax[2].major=0
ax[2].minor=0
ax[2].showtext = 1

;---------------------------------------------------------------------------------------
;; Saturation mask

restore, 'aia_1600_cube.sav'
sz = size(cube, /dimensions)
sat = 15000.
mask = fltarr(sz) + 1.0
mask[ where( cube gt sat) ] = 0.0
mask = product(mask,3)

start:;------------------------------------------------------------------------------
width=10.0
height=width
cols=1
rows=1
@graphics
im_data = mask;[300:650,350:700]
;im = image( im_data, /current, position=pos, _EXTRA=image_props)
im = image( (cube[*,*,-1])^0.5, /current, position=pos, _EXTRA=image_props)
c = contour(  im_data, /overplot, color='red' )
stop

for i = 0, sz[2]-1 do begin
    cube[*,*,i] = cube[*,*,i] * mask
endfor


my_xstepper, cube^0.5, scale=0.75


ref = cube[*,*,373]





end
