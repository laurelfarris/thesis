;+
;- 29 April 2019

;- USEAGE:
;-   IDL> @restore_maps

@parameters

path = '/solarstorm/laurel07/' + year+month+day + '/'

;restore, '/solarstorm/laurel07/aia1600map_2.sav'
restore, path + 'aia1600map.sav'
aia1600 = A[0]
aia1600 = create_struct( aia1600, 'map', map )

;restore, '/solarstorm/laurel07/aia1700map_2.sav'
restore, path + 'aia1700map.sav'
aia1700 = A[1]
aia1700 = create_struct( aia1700, 'map', map )

A = [ aia1600, aia1700 ]

undefine, map, aia1600, aia1700
;delvar, map
;delvar, aia1600
;delvar, aia1700


;A[0].map = map
;A[1].map = map
