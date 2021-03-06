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


; colors to match AIA colors (probably not for publications, but may
;  help me to keep track of which curves go with which data.
A[0].color = 'olive drab'
A[1].color = 'indian red'

wx = 11.0
wy = 8.5
dw
win = window( dimensions=[wx,wy]*dpi, buffer=0 )

time = strmid(A[0].time,0,5)
;margin=[1.0, 3.0, 1.0, 3.0]
position = get_position( $
    layout=[1,1,1], $
    left=1.25, right=1.25, $
    width=8.5, height=3.0 )

print, position

yshift = -2.0
position = position + [0.0, yshift, 0.0, yshift ]

; #s for shifting flux from both channels in y
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
        ;margin=margin*dpi, $
        position=position*dpi, $
        xtickinterval=75, $
        ymajor=7, $
        xticklen=0.025, $
        yticklen=0.010, $
        xtitle='index', $
        stairstep=1, $
        color=A[i].color, $
        name=A[i].name )
    p[i].Order, /bring_to_front
endfor


ax = p[0].axes

;gridstyle=1, $
;subgridstyle=1, $

;ax[0].ticklen=0.001
;ax[0].tickvalues = (ax[0].tickvalues)[1:*]
;ax[0].minor=0

ax[2].ticklen=1.0
ax[2].subticklen=0.01
ax[2].color='light gray'

ax[3].ticklen=1.0
ax[3].subticklen=0.005
ax[3].color='light gray'

ax[1].coord_transform = [aa[0],bb[0]]
ax[1].title='1600$\AA$ (DN s$^{-1}$)'
ax[3].coord_transform = [aa[1],bb[1]]
ax[3].title='1700$\AA$ (DN s$^{-1}$)'
ax[3].text_color='black'
ax[3].showtext = 1

ax[2].tickname = time[ax[0].tickvalues]
ax[2].title = 'index.date_obs'
ax[2].minor = 5
ax[2].text_color='black'
ax[2].showtext = 1


pos = p[0].position * [wx,wy,wx,wy]

;result = p[0].ConvertCoord( pos[2], pos[3], /NORMAL, /TO_DEVICE )
;xx = result[0]/dpi
;yy = result[1]/dpi

xx = pos[2]
yy = pos[3] + 1.0

leg = legend2(  $
    target=[p], $
    position=[xx,yy]*dpi, $
    ;position=[0.83,0.78], $
    /device )
    ;/normal )

v = OPLOT_FLARE_LINES( time, yrange=p[0].yrange, /send_to_back )

save2, 'lightcurve_only.pdf', /add_timestamp
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
