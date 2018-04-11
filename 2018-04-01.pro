;; Last modified:   15 February 2018 00:09:57


GOTO, start

; 01 April 2018

restore, '../aia_1600_aligned.sav'
;  -->  cube [ 1000 1000 750 ]

cube = crop_data(cube) ; using function in prep.pro
cube = cube[*,*,1:*]
stop

; This can go after determining dz and array of available freq's.
temp = cube[40:139, 90:189, *]
;step, temp

;sz = size(temp, /dimensions)
cadence = 24

;; First step - figure out dt (or dz, for image #) and d\nu.

; dt = whatever, then just calculate what dz would be?
dz = 50

; Run fourier2 once just to get array of possible frequencies/periods
result = fourier2( temp[0, 0, 0:dz], cadence )
frequency = reform( result[0,*] )
period = 1./frequency

T = 180.
t1 = (where( period gt T ))[-1]
t2 = (where( period lt T ))[ 0]

stop

; Final product of previous mess.
f1 = frequency[t1]
f2 = frequency[t2]
ind = where( frequency ge f1 AND frequency le f2 )

; So don't know how to write test routines, but can at least
; put little bits like this here and there as "mini tests".
if n_elements(ind) ne n_elements(period[t1:t2]) then $
    print, "Screwed up somewhere."
stop

;; Next step - power maps
; tt = 'total time', or number of steps forward to take.
; may not be the best variable name... ft is over a range of time,
; so is total time the first start to the last finish? or in the middle of
;  each segment?


; Adding 100 to calculate 100 MORE maps for temp (cropped cube).
tt = indgen(100) + 100
;tt = [0:175:5]

sz = size(temp, /dimensions)



map2 = [ [[map]], [[fltarr( sz[0], sz[1], n_elements(tt) )]] ]
;sz = size(cube, /dimensions)
;aia1600map = fltarr( sz[0], sz[1], n_elements(tt) )
stop

; Loop through all pixels to get power map.
; This only needs to deal with frequencies... period is for the user.
; Determine periods outside this loop (above).

; Map needs to increment by 1 for each loop, but tt doesn't necessarily
; increase by 1. Hence, the second variable j.


foreach i, tt, j do begin
    for y = 0, sz[1]-1 do begin
    for x = 0, sz[0]-1 do begin
        power = (fourier2( temp[x, y, i:i+dz], cadence ))[1,*]
        ;aia1600map[x,y,j] = total( power[ind] )
        map2[x,y,i] = total( power[ind] )
    endfor
    endfor
endforeach
stop


;; Step 3 - show power map

time = strmid(a6index.t_obs,12,10)
powertime = time[ tt ]
stop


rows = 5
cols = 5
counter = n_elements(tt)/(rows*cols)
arr = [0:n_elements(tt)-1:counter]
sz = size(map2, /dimensions)


; Came up with an even better version of this in mywindow.pro
wy = 1100.
wx = wy * (float(sz[0])/sz[1]) * float(cols)/rows
if wx gt 1920 then begin
    wx = 1920
    wy = wx * (float(sz[0])/sz[1]) * float(rows)/cols
endif
if wy gt 1100 then print, "We have a problem!"
; Another mini test! Always think to myself, aw gee, what if this messes
; up? Should have just written a few lines to check!



win = window( dimensions=[wx,wy] )
@graphics
im = objarr(rows*cols)
arr = [0:199:8]
foreach i, arr, j do begin
    im[j] = image( $
        ;(aia1600map[*,*,i])^0.5, $
        (map2[*,*,i])^0.5, $
        /current, $
        layout=[cols, rows, j+1], $
        margin=0.01, $
        rgb_table=39, $
        xshowtext=0, $
        yshowtext=0, $
        _EXTRA=image_props $
    )
endforeach
stop

foreach i, arr, j do begin
    ;print, powertime[i]
    txt = text(  $
        0.1, 0.9, $
        ;powertime[i],  $
        time[i], $
        font_size=9, $
        /relative, $
        target=im[j], $
        color='white' $
    )
endforeach
stop


;; Step: plot total power as function of starting image (not time yet)



;gr = [135, 175, 095]
;gr = [095, 135, 095]
gr = [135, 175, 135]
;gr = [095, 135, 000]
bk = [000, 000, 000]
wh = [255, 255, 255]

colortest = intarr(256,256)
for i = 0, 255 do colortest[i,*] = i

ct = colortable( [[bk],[gr],[wh]] );, $
    ;indices=[42,127,212] ); $
    ;stretch=[0,-50] $
    ;)


;im = image( colortest, layout=[1,1,1], margin=0.0, rgb_table=ct)

im = image( (cube[*,*,0])^0.3, $
    xtitle='X (pixels)', $
    ytitle='Y (pixels)', $
    _EXTRA=image_props $
);rgb_table=ct )

rec = polygon( [40, 139, 139, 40], [90, 90, 189, 189], $
    target=im, $
    /data, $
    fill_transparency=100, $
    linestyle='--', $
    ;thick=1,
    color='white' $
)

    
ax = im.axes
ax[2].showtext = 1
ax[3].showtext = 1

ax[2].tickname = strtrim( round(ax[0].tickvalues * 0.6), 1 )
ax[3].tickname = strtrim( round(ax[1].tickvalues * 0.6), 1 )
ax[2].title = 'X (arcseconds)'
ax[3].title = 'Y (arcseconds)'

start:;-----------------------------------------------------------------------------
    txt = text(  $
        0.1, 0.9, $
        ;powertime[i],  $
        time[0], $
        font_size=9, $
        /relative, $
        target=im, $
        color='white' $
    )
stop



xdata = indgen(200)
totalpower = total( total(map2,1), 1 )
ydata = totalpower
;ydata = reform(map2[50,50,*])


@graphics
win = window( dimensions=[1200, 800] )

p = plot( $
    xdata, $
    ydata, $
    /current, $
    xtickvalues=[0:199:25], $
    xtickname=time[0:199:25], $
    xtitle='observation time (15 February 2011)', $
    ytitle='3-minute power', $
    _EXTRA=plot_props $
)
;xind = fix(p.xtickvalues)
;p.xtickname=time[0:100:]


; now what if I want to increase the cycles, as in,
; start where tt left off and continue? Don't want to calculate the
; first few all over again...
; If power_map.pro was a subroutine like the above loop, and was
; being called with tt as one of the input variables,
; could input tt as an array, e.g. indgen(50), then again as
; indgen(50) + tt.


stop;-----------------------------------------------------------------------------------
;; All this should be a 'note' for 2018-03-29


; 29 March 2018 

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
