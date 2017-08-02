;; Last modified:   21 July 2017 08:13:58

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.


function FA_2D, cube, delt
    ;; Loop through all coordinates to calculate fourier2 on each pixel location
    ;; Could call the routine above to plot result of a single location.

    sz = size( cube, /dimensions )

    ;; 2D power image, to show power at 3 minutes
    power_image = fltarr( sz[0], sz[1] )

    t_delt = 15.   ;; time difference above and below 180 seconds

    for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin

            result = fourier2( cube[x,y,*], delt )
            f = result[0,*]     ; frequency 
            ps = result[1,*]    ; power_spectrum 

            ;; Use passband of power at range of periods ~ 2.75-3.15 minutes
            f1 = (1./(180+t_delt))
            f2 = (1./(180-t_delt))
            i1 = ( where( f gt f1) )[0]
            i2 = ( where( f lt f2) )[-1]
            power_image[x,y] = mean( ps[i1:i2] )
        endfor
    endfor
    return, power_image
end
