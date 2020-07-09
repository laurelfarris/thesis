;+
;oo  08 July 2020
;oo
;oo


;+
;- To do today :
;-   [] BDA maps
;- Steps:
;-   • .RUN restore_maps (requires @parameters AND .RUN struc_aia b/c uses 'A')
;-       DON'T NEED A.DATA!  What do I do????
;-   • EVENTUALLY : general imaging routine for power maps, but not
;-      until I have a figure to show this week.
;-


buffer=1

@parameters

cc = 0
dz = 64

;---------------------------------------

;- Derive BDA z_start values (from 2020-06-19)
time = strmid( A[cc].time, 0, 5 )

;print, gstart
;print, where( time eq strmid(gstart,0,5) )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind = [z1, z2, z3]

print, time[zind]

stop
;---------------------------------------


;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps

c30_1600_before = A[0].map[*,*,z1]
c30_1600_during = A[0].map[*,*,z2]
c30_1600_after  = A[0].map[*,*,z3]
;
c30_1700_before = A[1].map[*,*,z1]
c30_1700_during = A[1].map[*,*,z2]
c30_1700_after  = A[1].map[*,*,z3]

;---

@parameters
;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps
;- IDL> .RUN today
;-   Need to re-compute z-indices for new flare

m73_1600_before = A[0].map[*,*,z1]
m73_1600_during = A[0].map[*,*,z2]
m73_1600_after  = A[0].map[*,*,z3]
;
m73_1700_before = A[1].map[*,*,z1]
m73_1700_during = A[1].map[*,*,z2]
m73_1700_after  = A[1].map[*,*,z3]

;- 14:01 repeating this after renaming power map .sav files for 2011 X2.2 flare
print, min(x22_1600_during)
;- IDL> .RUN restore_maps
;-    ERROR... still not handling existance of 'map' tag in A.  :( :(
;-    Guess I'll just re-run struc_aia
;- IDL> undefine, A
;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps

x22_1600_before = A[0].map[*,*,z1]
x22_1600_during = A[0].map[*,*,z2]
x22_1600_after  = A[0].map[*,*,z3]
;
x22_1700_before = A[1].map[*,*,z1]
x22_1700_during = A[1].map[*,*,z2]
x22_1700_after  = A[1].map[*,*,z3]
;
print, min(x22_1600_during)
;-  --> 0.0026... (GT 0.0 !!!!!!!)
print min(A.map)
;-  --> 3.36e-05  ... ALL values are GT 0.0!!!!!!!!



format = '(e0.5)'
print, max(c30_1600_during), format=format
print, max(m73_1600_during), format=format
print, max(x22_1600_during), format=format


aia1600maps = [ $
    [[ c30_1600_before ]], $
    [[ c30_1600_during ]], $
    [[ c30_1600_after ]], $
    [[ m73_1600_before ]], $
    [[ m73_1600_during ]], $
    [[ m73_1600_after ]], $
    [[ x22_1600_before ]], $
    [[ x22_1600_during ]], $
    [[ x22_1600_after ]] $
]
help, aia1600maps

aia1700maps = [ $
    [[ c30_1700_before ]], $
    [[ c30_1700_during ]], $
    [[ c30_1700_after ]], $
    [[ m73_1700_before ]], $
    [[ m73_1700_during ]], $
    [[ m73_1700_after ]], $
    [[ x22_1700_before ]], $
    [[ x22_1700_during ]], $
    [[ x22_1700_after ]] $
]
help, aia1700maps


;- test for potential issues with computing log of power maps
;print, min(aia1600maps)

;locs = where(aia1600maps le 0.0)
;locs = where(aia1600maps LT 0.0)
;help, locs
;- Lots of pixel values = 0.0 in powermaps, but never LESS than 0.


print, max(aia1600maps), format=format
print, max(aia1700maps), format=format

print, min(aia1600maps), format=format
print, min(aia1700maps), format=format
;-  All values now GT 0.0   (14:07)


;--------------------------------------------------------


help, AIA_GCT(wave='1600')

;imdata = aia1600maps
imdata = alog10(aia1600maps)
;imdata = aia1600maps^-1
;


dw
resolve_routine, 'image3', /is_function
im = IMAGE3( $
    imdata, $
    cols=3, rows=3, $
    axis_style=0, $
    rgb_table=AIA_GCT(wave='1600'), $
    buffer=buffer $
)
;
save2, 'aia1600maps_multiflare'


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
;-  3-minute power as function of time
;-    from MAPS instead of integrated flux.



;- Copied code from Powercurves/get_power_from_maps.pro
;- b/c too much of a mess even for "bare min" figures.



;- EXTERNAL SUBROUTINES:
;-   powermap_mask.pro
;-   plot_pt.pro
;-
;- PURPOSE:
;-   1. Calculate P(t) by summing over power maps.
;-   2. Plot P(t) curves for all channels.
;-  aka does both computations AND graphics... these should be separate codes.
;-

buffer =1

@parameters
dz = 64

;-----------

;- Steps:
;-   edit parameters.pro to analyze flare 0, 1, or 2
;-   IDL> @struc_aia
;-   IDL> @restore_maps
;-

sz = size( A.map, /dimensions )
print, sz
power = fltarr( sz[2], sz[3] )


for cc = 0, n_elements(A)-1 do begin
    power[*,cc] = (total(total(A[cc].map,1),1))
;    print, "  min P(t) = ", min(power[*,cc])
;    print, "  max P(t) = ", max(power[*,cc])
;    print, "$\Delta$P = ", max(power[*,cc])/min(power[*,cc])
;    print, max(A[cc].map[*,*,280])
endfor


for cc = 0, n_elements(A)-1 do begin
    loc = where( power[*,cc] eq max(power[*,cc]) )
;    print, loc
;    print, A[0].time[loc]
;    print, A[0].time[loc+dz-1]
    print, loc + (dz/2)
    print, A[0].time[loc+(dz/2)]
endfor

;------------------------------------------------------------------------------


;+
;- Plot P(t)
;-
;-


resolve_routine, 'plot_pt', /is_function
dw
plt = PLOT_PT( $
    A[0].time, power/n_pix, dz, buffer=0, $
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


;fname = 'time-3minpower_maps_' + class; + '_3'
;fname = 'N_unsaturated_pixels' + class
fname = 'time-3minpower_maps_per_pixel' + class
resolve_routine, 'save2', /either
save2, fname


end
