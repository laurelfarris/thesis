;+
;- LAST MODIFIED:
;-   Tue Feb 12 12:12:38 MST 2019
;-
;- PURPOSE:
;-   General routine for imaging intensity maps
;-  (copied from Maps/image_any_powermaps.pro)
;-
;- INPUT:
;-   None (currently runs from main level).
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-
;+



;-----------------

;@parameters
;- Read headers from PREPPED fits files
;resolve_routine, 'read_my_fits', /either
;READ_MY_FITS, index, data, nodata=1, prepped=1

;- Retrieve aligned data array (if struc_aia not working)
;path = '/solarstorm/laurel07/' + year + month + day + '/'
;filename = instr + channel + 'aligned.sav'
;restore, path + filename
;help, cube
;---------------------------------------------------------------------------------


;cc = 0
cc = 1
@parameters
time = strmid(A[cc].time,0,5)

;z_ind = [  0, 456, 598]
z_ind = intarr(3)
z_ind[1] = ( where( time eq strmid(gpeak,0,5) ))[0]
z_ind[0] = 0
z_ind[2] = n_elements(time)-1



title = $
    ;strupcase(instr) + ' ' + $
    A[cc].channel + '$\AA$' + ' (' + $
    A[cc].time[z_ind] + ' UT)'
print, title, format='(A0)'
imdata = AIA_INTSCALE( $
    A[cc].data[*,*,z_ind], wave=fix(A[cc].channel), exptime=A[cc].exptime )
resolve_routine, 'image3', /is_function
;- function definition/calling sequence (31 July 2019):
;- im = IMAGE3( data, XX, YY, _Extra=e )

dw
im = image3( $
    imdata, $
    buffer=1, $
    rows=1, cols=3, $ ;- One channel (row 1), 3 time segments (BDA) --> 3 columns
    title = title, $ ; title = ARRAY of titles, one for each panel.
    xshowtext=0, $
    yshowtext=0, $
    ;rgb_table = AIA_COLORS( wave=fix(channel) ) )
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )
instr = 'aia'
filename = instr + A[cc].channel + 'images' + 'X22'
;print, filename
save2, filename

end
