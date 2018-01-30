;; Last modified:   25 August 2017 21:27:50

;+
; ROUTINE:      full_disk.pro
;
; PURPOSE:      Display image of full disk after reading fits files.
;               Specific data entered manually, since this is for visualization only,
;               not analysis.
;
; USEAGE:       GET_DATA_ARRAY, my_data
;               FULL_DISK, my_data
;
; INPUT:        None
;
; KEYWORDs:     /nodata
;
; OUTPUT:       3D image array, 1D array of dates for each image
;
; TO DO:        Separate windows for each image, rather than crowding into one?
;
; AUTHOR:       Laurel Farris
;
;KNOWN BUGS:    Procedures vs. main level... can't examine headers unless stop
;                   inside first procedure, or read them back into ML.
;-


pro GET_DATA_ARRAY,     data, date, nodata=nodata

    @main.pro

    ;; Read hmi data
    fls = file_search(hmi_path)
    n = n_elements(fls)/2
    read_sdo, fls[n], hmi_index, hmi_data, nodata=nodata

    ;; Read aia 1600 data
    fls = file_search(aia_1600_path)
    n = n_elements(fls)/2
    read_sdo, fls[n], aia_1600_index, aia_1600_data, nodata=nodata

    ;; Read aia 1700 data
    fls = file_search(aia_1700_path)
    n = n_elements(fls)/2
    read_sdo, fls[n], aia_1700_index, aia_1700_data, nodata=nodata

    ;; 3-element array with date of each header
    date = [ hmi_index.date_obs, aia_1600_index.date_obs, aia_1700_index.date_obs ]

    ;; Create data array for images
    if not keyword_set(nodata) then begin
        hmi_data = rotate( hmi_data, 2 )
        data = [ [[hmi_data]], [[aia_1600_data^0.4]], [[aia_1700_data^0.4]] ]
    endif

end


pro full_disk, data, date

    ;; Call script with all configurations (image_props, plot_props, cbar_props)
    ;; Set individual properties as needed (e.g. image_props.xtitle = "bleh")

    @main

    props = { $
        font_name : fontname, $
        xtickfont_name : fontname, $
        ytickfont_name : fontname, $
        font_size : fontsize, $
        xtickfont_size : fontsize, $
        ytickfont_size : fontsize, $
        ;xtitle     : , $
        ;ytitle     : , $
        ;xshowtext : 1, $
        ;yshowtext : 1, $
        axis_style : 0, $   ; 0=No axes & decreased margins, 1=single, 2=box, 3=crosshair, 4=1, but margins stay the same
        ;xticklen : 0.03, $ ; length of major tick marks, relative to graphic
        ;yticklen : 0.03, $
        xsubticklen : 0.5, $ ; ratio of minor to major tick length (default = 0.5)
        ysubticklen : 0.5 $
        ;xtickdir : 0, $ ; 0=inwards (default), 1=outwards
        ;ytickdir : 0, $
        ;xmajor : -1, $  ; Number of major tick marks (-1 --> auto-compute,  0 --> suppress)
        ;ymajor : -1, $
        ;xminor : 5, $  ; Number of minor tick marks between each pair of major ticks
        ;yminor : 5, $
        ;xtickinterval : ;; interval BETWEEN major tick marks [data units?]
        ;ytickinterval :
        ;xstyle : , $  ; (0=nice, 1=exact, 2=>nice, 3=>exact)
        ;ystyle : , $
        ;title      : "", $
        ;image_dimensions : , $
        ;image_location : , $
        }

    n = (size(data, /dimensions))[2]

    ;; Custom properties
    titles = [ $
        "HMI at UT " + date[0], $
        "AIA 1600$\AA$ at UT " + date[1], $
        "AIA 1700$\AA$ at UT " + date[2] $
    ]

    x0 = 2445
    y0 = 1645

    ;; Create graphics
    im = objarr(n)
    for i = 0, n-1 do begin
        if (i eq 0) then begin
            x1 = x0-200
            y1 = y0-200
            x2 = x0+300
            y2 = y0+130
            color='black'
        endif else begin
            x1 = x0-285
			y1 = y0-155
			x2 = x0+215
			y2 = y0+175
            color='white'
        endelse
        im[i] = image( $
            data[*,*,i], $
            layout=[3,1,i+1], $
			margin=0.04, $
            /current, $
            title = titles[i], $
			_EXTRA = props )
        pos = im[i].position
        im[i].position = pos + [0, -0.03, 0, -0.03]
        rec = polygon( $
            [x1,x2,x2,x1], $
            [y1,y1,y2,y2], $
            target=im[i], $
            fill_transparency=100, $
            linestyle='--', $
            thick=1, $
            color=color, $
            /data)
    endfor



end


;; Perk of calling routines from main level like this
;; -->  .run proname compiles it!

wx = 1200
wy = wx/3 + 30
w = window( dimensions=[wx,wy] )

; 1. Create data array (comment if not changed)
get_data_array, my_data, date, nodata=0


;my_data = [ [[hmi[*,*,0]]], [[a6[*,*,0]]], [[a7[*,*,0]]] ]
; 2. Image data array
full_disk, my_data, date


end
