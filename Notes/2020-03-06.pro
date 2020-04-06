;+
;- 06 March 2020
;-
;- Looking into AIA header information that might be useful.
;-


resolve_routine, 'read_my_fits'
READ_MY_FITS, index, data, $
    instr='aia', $
    channel=1600, $
    ind=[280], $
    nodata=0, $
    prepped=1


print, index.date_obs
print, index.nsatpix
print, index.nspikes
print, index.missvals

print, index.pixlunit


im = image2( data )

;--

end
