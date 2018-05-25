;; Last modified:   16 May 2018 22:14:06


goto, start

;resolve_routine, 'graphics'
;/compile_full_file --> this doesn't mean put the file's name...
; IDL will compile every subroutine in the file where it
;finds the one entered here as an argument
; (usually it stops once that one is found).

;resolve_routine, 'graphics', /compile_full_file
;graphics
;common defaults

;read_my_fits, '1600', aia1600index, data, nodata=1
aia1600 = PREP_AIA( '1600', index=aia1600index )
aia1600.color = 'dark orange'

;read_my_fits, '1700', aia1700index, data, nodata=1
aia1700 = PREP_AIA( '1700', index=aia1700index )
aia1700.color = 'dark cyan'

;S = {  aia1600 : aia1600, aia1700 : aia1700  }
A = [ aia1600, aia1700 ]


start:;-----------------------------------------------------------------------------

; read HMI data
hmi = PREP_HMI( index=hmiindex )
stop



; Structure of structures, or array of structures?
; Array - can retrieve all values for tag with A.tag,
; but all substructures in array have to have the same tags,
; with the same data type and same size, which would make it impossible
; to combine AIA and HMI.


; from A[0].X[-1] - A[0].X[0] (same for Y)
arcsec_dimensions = [304.07713, 200.48372]

cd1 = hmiindex[0].cdelt1
cd2 = hmiindex[0].cdelt2
pixel_dimensions = arcsec_dimensions / [cd1, cd2]

xx = round(pixel_dimensions[0] / 2)
yy = round(pixel_dimensions[1] / 2)


hmi_image = hmi.data[*,*,0]
image_hmi, hmi_image[x0-xx:x0+xx-1, y0-yy:y0+yy-1, 0]

save2, 'hmi_image_2.pdf'



end
