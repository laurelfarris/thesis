
read_my_fits, '1600', index=a6index
time = strmid(a6index.t_obs,11,5)

;restore, '../Sav_files/aia_1600_misaligned.sav'
;  -->  cube [ 800 800 750 ]

restore, '../aia_1600_aligned.sav'
;  -->  cube [ 1000 1000 750 ]

cube = crop_data(cube) ; using function in prep.pro
cube = cube[*,*,1:*]
stop

locs = [0:225:75]
locs = [0:225:50]
map = power_maps( cube, locs, 24, 180, dT=dT)

stop



; The following is old. Really need to separate science from graphics...

dat = [ $
[[S.(0).data[*,*,72]]],  $
[[S.(0).data[*,*,224]]],  $
[[S.(0).data[*,*,376]]],  $
[[S.(1).data[*,*,72]]],  $
[[S.(1).data[*,*,224]]],  $
[[S.(1).data[*,*,376]]] ]


;locs = [12, 35, 58, 81]
locs = [72, 224, 376, 528]

d1 = S.(0).data[50:449, 50:279, *]
d2 = S.(1).data[50:449, 50:279, *]
a6map = power_maps( d1, locs, 24., 180., 9. )
a7map = power_maps( d2, locs, 24., 180., 9. )
map = [ [[a6map]], [[a7map]] ]

sz = size(map, /dimensions)
cols = 1
rows = 1
width=4.0
height=width*( float(sz[1])/sz[0] )
@graphics
im = objarr(cols*rows)
for i = 0, cols*rows-1 do begin
    im[i] = image(map[*,*,i], $
        position=position[*,i], $
        title='Power at three freqs.', $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)', $
        ;ytickvalues=[0:329:100], $
        rgb_table=39, $ 
        _EXTRA=image_props)

    pos = im[i].position
    c = colorbar( $
        target=im[i], $
        orientation=1 , $
        major=4, $
        tickformat='(F0.1)', $
        position=[ pos[2]+0.01, pos[1], pos[2]+0.03, pos[3] ], $ 
        title="Power", $
        _EXTRA=cbar_props)

    if position[0,i] ne min(position[0,*]) then im[i].yshowtext=0
    if position[1,i] ne min(position[1,*]) then im[i].xshowtext=0
    txt = text( 0.05, 0.9, '('+alph[i]+')', /relative, target=im[i], color='white')
endfor


stop

bk = [000,000,000]
gr = [051,102,000]
pk = [102,000,051]
wh = [255,255,255]
gr_table = colortable( [[bk],[gr],[wh]], indices=[0,50,150] );, stretch=)
pk_table = colortable( [[bk],[pk],[wh]] )

@graphics
for i = 0, cols*rows-1 do begin
    im[i] = image((dat[*,*,i])^0.3, $
        position=position[*,i], $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)', $
        ytickvalues=[0:329:100], $
        rgb_table=gr_table, $
        _EXTRA=image_props)

    pos = im[i].position
    c = colorbar( $
        target=im[i], $
        orientation=1 , $
        major=4, $
        tickformat='(F0.1)', $
        position=[ pos[2]+0.01, pos[1], pos[2]+0.03, pos[3] ], $ 
        title="counts", $
        _EXTRA=cbar_props)

    if position[0,i] ne min(position[0,*]) then im[i].yshowtext=0
    if position[1,i] ne min(position[1,*]) then im[i].xshowtext=0
    txt = text( $
        position[0,i], position[3,i], $
        '('+alph[i]+')', $
        font_size=fontsize, $
        /device, $
        vertical_alignment=1.0, $
        target=im[i], $
        color='white')
endfor


stop


@graphics
im = objarr(6)
for i=0,2 do begin

    im[i] = image( $
        a7map[*,*,i], $
        dimensions=[wx,wy], $
        /current, $
        axis_style=2, $
        layout=[1,3,i+1], $
        ;margin=[ 0.2, 0.1, 0.2, 0.1], $
        ;/device, $
        ;margin=96*0.25, $
        ;xshowtext=0, $
        ;yshowtext=0, $
        rgb_table=39, $ 
        _EXTRA=props )

    pos = im[i].position
    c = colorbar( target=im[i], orientation=1 , $
        position=[ pos[2]+0.01, pos[1], pos[2]+0.02, pos[3] ], $ 
        title="Power", font_size=9, textpos=1 )
endfor

stop

    ax = im[i].axes
    if i eq 0 then begin
        ax[2].title = "AIA 1600$\AA$"
        ax[1].title = "Before"
    endif
    if i eq 1 then ax[2].title = "During"
    if i eq 2 then ax[2].title = "After"
    if i eq 3 then ax[1].title = "AIA 1700$\AA$"
    ax[2].showtext=1


;im[0].axes[1].title = "Before"
end
