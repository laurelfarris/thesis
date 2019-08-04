;- 25 July 2019


restore, '../20131228/aia1600shifts.sav'
;-  variable "aia1600shifts"; = FLOAT array [2, 595, 6]
restore, '../20131228/aia1700shifts.sav'
;-  variable "aia1700_shifts"; = FLOAT array [2, 594, 7]

;- Inconsistency with variable names, so re-doing this now.


aia1700shifts = aia1700_shifts
undefine, aia1700_shifts

save, aia1700shifts, filename='aia1700shifts.sav'


;- Check that everything is in order, then replace old .sav file with new one.

;restore, '../20131228/aia1700shifts.sav'
restore, 'aia1700shifts.sav'
help



;- 28 July 2019

;- 1600\AA{} z-indices that need to have shifts interpolated (roughly):
;- bad = [400:500]


;- Use align_in_pieces to aligns in 3 parts per looop:
;-   1. calculate shifts
;-   2. interpolate shifts
;-   3. apply interpolated shifts to get properly aligned cube

end
