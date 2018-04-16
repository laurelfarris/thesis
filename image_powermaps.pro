

pro image_powermaps, map, name, time, pos
    ; No science here! Just graphics

    ;wy = 1000
    ;total_ratio = (float(sz[0])*cols)/(float(sz[1])*rows)
    ;total_ratio = (sz[0]*cols)/(sz[1]*rows)
    ;wx = wy * total_ratio 

    ;win = window( dimensions=[wx,wy], name=name )
;    fwin = getwindows( names=basename )

    sz = size(pos, /dimensions)

    im = objarr(sz[1])


    ; maybe stop here and return the graphic object,
    ; to be used for plots or images.


    for i = 0, n_elements(im)-1 do begin
    ;for i = 3, 20, 4 do begin
        im[i] = image2( $
            map[*,*,i], $
            /current, $
            ;layout=[cols, rows, i+1], $
            ;margin=0.01, $
            /device, $
            position=pos[*,i], $
;            max_value=max(map), $
            rgb_table=39, $
            xshowtext=0, $
            yshowtext=0 $
        )
        t = text2(  $
            0.070, 0.85, $
            time[i], $
            ;/device, $
            /relative, $
            target=im[i], $
            color='white' $
        )
    endfor


    ;Should put this in a different subroutine, so can play with it
    ;without re-creating entire graphic every time!
    ; Problem - need position... in device coordinates, not relative,
    ; which is always returned from graphic.position for some reason.
    ; Units are bouncing around way too much.
    ;   Pixels? inches? relative?  How to keep this consistent?
    dpi = 96
    gap = 0.05
    cx1 = max(pos[2,*]) + gap*dpi
    cy1 = min(pos[1,*])
    cx2 = cx1 + 0.25*dpi
    cy2 = max(pos[3,*])
    c = colorbar2( $
        target=im[-1], $
        /device, $
        position=[cx1,cy1,cx2,cy2], $
        tickformat='(I0)', $
        title = "power^0.5"$
    )
end




cols = 4
;rows = fix(sz[2]/cols)
rows = 5
width = 2.0
;height = width * sz[1]/sz[0]
height = width * (330./500.)
gap = 0.05
dpi = 96
pos = get_position( $
    cols=cols, $
    rows=rows, $
    margin=[gap, gap, 1.5, gap], $
    width=width,  $
    ratio=(330./500), $
    ;height=height, $
    dpi = 76, $
    xgap=gap, ygap=gap )

; Image power maps
z = [0:199:10]
time = aia1600.time[z]



;image_powermaps, A[0].map^0.5, 'powermaps_AIA1600_zoomed', time
;mysave, 'powermaps_AIA1600_zoomed'
;image_powermaps, A[1].map^0.5, 'powermaps_AIA1700_zoomed', time
;mysave, 'powermaps_AIA1700_zoomed'

map = A[0].map[*,*,z]
image_powermaps, map^0.5, 'powermaps_AIA1600', time, pos

map = A[1].map[*,*,z]
image_powermaps, map^0.5, 'powermaps_AIA1700', time, pos


end
