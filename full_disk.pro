;; Last modified:   21 July 2017 07:42:23

;+
; ROUTINE:      full_disk.pro
;
; PURPOSE:      Display images after reading fits files.
;
; USEAGE:       GET_DATA_ARRAY, my_data
;               FULL_DISK, my_data
;
;
; TO DO:        Separate windows for each image, rather than crowding into one.
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:    Procedures vs. main level... can't examine headers unless stop
;                   inside first procedure, or read them back into ML.
;-

pro full_disk, data, date

    ;; Call script with all configurations (image_props, plot_props, cbar_props)
    ;; Set individual properties as needed (e.g. image_props.xtitle = "bleh")
    @graphic_configs  
    image_props.axis_style = 0


    n = (size(data, /dimensions))[2]

    ;; Create graphics
    im = objarr(n)
    for i = 0, n-1 do $
        im[i] = image( $
            data[*,*,i], $
            layout=[3,1,i+1], $
			margin=0.04, $
			_EXTRA = image_props )

    ;; Custom properties
    im[0].title = "HMI full disk at " + date[0]
    im[1].title = "AIA 1600$\AA$ full disk at " + date[1]
    im[2].title = "AIA 1700$\AA$ full disk at " + date[2]

    txt1 = text( 0.01, 0.01, "full_disk_images", font_size=fontsize-2, font_name=fontname)
    txt2 = text( 0.70, 0.01, systime(), font_size=fontsize-2, font_name=fontname)

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

pro get_data_array, data, date, nodata=nodata

    @main.pro

    ;; Read hmi data
    print, "hmi"
    print, ""
    fls = file_search(hmi_path + '*.fits')
    read_sdo, fls[0], hmi_index, hmi_data, nodata=nodata

    ;; Read aia data
    print, "aia 1600"
    print, ""
    fls = file_search(aia_path + '*1600*.fits')
    read_sdo, fls[0], aia_1600_index, aia_1600_data, nodata=nodata
    print, "aia 1700"
    print, ""
    fls = file_search(aia_path + '*1700*.fits')
    read_sdo, fls[0], aia_1700_index, aia_1700_data, nodata=nodata

    date = [ hmi_index.date_obs, aia_1600_index.date_obs, aia_1700_index.date_obs ]

    ;; Create data array for images
    if not keyword_set(nodata) then begin
        hmi_data = rotate( hmi_data, 2 )
        data = [ [[hmi_data]], [[aia_1600_data^0.5]], [[aia_1700_data^0.5]] ]
    endif

end



;; Perk of calling routines from main level like this
;; -->  .run proname compiles it!

; 1. Create data array (comment if not changed)
get_data_array, my_data, date, /nodata


; 2. Image data array
full_disk, my_data, date


end
