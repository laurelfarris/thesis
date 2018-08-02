; Last updated:     29 July 2018

function  PLOT_LIGHTCURVES_ONLY, ind, data, time, _extra=e

    common defaults

    width = 6.5
    height = 2.5
    wx = 8.5
    wy = 3.5
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )
    position = get_position( layout=[1,1,1], width=width, height=height  )

    color = [ 'dark orange', 'dark cyan' ]
    name = [ 'AIA 1600$\AA$', 'AIA 1700$\AA$' ]

    aa = [ min(data[*,0]), min(data[*,1]) ]
    slope = 1.0
    bb = [ slope, slope ]

    p = objarr(2)
    for i = 0, n_elements(p)-1 do begin
        ydata = ( data[*,i] - aa[i] ) / bb[i]
        p[i] = plot2(  $
            ind, ydata, $
            /current, $
            /device, $
            overplot=i<1, $
            position=position*dpi, $
            xtickinterval=75, $
            yrange=[ min(ydata), max(ydata)+0.5*max(ydata) ], $
            xminor=5, $
            ymajor=7, $
            xticklen=0.025, $
            yticklen=0.010, $
            stairstep=1, $
            xshowtext=1, $
            yshowtext=1, $
            color=color[i], $
            name=name[i], $
            xtitle='index', $
            _EXTRA=e )
    endfor
    ax = p[0].axes
    ax[1].coord_transform = [aa[0],bb[0]]
    ax[3].coord_transform = [aa[1],bb[1]]

    return, p
end

goto, start

windows = GetWindows(/current)
if n_elements(windows) eq 0 then begin
    win = window( dimensions=[wx,wy]*dpi, location=[300,0] )
endif else begin
    win = windows[0]
    win.erase
endelse


START:;---------------------------------------------------------------------------------

dz = 64
time = strmid(A[0].time,0,5)

;file = 'lightcurve_only'
file = 'power_only'

case file of
    'lightcurve_only' : begin
        p = plot_lightcurves_only( [0:748], A.flux, time )
        yr = p[0].yrange
        pad = 0.1 * (yr[1]-yr[0])
        p[0].yrange = [ yr[0] - 0.5*pad, yr[1] + 4.*pad ]
        yr = p[0].yrange
        ytitle = ['1600$\AA$ (DN s$^{-1}$)', '1700$\AA$ (DN s$^{-1}$)']
        end
    'power_only' : begin
        ;power = alog10(A.power_flux)
        power = A.power_maps
        ;power = alog10(A.power_maps)
        p = PLOT_LIGHTCURVES_ONLY( [32:748-32-1], power, time, xrange=[0,748] )
        ytitle = ['1600$\AA$ 3-min power', '1700$\AA$ 3-min power' ]
        ;ytitle = ['log 1600$\AA$ 3-min power', 'log 1700$\AA$ 3-min power' ]
        end
endcase

v = OPLOT_FLARE_LINES( time, yrange=p[0].yrange, /send_to_back, color='light gray' )

    dz_axis = axis( $
        'X', $
        axis_range=[ dz, dz*2 ], $
        location=(p[0].yrange)[1] - 0.2*(p[0].yrange)[1], $
        major=2, $
        minor=0, $
        tickname=['',''], $
        title='$T=64$', $
        tickdir=1, $
        textpos=1, $
        ;tickdir=(i mod 2), $
        tickfont_size = fontsize )

p[1].GetData, x, y

ax = p[0].axes

ax[0].tickname = time[ax[0].tickvalues]
ax[0].title = 'Start time (UT) on 2011-February-15'

ax[1].title=ytitle[0]

ax[3].title=ytitle[1]

pos = p[0].position
leg = legend2(  $
    target=[p,v], /normal, $
    position = [ pos[2]*0.90, pos[3]*0.97 ], $
    ;position=[ position[2]-0.25, position[3]-0.25 ]*dpi, $
    sample_width=0.2)

save2, file + '.pdf' ;, /add_timestamp
stop

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

end
