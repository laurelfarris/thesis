; Last modified:   25 April 2018


pro image_all, data, layout=layout, _EXTRA=e


    layout = [1,2]
    cols = layout[0]
    rows = layout[1]
    sz = size(S.(0).data, /dimensions)

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




function add_colorbar

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
end
;
;    txt = text( 0.05, 0.9, '('+alph[i]+')', /relative, target=im[i], color='white')



    wx = 8.5/2
    wy = wx * (330./500.) * 2
    t_array = [ ' 00:00:42.57 UT', ' 00:00:32.21 UT' ]
image_color, A

    w.save, '~/color_images.pdf', width=wx, height=wy, page_size=[wx,wy]

end
