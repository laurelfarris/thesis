

;- 02 December 2018

;- call: IDL> @restore_maps

;- Since there's no point restoring maps in prep.pro
;-  if won't be using them, put this in separate code.

restore, '../aia1600map_2.sav'
A[0].map = map
restore, '../aia1700map_2.sav'
A[1].map = map
