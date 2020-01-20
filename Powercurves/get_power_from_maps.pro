;+
;- LAST MODIFIED:
;-   13 August 2019
;-
;- ROUTINE:
;-   get_power_from_maps.pro
;-
;- EXTERNAL SUBROUTINES:
;-   powermap_mask.pro
;-   plot_pt.pro
;-
;- PURPOSE:
;-   1. Calculate 1D array of power as function of time, P(t),
;-     by summing over power maps.
;-   2. Plot P(t) curves for all channels.
;-
;- USEAGE:
;-   IDL> .RUN get_power_from_maps
;-
;- INPUT:
;-   N/A (is a Main Level (ML) routine)
;-
;- KEYWORDS:
;-   N/A
;-
;- OUTPUT:
;-   N/A
;-
;- TO DO:
;-   [] write subroutine with data as input argument
;-   [] Add test codes
;-   [] Create new saturation routine (this currently addresses
;-      saturation and calculation of total power with time.
;-
;- KNOWN BUGS:
;-   Possible errors, harcoded variables, etc.
;-
;- AUTHOR:
;-   Laurel Farris
;-


;----------------------------------------------------------------------------------


;- From IDL command line, run the following Main Level codes BEFORE
;-   calling this one.

; IDL> .run image_powermaps
; IDL> .run contours
; IDL> .run sub
; IDL> .run get_power_from_maps


;- Restore AIA powermaps from .sav files and read into A[0].map and A[1].map.
@restore_maps

format = "(e0.5)"
for cc = 0, n_elements(A)-1 do begin
    print, ""
    print, A[cc].channel, ":"
    print, "  min PowerMap = ", min(A[cc].map);, format=format
    print, "  max PowerMap = ", max(A[cc].map);, format=format
endfor

;- Thu Jan 24 11:46:02 MST 2019
;-   Correct restored power map for saturation by multiplying by mask.


dz = 64
;sz = size( A.data, /dimensions )
sz = size( A.map, /dimensions )
  ;- not sure why I was using data dimensions... esp. since 15-Feb-2011 flare
  ;-  power maps don't have correct z-dimensions, so can't base map_mask dimensions
  ;-  on data, or what dimensions "should" be.
  ;-  Wouldn't work if maps weren't computed or restored yet, and needed map_mask
  ;-   first? Unlikely...


;--------------------------------------------------------------------------

;- Initialize MAP mask
;map_mask = fltarr(sz[0],sz[1],sz[2]-dz+1,n_elements(A))
;map_mask = fltarr(sz[0],sz[1],sz[2],n_elements(A))
  ;- remove correction to z-dim (only needed when using data dims...)

map_mask = fltarr(sz)  ;- I was making this way too complicated...
;- Compute MAP mask
resolve_routine, 'powermap_mask', /either
for cc = 0, 1 do $
    map_mask[*,*,*,cc] = POWERMAP_MASK( $
        A[cc].data, $
        ;sz = size(A[cc].map, /dimensions), $
          ;- see rambling comments in powermap_mask.pro where sz is defined.
        dz=dz, $
        exptime=A[cc].exptime, $
        threshold=10000. )

; --> returns FLOAT [500,330,686,2]


;- Multiply mask by AIA power maps to set saturated pixels = 0.
;- NOTE: maps in AIA structure array ('A') are overwritten, so be careful!
;-  Tho is easy to restore maps from .sav files if I screw it up.
;-  Doing it here because already did this once before noticing that map_mask
;-  had the wrong z-dimensions... but now there's a "conflicting or dupliate
;-  structure tag definition... stupid.
;@restore_maps

A.map = A.map * map_mask

for cc = 0, n_elements(A)-1 do begin
    print, ""
    print, A[cc].channel, ":"
    print, "  min PowerMap = ", min(A[cc].map);, format=format
    print, "  max PowerMap = ", max(A[cc].map);, format=format
endfor




;- # UNSATURATED pixels in each map.
n_pix = total(total(map_mask,1),1)
;- FLOAT  = Array[686, 2] for 15 Feb 2011 flare
    ;- Test n_pix
    if (where(n_pix eq 0.0))[0] ne -1 then begin
        print, "Problem: n_pix = 0 somewhere, which should be impossible. "
        stop
    endif


;---------------------------------------------------------------------------------------------


;- P(t) pix^{-1} = 1D array created by summing over x & y in each map.
;power = (total(total(map,1),1)) / n_pix


;- Total power for small subregions

;r = 20
;cc = 0

;map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=[367,213] )
;map2 = CROP_DATA( A[cc].map, dimensions=[r,r], center=[382,193] )

;- center variable is defined in sub.pro
;map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,0] )
;map2 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,1] )

;n_pix = float(r*r) ;- map is FLOAT, so may as well convert n_pix

;p1 = (total(total(map1,1),1)) / n_pix
;p2 = (total(total(map2,1),1)) / n_pix


;- Use single pixel at center; no need to sum pixels or divide by n_pix
;-  (previously getting non-zero values during saturation times due to summing
;-    over several pixels, not all of which would have saturated at the same time.
;-    Didn't think plots showed accurate results).
;- --> lots of periodicity in P(t)... is this what Monsue et al. 2016 meant
;      when they said integrating over slightly larger area improved SNR?
;p1 = A[cc].map[center[0,0], center[1,0], *]
;p2 = A[cc].map[center[0,1], center[1,1], *]


;xdata = indgen(686)
  ;- all lines of code using xdata are currently commented out... (8/13/19)
  ;-  Also this is hardcoded... :(
;xdata = indgen(686, 2)
;ydata = [ [p1[*,0]], [p2[*,0]] ]
;plt = BATCH_PLOT( xdata, ydata, buffer=0 )

;- plotting is done externally... apparently tried doing it here, which was
;-  probably way too messy. Lots of clutter in this code that I don't need,
;-  but too scared to delete anything.


;dw
;wx = 8.0
;wy = 4.0
;win = window( dimensions=[wx,wy]*dpi, buffer=1 );location=[1250,0] )

;- 20 June 2019
;-  XQuartz quit, chose option to "reopen", but sswidl still quit somewhere in here.
;-  Triggered by call to DW? Or creation of window object "win"?
;-    Really fucking tired of this...
;-  Restarted sswidl. Don't have to ssh in again since re-started XQuartz,
;-    though still have to start idl session from scratch.

;mm = (size(center, /dimensions))[1]
;plt = objarr(mm)
;for ii = 0, mm-1 do begin
    ;map1 = CROP_DATA( A[cc].map, dimensions=[r,r], center=center[*,ii] )
;    p1 = (total(total(map1,1),1)) / n_pix
;    plt[ii] = plot2( xdata, p1, /current, overplot=ii<1, ylog=1, color=color[ii] )
;endfor

;plt = plot2( xdata, p1, /current, ylog=1, color="blue" )
;plt = plot2( xdata, p2, /overplot, ylog=1, color="red" )

;help, (total(total(A[0].map,1),1)) / n_pix

;- Initialize 1D power array (z-dim matches that of map and map_mask).
;power = fltarr(685, 2)
  ;- what's with the hard-coding??
power = fltarr( sz[2], sz[3] )
;power = (total(total(map,1),1)) / n_pix
  ;- ??
;power[*,0] = (total(total(A[0].map,1),1)) / n_pix[*,0]
;power[*,1] = (total(total(A[1].map,1),1)) / n_pix[*,1]

;-----------------------------------------------------------------------------------
;- Compute power WITHOUT excluding saturated pixels, compare values

@restore_maps
;A.map = A.map * map_mask
for cc = 0, n_elements(A)-1 do begin
;for cc = 0, 0 do begin
    print, ""
    power[*,cc] = (total(total(A[cc].map,1),1))
    ;power[*,cc] = (total(total(A[cc].map,1),1)) / (500.*330)
    ;power[*,cc] = (total(total(A[cc].map,1),1)) / n_pix[*,cc]
    print, A[cc].channel, ":"
    print, "  min P(t) = ", min(power[*,cc])
    print, "  max P(t) = ", max(power[*,cc])
    print, "$\Delta$P = ", max(power[*,cc])/min(power[*,cc])
    print, ""
    print, max(A[cc].map[*,*,280])
endfor


for cc = 0, n_elements(A)-1 do begin
    loc = where( power[*,cc] eq max(power[*,cc]) )
;    print, loc
;    print, A[0].time[loc]
;    print, A[0].time[loc+dz-1]
    print, loc + (dz/2)
    print, A[0].time[loc+(dz/2)]
endfor



;-----------------------------------------------------------------------------------






;print, min(power[*,0])
;print, max(power[*,0])
;print, min(power[*,1])
;print, max(power[*,1])
  ;- printing min/max values in for loop now, so can probably delete the above 4 lines.


;print, "AIA 1600:"
;st = stats( power[*,0], /display )
;print, st.min * A[0].exptime
;print, st.max * A[0].exptime
;print, "AIA 1700:"
;st = stats( power[*,1], /display )
  ;- there's also this... I forgot what that "stats" routine does...

;- Run separate routine for plotting:
;power_from_maps = power
  ;- ????  Not used anywhere... Good lord this code is a mess.



;- This routine calls PLOT_PT -- specifically for Power vs. time, then
;- PLOT_PT calls BATCH_PLOT, which is a general routine for plotting
;-   multiple lines overlaid on the same axes. It takes care of all the
;-   looping and making the plots look pretty, allowing the caller, the code
;-   doing the actual science, to be relatively clutter-free ("relatively"...)
;-
;- buffer=1 by default in plot_pt.pro (tho wouldn't hurt to set anyway).
;-

;- --> Try adding mini-axis BEFORE shifting ydata.

;- With the "props" structures, the call to plot_pt is still exactly
;-  the same in _maps as it is in _flux...
;- NOTE: xdata is defined in plot_pt


stop ;- Before plotting..



resolve_routine, 'plot_pt', /is_function
dw
plt = PLOT_PT( $
    A[0].time, power, dz, buffer=0, $
    stairstep = 1, $
    ;yminor = 4, $
    title = '', $
    name = A.name )
    ;yrange=[-250,480], $ ; maps
;ax = plt[0].axes
;ax[1].tickname = strtrim([68, 91, 114, 137, 160],1)
;ax[3].tickname = strtrim([1220, 1384, 1548, 1712, 1876],1)
ax2 = (plt[0].axes)[1]
ax2.title = plt[0].name + " 3-minute power"
ax2.text_color = plt[0].color
ax3 = plt[1].axes
ax3.title = plt[1].name + " 3-minute power"

stop

fname = 'time-3minpower_maps_' + class + '_3'
resolve_routine, 'save2', /either
save2, fname


end
