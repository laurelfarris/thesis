;+
;- LAST MODIFIED: Thu Jan 31 02:52:30 MST 2019
;-
;- PURPOSE:
;-   "Wavelet Analysis" (WA) - discrete
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   solid vertical lines at 1:30 and 2:30

; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change?



pro WA2, flux, $
    frequency, wmap, $
    cadence=cadence, $
    zz=zz, $
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

    nn = n_elements(zz)
    mm = n_elements(frequency)
    wmap = fltarr(nn,mm)

    for ii = 0, nn-1 do begin
        result = fourier2( flux[ zz[ii] : zz[ii]+dz-1 ], cadence, norm=norm )
        power = (reform( result[1,*] ))[ind]
        wmap[ii,*] = power
    endfor
end

goto, start
start:;---------------------------------------------------------------------------------
@parameters ;- 21 April 2019

;- User numbers to change (which is why these lines are up at the top, even
;-   though fcenter, flower, and fupper aren't used until much farther down).

dz = 64

;- coords for overplotting horizontal lines
fcenter = 1./180
flower = 0.005
fupper = 0.006

NN = n_elements(A[0].flux) - dz + 1

;- min/max frequencies to display on figure.
fmin = 0.0025
fmax = 0.0200


; starting indices/time for each FT (length = # resulting maps)
step = 8
z_start = [ 0 : NN : dz/step ]


;-------------------------------------------------------------------------------------

aia_wa_maps = []
;- A.flux is exptime-corrected, but NOT divided by # pixels
;-   (summed over 500x330 pixel AR)
for cc = 0, 1 do begin
    WA2, A[cc].flux, frequency, wmap_out, $
        cadence=A[cc].cadence, zz=z_start, dz=dz, fmin=fmin, fmax=fmax, norm=0
    aia_wa_maps = [ [[aia_wa_maps]], [[wmap_out]] ]
endfor


;- min/max values for comparable scaling between 1600 and 1700.
min_value = min(aia_wa_maps)
max_value = max(aia_wa_maps)



im = objarr(2)
cols = 1
rows = 2


wx = 7.5
wy = 9.0
win = window( dimensions=[wx,wy]*dpi, location=[500,0], buffer=0 )


for cc = 0, 1 do begin

    time = strmid(A[cc].time,0,5)

    wmap = aia_wa_maps[*,*,cc]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    XX = ((findgen(D1)/100)*dz) / step

    inc = (max(frequency) - min(frequency)) / (D2-1)

    YY = 1000. * [ min(frequency) : max(frequency) : inc ]
    n_freq = n_elements(frequency)
    ytickvalues = 1000.*(frequency[0:n_freq-1:4])

    position = GET_POSITION( layout=[cols,rows,cc+1], $
        top=0.5, left=0.75, width=5.0, height=3.0, ygap=0.75)

    im[cc] = image2( $
        wmap2, XX, YY, $
        /current, /device, $
        position=position*dpi, $
        aspect_ratio=0, $
        min_value=alog10(min_value), $
        max_value=alog10(max_value), $
        rgb_table=34, $
        xtickinterval=75, $
        xtitle='image #', $
        ytickvalues=ytickvalues, $
        ytickformat='(F0.1)', $
        yminor=0, $
        ytitle='Frequency (mHz)', $
        title=A[cc].name )

    ax = im[cc].axes
    ax[3].tickname = strmid( (strtrim(1000./ax[1].tickvalues,1)), 0, 5 )
    ax[3].title = "Period (s)"
    ax[3].showtext = 1

    ;- Position of image (--> INCHES)
    pos = im[cc].position*[wx,wy,wx,wy]

    cx1 = pos[2] + 0.75
    cy1 = pos[1]
    cx2 = cx1 + 0.15
    cy2 = pos[3]
    c = colorbar2( $
        position = dpi*[cx1,cy1,cx2,cy2], $
        target = im[cc], $
        /device, $
        tickinterval=1, $
        tickformat='(I0)', $
        minor=1, $
        title='Log Power' )

    ;- Convert index to time on x-axis
    ax = im[cc].axes
    xtickvalues = fix(round(ax[0].tickvalues))
    ax[0].tickname = time[xtickvalues]
    ;ax[0].title = 'Start time (UT) on 2011-February-15'
    ax[0].title = 'Start time (UT) on ' + date
      ;- 21 April 2019: added @parameters to top of routine

    f1 = flower * 1000
    f2 = fcenter * 1000
    f3 = fupper * 1000

    lines = objarr(6)


    HLINE, $
        im[cc], $
        [f1,f2,f3], $
        color = 'red', $
        linestyle=[':','--',':'], $
        name=[  $
            '$\nu_{lower} $ = 5.0 mHz', $
            '$\nu_{center}$ = 5.6 mHz', $
            '$\nu_{upper} $ = 6.0 mHz' ]

;    v = OPLOT_FLARE_LINES( time, yrange=im[cc].yrange )
    ;save2, 'wa' + A[cc].channel + '.pdf'
endfor



stop

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
;file = 'wa_plots_2.pdf'
;save2, file

end
