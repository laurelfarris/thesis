;; Last modified:   16 May 2018 18:59:50



goto, start


; Same variable name for both channels so I can
; use this in general subroutine.

restore, '../aia1600map2.sav'
map2 = aia1600map
save, map2, filename='aia1600map2.sav'
restore, '../aia1700map2.sav'
map2 = aia1700map
save, map2, filename='aia1700map2.sav'

restore, '../aia1600map.sav'
map = aia1600map
save, map, filename='aia1600map.sav'
restore, '../aia1700map.sav'
map = aia1700map
save, map, filename='aia1700map.sav'

;----------------------------------------------------------------------------------

temp = A[0].data
print, mean(temp)
; Seems like I could have done a single loop using logs somehow...
for i = 10000, 17000, 1000 do $
    print, n_elements(where( temp ge i AND temp lt i+1000))
;for i = 100, 1000, 100 do $
;    print, n_elements(where( temp ge i AND temp lt i+100))
stop


; Small sliver of pixels greater than 16000
mask[ where( temp ge sat )] = 0.1
mask[ where( temp ge sat + 1000 )] = 1.0


temp = A[0].data[65:300,100:275,275]
sz = size( temp, /dimensions )


; threshold
sat = 15000
; adjusted threshold
adj = 1000


im = image2( temp , $
    layout=[1,1,1], margin=0.0  )
stop

temp = A[0].data[*,*,275]
sz = size( temp, /dimensions )
mask = fltarr( sz )

mask[ where( temp ge 1000 )] = 0.1
mask[ where( temp ge 4000 )] = 0.2
mask[ where( temp ge 6000 )] = 0.3
mask[ where( temp ge 8000 )] = 0.4
mask[ where( temp ge 10000 )] = 0.5
mask[ where( temp ge 15000 )] = 1.0

im = image2( mask , $
    layout=[1,1,1], margin=0.0 , $
    rgb_table=66)

stop

; Create mask array to adjust power maps

temp = A[0].data
sz = size(temp, /dimensions)
mask_cube = fltarr(sz) + 1.0
threshold = 10000
mask_cube[ where( temp ge threshold ) ] = 0.0
stop


map = A[0].map2
sz = size(map, /dimensions)
mask_map = fltarr(sz)
z_start = [0:sz[2]-1]
stop


dz = 64

foreach z, z_start do begin
    mask_map[*,*,z] = product( mask_cube[*,*,z:z+dz-1], 3 )
endforeach
stop


; plot values of map
test = reform( map[*,*,280], 165000)
ind = sort(test)
p = plot2( indgen(165000), test )

print, min(map)
print, max(map)
print, (moment(map))[0]
print, (moment(map))[1]


zmap = 280
im = image2( (map[*,*,zmap]), $
    layout=[1,2,1], margin=0.1 , $
    max_value=(moment(map))[0], $
    rgb_table=70 $
    )

im = image2( mask_map[*,*,zmap], $
    /current, $
    layout=[1,2,2], margin=0.1 )

; new_map - same as map, but with more pixels set to zero
; after decreasing the saturation threshold.
new_map = map * mask_map

; See if maps are zero anywhere other than saturated pixels
test = fltarr(sz) + 1.0
test[ where( new_map eq 0.0 )]  = 0.0
print, where( test ne mask_map )


; --> -1, so power not = 0.0 anywhere.
; Cool, so now I can set all 0 values to 0.5 so they're white
; in the image

; Apparently needs to be normalized first. 0.5 not nec. in middle
; of color bar

test1 = n_elements( where( new_map_norm ge 0.9*max(new_map_norm)))
test2 = n_elements( where( new_map_norm ge 0.6*max(new_map_norm)))
print, test2/test1

new_map = map * mask_map
;normalize (this actually normalizes to the max value in the
; entire map cube, which makes no sense. No wonder I couldn't
; see anything.
;new_map_norm = new_map / max(new_map)
;print, where(new_map_norm eq min(new_map_norm))
;print, median(new_map_norm)

;new_map_norm[ where( new_map_norm eq 0.0 ) ] = median(new_map_norm)
;new_map_norm[ where( new_map_norm eq 0.0 ) ] = 0.5

START:;----------------------------------------------------------------

zmap = [0:685-1:45]

max_value=0.5

w = window( dimensions=[15.0,11.0]*dpi, location=[500,0] )

for i = 0, 15 do begin

    dat = new_map
    dat = dat/max(dat)

    im = image2( dat[*,*,zmap[i]], $
        /current, $
        layout=[3,5,i+1], margin=0.05 , $
        ;max_value=(moment(map))[0], $
        axis_style=0, $
        max_value=max_value, $
        ;min_value=0.0001, $
        title=A[0].name + ' ' + A[0].time[zmap[i]], $
        ;rgb_table=20 $
        ;rgb_table=39 $
        ;rgb_table=70 $
        rgb_table=1 $
        )

    ;cont = contour(dat, /overplot, color='red', c_value=0.0)

endfor

c = colorbar2( target=im )

end
