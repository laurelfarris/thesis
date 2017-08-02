;; Last modified:   21 July 2017 11:36:27

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
        linestyle=2, $
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
lc = objarr(2)

@graphic_configs
plot_props.ystyle = 2
plot_props.xtitle="UT time (15 February 2011)"
plot_props.ytitle="Flux"

time = strmid( aia_1600_index.date_obs, 11, 5 )
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

t = text( 0.2, 0.2, "AIA 1600$\AA$", font_size=fontsize-1, font_name=fontname )
t = text( 0.2, 0.6, "AIA 1700$\AA$", font_size=fontsize-1, font_name=fontname)


START:

result = fourier2( hmi_flux_before, hmi_delt, /norm )
print, get_indices( result, hmi_delt )
result = fourier2( aia_1600_flux_before, aia_delt, /norm )
print, get_indices( result, aia_delt )
STOP


hmi_fa_before = fourier2( hmi_flux_before, hmi_delt, /norm )
hmi_fa_during = fourier2( hmi_flux_during, hmi_delt, /norm )
hmi_fa_after = fourier2( hmi_flux_after, hmi_delt, /norm )
aia_1600_fa_before = fourier2( aia_1600_flux_before, aia_delt, /norm )
aia_1600_fa_during = fourier2( aia_1600_flux_during, aia_delt, /norm )
aia_1600_fa_after = fourier2( aia_1600_flux_after, aia_delt, /norm )
aia_1700_fa_before = fourier2( aia_1700_flux_before, aia_delt, /norm )
aia_1700_fa_during = fourier2( aia_1700_flux_during, aia_delt, /norm )
aia_1700_fa_after = fourier2( aia_1700_flux_after, aia_delt, /norm )



dw
@graphic_configs
plot_props.margin=0.2
plot_props.xstyle = 2
plot_props.ystyle = 2

dim = [250,500]
w = window(dimensions=dim)
p1 = objarr(3)


p1[0] = plot( hmi_fa_before[0,*], hmi_fa_before[1,*], layout=[1,3,1], _EXTRA=plot_props )
p1[1] = plot( hmi_fa_during[0,*], hmi_fa_during[1,*], layout=[1,3,2], _EXTRA=plot_props  )
p1[2] = plot( hmi_fa_after[0,*], hmi_fa_after[1,*], layout=[1,3,3], _EXTRA=plot_props  )
p1[0].title = "HMI"



w = window(dimensions=dim)
p2 = objarr(3)

p2[0] = plot( aia_1600_fa_before[0,*], aia_1600_fa_before[1,*], layout=[1,3,1], _EXTRA=plot_props )
p2[1] = plot( aia_1600_fa_during[0,*], aia_1600_fa_during[1,*], layout=[1,3,2], _EXTRA=plot_props  )
p2[2] = plot( aia_1600_fa_after[0,*], aia_1600_fa_after[1,*], layout=[1,3,3], _EXTRA=plot_props  )
p2[0].title = "AIA 1600$\AA$"


w = window(dimensions=dim)
p3 = objarr(3)
p3[0] = plot( aia_1700_fa_before[0,*], aia_1700_fa_before[1,*], layout=[1,3,1], _EXTRA=plot_props  )
p3[1] = plot( aia_1700_fa_during[0,*], aia_1700_fa_during[1,*], layout=[1,3,2], _EXTRA=plot_props  )
p3[2] = plot( aia_1700_fa_after[0,*], aia_1700_fa_after[1,*], layout=[1,3,3], _EXTRA=plot_props )
p3[0].title="AIA 1700$\AA$"

STOP
;p[3].ytitle = "Power"
;p[7].xtitle = "Frequency [Hz]"


end
