; 24 July 2018


; Reference figure:  make vertical lines thinner.

goto, start

print, min(A[0].flux)/1e7
print, max(A[0].flux)/1e7

print, min(A[1].flux)/1e7
print, max(A[1].flux)/1e7

;width = (p.position)[2] - (p.position)[0]
;height = (p.position)[3] - (p.position)[1]

wx = 11.0
wy = 8.5

START:;---------------------------------------------------------------------------------
windows = GetWindows(/current)
if n_elements(windows) eq 0 then begin
    win = window( dimensions=[wx,wy]*dpi, location=[300,0] )
endif else begin
    win = windows[0]
    win.erase
endelse

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
        margin=margin, $
        xtickinterval=75, $
        ymajor=7, $
        xticklen=0.025, $
        yticklen=0.010, $
        stairstep=1, $
        color=A[i].color, $
        xtitle='index', $
        name=A[i].name )
endfor
pos = p[0].position

v = plot_flare_lines( time, p[0].yrange )
for i = 0, n_elements(v)-1 do $
    v[i].Order, /send_to_back

ax = p[0].axes

;gridstyle=1, $
;subgridstyle=1, $

; X axes

;ax[0].ticklen=0.001
;ax[0].tickvalues = (ax[0].tickvalues)[1:*]
;ax[0].minor=0

ax[2].ticklen=1.0
ax[2].subticklen=0.01
ax[2].color='light gray'
ax[2].text_color='black'

ax[2].tickname = time[ax[0].tickvalues]
ax[2].title = 'index.date_obs'
ax[2].minor = 5
ax[2].showtext = 1

; Y axes

;ax[1].tickvalues = (ax[1].tickvalues)[1:*]
ax[1].coord_transform = [aa[0],bb[0]]
ax[1].title='1600$\AA$ (DN s$^{-1}$)'

ax[3].ticklen=1.0
ax[3].subticklen=0.005
ax[3].color='light gray'
ax[3].text_color='black'

ax[3].coord_transform = [aa[1],bb[1]]
ax[3].title='1700$\AA$ (DN s$^{-1}$)'
ax[3].showtext = 1


result = p[0].ConvertCoord( $
    pos[2], pos[3], /NORMAL, /TO_DEVICE )
xx = result[0]/dpi
yy = result[1]/dpi

;0.86,0.92
leg = legend2(  $
    target=[p], $
    ;position=([xx,yy]-0.5)*dpi, $
    position=[0.83,0.78], $
    ;/device )
    /normal )

print, p[0].xticklen, p[0].yticklen
ticklen = p[0].ConvertCoord( $
    p[0].yticklen, $
    p[0].xticklen, $
    /relative, $
    ;/normal, $
    /to_device )


ax[2].Order, /send_to_back
ax[3].Order, /send_to_back

save2, '_reference_figure.pdf', /add_timestamp
stop


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
