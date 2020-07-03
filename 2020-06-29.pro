;+
;oo  29 June 2020, 01 July 2020
;oo 
;oo  Today's task: compute power maps for C3.0 and M7.3 flares
;oo    (if hasn't been done already)
;oo 
;oo  As of today, may no longer type '-' after ';' comment character because
;oo  it's too  hard to reach and I can't figure out how to make vim
;oo  recognize ';' as the comment character for filetype IDLANG
;oo





@parameters
;- .RUN struc_aia

;----

cc = 1
dz = 64

;---


;- create two power maps from AIA 1600 data, before and after
;- dividing flux by exposure time, for 2014-04-18 M-class flare.
;- Compare to maps restored from .sav files.

;map = COMPUTE_POWERMAPS(/syntax)

map1 = COMPUTE_POWERMAPS( $
    A[cc].data[*,*,0:dz-1], $
    A[cc].cadence, fcenter=0.0056, bandwidth=0.001 $
)
help, map1
print, max( map1[*,*,0] )

map2 = COMPUTE_POWERMAPS( $
    A[cc].data[*,*,0:dz-1]/A[cc].exptime, $
    A[cc].cadence, fcenter=0.0056, bandwidth=0.001 $
)
help, map2

print, max( map2[*,*,0] )

restore, '../20140418/aia'+A[cc].channel+'map.sav'
help, map
print, max( map[*,*,0] )


;oo  9:54 -- repeated the above steps for AIA 1700
;oo


print, max(map1[*,*,0]) -  max(map2[*,*,0])

print, sqrt( max(map1[*,*,0]) -  max(map2[*,*,0]) )

print, max(A[cc].data[*,*,0]) -  (max(A[cc].data[*,*,0])/A[cc].exptime)


;oo  10:02 -- looks like data was NOT divided by exposure time before
;oo   computing power maps (both channels).
;oo  Updated README in 20140418 directory to include this, so hopefully
;oo  won't ever have to check this again.

;----------------------------------


;oo  Time to compute power maps for C3.0 flare.
;oo  --> haven't done this since full five hours was downloaded, processed
;oo   with aia_prep, and re-aligned.
@parameters
restore, '../' + year + month + day + '/aia' + A[cc].channel + 'map_SHORT.sav'
help, map
;oo   "map"  FLOAT  = Array[500, 330, 536]

sz = size(A[cc].data, /dimensions)
print, sz[2]
print, sz[2]-dz
print, sz[2]-dz+1

z_start = indgen(sz[2]-dz+1)
help, z_start

undefine, map
undefine, map1
undefine, map2
undefine, cube

cc = 0
;cc = 1
print, A[cc].channel

map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=z_start )

help, map
;oo  "map"  FLOAT  = Array[]

savename = 'aia' + A[cc].channel + 'map.sav' 
print, savename

save, map, filename=savename


;oo  18:42 -- second sswidl session for AIA 1700 maps
;aia1700map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=z_start )
;oo    Never mind...



end
