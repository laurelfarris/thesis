;- 19 January 2020


yy = A[0].flux

;- compare plots of:
;- log(y), y^{-1}, 1/y, sqrt(y)


;- ^-1 --> inverse, plot is basically upside down

dw
plt = plot2( sqrt(yy) )  
plt2 = plot2( yy^0.1 , $
    overplot=0, $
    color='blue')

;-----------------------------------------------

;- Can probably delete everything above



format = '(e0.6)'

;- Min/Max of flux
for cc = 0, 1 do $
    print, max(A[cc].flux), format=format

;- Exptime-corrected flux
for cc = 0, 1 do $
    print, max(A[cc].flux/A[cc].exptime), format=format


;- Flux per pixel
for cc = 0, 1 do $
    print, max(A[cc].flux) / (500.*330.), format=format

for cc = 0, 1 do $
    print, max(A[cc].flux/A[cc].exptime) / (500.*330.), format=format



;-----------------------------------------------

@restore_maps
im = image2( A[cc].map[*,*,ii] )


cadence = 24
dz = 64
;ii = 0
ii = 252
cc = 0
data = A[cc].data[*,*,ii:ii+(dz-1)]
map1 = compute_powermaps( data, cadence, norm=0 )
map2 = compute_powermaps( data/A[cc].exptime, cadence, norm=0 )

format='(e0.9)'
print, min(map1), format=format
print, max(map1), format=format
;print, max(map1)/min(map1), format=format
;print, max(map1)-min(map1), format=format
;print, min(map2), format=format
;print, max(map2), format=format
print, max(map2)/min(map2), format=format
;print, max(map2)-min(map2), format=format


print, A[cc].time[ii]



@parameters
path = '/solarstorm/laurel07/' + year+month+day + '/'

;restore, path + 'aia1600map.sav'
restore, path + 'aia1600map_2.sav'

print, max(map)
print, min(map)

ii=253
cc=0
imdata = map[*,*,ii]
dw
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )


print, max(aia1600map[*,*,ii])
print, max(map1)
print, max(map2)






aia1600map = map

;restore, path + 'aia1700map.sav'
restore, path + 'aia1700map_2.sav'
print, max(map)
aia1700map = map
;undefine, map


print, max(aia1600map)
print, max(aia1700map)

print, min(aia1600map)
print, min(aia1700map)

print, min(A[cc].map[*,*,ii]), format=format
print, max(A[cc].map[*,*,ii]), format=format

end
