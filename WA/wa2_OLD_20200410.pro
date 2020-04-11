;+
;- LAST MODIFIED:
;-   22 January 2020
;-
;-   10 April 2020
;-     Changed rgb_table to "my_viridis", custom made by me using
;-     IDL routine COLORTABLE and a close examination of the viridis colortable
;-     found online.
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
;-




;------------------------------------------------------------------------
;-----
;- 05 February 2020
;-  Merging wa.pro and wa2.pro
;-

function WA_AVERAGE, flux, power, dz=dz
    ; This is a little hacky... optimize later.

    ;- Thu Jan 24 15:17:59 MST 2019
    ;-   Merged wa_average.pro and wa.pro, then deleted wa_average.pro.
    ;-   Not sure yet what I was even trying to do here...


    x = n_elements(flux)
    y = n_elements(power)
    arr = fltarr( x, y )

    ; Set sub-arrays of length dz equal to power[i]
    ; step in x and y at the same time
    for i = 0, y-1 do begin
        arr[ i : i+dz-1, i ] = power[i]
        ;arr[ 0 : dz-1, i ] = power[i]
        ;arr[ *, i ] = shift(...)
    endfor

    ; Set new power to average(arr)
    arr2 = mean( arr, dimension=2 )
    N = n_elements(arr2)

    i1 = dz-1
    i2 = N-dz ; no need to subtract 1 because of inclusivity of indices.

    new_power = arr2[i1:i2]
    return, new_power
end
;arr = WA_AVERAGE( A.power_flux )





; Last modified:   14 July 2018
; Maybe could be called by power_maps in the intermost loop.
; Define z, dz, etc. in one place, since they never change?
; Wavelet Analysis (WA) - discrete
; To do:      solid vertical lines at 1:30 and 2:30
pro better
    ; (11 Sep 2018) Better way to code this perhaps:

    power1 = result[1,*]
    ; power P = [ p0, p1, ..., p185 ]

    NN = n_elements(power1)
    power2 = fltarr(NN)

    for i = 0, NN-1 do begin
        power2[i] = mean( power[ i : i+dz-1 ] )
    endfor
    ; plot vs. t = [ (dz/2) : NN - (dz/2) ]
end



;-------
;------------------------------------------------------------------------


pro WA2, flux, $
    frequency, wmap, $
    cadence=cadence, $
    z_start=z_start, $
    ;zz=zz, $
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm

    ;-
    ;- 05 February 2020
    ;-   NOTE: procedure WA2 in wa2.pro is same as "calc_wa" in wa.pro
    ;-     (which has been moved to ../.old/)
    ;-


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
    ;nn = n_elements(z_start)
    ;mm = n_elements(frequency)
    ;wmap = fltarr(nn,mm)
    ;for ii = 0, nn-1 do begin
    ;    result = fourier2( flux[ zz[ii] : zz[ii]+dz-1 ], cadence, norm=norm )
    ;    power = (reform( result[1,*] ))[ind]
    ;    wmap[ii,*] = power
    ;endfor


    ;-
    ;--- New way  (22 January 2020) ---
    ;-
    wmap = fltarr(n_elements(z_start), n_elements(frequency))
        ;- variables 'nn' and 'mm' seemed unnecessary...
    foreach zz, z_start, ii do begin
        result = fourier2( flux[ zz : zz+dz-1 ], cadence, norm=norm )
        ;power = (reform( result[1,*] ))[ind]
        ;wmap[ii,*] = power
        wmap[ii,*] = (reform( result[1,*] ))[ind]
    endforeach
end



;- 10 April 2020
my_viridis = COLORTABLE( $
    [ [255, 235, 000], $
      [000, 215, 135], $
      [000, 135, 135], $
      [067, 000, 089] ], $
      /reverse $
)

;-
;-------------------------------------------------------------------------------------
;- User-defined parameters

buffer=1

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

@parameters

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
win = window( dimensions=[wx,wy]*dpi, location=[500,0], buffer=buffer )


for cc = 0, 1 do begin

    time = strmid(A[cc].time,0,5)

    wmap = aia_wa_maps[*,*,cc]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    ;print, max(wmap2)

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
        ;rgb_table=34, $
        rgb_table=my_viridis, $
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
    resolve_routine, 'colorbar2', /is_function
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


;
;    HLINE, im[cc], $
;        [f1,f2,f3], $
;        color = 'red', $
;        linestyle=[':','--',':'], $
;        names=[  $
;            '$\nu_{lower} $ = 5.0 mHz', $
;            '$\nu_{center}$ = 5.6 mHz', $
;            '$\nu_{upper} $ = 6.0 mHz' ]

    ;h = OPLOT_HORIZONTAL_LINES( im[cc].xrange, ...
    ;-  Remainder of call to this function matched the above call to "hline" procedure
    ;

;    v = OPLOT_FLARE_LINES( time, yrange=im[cc].yrange )
    ;- same for both wa.pro and wa2.pro, except ii <--> cc




    ;------------
;    resolve_routine, 'oplot_flare_lines', /is_function
;    vert = OPLOT_FLARE_LINES( $
;        im[cc], $
;        t_obs=A[0].time, $
;        yrange=im[cc].yrange $
;    )
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
            [ im[cc].xrange[0], im[cc].xrange[-1] ], $
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

stop

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
