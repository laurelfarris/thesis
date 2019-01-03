;-
;- 20 December 2018
;-
;- function IMAGE_POWERMAPS takes STRUCTURE argument, whose tags are
;-   imdata (data to be imaged), graphic title, and filename to save as pdf.
;- Returns reference to image object, 'im'.
;-
;-
;- 17 December 2018
;- Creates structures (at ML) that can be input for function
;-  IMAGE_POWERMAPS, which returns reference to image object, 'im'.
;- Only shows a single image, not an array.
;- 3 structures: one for AIA intensity, one for HMI, and one for AIA power map.
;- Images are averaged over some time segemnt of length dz,
;- where starting indices for z are defined at main level below.
;-
;- NOTE:
;- Run this routine (image_powermaps) from ML before calling contours.pro
;-   (copied lines below from the bottom of that one).
;- IDL> .run image_powermaps
;- c_data = GET_CONTOUR_DATA( time[zz+(dz/2)], channel='mag' )
;- c = CONTOURS( c_data, target=im, channel='mag' )

function image_powermaps, struc, _EXTRA = e

    imdata = alog10(struc.imdata)

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, $
        title = struc.title, $
        xshowtext=0, yshowtext=0, $
        rows = 1, $
        cols = 1, $
        ;wx = 4.0, $
        wx = 8.0, $
        buffer = 0, $
        left = 0.10, right = 0.10, bottom = 0.10, top = 0.50, $
        ;left = 0.01, right = 0.01, bottom = 0.15, top = 0.15, $
        _EXTRA = e )
    return, im
end



goto, start
start:;---------------------------------------------------------------------------------
cc = 0

dz = 64
time = strmid(A[cc].time,0,5)
z_start = 197 ;- pre-flare
;z_start = 204 ;- pre-flare/impulsive
;z_start = 450 ;- post-flare

zz = z_start

;----------------------------------------------------------------------------------------
;- Structure for AIA intensity, hmi B_LOS, and AIA powermaps.
;- Call IMAGE_POWERMAPS with one of these (i.e. only used one at a time)
;- as first arg.

;- AIA intensity
intensity = { $
    imdata : mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    ;imdata : aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime ), $
    title : A[cc].name + ' (' + A[cc].time[zz] + '-' + A[cc].time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_image' }

;- HMI
hmi = { $
    imdata : mean(H[0].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    title : H[0].name, $
    file : 'hmi' + H[0].channel + 'big_image' }

;- Maps
map = { $
    imdata : A[cc].map[*,*,z_start], $
    title : A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_map' }

;----------------------------------------------------------------------------------------
;im1 = IMAGE_POWERMAPS( intensity, rgb_table = A[cc].ct )
im = IMAGE_POWERMAPS( map, rgb_table = A[cc].ct )

end
