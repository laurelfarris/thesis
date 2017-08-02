;; Last modified:   21 July 2017 10:49:46

;; Subroutines:     fourier2 --> returns "Array containing power and phase
;;                                              at each frequency"

;; Purpose:         Run fourier2 through time on each pair of 2D pixel coordinates
;;                  and return 2D power image


;; Inputs:          cube = data cube time series (i.e. same dt between each image).
;;                  delt = time between each image, in seconds.


pro hmi_power_images

    power_image_all = FA_2D( cube2, 45.0 )
    im1 = image( power_image_all, /current, $
        title='3-minute power of HMI continuum from ' + $
            strmid(hmi_index[0].date_obs,11,8) + ' to ' + $
            strmid(hmi_index[-1].date_obs,11,8), $
        _EXTRA=props)
    cbar = colorbar(_EXTRA=cbar_props)


    power_image_during = FA_2D( cube2[*,*,70:137], 45.0 )
    im2 = image( power_image_during, /current, $
        title='3-minute power of HMI continuum from ' + $
            strmid(hmi_index[70].date_obs,11,8) + ' to ' + $
            strmid(hmi_index[137].date_obs,11,8), $
        _EXTRA=props)
    cbar = colorbar(_EXTRA=cbar_props)
end

pro aia_power_images

    @graphic_configs

    power_image_all = FA_2D( a1600, 24.0 )
    im1 = image( power_image_all, /current, $
        title='3-minute power of AIA 1600 from ' + $
            strmid(aia_1600_index[0].date_obs,11,8) + ' to ' + $
            strmid(aia_1600_index[-1].date_obs,11,8), $
        _EXTRA=image_props)
    cbar = colorbar(_EXTRA=cbar_props)


    power_image_during = FA_2D( cube2[*,*,70:137], 45.0 )
    im2 = image( power_image_during, /current, $
        title='3-minute power of HMI continuum from ' + $
            strmid(hmi_index[70].date_obs,11,8) + ' to ' + $
            strmid(hmi_index[137].date_obs,11,8), $
        _EXTRA=props)
    cbar = colorbar(_EXTRA=cbar_props)
end


pro make_single_image, data

    image_props.xtitle = "x [pixels]"
    image_props.ytitle = "y [pixels]"

    im = image( data, layout=[1,1,1], margin=0.15, _EXTRA=image_props )

    pos = im.position
    d = 0.04
    im.position = im.position - [d, 0.0, d, 0.0]

    cx1 = pos[2]
    cy1 = pos[1]
    cx2 = cx1+0.03
    cy2 = pos[3]

    cbar = colorbar( $
        position=[ cx1, cy1, cx2, cy2], $
        title='3-minute power', $
        _EXTRA=cbar_props)

end

pro full_disk

    @main.pro

    ;; Read hmi data
    fls = file_search(hmi_path + '*.fits')
    read_sdo, fls[0], hmi_index, hmi_data

    ;; Read aia data
    fls = file_search(aia_path + '*1600*.fits')
    read_sdo, fls[0], aia_1600_index, aia_1600_data
    fls = file_search(aia_path + '*1700*.fits')
    read_sdo, fls[0], aia_1700_index, aia_1700_data

    @graphic_configs  

    ;; Create data array for images
    my_data = [ [[hmi_data]], [[aia_1600_data]], [[aia_1700_data]] ]
    n = (size(my_data, /dimensions))[2]

    ;; Create graphics
    im = objarr(n)
    for i = 0, n-1 do $
        im[i] = image( my_data[*,*,i], layout=[1,3,i+1], margin=0.1, _EXTRA = image_props )

    ;; Custom properties
    im[0].title = "HMI full disk at"
    im[1].title = "AIA 1600$\AA$ full disk at"
    im[2].title = "AIA 1700$\AA$ full disk at"

STOP
    ;; Create colorbar, using current graphic to position
    pos = im.position ; [ x1, y1, x2, y2 ]
    cx1 = pos[2]
    cy1 = pos[1]
    cx2 = cx1 + 0.03
    cy2 = pos[3]

    cbar = colorbar( $
        position = [ cx1, cy1, cx2,cy2], _EXTRA=cbar_props )

    ;; Shift graphics by amount d relative to window.
    d = 0.05
    im.position = im.position - [d, 0.0, d, 0.0]
end

w = window( dimensions=[0.9*451, 0.9*3.*301]) 
im = image( (aia_1700_cube_all[*,*,0])^0.5, layout=[1,3,1], margin=0.05, /current )
im1 = image( aia_1700_ps_all^0.5, layout=[1,3,2], margin=0.05 , /current )
im2 = image( aia_1700_ps_during^0.5, layout=[1,3,3], margin=0.05, /current )
; add text! (a), (b), (c)


end
