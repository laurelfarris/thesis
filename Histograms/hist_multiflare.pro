;+
;====================================================================================
;=
;= 19 February 2024:
;=
;=    [] defined variable nbins=50, followed by hardcoded values = 50 ... Coincidence? 
;=        Or should instances of value '50' be replaced by variable 'nbins' ??
;=    [] Re-run to confirm bin size, nbins, xrange
;=        (solve for the remaining unknown...)
;=
;====================================================================================
;-
;-
;- LAST MODIFIED:
;-   28 July 2020
;-
;- PURPOSE:
;-   1. Histogram for each BDA map with number of pixels with 3-minute power between
;-       N and N+dn, where dn = bin width (depends on max-min of power...
;-       probably easier to set number of bins instead of bin width in first
;-        call to IDL's HISTOGRAM function.
;-
;-   histogram: # pixels vs. 3-minute power
;-   xrange = [ MIN(map[*,*,zz]) : MAX(map[*,*,zz]) ]
;-   where zz = values from last week's BDA maps.
;-
;-
;- To do :
;-   [] Histograms
;-   [] copy code from struc_aia.pro that restores and crops 3D data cube
;-       and paste into a separate routine.
;-
;- See histogram module in ./Graphics/ for examples, including one from
;-   Harris geospatial ref pages for IDL --> PLOTHIST



;====================================================================================
;= Old code : [] copy to research log for 18 August 2020, then delete these lines.
;===

;-
;print, min(aia1600maps), format=format
;print, min(aia1700maps), format=format
;print, max(aia1600maps), format=format
;print, max(aia1700maps), format=format
;

;imdata = aia1600maps * aia1600mask
;imdata = aia1700maps * aia1700mask
;fname = 'aia1700_hist'

;- Hacky way to figure out xrange:
;-
;for jj = 0, sz[2]-1 do begin
;    for ii = 0, nbins-2 do begin
;        ;-  --. use TOTAL( /cumulative ) ?
;        npix = total( ydata[ii:nbins-1, jj] )
;        ;- [] test for MIN x-range as well
;;        if npix lt 100 then begin
;;            print, jj, ii, npix
;;            break
;;        endif
;    endfor
;    print, jj, ii, npix
;endfor
;;

;====================================================================================
;= START HERE:
;===

buffer = 1
dz = 64
@parameters
format='(e0.2)'

;----
;-- Restore "headers" for multiflare
;-

restore, '../multiflare_struc.sav'
;- IDL> help, multiflare_struc
;- ** Structure <...>, 3 tags, length=..., ...
;-    S1         STRUCT    -> <Anonymous> Array[2]
;-    S2         STRUCT    -> <Anonymous> Array[2]
;-    S3         STRUCT    -> <Anonymous> Array[2]
;-
;print, (multiflare_struc.(0))[cc].channel
;print, (multiflare_struc.(1))[cc].channel
;print, (multiflare_struc.(2))[cc].channel
;print, (multiflare_struc.(*))[cc].channel
;-    Error, can't use wildcard like this to access all tags in struc.
;-

;----
;-- Restore Power Maps
;-

restore, '../BDAmaps.sav'
;-   AIA1600MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   AIA1700MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   BDA_ZIND        LONG    = Array[ 3, 3 ]
;-   BDA_TIME      STRING    = Array[ 3, 3 ]

help, map

map = fltarr( [ size(aia1600maps, /dimensions), 2 ] )
    ;- Using 1600maps to set first 3 dimensions since 1700 is the same size,
    ;-   then adding a fourth dimension (=2) to save actual data in next step.
map[*,*,*,0] = aia1600maps
map[*,*,*,1] = aia1700maps


;----
;-- Restore Saturation Masks
;-
;restore, '../BDAmask.sav'
;-  renamed to bda_masks.sav? Or different file? (18 August 2020)
restore, '../bda_masks.sav'
;-   MASK    FLOAT    = Array[ 500, 330, 9, 2 ]

help, mask

;-----
;- MAP and MASK both FLOAT = Array[500, 330, 9, 2]
;-
;- 9 panels for each channel : 3 phases (BDA) for each of three flares (C, M, X)
;-


;- Define data array to represent in histogram plots:
imdata = map * mask
;-  IMDATA       FLOAT   = Array[500, 330, 9, 2]
;
sz = size(imdata, /dimensions)

STOP

;================================================================================================

;- Edit this code block to replace channel-specific vars with 4-dimension arrays... later.
for frac = 0.0, 1.0, 0.05 do begin
;    locs = where( aia1600maps gt frac*max(aia1600maps) )
    locs = n_elements(where( aia1600maps gt frac*max(aia1600maps) ))
    print, locs
    if locs lt 1000 then begin
        print, frac
        print, frac*max(aia1600maps), format=format
        break
    endif
endfor

for ii = 0, 8 do print, min(imdata[*,*,ii,0]), format=format
for ii = 0, 8 do print, max(imdata[*,*,ii,1]), format=format

;=================================================================================
;=================================================================================


;---
;- Compute histogram data
;-
;binsize = 0.1
nbins = 50
;
ydata = LONARR(nbins, sz[2], sz[3])
xdata = LONARR(nbins, sz[2], sz[3])
;
;-- Set values for min/max kws for HISTOGRAM function
;-    [] ==>> see prev. version of HIST code for other values of min and max
min = 0.1
;max = max(imdata)
max = 3.5e5
;-    ("min. max value" on plots -- 08 September 2020)
;
;print, min(imdata)
;print, n_elements( where( imdata lt 0.1 ) )
;
for cc = 0, 1 do begin
    for ii = 0, sz[2]-1 do begin
        ydata[*,ii,cc] = HISTOGRAM( $
            imdata[*,*,ii,cc], $
            ;min=min, $
            ;max=max, $
            omin=omin, $
            omax=omax, $
            nbins=nbins, $
    ;        binsize=binsize, $
            locations=locations $
        )
        xdata[*,ii] = locations
    endfor
endfor
;
;- 08 September 2020 -- split dimensions from 9 to 3x3 to separate flares
xdata = reform(xdata, 50, 3, 3, 2)
ydata = reform(ydata, 50, 3, 3, 2)
;
;ind = [1:499]
;- 18 August 2020 -- set min and max kws in call to HISTOGRAM function, which should
;-      accomplish the same thing, but tidier than cropping x|ydata in call to PLOT func.
;


;---
;- PLOT histgram
;-
;
;help, multiflare_struc.(0)[0]
;help, multiflare_struc.(0)[1]
;
fname = 'aia' + multiflare_struc.(0).channel  + '_hist'
;print, fname
;
;
ylog=1
xlog=1
;
xtitle='3-min power'
if xlog then xtitle = 'log ' + xtitle
ytitle='# pixels'
if ylog then ytitle = 'log ' + ytitle
;
;
title = ['pre-flare', 'flare', 'post-flare']
name = ['C3.0', 'M7.3', 'X2.2']
color = ['deep sky blue', 'green', 'dark orange', '']
;
wx = 8.5
wy = 3.0
resolve_routine, 'plot2', /is_function
;
for cc = 0, 1 do begin
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
    plt = objarr(3,3)
    for tt = 0, 2 do begin
        for ff = 0, 2 do begin
            plt[tt,ff] = plot2( $
                xdata[*,tt,ff,cc], $
                ydata[*,tt,ff,cc], $
                /current, $
                layout=[3,1,tt+1], $
                overplot=ff<1, $
                margin=0.18, $
                histogram=1, $
                xlog=xlog, $
                ylog=ylog, $
                ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
                ;xtickinterval=2e3, $
                name=name[ff], $
                color=color[ff], $
                ;xmajor=2, $
                xtickunits="scientific", $
                ytickunits="scientific", $
                ;xticklen=(0.20/wy), $
                ;yticklen=(0.20/wx), $
                title=title[tt], $
                xtitle=xtitle, $
                ytitle=ytitle, $
                font_size=9, $
                xtickfont_size=9, $
                ytickfont_size=9, $
                buffer=buffer $
            )
        endfor
        leg = legend2( target = plt[tt,*], /upperright )
    endfor
    save2, fname[cc], /add_timestamp
    stop
endfor

end
