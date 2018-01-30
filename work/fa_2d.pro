;; Last modified:   01 October 2017 00:11:51

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image [seconds]
;;                  T = period [seconds]
;;                  dt = time difference above and below T (period range = T-dT : T+dT )


function FA_2D, cube, delt, T, dT
    ;; Loop through all coordinates to calculate fourier2 on each pixel location
    ;; Could call the routine above to plot result of a single location.

    sz = size( cube, /dimensions )

    ;; 2D power image, to show power at 3 minutes
    power_image = fltarr( sz[0], sz[1] )


    for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin

            result = fourier2( cube[x,y,*], delt )
            f = result[0,*]     ; frequency 
            ps = reform(result[1,*])    ; power_spectrum 

            ;; Use passband of power at range of periods ~ 2.75-3.15 minutes
            f1 = (1./(T+dt))
            f2 = (1./(T-dt))
            i1 = ( where( f ge f1) )[0]
            i2 = ( where( f le f2) )[-1]
            power_image[x,y] = mean( ps[i1:i2] )
        endfor
    endfor
    print, n_elements(ps[ i1:i2 ])
    return, power_image
end


goto, START

;; HMI power spectrum images
;hmi_ps3 = FA_2D( hmi, hmi_cad, 180., 15. )
;hmi_ps5 = FA_2D( hmi, hmi_cad, 300., 15. )

;hmi_B = FA_2D( hmi[*,*,0:ht1-1], hmi_cad, 180., 15. )
;hmi_D = FA_2D( hmi[*,*,ht1:ht2], hmi_cad, 180., 15. )
;hmi_A = FA_2D( hmi[*,*,ht2+1:*], hmi_cad, 180., 15. )
;a6_B =  FA_2D( a6[*,*,0:a6t1-1], aia_cad, 180., 15. )
;a6_D = FA_2D( a6[*,*,a6t1:a6t2], aia_cad, 180., 15. )
;a6_A = FA_2D( a6[*,*,a6t2+1:*], aia_cad, 180., 15. )
;a7_B =  FA_2D( a7[*,*,0:a7t1-1], aia_cad, 180., 15. )
;a7_D = FA_2D( a7[*,*,a7t1:a7t2], aia_cad, 180., 15. )
;a7_A = FA_2D( a7[*,*,a7t2+1:*], aia_cad, 180., 15. )

arr = [ $
    [[ hmi_B ]], $
	[[ hmi_D ]], $
	[[ hmi_A ]], $
	[[ a6_B ]], $
	[[ a6_D ]], $
	[[ a6_A ]], $
	[[ a7_B ]], $
	[[ a7_D ]], $
	[[ a7_A ]] ]


START:

w = window( dimensions=[800,700] )

im = image( hmi_B, /current, layout=[3,3,1], margin=0.01 ) 
im = image( hmi_D, /current, layout=[3,3,4], margin=0.01 ) 
im = image( hmi_A, /current, layout=[3,3,7], margin=0.01 ) 
im = image( a6_B, /current, layout=[3,3,2], margin=0.01 ) 
im = image( a6_D, /current, layout=[3,3,5], margin=0.01 ) 
im = image( a6_A, /current, layout=[3,3,8], margin=0.01 ) 
im = image( a7_B, /current, layout=[3,3,3], margin=0.01 ) 
im = image( a7_D, /current, layout=[3,3,6], margin=0.01 ) 
im = image( a7_A, /current, layout=[3,3,9], margin=0.01 ) 



;im = image(hmi_ps3, layout=[1,2,1], margin=0.1, /current);, title="3-min. power")
;im = image(hmi_ps5, layout=[1,2,2], margin=0.1, /current);, title="5-min. power" )


end
