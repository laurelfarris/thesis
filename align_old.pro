;; Last modified:   15 February 2018 20:18:22

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

