;; Last modified:   15 February 2018 00:09:57


function power_maps, data, indices, cadence, T, dT

    ;; returns a power map for ONE channel.

    ;; Need to be able to call this 

    sz = size( data, /dimensions )
    n = n_elements(indices) - 1
    map = fltarr( sz[0], sz[1], n )

    ;print, systime()
    for i = 0, n-1 do begin

        t1 = indices[i]
        t2 = indices[i+1]-1

        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin

            result = fourier2( data[x,y,t1:t2], cadence )
            ;result = fourier2( data[x,y,t1:t2], cadence, /norm)
            frequency = reform( result[0,*] )
            power = reform( result[1,*] )
            period = 1./frequency

            f1 = 1./(T+dt)
            f2 = 1./(T-dt)
            ;f1 = 0.0048
            ;f2 = 0.0058

            ind = where( frequency ge f1 AND frequency le f2 )

            ;map[x,y,i] = total( power[ind] )
            map[x,y,i] = mean( power[ind] )

        endfor
        endfor
    endfor
    ;print, systime()
    ;print, 1./(frequency[ind]), format='(F0.6)'
    print, ind
    return, map
end

GOTO, start

dat = [ $
[[S.(0).data[*,*,72]]],  $
[[S.(0).data[*,*,224]]],  $
[[S.(0).data[*,*,376]]],  $
[[S.(1).data[*,*,72]]],  $
[[S.(1).data[*,*,224]]],  $
[[S.(1).data[*,*,376]]] ]

;; Really need to separate data from graphics...


start:;-----------------------------------------------------------------------------
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
