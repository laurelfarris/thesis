;; Last modified:   21 July 2017 15:59:29

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



function PLOT_POWER_SPECTRUM, data, delt
    ;; Plot power spectrum as function of output frequencies
    ;; data = 1D array

    result = fourier2( data, delt, /norm )

    fr = result[0,*]
    period = 1./fr
    power_spectrum = result[1,*]
    phase = result[2,*]
    amplitude = result[3,*]

    @graphic_configs

    ;; Plot power vs. frequency
    plot_props.current = 1
    plot_props.xtitle = "frequency [Hz]"
    plot_props.ytitle = "power"


    ;; "Passband" of periods: +/- 15 seconds around 180.
    t_delt = 15.0
    f1 = (1./(180+t_delt))
    f2 = (1./(180-t_delt))
    i1 = ( where( fr gt f1) )[0]
    i2 = ( where( fr lt f2) )[-1]

    ;; Zoom in on 3-min power
    p = objarr(2)
    w = window()
    x = fr
    y = power_spectrum
    p[0] = plot( x, y, layout=[1,2,1], margin=0.1, _EXTRA=plot_props)

    ;; Vertical line at maximum power
    px = reverse([ f1,f1,f2,f2 ])
    py = reverse([ min(y), max(y), max(y), min(y) ])

    pol = polygon( px, py, /data, $
        ;color=blue, $
        linestyle=1, $
       transparency=0, $
        fill_background=1, $
        ;fill_color=red, $
        fill_transparency=90 )

    x = fr[i1:i2]
    y = power_spectrum[i1:i2]
    p[1] = plot( x, y, layout=[1,2,2], margin=0.1, $
        ;xrange = [f1, f2], yrange = [-0.2, 0.5], $
        _EXTRA=plot_props)
end


GOTO, START

lc = objarr(1)

@graphic_configs
plot_props.ystyle = 2
plot_props.xtitle="UT time (15 February 2011)"
plot_props.ytitle="Flux"

time = strmid( hmi_index.date_obs, 11, 5 )
xm = 5
N = n_elements(time)
x = []
for i = 0, N-1, N/xm do begin
   x = [x, time[i]] 
endfor

dw
w = window(dimensions=[800,400])
lc[0] = plot( aia_1600_flux_all, /current, xmajor=xm,  xtickname=x, $
    _EXTRA=plot_props)
lc[1] = plot( aia_1700_flux_all, /overplot, _EXTRA=plot_props )

STOP



fontsize = 10
fontname = "Helvetica"
plot_props = { $
    current    : 1, $
    margin : 0.1, $
    device     : 0, $
    title      : "", $
    xtitle      : "UT time (15 February 2011)", $
    ytitle      : "Flux", $
    axis_style : 2, $
    xstyle : 1, $
    ystyle : 2, $
    ;xrange     : [0,0], $
    ;yrange     : [-0.1,1.5], $
    ;xmajor : 3, $
    ;ymajor : 7, $
    ;xtickdir   : 0, $
    ;ytickdir   : 0, $
    ;xticklen : 0.03,$
    ;yticklen : 0.03, $
    ;xminor : 5, $
    ;yminor : 5, $
    xtickfont_size : fontsize-1, $
    ytickfont_size : fontsize-1, $
    ;xtickformat: '(F6.3)', $
    ;ytickformat: '(F5.1)', $
    font_name   : fontname, $
    font_size  : fontsize+1 $
    }


w = window(dimensions=[800,600])
ydat = hmi_flux_all
time = strmid( hmi_index[22:*].date_obs, 11, 5 )
xm = 5
N = n_elements(time)
x = []
for i = 0, N-1, N/xm do begin
   x = [x, time[i]] 
endfor
hmi_lc = plot( ydat, layout=[1,2,1], /current, xmajor=xm,  xtickname=x, $
    _EXTRA = plot_props)

lc = objarr(2)

time = strmid( aia_1600_index.date_obs, 11, 5 )
xm = 5
N = n_elements(time)
x = []
for i = 0, N-1, N/xm do begin
   x = [x, time[i]] 
endfor
print, x

ydat = aia_1600_flux_all;/max(aia_1600_flux_all)
lc[0] = plot( ydat, layout=[1,2,2], /current, xmajor=xm, xminor=10, xtickname=x, $
    _EXTRA=plot_props)
ydat = aia_1700_flux_all;/max(aia_1700_flux_all)
lc[1] = plot( ydat, /overplot, _EXTRA=plot_props )

t = text( 0.3, 0.15, "AIA 1600$\AA$", font_size=fontsize-1, font_name=fontname )
t = text( 0.3, 0.35, "AIA 1700$\AA$", font_size=fontsize-1, font_name=fontname)
t = text( 0.3, 0.85, "HMI", font_size=fontsize-1, font_name=fontname)
;ydat = hmi_flux_all/max(hmi_flux_all)
;hmi_lc = plot( ydat, axis_style=4, /current)


;?
result = fourier2( hmi_flux_before, hmi_delt, /norm )
print, get_indices( result, hmi_delt )
result = fourier2( aia_1600_flux_before, aia_delt, /norm )
print, get_indices( result, aia_delt )


;; Fourier power spectrum plots----------------------------------------------------------------------

hmi_fa_before = fourier2( hmi_flux_before, hmi_delt, /norm )
hmi_fa_during = fourier2( hmi_flux_during, hmi_delt, /norm )
hmi_fa_after = fourier2( hmi_flux_after, hmi_delt, /norm )
aia_1600_fa_before = fourier2( aia_1600_flux_before, aia_delt, /norm )
aia_1600_fa_during = fourier2( aia_1600_flux_during, aia_delt, /norm )
aia_1600_fa_after = fourier2( aia_1600_flux_after, aia_delt, /norm )
aia_1700_fa_before = fourier2( aia_1700_flux_before, aia_delt, /norm )
aia_1700_fa_during = fourier2( aia_1700_flux_during, aia_delt, /norm )
aia_1700_fa_after = fourier2( aia_1700_flux_after, aia_delt, /norm )




START:
fontsize = 9
fontname = "Helvetica"

plot_props = { $
    current    : 1, $
    margin : 0.0, $
    device     : 0, $
    title      : "", $
    xtitle      : "", $
    ytitle      : "", $
    axis_style : 2, $
    xstyle : 1, $
    ystyle : 1, $
;        xrange     : [0,0], $
    yrange     : [-0.1,1.5], $
    xmajor : 3, $
    ymajor : 7, $
    xtickdir   : 0, xticklen : 0.03, xminor : 5, xtickfont_size : fontsize-1, $
    ytickdir   : 0, yticklen : 0.03, yminor : 5, ytickfont_size : fontsize-1, $
    ;xtickformat: '(F6.3)', $
    ytickformat: '(F5.1)', $
    font_name   : fontname, $
    font_size  : fontsize+1 $
    }



plot_props.margin=0.15
plot_props.xstyle = 2
plot_props.ystyle = 2

w = window(dimensions=[800,800])
p = objarr(9)

xmin = 1./(180+15)
xmax = 1./(180-15)

plot_props.title="HMI"
fr = hmi_fa_before[0,*]
ps = hmi_fa_before[1,*]
vx = [1./180, 1./180]
vy = [-0.1,max(ps)]

p[0] = plot( fr, ps, layout=[3,3,1], _EXTRA=plot_props, $
    ;xrange=[fr[21], fr[24]])
    xrange=[xmin, xmax])
plot_props.title="AIA 1600$\AA$"
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1600_fa_before[0,*]
ps = aia_1600_fa_before[1,*]
p[1] = plot( fr, ps, layout=[3,3,2], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
plot_props.title="AIA 1700$\AA$"
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1700_fa_before[0,*]
ps = aia_1700_fa_before[1,*]
p[2] = plot( fr, ps, layout=[3,3,3], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
plot_props.title=""
vert = plot(vx,vy,/overplot, linestyle=1)

fr = hmi_fa_during[0,*]
ps = hmi_fa_during[1,*]
p[3] = plot( fr, ps, layout=[3,3,4], _EXTRA=plot_props, $
    ;xrange=[fr[21], fr[24]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1600_fa_during[0,*]
ps = aia_1600_fa_during[1,*]
p[4] = plot( fr, ps, layout=[3,3,5], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1700_fa_during[0,*]
ps = aia_1700_fa_during[1,*]
p[5] = plot( fr, ps, layout=[3,3,6], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

fr = hmi_fa_after[0,*]
ps = hmi_fa_after[1,*]
p[6] = plot( fr, ps, layout=[3,3,7], _EXTRA=plot_props, $
    ;xrange=[fr[21], fr[24]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1600_fa_after[0,*]
ps = aia_1600_fa_after[1,*]
p[7] = plot( fr, ps, layout=[3,3,8], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

fr = aia_1700_fa_after[0,*]
ps = aia_1700_fa_after[1,*]
p[8] = plot( fr, ps, layout=[3,3,9], _EXTRA=plot_props, $
    ;xrange=[fr[24], fr[28]])
    xrange=[xmin, xmax])
vert = plot(vx,vy,/overplot, linestyle=1)

p[3].ytitle = "Power"
p[7].xtitle = "Frequency [Hz]"



end
