;; Last modified:   16 February 2018 13:09:31



goto, start


;; Data to align (cropped to save time whilst developing code)
;cube = S.aia1600.data[*,*,50:149]
;sz = size(cube, /dimensions)

; Array of shifts in x and y, over many alignment runs (z) ...eventually.
a6shifts = []
a7shifts = []

n = 6

resolve_routine, 'align_cube3'

cube = S.aia1600.data
print, "Start alignment  ", strtrim(i+1,1), ": ", systime()
for i = 0, n-1 do begin
    align_cube3, cube, temp_shifts
    a6shifts = [ [[a6shifts]], [[temp_shifts]] ]
end
cube = S.aia1700.data
for i = 0, n-1 do begin
    align_cube3, cube, temp_shifts
    a7shifts = [ [[a7shifts]], [[temp_shifts]] ]
end
print, "Finish alignment ", strtrim(i+1,1), ": ", systime()
stop

shifts = a6shifts

;; Exclude saturated images
locs = where( a6index.nsatpix ne 0 )

xshifts = reform(shifts[0,*,*])
yshifts = reform(shifts[1,*,*])

max_value = max(shifts)
min_value = min(shifts)




stop


;xstepper, cube, xsize=sz[0], ysize=sz[1], start=260

stop

;; Axis labels for time (x-axis)... I think
caldat, a6jd, month, day, year, hour, minute, second
ind =  (where( minute eq 30 ))[0:-1:2]
labels = strmid( a6index[ind].t_obs, 11, 5 )



;; Run alignment on cube, a few chunks at a time


sz = size(cube, /dimensions)
ref = cube[*,*,373]
temp = cube[*,*,0:9]

n = 20
s = []
x_shifts = []
y_shifts = []

for i = 0, n-1 do begin
    align_cube3, temp, ref, shifts=shifts
    s = [ [[ s ]], [[ shifts ]] ]
    x_shifts = [ [[ x_shifts ]], [[ shifts[0,*,*] ]] ]
    y_shifts = [ [[ y_shifts ]], [[ shifts[1,*,*] ]] ]
endfor
stop


x_shifts = reform(x_shifts)
y_shifts = reform(y_shifts)

;shift_range = []
dx = []
dy = []
for i = 0, n-1 do begin
    dx = [ dx, max(x_shifts[*,i]) - min(x_shifts[*,i]) ]
    dy = [ dy, max(y_shifts[*,i]) - min(y_shifts[*,i]) ]
    ;shift_range = [ shift_range, max( s[ *,*,i ] ) ]
endfor
stop

p = plot( $
    indgen(n)+1, $
    dx, $
    xtitle="Alignment run", $
    ytitle="range of shifts (x and y)", $
    color='dark cyan', $
    ylog=1, $
    name="X shifts", $
    symbol='Square', $
    linestyle='none', $
    sym_filled=1, $
    _EXTRA=props )
op = plot( $
    indgen(n)+1, $
    dy, $
    /overplot, $
    name="Y shifts", $
    symbol='Triangle', $
    sym_size=2.0, $
    linestyle='none', $
    sym_filled=1, $
    color='dark orange' )


leg = legend( target=[p,op], $
    /relative,  $
    position=[0.85,0.85], $
    _EXTRA=legend_props )

stop


k1 = [  4,  81, 240, 458, 469, 638, 668, 713]
k2 = [ 14, 112, 335, 465, 480, 645, 704, 720] 

time = strmid( a6index.t_obs, 11, 5 )
ind = [75, 225, 375, 525, 675]

;; Plot all 750-ish shifts from first alignment run

height = 1.50
x1 = 1.0
x2 = 6.0
y1 = reverse(height*findgen(6) + 1.0)
y2 = y1 + height

alph = string( bindgen(1,6)+(byte('a'))[0] )

p = objarr(6)
@graphics
for i = 0, 5 do begin
    ydata = a6shifts[*,*,i]
    ymax = max(abs(ydata))
    ymin = -ymax
    p[i] = plot( $
        ydata[0,*], $
        /current, $
        /device, $
        position=[x1, y1[i], x2, y2[i]]*dpi, $
        xshowtext=0.0, $
        xticklen=0.02, $
        xtickvalues=ind, $
        ;ylog=1, $
        ;yrange=[ymin*1.1, ymax*1.1], $
        yrange=[ 1.2*min(ydata), 1.2*max(ydata) ], $
        ;ytickvalues=[ymin, ymax], $
        ytickvalues=[min(ydata), max(ydata)], $
        yticklen=0.01, $
        color='dark cyan', $
        ytitle="shifts", $
        name='Horizontal shifts', $
        _EXTRA=props )
    op = plot( $
        ydata[1,*], $
        /overplot, $
        name='Vertical shifts', $
        color='dark orange', $
        _EXTRA=props )

    txt = text( 0.02, 0.85,  $
        "(" + alph[i] + ")", $
        target=p[i], $
        /relative, $
        ;alignment=1.0, $
        font_size=9 )

    yr = p[i].yrange
    v = plot( [240,240], [yr[0],yr[1]], /overplot, linestyle=3 )
    v = plot( [335,335], [yr[0],yr[1]], /overplot, linestyle=3 )

endfor

ax = p[5].axes
ax[0].showtext=1
ax[0].ticklen=0.02
ax[0].title='Start time (15-Feb-11 00:00:00)'
ax[0].tickvalues = ind
ax[0].tickname = time[ind];[time[0], time[150], time[300], time[450], time[600]]

ax = p[0].axes
ax[2].showtext=1
ax[2].title='image number'

pos = p[0].position
leg = legend(  $
    font_size=fontsize, $
    target=[p[5],op], $
    horizontal_alignment='LEFT', $
    sample_width=0.05, $
    position=[pos[2],pos[3]], $
    linestyle=6, $
    shadow=0 )

stop
    



;; Plot skewed regions individually
side = 2.5 * dpi
x1 = [ 1.0 : 11.0 : 3.25 ] * dpi
y1 = [ 1.0 :  8.5 : 3.25 ] * dpi
x1 = x1[0:2]
y1 = reverse(y1[0:1])

rows = 2
cols = 3
p = objarr(cols,rows)

ind = [250, 270, 290, 310, 330]

i = 0
@graphics
for r = 0, rows-1 do begin
for c = 0, cols-1 do begin

    x = [ 240 : 335 : 1 ]
    p[c,r] = plot( x, a6shifts[0,x,i], $
        /current, $
        /device, $
        ;layout=[cols,rows,i+1], margin=0.1, $
        ;position=[0.0, 0.0, side, side], $
        position=[ x1[c],y1[r],x1[c]+side,y1[r]+side], $
        xshowtext=0, $
        name='Horizontal shifts', $
        color='dark cyan', $
        ymajor=6, $
        _EXTRA=props )

    op = plot( x, a6shifts[1,x,i], $
        /overplot, $
        name='Vertical shifts', $
        color='dark orange', $
        _EXTRA=props )

    ax = p[c,r].axes
    if r eq 1 then begin
        ax[0].tickvalues=ind
        ax[0].tickname=time[ind]
        ax[0].title='Start time (2011-Feb-15 00:00:00)'
        ax[0].showtext=1
    endif
    if r eq 0 then begin
        ax[2].tickvalues=ind
        ax[2].title="image number"
        ax[2].showtext=1
    endif

    if c eq 0 then begin
        ax[1].title="shifts"
    endif

    txt = text( $
        0.05, 0.9, $
        "(" + alph[i] + ")" , $
        target=p[c,r], $
        /relative, $
        ;vertical_alignment=1.0, $
        font_size=fontsize)

    i = i + 1

endfor
endfor

pos = p[2,0].position
leg = legend(  $
    font_size=fontsize, $
    position=[pos[2],pos[3]+0.05], $
    vertical_alignment='bottom', $
    linestyle=6, $
    shadow=0 )

stop



;; Graphics (post-alignment)
cols = 3
rows = 2
side = inches_to_pixels(2.5)

xpos = [0.20, 0.50, 0.80]
ypos = [0.60, 0.30 ]
p = objarr(cols,rows)

k = 0 ;; counter for array to be plotted... better way?
for j = 0, rows-1 do begin
    for i = 0, cols-1 do begin

        ;x = indgen(10)+1
        ;y = 1000.*s[0,*,k]
        x = indgen(749)+1
        y = 1000.*a6shifts[0,*,k]

        p[i,j] = plot( x, y, $
            /device, /current, $
            position=[0.0, 0.0, side, side], $
            ;yrange=[-4.0, 4.0], $
            ;ytickvalues=[-0.5, 0.0, 0.2], $
            ;ymajor=3, $
            name="Horizontal shifts", $
            color='dark cyan', $
            title="Alignment " + strtrim((k+1),1), $
            xtitle="image number", $
            ytitle="shifts $\times$ 10$^{-3}$", $
            ytickformat='(F5.2)', $
            _EXTRA=props)

        ;y = 1000.*s[1,*,k]
        y = 1000.*a6shifts[1,*,k]
        op = plot( x, y, $
            /overplot, $
            name="Vertical shifts", $
            color='dark orange', $
            _EXTRA=props)

        ;; Adjust position
        p[i,j].position = [ xpos[i], ypos[j] ]

        ;; No inter-panel axis labels
        if i ne 0 then p[i,j].ytitle = ""
        if j ne 2 then p[i,j].xtitle = ""

        ;; Text to keep track of order in which graphics are added to win.
        txt = text( 0.89, 0.89, $
            "(" + strtrim(i,1) + ", " + strtrim(j,1) + ")", $
            target=p[i,j], $
            /relative, $
            alignment=1.0, $
            font_size=9 )

        k = k + 1
    endfor
endfor

leg = legend( position=[0.97,0.90], _EXTRA=legend_props )
;----------------------------------------------------------------------------------



;; 1. restore data
restore, 'aia_1600_cube.sav'
;cube = cube[ 100:899, 100:899, * ]
sz = size( cube, /dimensions )
ref = cube[*,*,373]

shifts2 = fltarr(2, sz[2], 6)

start:;----------------------------------------------------------------------------------
temp = cube[*,*,0:19]
for i = 0, 5 do begin
    align_cube3, temp, ref, shifts
    ;shifts2[*,*,i] = shifts
endfor
xstepper, temp, xsize=800, ysize=800



stop

;; 2. Divide data into chunks to be aligned individually
k1 = [ 4,  81, 240, 458, 469, 638, 668, 713 ]
k2 = [ 14, 112, 335, 465, 480, 645, 704, 720]
align_locs = [0, k1, k2+1, sz[2] ]
A = align_locs[ sort(align_locs) ]



;; 3. Run alignment


;; Create empty arrays for shifts and aligned cube for entire series
;;     ( 0 --> 748 )
;; 20 = MAX number of times to run alignment... this way I can
;; keep using the same array, and if parts don't need
;; many alignments, there will just be a bunch of zeros,
;; which should be relatively easy to exclude.
aligned_cube = intarr( sz )
my_shifts = fltarr(2, sz[2], 20)
ref = cube[*,*,373]

A = [ 0, 14, 81, 112, 240, 335, 458, 480, 638, 668, 704, sz[2] ]

j = 1
a1 = A[j-1]
a2 = A[j]-1


temp = cube[*,*, a1:a2 ]
xstepper, temp, xsize=800, ysize=800
stop

dx = []
dy = []
n_align = 6
for i = 0, n_align-1 do begin

    align_cube3, temp, ref, shifts
    stop
    my_shifts[ *, a1:a2, i] = shifts
    dx = [ dx, max(shifts[0,*]) - min(shifts[0,*]) ]
    dy = [ dy, max(shifts[1,*]) - min(shifts[1,*]) ]
    

endfor

stop

;aligned_cube[ 0, 0, a1 ] = temp
    

;----------------------------------------------------------------------------------


; No more changing variables at this point!!!!!
@graphics
cols = 1
rows = 1
pos = dpi*positions(layout=[cols,rows], margin=1.0, width=4.5, height=2.5 )
wx = max( pos[2,*] ) + 0.5*dpi
wy = max( pos[3,*] ) + 0.5*dpi
p = objarr(cols,rows)
win = window( dimensions=[wx,wy]*2, buffer=0 )

i = 0


;; Different x and y data, hence, different name and axis labels.
;; Changed layout and dimensions of graphics
;; Everything else is the same. 
;;  Make a subroutine for this! Specific to this part of the research
;;   process so stays in this file, but general to the little steps.

for y = 0, rows-1 do begin
for x = 0, cols-1 do begin

    ;xdata = indgen(a2+1)
    ;ydata = my_shifts[*, a1:a2, i+9]
    xdata = indgen(n_align)+1

    p[x,y] = plot( $
        ;xdata, ydata[0,*], $
        xdata, dx, $
        /device, /current, $
        position=pos[*,i], $
        ;yrange=[-4.0, 4.0], $
        ;ytickvalues=[-0.5, 0.0, 0.2], $
        ;xmajor=9, $
        ;ymajor=4, $
        ylog=1, $
        name="Horizontal shifts", $
        color='dark cyan', $
        ;ytickformat='(F5.2)', $
        _EXTRA=plot_props)

    op = plot( $
        ;xdata, ydata[1,*], $
        xdata, dy, $
        /overplot, $
        name="Vertical shifts", $
        color='dark orange', $
        _EXTRA=plot_props)

    txt = text( 0.11, 0.89, $
        ;'(' + alph[i] + ')', $                
        '(' + strtrim(i,1) + ')', $                
        target=p[x,y], $
        /relative, $
        alignment=1.0, $
        font_size=10 )

    i = i + 1

endfor
endfor

;; No inter-panel axis labels
;p[0,*].ytitle = "shifts"
;p[*,0].xtitle = "image number"
p[0,0].xtitle = "Number of alignments"
p[0,0].ytitle = "$\Delta$ shifts"

;leg = legend( position=[0.97,0.90], _EXTRA=legend_props )

end
