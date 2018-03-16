;; Last modified:   05 March 2018 23:14:16


; input:            shifts [ 2 x N ]; x/y shifts for N images


pro plot_shifts, old, new

    cols = 1
    rows = 1

    @graphics

    graphic = objarr(4)

    x = indgen(749)
    for i = 0, 0 do begin

        ;; Really, there should be a better way to do this...
        v1 = old[0,*,i]
        h1 = old[1,*,i]
        v2 = new[0,*,i]
        h2 = new[1,*,i]

        graphic[i] = plot( x, v1, /nodata, $
            position=dpi*pos[*,i], $
            ytitle='shifts', $
            xshowtext=0, $
            ;yrange=[-10.0,10.0], $
            ;xmajor=5, $
            ;ymajor=5, $
            ;xtickvalues=[50:150:10], $
            _EXTRA=plot_props)

        ;p1 = plot( x, v1, color='dark cyan', /overplot )
        ;p2 = plot( x, h1, color='dark orange' ,/overplot )
        p3 = plot( x, v2, color='dark cyan',   thick=2, /overplot )
        p4 = plot( x, h2, color='dark orange', thick=2, /overplot )


        txt = text( 0.1, 0.9, alph[i], /relative )
        leg = legend( target=[p3,p4], _EXTRA=legend_props )


    endfor

    ax = graphic[-1].axes
    ax[0].title='image #'
    ax[0].showtext=1

    stop
    return



    ;i1 = [  6,  83, 240, 460, 471, 640, 670, 715 ]
    ;i2 = [ 12, 110, 335, 463, 478, 643, 702, 718 ]
    i1 = [  6,  83, 240, 460, 640, 670 ] - 1
    i2 = [ 12, 110, 335, 478, 643, 718 ] + 1

    ydata = [ [[old]], [[new]] ]
    graphic = objarr(6)
    for i = 0, 5 do begin

        xdata = [ i1[i]:i2[i] ]
        y1 = ydata[ 0, i1[i]:i2[i], 0 ]
        y2 = ydata[ 1, i1[i]:i2[i], 0 ]
        y3 = ydata[ 0, i1[i]:i2[i], 1 ]
        y4 = ydata[ 1, i1[i]:i2[i], 1 ]


        graphic[i] = plot( xdata, y1, /nodata, $
            position=dpi*pos[*,i], $
            xmajor=5, $
            ymajor=5, $
            ;xrange=[50,149], $
            ;xtickvalues=[50:150:10], $
            _EXTRA=plot_props)

        p1 = plot( xdata, y1, color='dark cyan', $
            /overplot )
        p2 = plot( xdata, y2, color='dark orange', $
            /overplot )
        p3 = plot( xdata, y3, $
            linestyle=3, $
            /overplot )
        p4 = plot( xdata, y4, $
            linestyle=3, $
            /overplot )

        ax = graphic[i].axes
        if (i eq 0) or (i eq 3) then ax[1].title='shifts'
        if (i ge 3) then ax[0].title='image #'

    endfor

end



function inter, shifts

    ;; shifts should be a 2xN array, not 3 dimensions.


    N = fix((size(shifts, /dimensions))[1])

    ;; Indices of images that are NOT shifted by some crazy amount
;    A = [ 0, $
;        [  1:  5], $
;        [ 13: 82], $
;        [111:240], $
;        [336:459], $
;        [464:470], $
;        [479:639], $
;        [644:669], $
;        [703:714], $
;        [719:N-1] $
;    ]

    ;; Indices of shifts that are definitely wrong...
    bad = [ $
        [7:11],[84:103],107,108,109,[266:309],461,462,[472:477], $
        641,642,[671:701],716,717 ]

    good = [ 0, [1:6],[12:83],[104:106],[110:265],[310:460],[463:471], $
        [478:640],[643:670],[702:715],[718:N-1]]

    ;; Full arrays, POST-interpolation
    cadence_inter = findgen(N)
    data_inter = fltarr( size(shifts, /dimensions) )

    ;; Crop data to normal shifts ONLY
    cad = cadence_inter[good]
    data = shifts[ *, good ]


    data_inter[0,*] = interpol( data[0,*], cad, cadence_inter, /spline )
    data_inter[1,*] = interpol( data[1,*], cad, cadence_inter, /spline )

    return, data_inter

end

goto, start


;; test - maybe start with this to make a test subroutine?
;restore, 'aia_1600_shifts.sav'
;test = inter( a6shifts[*,*,0] )

;; Read in unprocessed data cube for AIA 1600.
restore, 'aia_1600_cube.sav'

;; Prep for alignment (expecting no more than 10 runs)
ref = cube[*,*,373]
sz = size(cube, /dimensions)

shifts     = fltarr( 2, sz[2], 10)
new_shifts = fltarr( 2, sz[2], 10)

a = 1

;;  Calculate shifts
for i = 0, sz[2]-1 do begin
    offset = alignoffset( cube[*,*,i], ref )
    shifts[*,i,a] = -offset
endfor
;;   Interpolate to get CORRECT set of shifts
new_shifts[*,*,a] = inter( shifts[*,*,a] )
stop


START:;----------------------------------------------------------------------------------
;;  Plot shifts

cols=1
rows=1
@graphics

y = new_shifts[0,*,a]
y = shifts[0,*,a]
ind=[0:25]
p = plot( ind, y[ind], $
    xtickvalues=[ ind[0]:ind[-1]: 5], $
    ;yrange=[min(a6shifts),max(a6shifts)], $
    color='dark cyan', $
    xticklen=0.1/wy, $
    yticklen=0.1/wx, $
    position=pos[*,0], $
    symbol='circle', sym_filled=1, sym_size=0.5, $
    _EXTRA=plot_props)

y = new_shifts[1,*,a]
y = shifts[1,*,a]
p = plot( ind, y[ind], $
    color='dark orange', $
    symbol='circle', sym_filled=1, sym_size=0.5, $
    /overplot)


;plot_shifts, shifts, new_shifts
stop




;; Apply new shifts to cube
;;  (after confirming previous shifts look correct).
;new_shifts[0,311,0] = mean( [ new_shifts[0,310,0], new_shifts[0,312,0]] )
a = 0
for i = 0, sz[2]-1 do begin
    cube[*,*,i] = shift_sub( $
        cube[*,*,i], $
        new_shifts[0,i,a], new_shifts[1,i,a])
endfor
stop


end
