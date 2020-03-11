;Copied from clipboard


;-
;-
;- query, download, and run aia_prep on test data.
result = VSO_SEARCH(t0, t1, inst=inst, wave=wave, sample=sample)
log = VSO_GET(result, out_dir='SDO_guide',filenames=fnames, /rice)
aia_prep, fnames, -1, out_index, out_data
;-
;-
;- convert images to a map structure, plot the first one.
index2map, out_index, out_data, map
plot_map, map, /log, drange=[1e2, 1e4]
;-
;-
;-

end

