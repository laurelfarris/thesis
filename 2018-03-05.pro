;; Last modified:   05 March 2018 23:14:16

goto, start


cadence_inter = findgen(100) * 12
cad = cadence_inter[0:48]
cad = [ cad, cadence_inter[52:*] ]
data = randomn( seed, n_elements(cad) )
data_inter = interpol( data, cad, cadence_inter, /spline )

help, data, cad, data_inter, cadence_inter

p = plot( cad, data, dimensions=[1000,800], $
    symbol='circle', sym_filled=1 )
    
;p2 = plot(cadence_inter, data_inter, /overplot, $
;    symbol='circle', sym_filled=1, color='blue' )

missing = plot( cadence_inter[48:52], data_inter[48:52], /overplot, $
    ;linestyle=6,  $
    color='red', sym_filled=1, sym_size=0.5, symbol='circle' )







restore, 'aia_1600_shifts.sav'
sz = size( a6shifts, /dimensions )


A = [ $
    0, 5, $
    13, 82, $
    111, 240, $
    336, 459, $
    464, 470, $
    479, 639, $
    644, 669, $
    703, 714, $
    719, sz[1]-1 ]

cadence_inter = findgen(sz[1])

;; Crop data to normal shifts ONLY
cad = []
H_data = []
V_data = []
for i = 0, n_elements(A)-1, 2 do begin
    ;print, A[i], ':', strtrim(A[i+1],1)
    ind1 = [ A[i]   : A[i+1]   ]
    cad = [ cad, cadence_inter[ind1] ]
    H_data = [ H_data, reform( a6shifts[0, ind1, 0] ) ]
    V_data = [ V_data, reform( a6shifts[1, ind1, 0] ) ]
endfor

H_data_inter = interpol( H_data, cad, cadence_inter, /spline )
V_data_inter = interpol( V_data, cad, cadence_inter, /spline )

layout=[3,2]
margin=[0.75, 0.75, 0.25, 0.25]
width=4
height=4
gap=0.75

@graphics

win = window( dimensions=[wx,wy]*dpi )

i1 = [  6,  83, 240, 460, 471, 640, 670, 715 ]
i2 = [ 12, 110, 335, 463, 478, 643, 702, 718 ]

i1 = [  6,  83, 240, 460, 640, 670 ] - 1
i2 = [ 12, 110, 335, 478, 643, 718 ] + 1

for i = 0, 5 do begin

xdata = cadence_inter[ i1[i]:i2[i] ]

y1 = a6shifts[0,i1[i]:i2[i],0]
y2 =  H_data_inter[ i1[i]:i2[i] ]

y3 =  a6shifts[1,i1[i]:i2[i],0]
y4 =  V_data_inter[ i1[i]:i2[i] ]

graphic = plot( $
    xdata, y1, $
    /nodata, $
    /current, $
    /device, $
    name='Horizontal shifts', $
    xtitle='image #', $
    ytitle='shifts', $
    position=dpi*position[*,i], $
    xmajor=5, $
    ymajor=5, $
    ;xrange=[50,149], $
    ;xtickvalues=[50:150:10], $
    _EXTRA=plot_props)

p1 = plot( $
    xdata, y1, $
    thick=5, $
    transparency=75, $
    color='dark cyan', $
    /overplot )

p3 = plot( $
    xdata, y3, $
    thick=5, $
    transparency=75, $
    color='dark orange', $
    /overplot )

p2 = plot( $
    xdata, y2, $
    thick=2, $
    symbol='circle', $
    sym_filled=1, $
    sym_size=0.3, $
    color='dark cyan', $
    /overplot )


p4 = plot( $
    xdata, y4, $
    color='dark orange', $
    thick=2, $
    symbol='circle', $
    sym_filled=1, $
    sym_size=0.3, $
    /overplot )

endfor
stop



H_data_inter = reform(H_data_inter, 1, n_elements(H_data_inter))
V_data_inter = reform(V_data_inter, 1, n_elements(V_data_inter))

new_shifts = [ H_data_inter, V_data_inter ]

restore, 'aia_1600_cube.sav'
sz = size(cube, /dimensions)

for i = 0, sz[2]-1 do begin
    cube[*,*,i] = shift_sub(cube[*,*,i], new_shifts[0,i], new_shifts[1,i])
endfor



;; Tuesday, March 6, 2018 

START:

ref = cube[*,*,373]

;; Calculate 2nd set of shifts

for i = 0, sz[2]-1 do begin
    
    offset = alignoffset( cube[*,*,i], ref )
    shifts[*,i] = -offset

endfor

stop

;; interpolate again to get CORRECT set of shifts



;; Apply second set of new shifts to cube.

for i = 0, sz[2]-1 do begin
    cube[*,*,i] = shift_sub(cube[*,*,i], new_shifts[0,i], new_shifts[1,i])
endfor




end
