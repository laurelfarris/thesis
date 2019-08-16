;+
;- LAST MODIFIED:
;-   13 August 2019
;-
;- WRITTEN:
;-   29 April 2019
;-
;- USEAGE:
;-   IDL> @restore_maps
;-
;- NOTE: Doesn't work if maps have already been added to structure.
;-  Get "duplicate tag def." or whatever
;-
;- OLD PATH/FILENAMES:
;-   restore, '/solarstorm/laurel07/aia1600map_2.sav'
;-   restore, '/solarstorm/laurel07/aia1700map_2.sav'
;-

@parameters

path = '/solarstorm/laurel07/' + year+month+day + '/'

;- TEST to see if struc already has tag "map"
;-   NOTE: structure tag strings ARE case-sensitive (i.e. "map" doesn't match)
tagnames = tag_names(A)
test = where(tagnames eq "MAP")

;if test eq -1 then begin  -->  true even though test = 13... I don't get it.

if (test ge 0) then begin
;- If map is already included in structures, simply set each A[cc].map = map,
;-   where "map" is name of variable that has just been freshly restored.

    restore, path + 'aia1600map.sav'
;    help, map
;    help, A[0].map
    A[0].map = map
    undefine, map

    restore, path + 'aia1700map.sav'
    A[1].map = map
    undefine, map


endif else begin
;- If tag for "map" has not been added to structures in array "A", add them now.
;if (where(tagnames eq "MAP") eq -1) then begin

    restore, path + 'aia1600map.sav'
    aia1600 = A[0]
    aia1600 = create_struct( aia1600, 'map', map )

    restore, path + 'aia1700map.sav'
    aia1700 = A[1]
    aia1700 = create_struct( aia1700, 'map', map )

    A = [ aia1600, aia1700 ]

    undefine, map
    undefine, aia1600
    undefine, aia1700
    ;delvar, map
    ;delvar, aia1600
    ;delvar, aia1700

    ;A[0].map = map
    ;A[1].map = map


endelse
