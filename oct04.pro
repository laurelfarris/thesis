;; Last modified:   04 October 2017 16:55:47


goto, START


for i = 0, 502 do begin
   
    if datHMI[i].physobs ne "intensity" then print, datHMI[i].physobs

endfor

;; HMI data types (for kw "physobs"):
;;  intensity
;;  vector_magnetic_field
;;  LOS_magnetic_field
;;  LOS_velocity



START:;----------------------------------------------------------------------------------------------------------




end
