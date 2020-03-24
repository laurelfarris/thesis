;+
;- 23 March 2020
;-
;- Today's project:
;-   Generate powermap and compare to restored maps from Modules/restore_maps.pro
;-
;- COMPUTE_POWERMAPS.pro .... better to crop input data prior to input arg?
;-  Or let subroutine do this, using z_start=280 (or w/e).
;-  Passing huge array back and forth may be unecessarily slow if only only
;-  small portion for the computation.
;-
;-
;-

;+
;- IDL> .RUN struc_aia
;- IDL> .RUN restore_maps
;-

@parameters
cc = 0
dz = 64
z_start = 280
ind = [z_start:z_start+dz-1]

resolve_routine, 'compute_powermaps', /either
;map = COMPUTE_POWERMAPS( /syntax )

mapdata = A[cc].data[*,*,ind]

;- data NOT corrected for exposure time
map1 = COMPUTE_POWERMAPS( mapdata, A[cc].cadence )


;- exposure-time-corrected data
resolve_routine, 'compute_powermaps', /either
map2 = COMPUTE_POWERMAPS( (A[cc].data[*,*,ind])/A[cc].exptime, A[cc].cadence )



format = '(e0.8)'
print, (max(map1))/((A[cc].exptime)^2), format=format
;-  2.12026850e+05
print, max(A[cc].map[*,*,z_start]), format=format
;-  2.12020172e+05


;+
;----> pretty sure restored maps were computed from exptime-corrected data,
;-       and that power does scale as input SQUARED.
;-



print, max(map2), format=format
print, max(A[cc].map[*,*,z_start]), format=format


print, max(map1) / max(A[cc].map[*,*,z_start]), format=format

print, ((max(map1) / max(A[cc].map[*,*,z_start])) / (A[cc].exptime^2)), format=format


;-   = 8.41465
;- --> A[0].exptime = 2.9007560
;-
print, max(map2) / max(A[cc].map[*,*,z_start]), format=format
;-   = 1.00003

loc = array_indices( map2, where(map2 eq max(map2)) )
;loc = array_indices( A[cc].data[*,*,ind], where(A[cc].data[*,*,ind] eq max(A[cc].data[*,*,ind])) )
print, loc


print, A[cc].data[225,133,1]
print, (A[cc].data[225,133,1])^2
print, map2[225,133]




;-------------------------------------------------------------

;+
;- NEXT: re-create maps in Figures 3, 4, and 5 in article1.
;-   --> IDL code "article1_maps.pro" (really need to rename this...)
;-


end
