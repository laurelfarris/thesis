;Copied from clipboard


start_time = systime()
;READ_SDO, fls, index, data
READ_SDO, fls[ind], index, data
print, "Started at ", start_time
print, "Finished at ",  systime()
;undefine, data

end

