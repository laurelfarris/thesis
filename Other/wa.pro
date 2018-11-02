; Last modified:   14 July 2018

; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change?

; Wavelet Analysis (WA) - discrete


; To do:      solid vertical lines at 1:30 and 2:30


pro better
    ; (11 Sep 2018) Better way to code this perhaps:

    power1 = result[1,*]
    ; power P = [ p0, p1, ..., p185 ]

    N = n_elements(power1)
    power2 = fltarr(N)

    for i = 0, N-1 do begin
        power2[i] = mean( power[ i : i+dz-1 ] )
    endfor
    ; plot vs. t = [ (dz/2) : N - (dz/2) ]

end



pro CALC_WA, flux, $
    frequency, wmap, $
    cadence=cadence, $
    z=z, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

    ; Input:  flux
    ; Output: wmap (2D) and frequency (1D)

    ; Find available frequencies within bandpass
    result = fourier2( indgen(dz), cadence, norm=norm )
    frequency = reform( result[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]

    n = n_elements(z)
    m = n_elements(frequency)
    wmap = fltarr(n,m)
    step = 1

    for i = 0, n-1, step do begin
        result = fourier2( flux[ z[i] : z[i]+dz-1 ], cadence, norm=norm )
        power = (reform( result[1,*] ))[ind]
        wmap[i,*] = power
    endfor
end

goto, start
start:

resolve_routine, 'oplot_horizontal_lines', /either
resolve_routine, 'oplot_flare_lines', /either
resolve_routine, 'oplot_vertical_lines', /either

wx = 7.5
wy = 9.0
win = GetWindows(/current)
help, win ;; obj (not array), but still has one element [0],
          ;; which is why the following if statement doesn't work.
          ;;if n_elements(win) eq 0 then begin ...
          ;; Trying to access win[1] will generate error.
if win eq !NULL then begin
    win = window( dimensions=[wx,wy]*dpi, buffer=1 )
endif else begin
    win.erase ; if errors here - win may need to be an object, not an array.
endelse


dz = 64  ; length of time segment (#images) over which to calculate FT
fcenter = 1./180
flower = 0.005
fupper = 0.006

; 24 July 2018
; increasing fmax to range shown by Milligan et al. 2017 (fmin is fine).
;fmin = 0.001
 fmin = 0.0025
;fmax = 0.009
 fmax = 0.020

N = n_elements(A[0].flux) - dz

; starting indices/time for each FT (length = # resulting maps)
z_start = [ 0 : N-1 : dz ]

aia_wa_maps = []
for ii = 0, 1 do begin
    CALC_WA, A[ii].flux, $
        frequency, wmap_out, $
        cadence=A[ii].cadence, z=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0
    aia_wa_maps = [ [[aia_wa_maps]], [[wmap_out]] ]
endfor
min_value = min(aia_wa_maps)
max_value = max(aia_wa_maps)

im = objarr(2)
cols = 1
rows = 2
for ii = 0, 1 do begin

    time = strmid(A[ii].time,0,5)

    wmap = aia_wa_maps[*,*,ii]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    X = (findgen(D1)/100)*dz

    inc = (max(frequency) - min(frequency)) / (D2-1)

    Y = 1000. * [ min(frequency) : max(frequency) : inc ]
    n_freq = n_elements(frequency)
    ytickvalues = 1000.*(frequency[0:n_freq-1:4])

    left = 0.75
    right = 1.50
    width = wx - (left + right)
    position = GET_POSITION( layout=[cols,rows,ii+1], $
        left=0.75, $
        right=1.25, $
        width=5.0, height=3.0, ygap=0.75)

    im[ii] = image2( $
        wmap2, X, Y, $
        /current, /device, $
        position=position*dpi, $
        aspect_ratio=0, $
        min_value=alog10(min_value), $
        max_value=alog10(max_value), $
        rgb_table=34, $
        xtitle='image #', $
        ytickvalues=ytickvalues, $
        ytickformat='(F0.1)', $
        yminor=0, $
        ytitle='Frequency (mHz)', $
        title=A[ii].name )

    ;ax = axis('Y', location=max(x),

    ax = im[ii].axes
    ax[3].tickname = strmid( (strtrim(1000./ax[1].tickvalues,1)), 0, 5 )
    ax[3].title = "Period (s)"
    ax[3].showtext = 1


    ;cx1 = (im[ii].position)[2] + 0.01  ;; need to convert to inches
    cx1 = (im[ii].position)[2] + 0.1
    cy1 = (im[ii].position)[1]
    cx2 = cx1 + 0.02
    cy2 = (im[ii].position)[3]
    c = colorbar2( $
        position=[cx1,cy1,cx2,cy2], $
        target=im[ii], $
        tickinterval=1, $
        tickformat='(I0)', $
        minor=1, $
        title='Log Power' )

    ; 24 July 2018 - changing x-axis to show time
    ax = im[ii].axes
    xtickvalues = fix(round(ax[0].tickvalues))
    ax[0].tickname = time[xtickvalues]
    ax[0].title = 'Start time (UT) on 2011-February-15'

    f1 = flower * 1000
    f2 = fcenter * 1000
    f3 = fupper * 1000

    lines = objarr(6)

    h = OPLOT_HORIZONTAL_LINES( $
        im[ii].xrange, [f1,f2,f3], $
        color = 'red', $
        linestyle=[':','--',':'], $
        names=[  $
            '$\nu_{lower} $ = 5.0 mHz', $
            '$\nu_{center}$ = 5.6 mHz', $
            '$\nu_{upper} $ = 6.0 mHz' ] )

    v = OPLOT_FLARE_LINES( time, yrange=im[ii].yrange )
    ;save2, 'wa' + A[ii].channel + '.pdf'
endfor


;(im[-1]).position
xl = 1.0
yl = 0.5

leg1 = legend2( /device, $
    target=h, $
    position = [xl,yl]*dpi, $
    horizontal_alignment = 'Left', $
    vertical_alignment = 'Bottom' )

leg2 = legend2( /device, $
    target=v, $
    position = [xl+3.,yl]*dpi, $
    horizontal_alignment = 'Left', $
    vertical_alignment = 'Bottom' )

    ;print, 1000*frequency, format='(F0.2)'
    ;print, ytickvalues
;file = 'wa_plots.pdf'
file = 'wa_plots_2.pdf'
save2, file

end
