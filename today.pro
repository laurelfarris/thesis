;+
;oo  02 July 2020
;oo 
;oo





@parameters
;- .RUN struc_aia
cc = 0
;cc = 1
dz = 64


foreach zz, z_start, ii do begin
    print, ii, zz
    map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=[zz:zz+99] )
        ;oo  02 July 2020
        ;oo   Probably faster to pass a small subset of A.data each loop iteration
        ;oo   instead of the entire data cube when don't need most of it.
    filename = 'map' + strtrim(ii,1) + '.sav'
    print, filename
    save, map, filename=filename
    undefine, map
endforeach




savename = 'aia' + A[cc].channel + 'map.sav' 
print, savename

map = finalmap
undefine, finalmap

save, map, filename=savename

;-----------------------------------------------------------------------------





end
