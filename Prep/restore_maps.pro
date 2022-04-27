; This is probably obsolete now that I don't think it makes sense to read huge data
;  arrays into structure every IDL session, especially if not even using maps. 



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
;- NOTE:
;-  Doesn't work if maps have already been added to structure;
;-    get "duplicate tag def." or whatever
;-  Pretty sure test for tagname "MAP" takes care of this, but there
;-    may be cases where it doesn't, so leaving this note here.
;-     (23 January 2020)
;-
;- OLD PATH/FILENAMES:
;-   restore, '/solarstorm/laurel07/aia1600map_2.sav'
;-   restore, '/solarstorm/laurel07/aia1700map_2.sav'
;-     ????????? (23 January 2020)
;-

@parameters

path = '/solarstorm/laurel07/' + year+month+day + '/'

;- TEST to see if struc already has tag "map"
;-   NOTE: structure tag strings ARE case-sensitive (i.e. "map" doesn't match)
tagnames = tag_names(A)
test = where(tagnames eq "MAP")
print, tagnames
print, test


;if test eq -1 then begin  -->  true even though test = 13... I don't get it.

if (test ge 0) then begin
;- If map is already included in structures, simply set each A[cc].map = map,
;-   where "map" is name of variable that has just been freshly restored.


    print, 'Replace existing map with restored map.'

    restore, path + 'aia1600map.sav'
    ;restore, path + 'aia1600map_2.sav'
;    help, map
;    help, A[0].map
    A[0].map = map
    undefine, map

    restore, path + 'aia1700map.sav'
    ;restore, path + 'aia1700map_2.sav'
    A[1].map = map
    undefine, map

stop

endif else begin

;- If tag for "map" has not been added to structures in array "A", add them now.
;if (where(tagnames eq "MAP") eq -1) then begin

    print, 'Adding tag "MAP" to struc array "A", set to restored maps.'
    ;
    restore, path + 'aia1600map.sav'
    ;restore, path + 'aia1600map_2.sav'
    aia1600 = A[0]
    aia1600 = create_struct( aia1600, 'map', map )
    ;
    restore, path + 'aia1700map.sav'
    ;restore, path + 'aia1700map_2.sav'
    aia1700 = A[1]
    aia1700 = create_struct( aia1700, 'map', map )
    ;
    A = [ aia1600, aia1700 ]
    ;
    undefine, map
    undefine, aia1600
    undefine, aia1700
    ;delvar, map
    ;delvar, aia1600
    ;delvar, aia1700
    ;
    ;A[0].map = map
    ;A[1].map = map
    ;

endelse


end
