;- 25 July 2019

goto, start

restore, '../20131228/aia1600shifts.sav'
;-  variable "aia1600shifts"; = FLOAT array [2, 595, 6]
restore, '../20131228/aia1700shifts.sav'
;-  variable "aia1700_shifts"; = FLOAT array [2, 594, 7]

;- Inconsistency with variable names, so re-doing this now.


aia1700shifts = aia1700_shifts
undefine, aia1700_shifts

save, aia1700shifts, filename='aia1700shifts.sav'

start:




;- Check that everything is in order, then replace old .sav file with new one.

;restore, '../20131228/aia1700shifts.sav'
restore, 'aia1700shifts.sav'
help
end
