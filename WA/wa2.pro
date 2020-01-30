;+
;- LAST MODIFIED:
;-   22 January 2020
;-
;- -----------
;-
;- Thu Jan 31 02:52:30 MST 2019
;-
;- PURPOSE:
;-   "Wavelet Analysis" (WA) - discrete
;-
;- INPUT:
;-   flux
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-   frequency, wmap (if arg variable names are provided in call to wa2)
;-
;- TO DO:
;-   solid vertical lines at 1:30 and 2:30
;-
;-
; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change?
;-  Don't know why I wanted to do that, so I'm going with nooooo (22 January 2020)
;-



pro WA2, flux, $
    frequency, wmap, $
    cadence=cadence, $
    z_start=z_start, $
    ;zz=zz, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

    ; Input:  flux
    ; Output: wmap (2D) and frequency (1D)
    ;-  Gee, sure wish this comment was at the TOP with the rest of the
    ;-   code documentation! (22 January 2020)

    ; Find available frequencies within bandpass
    ;-  NOTE: this block of code is fairly standard.. appears numerous times
    ;-   in many of my codes. Somehow never could figure out how to write a
    ;-   simple, intuitive subroutine for this.
    result = fourier2( indgen(dz), cadence, norm=norm )
    frequency = reform( result[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]



    ;-
    ;--- Original way ---
    ;-
;    nn = n_elements(z_start)
;    mm = n_elements(frequency)
;    wmap = fltarr(nn,mm)
;    for ii = 0, nn-1 do begin
;        result = fourier2( flux[ zz[ii] : zz[ii]+dz-1 ], cadence, norm=norm )
;        power = (reform( result[1,*] ))[ind]
;        wmap[ii,*] = power
;    endfor


    ;-
    ;--- New way  (22 January 2020) ---
    ;-
    wmap = fltarr(n_elements(z_start), n_elements(frequency))
        ;- variables 'nn' and 'mm' seemed unnecessary...
    foreach zz, z_start, ii do begin
        result = fourier2( flux[ zz : zz+dz-1 ], cadence, norm=norm )
;        power = (reform( result[1,*] ))[ind]
;        wmap[ii,*] = power
        wmap[ii,*] = (reform( result[1,*] ))[ind]
    endforeach
end

@parameters

;-
;-------------------------------------------------------------------------------------
;- User-defined parameters

dz = 64

;- coords for horizontal lines marking upper/lower boundaries of
fcenter = 1./180
flower = 0.005
fupper = 0.006

;- number of points available with chosen dz
;-   [] when more awake, figure out a better way to word this...
NN = n_elements(A[0].flux) - dz + 1

;- min/max frequencies to display on figure.
;-   aka: y-range
fmin = 0.0025
fmax = 0.0200


; starting indices/time for each FT (length = # resulting maps)
step = 1
;step = 8
z_start = [ 0 : NN : dz/step ]


;-------------------------------------------------------------------------------------

;-
;- A.flux is exptime-corrected, but
;-   NOT divided by # pixels (summed over 500x330 pixel AR)
;-
;- 22 January 2020 --> A.flux NO LONGER exptime-corrected ...
;-

aia_wa_maps = []
for cc = 0, 1 do begin
    WA2, A[cc].flux, $ ;- input: flux
        frequency, wmap_out, $  ;- output: frequency (1D) & wmap (2D)
        cadence=A[cc].cadence, $  ;- cadence... obviously
        ;zz=z_start, $
        z_start=z_start, $
           ;- Replaced 'zz' kw in wa2 def with 'z_start'...
           ;-   'zz' is a counter, not a variable name.
        dz=dz, fmin=fmin, fmax=fmax, $ ;- parameters defined by user at top of ML
        norm=0
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


for cc = 1, 1 do begin

    time = strmid(A[cc].time,0,5)

    wmap = aia_wa_maps[*,*,cc]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

print, max(wmap2)

    ;- x & y coordinates of image data (aka "wmap2")
    XX = ((findgen(D1)/100)*dz) / step
    YY = 1000. * [ min(frequency) : max(frequency) :  $
        (max(frequency) - min(frequency)) / (D2-1) ] ;- y increment


;    n_freq = n_elements(frequency)
;    ytickvalues = 1000.*(frequency[0:n_freq-1:4])
    ytickvalues = 1000.*(frequency[0:n_elements(frequency)-1:4])
    ;-  n_freq is never used again... another pointless variable.
    ;-  Could simply use sz[1] instead of n_elements(frequency), but may be
    ;-     risky since dimensions of wmap are changed with CONGRID, and
    ;-     if sz is defined after this, will no longer = n_elements(freq) ...

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


    ;-
    ;- Colorbar
    ;-

    ;- Convert image position to inches
    ;-  (easier to tinker with colorbar position when units make sense)
    pos = im[cc].position*[wx,wy,wx,wy]
    cx1 = pos[2] + 0.75
    cy1 = pos[1]
    cx2 = cx1 + 0.15
    cy2 = pos[3]
    cbar = colorbar2( $
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
    ax[0].title = 'Start time (UT) on ' + date

    f1 = flower * 1000
    f2 = fcenter * 1000
    f3 = fupper * 1000

    lines = objarr(6)

;-
;- 22 January 2020
;-   Cannot find a code written by me called 'hline'...
;-   IDL has a routine by this name, but does not appear to be what I'm using..
;-   wa.pro calls oplot_horizontal_lines.pro; syntax is similar enough
;-     (counter is ii instead of cc,
;-     first arg is xrange of image, not the whole image, and
;-      switched from procedure to function, or vice versa, but probably not)
;-  that I assume I changed the name of this routine at some point without
;-  changing the name in every occurrance where that routine was called from
;-  an external file.. rookie mistake.
;-



    HLINE, im[cc], $
        [f1,f2,f3], $
        color = 'red', $
        linestyle=[':','--',':'], $
        names=[  $
            '$\nu_{lower} $ = 5.0 mHz', $
            '$\nu_{center}$ = 5.6 mHz', $
            '$\nu_{upper} $ = 6.0 mHz' ]

    ;h = OPLOT_HORIZONTAL_LINES( im[cc].xrange, ...
    ;-  Remainder of call to this function matched the above call to "hline" procedure
    ;

;    v = OPLOT_FLARE_LINES( time, yrange=im[cc].yrange )
    ;- same for both wa.pro and wa2.pro, except ii <--> cc




    ;------------
    resolve_routine, 'oplot_flare_lines', /is_function
    vert = OPLOT_FLARE_LINES( $
        im[cc], $
        t_obs=A[0].time, $
        yrange=im[cc].yrange $
    )
;- NOTE: linestyle already set up in subroutine.
;-  Copied the lines from plot_lc.pro .. we'll see what happens.

    f1 = flower * 1000
    f2 = fcenter * 1000
    f3 = fupper * 1000
    f_lines = [f1, f2, f3]

    linestyle=[':','--',':']

    name=[  $
        '$\nu_{lower} $ = 5.0 mHz', $
        '$\nu_{center}$ = 5.6 mHz', $
        '$\nu_{upper} $ = 6.0 mHz' ]

    horz = objarr(3)
    ;- NOTE: syntax for x-coords is NOT correct, this is just a
    ;- placeholder until I can actually run the code.
    ;-   This explains the use of im[cc].xrange as arg to
    ;-     one of the hline plotting routines
    for hh = 0, n_elements(horz) do begin
        horz[hh] = plot( $
            [ xrange[0], xrange[-1] ], $
            [ f_lines[hh], f_lines[hh] ], $
            color = 'red', $
            linestyle = linestyle[hh], $
            name = name[hh] )
    endfor
    ;------------



    ;save2, 'wa' + A[cc].channel + '.pdf'
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

stop
;file = 'wa_plots.pdf'
;file = 'wa_plots_2.pdf'
file = 'wa'
save2, file

end
