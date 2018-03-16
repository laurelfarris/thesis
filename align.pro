;; Last modified:   05 March 2018 15:44:45




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
