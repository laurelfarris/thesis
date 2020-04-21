;+
;- LAST MODIFIED:
;-   10 April 2020
;-     Changed rgb_table to "my_viridis", custom made by me using
;-     IDL routine COLORTABLE and a close examination of the viridis colortable
;-     found online.
;-   14 April 2020
;-     Removed codes from 4/10/2020 defining colortable directly in this routine.
;-     Copied lines creating viridis colortable into function "my_viridis",
;-     called simply as rgb_table = my_viridis().
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
;-   frequency (1D)
;-   wmap (2D) ... if arg variable names are provided in call to wa2
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
    dz=dz, $
    fmin=fmin, $
    fmax=fmax, $
    norm=norm


    ; Find available frequencies within bandpass
    result = fourier2( indgen(dz), cadence, norm=norm )
    frequency = reform( result[0,*] )
    ind = where( frequency ge fmin AND frequency le fmax )
    frequency = frequency[ind]

    ;--- New way  (22 January 2020) ---
    ;-     (see wa2_OLD.pro for "original way")
    wmap = fltarr(n_elements(z_start), n_elements(frequency))
        ;- variables 'nn' and 'mm' seemed unnecessary...
    foreach zz, z_start, ii do begin
        result = fourier2( flux[ zz : zz+dz-1 ], cadence, norm=norm )
        wmap[ii,*] = (reform( result[1,*] ))[ind]
    endforeach
end



;-
;-------------------------------------------------------------------------------------
;- User-defined parameters

buffer=1
fname = 'wa'

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
;- NOTE:  A.flux is NOT exptime-corrected.
;-


dw

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


;+
;- 14 April 2020
rgb_table = my_viridis()
;- IDL> help, rgb_table
;-        INT   = Array[256, 3]
;-

for cc = 0, 1 do begin

    time = strmid(A[cc].time,0,5)

    wmap = aia_wa_maps[*,*,cc]
    sz = size( wmap, /dimensions )
    D1 = sz[0] * 100
    D2 = sz[1] * 100
    wmap2 = alog10( congrid(wmap, D1, D2) )

    ;- x & y coordinates of image data (aka "wmap2")
    XX = ((findgen(D1)/100)*dz) / step
    YY = 1000. * [ min(frequency) : max(frequency) :  $
        (max(frequency) - min(frequency)) / (D2-1) ] ;- y increment

    ytickvalues = 1000.*(frequency[0:n_elements(frequency)-1:4])

    position = GET_POSITION( layout=[cols,rows,cc+1], $
        top=0.5, left=0.75, width=5.0, height=3.0, ygap=0.75)

    im[cc] = image2( $
        wmap2, XX, YY, $
        /current, /device, $
        position=position*dpi, $
        aspect_ratio=0, $
        min_value=alog10(min_value), $
        max_value=alog10(max_value), $
        rgb_table=rgb_table, $
        xtickinterval=75, $
        xminor=5, $ ;- minor tick interval = 5 minutes (21 April 2020)
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

    ;resolve_routine, 'colorbar2', /is_function
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

    ;+
    ;- Vertical lines (flare start/peak/end times)
    ;-

    flare_times = strmid( [gstart, gpeak, gend], 0, 5 )
    name = flare_times + [ ' UT (start)', ' UT (peak)', ' UT (end)' ]
    nn = n_elements(flare_times)
    yrange = im[cc].yrange
    x_indices = intarr(nn)
    for ii = 0, nn-1 do $
        x_indices[ii] = (where( time eq flare_times[ii] ))[0]

    vert = objarr(nn)
    linestyle = [1,2,4]
    foreach vx, x_indices, jj do begin
        vert[jj] = plot( $
            ;[ xx[vx], xx[vx] ], $
            [ vx, vx ], $
            yrange, $
            /current, $
            /overplot, $
            ;overplot = plt[0], $
            thick = 0.5, $
            linestyle = linestyle[jj], $
            ystyle = 1, $
            name = name[jj], $
            color = 'black', $
            _EXTRA=e )
        if keyword_set(send_to_back) then vert[jj].Order, /SEND_TO_BACK
    endforeach
    vert[0].linestyle = [1, '1111'X]
    vert[1].linestyle = [1, '3C3C'X]
    vert[2].linestyle = [1, '47E2'X]

    ;+
    ;- Horizontal lines (frequencies)
    ;-

    f_lines = [ flower, fcenter, fupper ] * 1000
    name=[  $
        '$\nu_{lower} $ = 5.0 mHz', $
        '$\nu_{center}$ = 5.6 mHz', $
        '$\nu_{upper} $ = 6.0 mHz' ]
    linestyle=[':','--',':']
;
    horz = objarr(3)
    for hh = 0, n_elements(horz)-1 do begin
        horz[hh] = PLOT( $
            [ im[cc].xrange[0], im[cc].xrange[-1] ], $
            [ f_lines[hh], f_lines[hh] ], $
            /overplot, $
            thick = 0.5, $
            color = 'red', $
            linestyle = linestyle[hh], $
            name = name[hh] $
        )
    endfor

endfor

;+
;- Legend -- applies to both top (1600) and bottom (1700) panels.
;-

xl = 1.0
yl = 0.5

leg1 = legend2( /device, $
    ;target=h, $
    target=horz, $
    position = [xl,yl]*dpi, $
    horizontal_alignment = 'Left', $
    vertical_alignment = 'Bottom' )

leg2 = legend2( /device, $
    target=vert, $
    position = [xl+3.,yl]*dpi, $
    horizontal_alignment = 'Left', $
    vertical_alignment = 'Bottom' )


;+
;- Save figure
save2, fname; + strcompress(cc, /remove_all)

end
