;+
;- LAST MODIFIED:
;-   05 April 2020
;-    Separated this subroutine (plot_contours.pro) from ML code (contours_ML.pro)
;-
;- PURPOSE:
;-    Return graphic object created using IDL routine CONTOUR.
;-
;- INPUT:
;-    time - date_obs for which you desire your contour data.
;-
;- KEYWORDS:
;-    channel - (not optional, despite usual kw useage).
;-
;- OUTPUT:
;-    HMI image cropped to 500x330, to be used in CONTOUR arg.
;-
;- SUBROUTINES:
;-    Codes/Grahphics/contour2.pro 
;-
;- NOTE(S):
;-  •  User must generate image prior to calling this routine;
;-       contours are overlaid on existing graphic (see IDL documenation for CONTOUR)
;-  •  X and Y arguments may cause trouble... haven't yet grasped best way to
;-       include these arguments as OPTIONAL, how to set defaults (correctly).
;-  •  NOT GENERALIZED! Written SPECIFICALLY to plot contours representing
;-        data from HMI magnetograms.
;-  •
;-
;-
;- TO DO:
;-   [] Generalize for any instrument (not just HMI mag ...)
;-   [] Make sure comments are specific to this subroutine, not the caller.
;-       Ditto for contours_ML.pro, but in reverse.
;-

function PLOT_CONTOURS, c_data, x, y, target=target, channel=channel, $
    _EXTRA = e



    sz = size(c_data, /dimensions)
    if n_elements(sz) eq 2 then nn = 1 else nn = sz[2]
    contourr = objarr(nn)


    if n_elements(x) eq 0 then x = indgen(sz[0])
    if n_elements(y) eq 0 then y = indgen(sz[1])


    if channel eq 'cont' then begin
        ;- Define continuum contours relative to average in quiet sun (lower right corner).
        ;- Outer edges of [penumbra, umbra]
        data_avg = mean(c_data[350:450,50:150])
        c_value = [0.9*data_avg, 0.6*data_avg]
        c_color = ['red','red']
        c_thick = 1.0
        name = 'umbra and penumbra boundaries'
    endif

    if channel eq 'mag' then begin
        ;- min/max values used by Schrijver2011... don't know why.
        c_value = [-300, 300]
        ;c_value = [-1000, -300, 300, 1000]
        ;c_value = [ -reverse(c_value), c_value ]
        ;c_thick = [1.0, 2.0, 2.0, 1.0]
        c_color = ['black', 'white']
        ;c_color = ['black', 'black', 'white', 'white']
        rgb_table = 0 ; black --> white
        name = 'B$_{LOS} \pm 300$'
        ;title = 'B$_{LOS} \pm 300$'
    endif

    for ii = 0, nn-1 do begin
        ;contourr[ii] = CONTOUR( $
        contourr[ii] = CONTOUR2( $
            c_data, $
            x, y, $
            overplot=target, $
            c_value=c_value, $
            c_thick=1.0, $
            c_color=c_color, $
            c_linestyle='-', $
            c_label_show=0, $
            title = title, $
            name = name, $
            _EXTRA = e )
    endfor
    return, contourr
end
