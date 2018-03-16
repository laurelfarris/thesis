;; Last modified:   16 February 2018 17:13:05

GOTO, START


;xstepper, cube, xsize=sz[0], ysize=sz[1], start=260

stop

;; Axis labels for time (x-axis)... I think
caldat, a6jd, month, day, year, hour, minute, second
ind =  (where( minute eq 30 ))[0:-1:2]
labels = strmid( a6index[ind].t_obs, 11, 5 )



;; Run alignment on cube, a few chunks at a time

;sh = [ [[s1]], [[s2]], [[s3]], [[s4]], [[s5]], [[s6]] ]


start:;----------------------------------------------------------------------------------
sz = size(cube, /dimensions)
ref = cube[*,*,373]
temp = cube[*,*,0:9]

n = 20
s = []

for i = 0, n-1 do begin
    align_cube3, temp, ref, shifts=shifts
    s = [ [[ s ]], [[ shifts ]] ]
endfor
stop


p = plot( $
    indgen(n)+1, $
    shifts, $
    xtitle="Alignment run", $
    ytitle="range of shifts (x and y)", $
    xtickvalues=[1,4,8,12], $
    ylog=1, $
    _EXTRA=props )


stop




d_shifts = []

;; Graphics (post-alignment)
@graphics

cols = 4
rows = 3

w = window( dimensions=[2.2*wx,wy] )
left = 4.0 * dpi
bottom = 0.6 * dpi
right = 0.2 * dpi
top = 0.2 * dpi
;n_align = (size(s, /dimensions))[2]

p = objarr(n)
for i = 0, n-1 do begin

    p[i] = plot( $
        s[0,*,i], $
        /current, $
        ;/device, $
        layout=[cols,rows,i+1], $
        margin=0.25, $
        ;margin=[left,bottom,right,top], $
        ;ytickunits="exponent", $
        ;xmajor=5, $
        xtickinterval=((size(temp, /dimensions))[2])/3, $
        ymajor=3, $
        name="X shifts", $
        symbol='Square', $
        linestyle='none', $
        sym_filled=1, $
        color='dark cyan', $
        xtitle="image number", $
        ytitle="shifts", $
        _EXTRA=props)
    op = plot( $
        s[1,*,i], $
        /overplot, $
        name="Y shifts", $
        symbol='Triangle', $
        sym_size=2.0, $
        linestyle='none', $
        sym_filled=1, $
        color='dark orange', $
        _EXTRA=props)

    x = p[i].xrange
    y = p[i].yrange
    dx = x[1]-x[0]
    dy = y[1]-y[0]
    p[i].aspect_ratio = dx/dy

    d_shifts = [ d_shifts, dy ]

endfor
stop

for i = 0, n-1 do begin
    pos = p[i].position
    dx = pos[0]*0.25
    p[i].position = pos - [ dx, 0.0, dx, 0.0 ]
;    xind = reverse( indgen(n) mod cols )
;    yind = [0,0,0,1,1,1,2,2,2,3,3,3]
;    p1.position = pos + $
;        [ xind[i]*0.06, yind[i]*0.06, $
;          xind[i]*0.06, yind[i]*0.06  ]

;; Text won't move with image...
    txt = text( 0.89, 0.89, $
        "(" + strtrim(i,1) + ")", $
        target=p[i], $
        /relative, $
        ;font_color='red', $
        font_size=9 )
endfor

leg = legend( position=[0.85,0.85], _EXTRA=legend_props )



end
