;Copied from clipboard


;filename = 'pt_maskGlobal_' + class
filename = 'time-3minutepower_maps_' + class
resolve_routine, 'save2'
save2, filename, /timestamp, /overwrite

end

