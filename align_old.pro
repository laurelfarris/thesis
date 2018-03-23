;; Last modified:   23 March 2018 01:37:03

function align_data, data

    ;; Calls align_cube3 with both cube and quiet cube...
    ;;   probably don't need this subroutine anymore.

    r = 500

    ; Center coordinates of AR (relative to full 4096x4096 array)
    xc = 2400
    yc = 1650
    cube = data[ xc-r:xc+r-1, yc-r:yc+r-1, * ]

    ; Center coordinates of quiet region (relative to full 4096x4096 array)
    xc = 2000
    yc = 2400
    quiet = data[ xc-r:xc+r-1, yc-r:yc+r-1, * ]

    sdv = []
    print, "Start:  ", systime()
    repeat begin
        align_cube3, quiet, cube, shifts
        sdv = [ sdv, stddev( shifts[0,*] ) ]
        k = n_elements(sdv)
        print, sdv
    endrep until ( k ge 2 && sdv[k-1] gt sdv[k-2] )
    print, "End:  ", systime()

    xstepper, cube, xsize=512, ysize=512

    return, cube

end

z1 = 225 & z2 = 300; 375
cube = cube[ *,*,z1:z2]
n = 2
sz = size(cube, /dimensions)
shifts = fltarr(2, sz[2], n)
resolve_routine, 'align_cube3'
for i = 0, n-1 do align_cube3, cube, shifts[*,*,i]
stop

my_xstepper, cube^0.5, scale=0.75
stop

@graphics
gap = fontsize*3.0
props = create_struct( $
    'stairstep', 1, $
    'xtitle'   , 'Image number', $
    'ytitle'   , 'shift [pixels]', $
    'xshowtext', 0, $
    'yshowtext', 0, $
    plot_props )

;x1 = make_array(3, /index, increment=wx/3, type=2)
;x1 = fix((indgen(6) mod 2)*(4.25*dpi) + dpi)

width = (dpi*3.0)
height = width
x1 = [0, width, 0, width, 0, width] + dpi
y1 = [0, 0, height, height, 2*height, 2*height ] + dpi
y1 = reverse(y1, 1)

w = window( dimensions=[wx,wy] )
image_number = indgen(sz[2]) + z1
p = objarr(n)
for i = 0, n-1 do begin
    p[i] = plot( $
        image_number, shifts[0,*,i], /nodata, $
        /current, $
        /device, $
        title="Alignment " + strtrim(i+1,1), $
        position=[ x1[i], y1[i], $
            x1[i]+width-gap, y1[i]+height-gap], $
        _EXTRA=props)
    px = plot( $
        image_number, shifts[0,*,i], $
        /overplot, $
        name='x shifts', $
        color='blue')
    py = plot( $
        image_number, shifts[1,*,i], $
        /overplot, $
        name='y shifts', $
        color='orange' )
endfor

pos = p[-1].position * [wx, wy, wx, wy]

leg = legend( $
    target=[px, py], $
    font_size = fontsize, $
    /device, $
    position=pos[2:3] + [gap, 0.0], $ ;[pos[2:3]-[20,20]], $
    horizontal_alignment='left', $
    shadow=0 $
)

end




; older alignment routine


;; Last modified:   15 July 2017 19:33:17
;; Filename:        align.pro
;; Function(s):     align_cube3.pro, alignoffset.pro, align_shift_sub.pro
;; Description:     Align images using the center image as a reference
;;                      Reference can be changed in align_cube3.pro
;;                      Images should shift more in x than y since this
;;                      is primarily correcting for rotation of sun.



pro ALIGN, cube

    ;; Start alignment. Note this may take a while, depending on size of cube;
    ;;      1000 x 1000 x 300 x 6 took ~4 hours.
    ;;      Should probably rewrite so my_average isn't being copied back and forth each time.
    my_average = []
    sdv = []
    repeat begin
        ALIGN_CUBE3, cube, x_sdv, y_sdv
        ;my_average = [my_average, avg]
        ;k = n_elements(my_average)
        sdv = [sdv, x_sdv]
        k = n_elements(sdv)
    endrep until (k ge 2 && sdv[k-1] gt sdv[k-2])

end


pro ALIGN_HMI, cube
    ;; Coords for flare in HMI data (roughly in the middle of group of sunspots)
    ;; Relative to (unrotated) 4096 x 4096 full disk image
    ;;   r is the "radius", or perpendicular distance from center to edge of square
    ;; Note: These will need to be corrected when hmi images are properly rotated 180 degrees.

    x = 1650
    y = 2450
    r = 500

    ;; Cut out r x r data cube centered at x, y (variables declared above)

    cube = hmi_data[ x-r:x+r-1, y-r:y+r-1, 22:* ]


    ;; Run alignment

    ALIGN, cube

    ;; Save, cutting out edges where alignment routine caused wrapping.
    save, cube[100:899, 100:899, *], 'hmi_aligned.sav'
end


pro ALIGN_AIA, data, cube

    x = 2445
    y = 1645
    r = 500

    cube = data[x-r:x+r-1,y-r:y+r-1, *]
    align, cube

end


pro SAVE_ALIGN, cube

    cube = cube[100:899, 100:899, *]
    save, cube, filename="aia_1700_aligned.sav"
end



;ALIGN_AIA, data, cube
; Will stop when shift is higher than previous, but may be worth running this again...
; Went to even tinier shifts with aia_1700_data
SAVE_ALIGN, cube


;; Where should these steps be done?
;;   In read_fits after reading?
;;   In align routine before aligning?
;; data read in from fits
;; trimmed to area of interest to reduce align time
;; trimmed again to get rid of edges
;; saved
end


;; Last modified:   21 March 2018 14:01:58



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




;; Last modified:   21 March 2018 14:02:11




goto, start



; 01 March 2018  (technically morning of March 02)


;restore, 'aia_1600_cube.sav'
;restore, 'aia_1600_shifts.sav'
cube = float(cube)
ref = cube[ *,*,373 ]
temp = cube[ *,*, 81:112 ]
sz = size(temp, /dimensions )
temp_shifts = a6shifts[*,81:112,*]

for j = 0, 5 do begin

    for i = 0, sz[2]-1 do begin

        xo = temp_shifts[0,i,j]
        yo = temp_shifts[1,i,j]

        temp[*,*,i] = shift_sub( temp[*,*,i], xo, yo )
        ;align_cube3, temp, ref, shifts

    endfor
endfor

xstepper, temp^0.5, xsize=800, ysize=800




; 05 March 2018



;; Restore variable 'cube' = [1000 x 1000 x 749] int array
restore, 'aia_1600_cube.sav'

;; Restore variable 'a6shifts' = [2 x 749 x 6] float array
restore, 'aia_1600_shifts.sav'


temp = cube[*,*,50:99]
ref = cube[*,*,75]
;my_xstepper, temp^0.5


for i = 0, 11 do begin
    align_cube3, temp, ref, shifts
endfor
my_xstepper, temp^0.5

; Definitely looked better when ref was closer to cube being aligned...


margin=[1.0, 0.5, 0.25, 0.25]
dpi = 96

cols=1
rows=1
width = 6.0
height = 2.5
gap = 0.0

@graphics


;props = create_struct( plot_props, my_props )

p = objarr(1)
win = window( dimensions=[wx,wy]*dpi )
for i = 0, 0 do begin

    ydata = shifts[*,*,i]
    ysz = size( ydata, /dimensions )
    xdata = indgen(ysz[1]) + 1


    p[i] = plot( xdata, ydata[0,*], /nodata, $
        /device, /current, $
        position=pos[*,i], $
        xshowtext = 0, $
        ;xmajor = 10, $
        ;ymajor = 6, $
        xtitle = 'alignment run #', $
        _EXTRA=props )

    op1 = plot( xdata, ydata[0,*], /overplot, $
        color = 'dark cyan',  $
        stairstep = 1, $
        name = 'Horizonal shifts' )

    op2 = plot( xdata, ydata[1,*], /overplot, $
        color = 'dark orange',  $
        stairstep = 1, $
        name = 'Vertical shifts' )

    yrange = p[i].yrange
    inc = (yrange[1] - yrange[0])/6.
    tickvalues = [ yrange[0] : yrange[1] : inc ]
    p[i].ytickvalues = tickvalues[ 1 : -2 ]

endfor

ax = p[-1].axes
ax[0].showtext = 1




end






;; Last modified:   14 March 2018 19:09:42


goto, start

restore, 'aia_1600_cube.sav'

x = [ [0, 300], [650, 999] ]
y = [ [0, 350], [700, 999] ]
z = [ 225, 350 ]

mainref = cube[*,*, 373]
;cube = cube[*,*, z[0]:z[1]-1]

average_shifts = []

for a = 0, 5 do begin

    s = []

    for i = 0, 1 do begin
        for j = 0, 1 do begin

        x1 = x[0,i]
        x2 = x[1,i]
        y1 = y[0,j]
        y2 = y[1,j]

        temp = cube[ x1:x2, y1:y2, * ]
        ref = mainref[ x1:x2, y1:y2 ]

        sz = size(temp, /dimensions)
        shifts = fltarr(2, sz[2])

        for l = 0, sz[2]-1 do begin

            offset = alignoffset( temp[*,*,l], ref )
            shifts[*,l] = -offset

        endfor

        ;align_cube3, temp, ref, shifts=shifts
        s = [ [[s]], [[shifts]] ]


        endfor
    endfor

    shifts = mean( s, dimension=3 )

    for l = 0, sz[2]-1 do $
        cube[*,*,l] = shift_sub( $
            cube[*,*,l], shifts[0,l], shifts[1,l] )

    average_shifts = [ [[ average_shifts ]], [[ shifts ]] ]

endfor

stop

for i = 0, 1 do $
    im = image( $
        (cube[*,*,373])^0.5, $
        ;(cube[400:600,400:600,z[i]])^0.5, $
        layout=[1,1,1], $
        margin=0.0, $
        dimensions=[800,800] )



;all_shifts[*, z[0]:z[1], a] = average_shifts
;a = a + 1


restore, 'aia_1600_cube.sav'
ref  = cube[ 100:899, 100:899, 373 ]
cube = cube[ 100:899, 100:899, 0:224 ]

align_cube3, cube, ref, shifts=shifts
stop


start:;----------------------------------------------------------------------------------
xstepper, (cube)^0.5, xsize=800, ysize=800

end
