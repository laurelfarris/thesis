;+
;- 02 December 2018

;- USEAGE:
;-   IDL> @restore_maps

restore, '../aia1600map_2.sav'
A[0].map = map
restore, '../aia1700map_2.sav'
A[1].map = map
