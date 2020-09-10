+
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

help, mask
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


;-----
;- MAP and MASK both FLOAT = Array[500, 330, 9, 2]
;-
;- 9 panels for each channel : 3 phases (BDA) for each of three flares (C, M, X)
;-


STOP

;=================================================================================


;- Define data array to represent in histogram plots:
imdata = map * mask
;-  IMDATA       FLOAT   = Array[500, 330, 9, 2]
;
sz = size(imdata, /dimensions)
help, sz



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
;


cc = 0
;cc = 1
;
fname = 'aia' + multiflare_struc.(0)[cc].channel  + '_hist'
print, fname

fname = 'aia' + multiflare_struc.(0).channel  + '_hist'

help, fname

help, multiflare_struc.(0)[0]
help, multiflare_struc.(0)[1]

;---

;-
;- Compute histogram data
;-


;binsize = 0.1
nbins = 50
;
ydata = LONARR(nbins, sz[2], sz[3])
xdata = LONARR(nbins, sz[2], sz[3])
;
;min = 0.0
;min = 1.e-5
;min = 10.0
;
;max = 1.e3
;max = 1.e4
;max = 1.e5
;

;- AIA 1600:
;min = 0.0
;min = 4.45e-3
min = 1.e2
;
;max = 2.52e3
;max = 1.e5
max = 1.e4

;- AIA 1700:
;min = 2.88e-1
;max = 2.27e4

;--------


;-
;- 8/21/2020
;-
min = 0.1
max = max(imdata)
;max = 1.e5
;max = 1.e4
;max = 1.e3
;max = 1.e2
;max = 1.e1

;-
;- Array of min/max values for both channels (min[0]=min for 1600, min[1]=min for 1700, ...)
;-   only needed if the 3-minut power varies too much between channels to scale both histograms
;-   to the same axes.
;min = [ 1.e2 , ]
;max = [ 1.e4 , ]

print, min(imdata)
print, n_elements( where( imdata lt 0.1 ) )

for cc = 0, 1 do begin
    for ii = 0, sz[2]-1 do begin
        ydata[*,ii,cc] = HISTOGRAM( $
            imdata[*,*,ii,cc], $
            min=min, $
            max=max, $
            omin=omin, $
            omax=omax, $
            nbins=nbins, $
    ;        binsize=binsize, $
            locations=locations $
        )
        xdata[*,ii] = locations
    endfor
endfor


print, min(ydata[*,*,0])
print, min(ydata[*,*,1])


;
;ind = [1:499]
;- 18 August 2020 -- set min and max kws in call to HISTOGRAM function, which should
;-      accomplish the same thing, but tidier than cropping x|ydata in call to PLOT func.
;




;---
;- Plot histgram
;-
;
ylog=1
xlog=0
;
xtitle='3-min power'
if xlog then xtitle = 'log ' + xtitle
ytitle='# pixels'
if ylog then ytitle = 'log ' + ytitle
;
name = [ $
    'C3.0 pre-flare ' + bda_time[0], $
    'C3.0 flare '      + bda_time[1], $
    'C3.0 post-flare ' + bda_time[2], $
    'M7.3 pre-flare ' + bda_time[3], $
    'M7.3 flare '      + bda_time[4], $
    'M7.3 post-flare ' + bda_time[5], $
    'X2.2 pre-flare ' + bda_time[6], $
    'X2.2 flare '      + bda_time[7], $
    'X2.2 post-flare ' + bda_time[8] $
]
;
color = [ $
    'black', 'black', 'black', $
    'blue', 'blue', 'blue', $
    'red', 'red', 'red' $
]
;
wy = 8.5
wx = 8.5
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
plt = objarr(sz[2])
resolve_routine, 'plot2', /is_function
for ii = 0, sz[2]-1 do begin
    plt[ii] = plot2( $
        xdata[*,ii], $
        ydata[*,ii], $
        /current, $
        layout=[3,3,ii+1], $
        margin=0.12, $
        overplot=0, $
        histogram=1, $
        xlog=xlog, $
        ylog=ylog, $
        xtickinterval=2e3, $
        name=name[ii], $
        font_size=9, $
        xtickfont_size=9, $
        ytickfont_size=9, $
        title=name[ii], $
        xtitle=xtitle, $
        ytitle=ytitle, $
        color=color[ii], $
        ;xmajor=4, $
        xtickunits="scientific", $
        ytickunits="scientific", $
        ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
        xticklen=(0.20/wy), $
        yticklen=(0.20/wx), $
        buffer=buffer $
    )
endfor
;
;leg = legend2( target = plt, /upperright )
;
save2, fname, /add_timestamp

;plot, xdata[*,4], ydata[*,4]

;- oplot 3 at a time
end
