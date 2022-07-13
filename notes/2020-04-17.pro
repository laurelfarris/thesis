;+
;- 17 April 2020
;-
;-



@parameters
path = '/solarstorm/laurel07/' + year+month+day + '/'
print, path
restore, path + 'aia1600map.sav'
aia1600map = map
undefine, map
restore, path + 'aia1700map.sav'
aia1700map = map
undefine, map


print, max(aia1600map)
print, max(aia1700map)




buffer = 1
imdata = aia_intscale( aia1600map[*,*,0], wave=1600, exptime=2.90 )
im = image2( $
    ;aia1600map[*,*,0], $
    ;alog10(aia1600map[*,*,0]), $
    imdata, $
    rgb_table=AIA_GCT( wave=1600 ), $
    buffer=buffer)
;-
save2, 'test_aia1600map_C30'


end
