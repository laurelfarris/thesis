;+
;- LAST MODIFIED:
;-   02 February 2021
;-
;- ROUTINE:
;-   extract_subset.pro
;-
;- PURPOSE:
;-   Read data and header from level 1.5 fits files, center on AR, trim to desired dimensions, and
;-     save cube + header to .sav file.
;-   1. read data/headers from level 1.5 data (processed with aia_prep.pro)
;-   2. extract subset centered on AR with dimensions padded with enough pixels beyond
;-       boundaries of AR to allow room for edge effects due to shifting
;-       (maximum shift most likely x-direction, ~70 pixels at the most for a 5-hr ts.
;-   3. SAVE subset (cube) + index from lvl 1.5 data to file.sav
;-
;- CALLING SEQUENCE:
;-
;- INPUT:
;-
;- OUTPUT:
;-
;- EXTERNAL SUBROUTINES:
;-
;- TO DO:
;-   []
;-   []
;-   []
;-

;=====================================================================

buffer=1
;
;instr = 'aia'
;channel = '1600'
;channel = '1700'

instr = 'hmi'
;channel = 'mag'
channel = 'cont'
;channel = 'dop'

@par2
flare = multiflare.(0)


;=====================================================================

;-
;--- § Read index and data from level 1.5 fits files

;resolve_routine, 'read_my_fits', /either
;READ_MY_FITS, index, data, fls, instr=instr, channel=channel, ind=[0], nodata=0, prepped=1

;- OR skip my subroutine and use READ_SDO directly
;-  (read_my_fits probably needs updating for new multiflare structures anyway...)

date = flare.year + flare.month + flare.day
print, date

;+
;- 'AIAyyyymmdd_hhmmss_1600.fits'
;- 'AIAyyyymmdd_hhmmss_0304.fits'
;-
;- 'HMIyyyymmdd_hhmmss_cont.fits'
;- 'HMIyyyymmdd_hhmmss_mag.fits'
;- 'HMIyyyymmdd_hhmmss_dop.fits'
;-

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + date + '*' + strtrim(channel,1) + '.fits'

fls = FILE_SEARCH( path + fnames )
help, fls

stop;---------------------------------------------------------------------------------------------

READ_SDO, fls, index, data, /nodata

start_time = systime()
start_time_seconds = systime(/seconds)
READ_SDO, fls, index, data
;-
print, "=========="
print, "Started at ", start_time
print, "Finished at ", systime()
print, "Took ", (systime(/seconds)-start_time_seconds)/60., "minutes to run."
print, "=========="
;-




;-----
;-----------------
;-- Convert center from arcsec (xcen,ycen) to pixels.
;-
;-
;-
;help, [flare.xcen, flare.ycen]
;print, [flare.xcen, flare.ycen]
;

;spatial_scale = index[0].cdelt1
spatial_scale = [ index[0].cdelt1, index[0].cdelt2 ]
print, spatial_scale

;
;half_dimensions = [ index[0].crpix1, index[0].crpix2 ]
;-   index.crpix[1|2] --> n_pix to center? = half naxis (2048)
;center =  half_dimensions + ([flare.xcen, flare.ycen]/spatial_scale)
;

;- index.naxis[1|2] --> length of ccd (4096)
full_dimensions = [ index[0].naxis1, index[0].naxis2 ]
center = FIX( (full_dimensions/2) + ([flare.xcen, flare.ycen]/spatial_scale) )
;-
;-    Chose to convert (xcen,ycen) from arcsec to pixels using naxis instead of crpix
;-    only because center doesn't compute as a fraction.. may be off by one pixel, if it matters..
;-    "full_dimensions" avoids fractional pixel coords, if it matters...
;-
;-
;--
;-----------------


stop;---------------------------------------------------------------------------------------------


;-
;--- § Extract subset centered on AR from full disk images by cropping x and y pixels

print, minmax(data)

im = image2( data[*,*,0], buffer=buffer )
save2, 'hmi_test'


;- size of subset [x,y], in pixels centered on AR
dimensions = [800,800]

resolve_routine, 'crop_data', /either
cube = CROP_DATA( $
    data, $
    center=center, $ ;- defined in @parameters
    dimensions=dimensions $
)
help, cube

;---
;-


end
