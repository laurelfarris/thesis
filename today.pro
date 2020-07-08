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

end
