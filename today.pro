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



cc = 0

;- Read headers from PREPPED fits files
@parameters
resolve_routine, 'read_my_fits', /either
READ_MY_FITS, index, data, nodata=1, prepped=1

;- Retrieve aligned data array (if struc_aia not working)
path = '/solarstorm/laurel07/' + year + month + day + '/'
filename = instr + channel + 'aligned.sav'
restore, path + filename
help, cube

time = strmid(A[cc].time,0,5)
title = $
    ;strupcase(instr) + ' ' + $
    channel + '$\AA$ @5.6mHz' + ' (' + $
    strmid(index[z_start].date_obs,11,5) + $
    '-' + $
    strmid(index[z_start+dz-1].date_obs,11,5) + $
    ' UT)'

z_ind = [75, 225, 375]
imdata = AIA_INTSCALE( $
    A.data[*,*,z_ind,cc], wave=fix(A[cc].channel), exptime=A[cc].exptime )

resolve_routine, 'image3', /is_function
;- function definition/calling sequence (31 July 2019):
;- im = IMAGE3( data, XX, YY, _Extra=e )
im = image3( $
    imdata, $
    buffer=1, $
    rows=1, cols=3, $ ;- One channel (row 1), 3 time segments (BDA) --> 3 columns
    xshowtext=1, yshowtext=1, $
    title = title, $ ; title = ARRAY of titles, one for each panel.
    rgb_table = AIA_COLORS( wave=fix(channel) ) )
    ;rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )

filename = instr + channel + 'images'
print, filename

save2, filename

end
