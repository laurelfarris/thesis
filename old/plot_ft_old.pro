; Last modified:   06 February 2018 13:32:26


;; Last modified:   04 October 2017 18:54:23

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.



; 2018-04-24
; This involves a lot of graphics techniques that I no longer use.
; But I think it's also the same code I used to produce FFT
; figures in proposal. So will keep for log purposes.


pro plot_fft, flux, cad, props, i, zoomin=zoomin


    ;; Zoom in
    if keyword_set( zoomin ) then begin
        T = 210.
        dT = 120.
        zi = where( period ge T-dT AND period le T+dT )
        x = x[zi]
        y = y[zi]
        props.ylog = 0
        props.yrange = [0.0, 1.0]
        ;props.yrange = [0.0003, 6.1]
        props.ytitle = "power (normalized)"
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]
    endif else begin
        props.ytitle = "log power (normalized)"
        tvalues = (1./60.)/[2.0, 3.0, 4.0, 5.0]
    endelse

    b = 0.08
    l = 0.10
    t = 0.1
    r = 0.01
    gap = 0.02
    pos = positions( 3, 3, b, l, t, r, gap )
    pos = pos[*,i-1]


    ;; Make plots
    p = plot( x, y, /current, $
        position=pos, $
        _EXTRA=props )

    ;; Axes
    ax = p.axes
    if pos[0] ne l then ax[1].showtext = 0
    if pos[1] ne b then ax[0].showtext = 0

    ;; Add vertical line at 3-min
    f3 = 1./180.
    f5 = 1./300.
    v1 = props.yrange[0]
    v2 = props.yrange[1]
    vert = plot( [f3, f3], [v1,v2], linestyle=2, /overplot ) 
    vert2 = plot( [f5, f5], [v1,v2], linestyle=2, /overplot ) 

    ;; Add axis to show period
    ; convert desired periods (min) to Hz to find locs on x-axis
    nmaj = n_elements(tvalues)
    ax[2].major = nmaj
    ax[2].minor = 5
    ax[2].tickvalues = tvalues
    if pos[3] ge (1.0-t) then begin
        ax[2].showtext = 1
        ax[2].title = "period [min]"
        ax[2].tickname = reverse( string( (1./tvalues)/60., format='(F6.1)' ) )
    endif
    ;if (i le 3) then ax[2].title = "period [min]" else ax[2].title = ""
    ;period_label = GET_LABELS( period_min, nmaj )
    ;ax[2].tickname = string( period_label, format='(F6.1)' )

    
    ;; Column lables (HMI, AIA 1600, AIA 1700)
    ty = 1.0 - t/3.0
    tx = pos[0] + (pos[2]-pos[0])/2
    titles = ["HMI","AIA 1600$\AA$","AIA 1700$\AA$"]
    text_props = { $
         font_size:fontsize+1, $
         font_name:fontname, $
         font_style:2, $
         alignment:0.5 }
    if i eq 1 then t = text( tx, ty, titles[0], _EXTRA=text_props )
    if i eq 2 then t = text( tx, ty, titles[1], _EXTRA=text_props )
    if i eq 3 then t = text( tx, ty, titles[2], _EXTRA=text_props )


    ;; Better way, except IDL thinks the titles should go right on
    ;; top of the axis labels... also not using the same font :(
    ;;     29 Sep 2017
    ;if i eq 7 then p.title="HMI"
    ;if i eq 8 then p.title="AIA 1600"
    ;if i eq 9 then p.title="AIA 1700"


end



pro ARRS, S, frequency, power

    ; assign array and result to proper structure.
    ; This bit goes in its own subroutine as well.
    dz = 50
    z = [0:224:9]
    result = fourier2( indgen(dz), S.cadence )
    frequency = reform( result[0,*] )
    power = fltarr( n_elements(z), n_elements(frequency) )

    for i = 0, n_elements(z)-1 do begin
        result = fourier2( S.flux[i:i+dz], S.cadence )
        power[i,*] = result[1,*]
    endfor
    ; get indices of frequencies of interest for plotting.
    ;period = 1./frequency
    ;locs = where( period gt 110 AND period lt 210 )
    ;period = period[locs]
end


goto, start

ARRS, aia1700, frequency, power

aia1700 = create_struct( aia1700, $
    'frequency', frequency, $
    'power', power )


stop

start:;-----------------------------------------------------------------------------------

; txt = text( string='S.(i).time[z]'
@graphics
cols = 3
rows = 3

;zoomin=1
; Periods of interest (seconds)
;power = power[locs]
int = 1./[120,180,200]

position = get_position( $
    layout=[cols,rows],  $
    margin=1.0, $
    width=1.7, $
    height=1.7 $
)
win = get_window( position )
dims = win.dimensions

p1 = objarr(rows*cols)
p2 = objarr(rows*cols)
for i=0, rows*cols-1 do begin

    p1[i] = plot( $
        S.(0).frequency, S.(0).power[i,*], /current, /device, $
;        layout=[cols,rows,i+1], margin=0.10, $
;        yrange=[min(S.(1).power), max(S.(1).power)], $
        position=position[*,i], $
        xtitle = "frequency (Hz)", $
        ytitle = "Log(power)", $
        ylog = 1, $
        xshowtext=0, $
        yshowtext=0, $
        thick = 1.5, $
        color = S.(0).color, $
        _EXTRA=plot_props)

    p2[i] = plot( $
        S.(1).frequency, S.(1).power[i,*], /overplot, $
        ;ylog = 1, $
        thick = 1.5, $
        color = S.(1).color, $
        _EXTRA=plot_props)

    ; Show start time of each power spectrum
    txt = text( $
        0.9, 0.85, S.(0).time[z[i]], /relative, $
        alignment=1.0, $
        font_size=9, target=p1[i], color='black' $
    )

    ; overplot vertical lines at 120, 180, and 200 seconds.
    for j=0,n_elements(int)-1 do begin
        v = plot( $
            [int[j],int[j]], $
            p2[i].yrange, $
            /overplot, $
            linestyle=j+1 )
    endfor
    
    ax = p1[i].axes
    ;pos = p1[i].position * [ dims[0], dims[1], dims[0], dims[1] ]
    pos = round(p1[i].position * [ dims[0], dims[1], dims[0], dims[1] ])
    if pos[0] le round(min(position[0,*])) then ax[1].showtext=1
    if pos[1] le round(min(position[1,*])) then ax[0].showtext=1

endfor



end
