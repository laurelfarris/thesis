; 24 July 2018

; Reference figure:  make vertical lines thinner.

goto, start

windows = GetWindows(/current)
if n_elements(windows) eq 0 then begin
    win = window( dimensions=[wx,wy]*dpi, location=[300,0] )
endif else begin
    win = windows[0]
    win.erase
endelse

;print, min(A[0].flux)/1e7
;print, max(A[0].flux)/1e7
;print, min(A[1].flux)/1e7
;print, max(A[1].flux)/1e7
;width = (p.position)[2] - (p.position)[0]
;height = (p.position)[3] - (p.position)[1]


START:;---------------------------------------------------------------------------------

dz = 64
wx = 8.5
wy = 3.5
dw
width = 6.5
height=2.5
win = window( dimensions=[wx,wy]*dpi, /buffer )
position = get_position( layout=[1,1,1], width=width, height=height  )

time = strmid(A[0].time,0,5)
margin=[1.0, 3.0, 1.0, 3.0]*dpi
aa = [ min(A[0].flux), min(A[1].flux) ]
slope = 1.0
bb = [ slope, slope ]

p = objarr(2)
for i = 0, n_elements(p)-1 do begin
    flux = ( A[i].flux - aa[i] ) / bb[i]
    p[i] = plot2(  $
        [0:748], flux, $
        /current, $
        /device, $
        overplot=i<1, $
        position=position*dpi, $
        xtickinterval=75, $
        xminor=5, $
        ymajor=7, $
        xticklen=0.025, $
        yticklen=0.010, $
        stairstep=1, $
        xshowtext=1, $
        yshowtext=1, $
        color=A[i].color, $
        xtitle='index', $
        name=A[i].name )
endfor

yr = p[0].yrange
pad = 0.1 * (yr[1]-yr[0])
p[0].yrange = [ yr[0] - 0.5*pad, yr[1] + 4.*pad ]
yr = p[0].yrange

v = OPLOT_FLARE_LINES( time, yrange=p[0].yrange, /send_to_back, color='light gray' )

p[1].GetData, x, y

z_start = [0, 50, 150, 200, 280, 370, 430, 525, 645] 
dz_scale = objarr(n_elements(z_start))
foreach zz, z_start, i do begin
    axis_range=[ zz, zz+16+dz ]
    modd = i mod 2
    dz_scale[i] = axis( $
        'X', $
        axis_range=axis_range, $
        location=max( y[ axis_range[0]:axis_range[1] ]) + 2.*pad, $
        ;location=yr[0]-(2.0-modd)*pad, $
        major=2, $
        minor=0, $
        tickname=['',''], $
        title=alph[i], $
        tickdir=1, $
        textpos=1, $
        ;tickdir=(i mod 2), $
        tickfont_size = fontsize ) 
endforeach
dz_scale[1].location = dz_scale[1].location + [0.0, 1.5*pad, 0.0]
dz_scale[4].location = dz_scale[4].location + [0.0, 1.0*pad, 0.0]
dz_scale[5].location = dz_scale[5].location + [0.0, 2.0*pad, 0.0]

ax = p[0].axes

ax[0].tickname = time[ax[0].tickvalues]
ax[0].title = 'Start time (UT) on 2011-February-15'

ax[1].coord_transform = [aa[0],bb[0]]
ax[1].title='1600$\AA$ (DN s$^{-1}$)'

ax[3].coord_transform = [aa[1],bb[1]]
ax[3].title='1700$\AA$ (DN s$^{-1}$)'

leg = legend2(  $
    target=[p,v], /device, $
    position=[ position[2]-0.25, position[3]-0.25 ]*dpi, $
    sample_width=0.2)

save2, 'lightcurve_only.pdf';, /add_timestamp
stop

;print, p[0].xticklen, p[0].yticklen
ticklen = p[0].ConvertCoord( $
    p[0].yticklen, $
    p[0].xticklen, $
    /relative, $
    ;/normal, $
    /to_device )

;; Doesn't work:
;ax[2].Order, /send_to_back
;ax[3].Order, /send_to_back


text_pos = [ $
    0.8 * (p[0].position)[2], $
    0.9 * (p[0].position)[3]  ]
t = TEXT(  $
    text_pos[0], text_pos[1], $
    'slope = ' + strtrim(slope,1), $
    target=p[0], $
    ;vertical_alignment = 'Top', $
    vertical_alignment = 1.0, $
    alignment = 1.0, $
    font_size=9 )


end
