

; 11-12 September 2018

; Image one sunspot, compute power maps over time before X-flare

goto, start


data = A[0].data[*,*,0]
dimensions=[100,100]
center=[365,215]

image_data = crop_data( $
    data, $
    dimensions=[100,100], $
    center=[365,215] )

wx = 8.5/2
wy = wx
win = window( dimensions=[wx,wy]*dpi, /buffer )
im = image2( $
    image_data, /current, $
    margin=0.1, $
    rgb_table=A[0].ct )
save2, 'test_image.pdf'


dimensions=[100,100]
center=[365,215]

; pre-flare data (up to but not including C-flare)
data = crop_data( A[0].data[*,*,0:125], dimensions=dimensions, center=center )

fmin = 0.005
fmax = 0.006
dz = 64


map1 = power_maps( data, 24., [fmin,fmax], dz=dz, z=0 )
map2 = power_maps( data, 24., [fmin,fmax], dz=dz, z=12 )
map3 = power_maps( data, 24., [fmin,fmax], dz=dz, z=58 )
  ; from reference plot, 58:122 is range centered on C-flare for dz = 64

map = [ [[map1]], [[map2]], [[map3]] ]

start:;----------------------------------------------------------------------------------


; This is where a general routine for imaging power maps would be handy...
; Also one to convert cropped AR subregion to physical coords (arcsec)
wx = 8.5
wy = wx/2
dw
win = window( $
    dimensions=[wx,wy]*dpi, $
    title = 'AIA 1600$\AA$ @ 5 mHz', $
    /buffer )

props = { $
    current : 1, $
    margin : 0.1, $
    min_value : min(map), $
    max_value : max(map)/10., $
    rgb_table : 39 }

im = image2( $
    map[*,*,0], $
    layout=[3,1,1], $
    title='i = 0-63', $
    _EXTRA=props  )
im = image2( $
    map[*,*,1], $
    layout=[3,1,2], $
    title='i = 12-75', $
    _EXTRA=props  )
im = image2( $
    map[*,*,2], $
    layout=[3,1,3], $
    title='i = 58-122', $
    _EXTRA=props  )
save2, 'test_maps.pdf'

stop

k = 0

flux = A[k].flux
cadence = A[k].cadence



end
