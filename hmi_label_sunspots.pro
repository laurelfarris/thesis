
;- Mon Dec 17 16:48:13 MST 2018

;- Purpose: Image HMI B_{LOS} with contours and label each of the four
;-  sunspots as they wil be referred to in the paper.


goto, start
start:;---------------------------------------------------------------------------------

;- Should write prep routines to only read a subset, not entire data series.
;- IDL> .run hmi_prep
;- Just 'mag' (LOS magentic field) for now.

imdata = H[0].data[*,*,0]

title = H[0].name + ' ' + strmid(H[0].time[0],0,5) + ' UT'

;- Only need to cover one column with this one.
wx = 4.0
wy = wx * (330./500.)
;- NOTE: Adjusting wy this way won't work when extra space is needed for
;- color bars or tick labels on one axis... just fyi.

win = window( dimensions=[wx,wy]*dpi, location=[500,0] )
im = image2( imdata, $
    layout = [1,1,1], $
    margin = 0.1, $
    title = title )

;- image3 might be useful even when only showing one image...
;- Window is created in subroutine.
;- Attempting to use X and Y arrays with image3 again to
;-   set tick labels in arcseconds.
im = image3( imdata, X=H[0].X, Y=H[0].Y, wx=wx, buffer=0 )


;- Contours:
;-   Copied lines of code from Notes/2018-11-21.pro for contours
;-    (formerly "today.pro" that produced 4x4 images of HMI continuum and mag.,
;-    where bottom rows has blue and red contours).

c_value = [-300, 300]
c_color = ['blue', 'red']

;name = 'B$_{LOS} \pm 300$'
name = ['-300 G', '+300 G']

contourr = objarr(2)
for ii = 0, 1 do begin
    contourr[ii] = CONTOUR( $
        c_data, $
        overplot=im, $
        c_value=c_value[ii], $
        c_thick=1.0, $
        c_thick=0.0, $
        c_color=c_color[ii], $
        c_linestyle='-', $
        c_label_show=0, $
        ;title = title, $
        name = name[ii] )
endfor

leg = legend2( target=contourr )

;- Label each of the four sunspots
;- (same coords as in subregions.pro, and hmi_spectra.pro)

center = [ $
    [367, 213], $
    [280, 180], $
    [230, 190], $
    [115, 115] ]
nn = (size(center, /dimensions))[1]


;- Or maybe search for highest (magnitude) values in magnetogram?

label = [ 'AR_1a', 'AR_1b', 'AR_2a', 'AR_2b' ]
color = [ 'white', 'black', 'white', 'black' ]

sunspot = objarr(nn)

resolve_routine, 'text2', /either
for ii = 0, nn-1 do begin

    sunspot[ii] = TEXT2( $
        center[0,ii], $
        center[1,ii], $
        label[ii], $
        /data, $
        color = color[ii] )
endfor

file = 'hmi_label_sunspots'
;save2, file

end
