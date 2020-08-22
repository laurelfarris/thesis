;+
;- 24 July 2020
;-   (copied content of 2020-07-14.pro)
;-
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


;--

buffer = 1
dz = 64
threshold=10000
@parameters

;---

;restore, '../multiflare_struc.sav'
;

;- restore BDA maps along with zind/time --> need these ind to extract
;-   the correct mask to multiply by aia1[6|7]00map
restore, '../BDAmaps.sav'
;-   AIA1600MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   AIA1700MAPS    FLOAT    = Array[ 500, 330, 9 ]
;-   BDA_ZIND        LONG    = Array[ 3, 3 ]
;-   BDA_TIME      STRING    = Array[ 3, 3 ]
;-


;=========================================================================

;+
;- Powermap MASKs
;-


;- Compute Powermap mask
;-   • edit @parameters -- uncomment desired flare
;-   • restore structure from .sav file for desired flare
;-   • use data in structure to compute mask (one for each channel)
;-   • restore 'BDAmaps.sav' and use zind to extract BDA masks
;-   • save mask variable in similar fashion as done for BDAmaps, zind/time, etc.
;-
;-


restore, "../multiflare_structures_X22.sav"
;- help, XXX
;-   XXX      STRUCT    = -> <Anonymous> Array[ 2 ]
;- help, XXX.map
;-   <Expression>   FLOAT   = Array[500,330,686,2]

restore, "../multiflare_structures_M73.sav"
restore, "../multiflare_structures_C30.sav"

;---


;-
;- Each map has the same dimensions, but to prevent future confusion,
;-   use same flare map for which mask is to be computed.

resolve_routine, 'powermap_mask', /either

;--
;- C-flare

sz = size(CCC.map, /dimensions)
map_mask = fltarr(sz)
help, map_mask
;-    FLOAT [500,330,686,2]
;-     (same as MAP dimensions... as it should be)

for cc = 0, 1 do begin
    map_mask[*,*,*,cc] = POWERMAP_MASK( CCC[cc].data, dz=dz, threshold=threshold )
endfor
;
;print, bda_zind[*,0]
;print, bda_time[*,0]
;help, map_mask[ *, *, bda_zind[*,0], * ]

ccc_mask = map_mask[ *, *, bda_zind[*,0], * ]
;-  FLOAT   = Array[ 500, 330, 3, 2 ]
;-    3 --> BDA
;-    2 --> 1600,1700



;--
;- M-flare
;
sz = size(MMM.map, /dimensions)
map_mask = fltarr(sz)
;
for cc = 0, 1 do begin
    map_mask[*,*,*,cc] = POWERMAP_MASK( MMM[cc].data, dz=dz, threshold=threshold )
endfor
;
print, bda_zind[*,1]
print, bda_time[*,1]
help, map_mask[ *, *, bda_zind[*,1], * ]
mmm_mask = map_mask[ *, *, bda_zind[*,1], * ]



;--
;- X-flare
sz = size(XXX.map, /dimensions)
for cc = 0, 1 do begin
    map_mask[*,*,*,cc] = POWERMAP_MASK( xxx[cc].data, dz=dz, threshold=threshold )
endfor
;
print, bda_zind[*,2]
print, bda_time[*,2]
help, map_mask[ *, *, bda_zind[*,2], * ]
xxx_mask = map_mask[ *, *, bda_zind[*,2], * ]

undefine, map_mask
;

;- FINAL (should have dims = aia1600maps
mask = [ [[ ccc_mask ]], [[ mmm_mask ]], [[ xxx_mask ]] ]
help, mask
;-  -->  500, 330, 9, 2


;- C-flare
print, max(ccc_mask[*,*,0,*])  ;- B
print, max(ccc_mask[*,*,1,*])  ;- D
print, max(ccc_mask[*,*,2,*])  ;- A

;----

;
;+
;- --> IMAGE MASKS before multiplying by Power maps!!
;cc = 0
cc = 1
imdata = mask[ *,*,*,cc ]
;imdata = test[ *,*,*,cc ]
resolve_routine, 'image3', /is_function
dw
im = IMAGE3( $
    mask[*,*,*,cc], cols=3, rows=3, axis_style=0, max_value=1, min_value=0, buffer=buffer $
)
;
filename = 'test_masks_' + CCC[cc].channel
print, filename
;
save2, filename


;----
save, mask, filename='bda_masks.sav'
;----


;+
;- Image power maps again (copy code from 2020-07-08.pro)
;-   this time scaled to common min/max range in 3-minute power, and/or
;-   multiplied by saturation mask to set some pixel values = 0.
;-

help, aia1600maps
help, mask

mask[*,*,1,0] * aia1600maps[*,*,1] ))

;+
;- For next time (7/15/2020 or later):
;-   Show images before AND after multiplying by saturation mask, and compare.
;-   Maybe also compare with and without min_value and max_value.
;-


imdata = alog10(aia1600maps)
;imdata = alog10(aia1700maps)

;min_value = min(imdata)
;max_value = max(imdata)

dw
resolve_routine, 'image3', /is_function
im = IMAGE3( $
    imdata, $
    cols=3, rows=3, $
    axis_style=0, $
;    min_value=min_value, $
;    max_value=max_value, $
    rgb_table=AIA_GCT(wave=CCC[cc].channel), $
    buffer=buffer $
)
;


save2, 'aia1600maps_multiflare'
;save2, 'aia1700maps_multiflare'

;----
;-
;-



;=========================================================================



;+
;- Histogram
;-


help, mask

aia1600mask = mask[*,*,*,0]
aia1700mask = mask[*,*,*,1]

format='(e0.2)'
;
for ii = 0, 8 do begin
    ;print, n_elements(where(aia1600mask[*,*,ii] eq 0.0))
    print, max(aia1700maps[*,*,ii]), format=format
endfor
;
;imdata = aia1600maps * aia1600mask
;filename = 'aia1600_BDA_histogram'
imdata = aia1700maps * aia1700mask
filename = 'aia1700_BDA_histogram'
;
nbins = 500
ydata = LONARR(nbins, 9)
xdata = LONARR(nbins, 9)
;help, ydata[0,0]
;
;
for ii = 0, 8 do begin
    ydata[*,ii] = HISTOGRAM( $
        ;imdata, $
        imdata[*,*,ii], $
        locations=locations, $
        nbins=nbins, $
        binsize=binsize, $
        ;min=0.0, $
        omax=omax, $
        omin=omin $
    )
    xdata[*,ii] = locations
endfor

;help, ydata
;print, max(xdata)
;print, max(ydata)
;
;
for jj = 0, 8 do begin
    for ii = 0, nbins-2 do begin
        npix = total( ydata[ii:nbins-1, jj] )
        ;- [] test for MIN x-range as well
        if npix lt 100 then begin
            print, jj, ii, npix
            break
        endif
    endfor
endfor
;
;ind = [0:nbins/2]
;help, ind
;print, max(ydata[ind,0])
;
ind = [1:499]
    ;- NOTE:  x-range cutoff, doesn't change with new value for nbins.
    ;- NOTE2: Exclude first element of xdata because lots of pixels in imdata = 0
    ;-   b/c of multiplication by saturation mask... true values NE 0...
    ;-  (not setting VALUE of xrange[0] = 0... starting with element 1, which
    ;-   in this case = 51 (will fluxuate with different bin sizes).
;
;
wy = 8.5
wx = 8.5
dw
win = window( dimensions=[wx,wy]*dpi, buffer=buffer )
resolve_routine, 'plot2', /is_function
;
plt = objarr(9)
for ii = 0, 8 do begin
    plt[ii] = plot2( $
        xdata[ind,ii], $
        ydata[ind,ii], $
        /current, $
        layout=[3,3,ii+1], $
        margin=0.15, $
        stairstep=1, $
        ;xlog=1, $
        ylog=1, $
        xmajor=4, $
        xtickunits="scientific", $
        ytickunits="scientific", $
        ;yrange=[0.1, 10^(ceil(alog10(max(result)))) ], $
        ;yrange=[0,10], $
        ;min_value=0, $
        xticklen=(0.20/wy), $
        yticklen=(0.20/wx), $
        ytitle='log # pixels', $
        xtitle='log 3-min power', $
        buffer=buffer $
    )
endfor
;
plt[0].title='C3.0 pre-flare'
plt[1].title='C3.0 flare'
plt[2].title='C3.0 post-flare'
plt[3].title='M7.3 pre-flare'
plt[4].title='M7.3 flare'
plt[5].title='M7.3 post-flare'
plt[6].title='X2.2 pre-flare'
plt[7].title='X2.2 flare'
plt[8].title='X2.2 post-flare'
;- [] need better multiflare structure setup for this!
;
;save2, 'histogram_' + strtrim(ii+1,1)
;
save2, filename

;===============================================================================


help, mask

help, aia1600mask

help, aia1600maps
help, aia1700maps

imdata = aia1600maps
imdata = aia1700maps

;---

;filename = 'aia1600maps_multiflare'
filename = 'aia1700maps_multiflare'
;
;imdata = (alog10(aia1600maps)) * aia1600mask
;imdata = (alog10(aia1700maps)) * aia1700mask
;
;imdata = alog10( (aia1600maps * aia1600mask) + 0.0001  )
imdata = alog10( (aia1700maps * aia1700mask) + 0.0001  )
;
dw
resolve_routine, 'image3', /is_function
im = IMAGE3( $
    imdata, $
    cols=3, rows=3, $
    axis_style=0, $
    ;min_value=min(alog10(aia1600maps)), $
    min_value=min(alog10(aia1700maps)), $
    max_value=max(imdata), $
    ;rgb_table=AIA_GCT(wave='1600'), $
    rgb_table=AIA_GCT(wave='1700'), $
    buffer=buffer $
)
;
save2,  filename


;- axis_style test (sole purpose was to add comment to 'image2.pro'
;-   specifying which value of axis_sytle dw is default.
;-  Then became curious as to what default value is for PLOT.
;plt = plot(indgen(10), buffer=buffer, axis_style=0)
plt = plot(indgen(10), buffer=buffer)
help, plt
;print, plt.axis_style
;
save2, 'test'

;--------------------------------------------------------



;+
;- Image power maps (final)
;-


;cc = 0
cc = 1
;
;imdata = alog10(aia1600maps)
imdata = alog10(aia1700maps)
;
dw
resolve_routine, 'image3', /is_function
im = IMAGE3( $
    imdata, $
    cols=3, rows=3, $
    axis_style=0, $
    rgb_table=AIA_GCT(wave=A[cc].channel), $
    buffer=buffer $
)
;
filename = 'aia' + A[cc].channel + 'maps_multiflare'
print, filename
;
save2, filename

;=============================================================================

;+
;-  P_3min(t) from MAPS instead of integrated flux.
;-    (copied code from Powercurves/get_power_from_maps.pro
;-      b/c too much of a mess even for "bare min" figures).


;- EXTERNAL SUBROUTINES:
;-   powermap_mask.pro
;-   plot_pt.pro
;-
;- PURPOSE:
;-   1. Calculate P(t) by summing over power maps.
;-   2. Plot P(t) curves for all channels.
;-  (aka does both computations AND graphics... these should be separate codes).
;-

;- Steps:
;-   edit parameters.pro to analyze flare 0, 1, or 2
;-   IDL> .RUN struc_aia
;-   IDL> .RUN restore_maps
;-

buffer =1
dz = 64


;----
;- Compute P(t)
;-

@parameters
;
sz = size( A.map, /dimensions )
print, sz
power = fltarr( sz[2], sz[3] )
;
for cc = 0, n_elements(A)-1 do begin
    power[*,cc] = (total(total(A[cc].map,1),1))
endfor
;
format='(e0.4)'
for cc = 0, n_elements(A)-1 do begin
    print, ""
    print, "  min P(t) = ", min(power[*,cc])
    print, "  max P(t) = ", max(power[*,cc])
    print, "$\Delta$P = ", max(power[*,cc])/min(power[*,cc])
    print, max(A[cc].map[*,*,280]), format=format
endfor
print, ""
;
for cc = 0, n_elements(A)-1 do begin
    loc = where( power[*,cc] eq max(power[*,cc]) )
    ;print, loc
    ;print, loc + (dz/2)
    print, A[0].time[loc]
    print, A[0].time[loc+(dz/2)]
    print, A[0].time[loc+dz-1]
endfor


;----
;- Plot P(t)
;-

resolve_routine, 'plot_pt', /is_function
dw
plt = PLOT_PT( $
    A[0].time, power, dz, buffer=buffer, $
    stairstep = 1, $
    ;yminor = 4, $
    title = '', $
    ;yrange=[-250,480], $ ; maps
    name = A.name  $
)
;
;
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"




fname = 'time-3minpower_maps_' + class; + '_3'
;
resolve_routine, 'save2', /either
save2, fname


end
