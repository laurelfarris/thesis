;Copied from clipboard


;- Read fits files whose filename are included in fls
start_time = systime()
READ_SDO, fls, old_index, old_data, nodata=0
;READ_SDO, fls[ind], old_index, old_data, nodata=0
print, 'start time = ', start_time
print, 'end time = ', systime()

end

