;+
;- LAST MODIFIED:
;-   Mon Jan 28 17:26:48 MST 2019
;-
;- PURPOSE:
;-   General routine for imaging powermaps... for real this time!
;-
;- INPUT:
;-   Currently at main level.
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   Look through all routines that create image of power maps
;-   (or data for that matter) and perfect this thing!
;-   Is okay that it's at the main level. Could edit directly, or copy
;-   into another routine. Hell of a lot better than typing the same thing
;-   and wasting time fixing the same synax errors over and over...
;-
;-



goto, start

start:;-----------------------------------------------------------------------------------


;- "The usual"

cc = 0
time = strmid(A[cc].time,0,5)
dz = 64


;- z indices (time) to be covered
z_ind = [0, 197]


;- Crop data, if desired
center = [ 225, 175 ]
r = 200
mapdata = CROP_DATA( $
    A[cc].map, $
    center=center, $
    dimensions=[r,r], $
    z_ind=z_ind )


;- min(map) = 0, so adding small number to avoid errors with LOG.
mapdata = alog10( mapdata + 0.0001 )

rows = 1
cols = 3


;- Should be able to call IMAGE3 here, but that can wait.
wx = 12.0
wy = 4.0
win = window( dimensions=[wx,wy]*dpi, location=[750,0] )

foreach zz, z_ind, ii do begin

    title = A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + $
        ' (' + strtrim(zz,1) + '-' + strtrim(zz+dz-1,1)  + ')'

    im = image2( $
        mapdata[*,*,ii], $
        /current, $
        /device, $
        layout=[cols,rows,ii+1], $
        margin=0.50*dpi, $
        xshowtext=0, $
        yshowtext=0, $
        rgb_table=A[cc].ct, $
        title = title )

    endforeach

end
