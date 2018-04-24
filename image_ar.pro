;; Last modified:   06 April 2018 23:54:41
; Last modified:   05 April 2018 03:34:33


;pro image_powermaps
;
;    ; Image an array of power maps
;    wx = 1500
;    wy = 1000
;    w = window(dimensions=[wx,wy])
;    @graphics
;    sz = size(map, /dimensions)
;    im = objarr(sz[2])
;    data = map^0.3
;    t = time[locs]
;    for i = 0, sz[2]-1 do begin
;        im[i] = image( $
;            (map[*,*,i])^0.3, $
;            current=1, $
;            max_value=max(data), $
;            title=t[i] + ' - ' + t[i+1], $
;            xtitle='X (pixels)', $
;            ytitle='Y (pixels)', $
;            rgb_table=39, $
;            _EXTRA=image_props $
;        )
;    endfor
;
;    ;pos = im[i].position
;    c = colorbar( $
;        target=im[0], $
;        orientation=1 , $
;        ;major=4, $
;        tickformat='(I0)', $
;        ;position=[ pos[2]+0.005, pos[1], pos[2]+0.025, pos[3] ], $ 
;        position=[0.93,0.1,0.95,0.9], $
;        title="power", $
;        _EXTRA=cbar_props $
;    )
;
;    txt = text( 0.05, 0.9, '('+alph[i]+')', /relative, target=im[i], color='white')
;
;end

pro image_ar, S

    ; Show image with subset outlined by a box.

    layout = [1,2]
    cols = layout[0]
    rows = layout[1]
    sz = size(S.(0).data, /dimensions)

    ; Set width, then set height so that the cube dimensions are conserved.
    ; ... or maybe use that aspect ratio thingy.
    width=4.0
    height=width*( float(sz[1])/sz[0] )

    ; position in pixel values
    position = get_position( layout=layout,width=width,height=height ) ;,$margin=0.1, $

    ; create window object
    win = get_window( position )

    ; initialize array of images
    im = objarr(cols*rows)

    for i = 0, cols*rows-1 do begin

        im[i] = image2( $
            (S.(i).data[*,*,224])^0.5, $
            current=1, $
            /device, $
            position=position[*,i], $
            xtitle = "X (pixels)", $
            ytitle = "Y (pixels)", $
            title=S.(i).name + ' at 01:30' $
            )

        ; Draw rectangle around (temporary) area of interest.
        rec = polygon2( 40, 90, 139, 189, target=im[i])
    endfor
    return

        ; position in relative values
        ;pos = im[i].position 

        ; Label opposite axis in units of arcseconds
;        ax = im[i].axes
;        ax[2].tickname = strtrim(round(ax[0].tickvalues * 0.6), 1)
;        ax[3].tickname = strtrim(round(ax[1].tickvalues * 0.6), 1)
;        ax[2].title = "X (arcseconds)"
;        ax[3].title = "Y (arcseconds)"
;        ax[2].showtext = 1
;        ax[3].showtext = 1

        ; comparing array to itself, rather than pulling im[i].position.
        ; Data types and unit conversions caused comparisons like this
        ; to never be true, and I don't have time to try and figure it out.
        ;if position[1,i] ne min(position[1,*]) then im[i].xshowtext=0
        ;if position[0,i] ne min(position[0,*]) then im[i].yshowtext=0

        ; Use methods or whatever to grab current graphics
        ;    as a way to attach text, e.g. to a plot.
        ; Shouldn't need to feed the data back and forth.
        txt = [ '(a)', '(b)' ]
        t = text2( $
            position[0,i], position[3,i], $  ; upper left corner of each panel
            ;0.03, 0.9, $
            txt[i], $
            device=1, $
            ;relative=1, $
            target=im[i], $
            vertical_alignment=1.0, $
            color='white' $
        )

end



pro image_color, A

    ; 2018 April 19
    ; updated April 23

    common defaults
    t_array = [ ' 00:00:42.57 UT', ' 00:00:32.21 UT' ]

    wx = 8.5/2
    wy = wx * (330./500.) * 2

    im = objarr(2)
    w = window( dimensions=[wx,wy]*dpi )

    for i = 0, 1 do begin

        data = A[i].data[*,*,0]
        im[i] = image2( $
            data^0.5, $
            /device, $
            /current, $
            layout=[1,2,i+1], $
            margin=[0.50, 0.75, 0.2, 0.75]*dpi, $
            rgb_table=A[i].ct, $
            title=A[i].name + ' 2011-February-15 ' + t_array[i], $
            xtitle='X (pixels)', $
            ytitle='Y (pixels)', $
            name=A[i].name $
        )
        ; Draw rectangle around (temporary) area of interest.
        rec = polygon2( 40, 90, 139, 189, target=im[i])
    endfor
    return
    w.save, '~/color_images.pdf', width=wx, height=wy, page_size=[wx,wy]
end

image_color, A


end
