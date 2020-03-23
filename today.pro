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
print, path
stop

@parameters
cc = 0
dz = 64
z_start = 280

resolve_routine, 'compute_powermaps', /either
;map = COMPUTE_POWERMAPS( /syntax )
map = COMPUTE_POWERMAPS( $
    A[cc].cube[*,*,z_start+dz-1], $
    A[cc].cadence, $
    dz=dz, $
    z_start=z_start )


print, max(map)
print, max(A[cc].map[*,*,z_start]
stop


;mapfilename = 'TEST_' + instr + A[cc].channel + 'map.sav'
;print, mapfilename
;print, path + mapfilename
;save, map, filename=path + mapfilename

;+
;-
;-
;-


end
