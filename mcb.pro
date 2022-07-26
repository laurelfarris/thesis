;Copied from clipboard


for cc = 0, 1 do begin
    map[*,*,cc] = COMPUTE_POWERMAPS( $
        A[cc].data[*,*,z_imp], cadence, bandwidth=0.001)
    map_mask[*,*,cc] = PRODUCT( data_mask[*,*,z_imp,cc], 3 )
endfor
;
for cc = 0, 1 do begin
    map[*,*,cc+2] = COMPUTE_POWERMAPS( $
        A[cc].data[*,*,z_decay], cadence, bandwidth=0.001 )
    map_mask[*,*,cc+2] = PRODUCT( data_mask[*,*,z_decay,cc], 3 )
endfor

end

