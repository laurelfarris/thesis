;; Last modified:   12 July 2017 14:24:37

;; Syntax:  graphic = MAKE_GRAPHICS( data, lx, ly [, scale=1.0, /make_image, /make_plot )

;; Create graphics. Input data and desired grid layout.
;; Returns graphic (object array). Properties can then be changed outside of
;;    this routine, e.g. graphic.property = blah (I think).


;; Applies to any type of image or plot.
;; Nothing that might be specific to a particular graphic (e.g. titles, x/y range, etc.)



function MAKE_GRAPHICS, $
    data, lx, ly, $
    scale=scale, $
    im=im, plt=plt, $
    _EXTRA=ex ;, _REF_EXTRA = ex

    ;; All graphics--------------------------------------------------------------------------------

    ;; Window - use desired grid layout to determine dimensions
    if not keyword_set(scale) then scale = [1.0, 1.0]
    w = window( dimensions=[500*sqrt(lx)*scale[0], 500*sqrt(ly)*scale[1]] )

    ;; Object array for all panels. Number of panels based on grid layout.
    graphic = objarr(lx*ly)

    ;; Properties for any type of graphic
    @graphic_configs

    ;; Dimensions of data
    sz = size(data, /dimensions)


    ;; Imaging------------------------------------------------------------------------------------
    if keyword_set( im ) then begin

        ;; Change 2D array into 3D array with third dimension = 1
        if n_elements(sz) eq 2 then data = reform( data, sz[0], sz[1], 1 )

        ;; Object array based on input layout
        for i = 0, (lx*ly)-1 do begin
            graphic[i] = image( data[*,*,i], $
                layout=[lx,ly,i+1], $
                margin=0.1, $
                /current, $
                _EXTRA=image_props)
        endfor

    endif

    ;; Plotting-----------------------------------------------------------------------------------
    if keyword_set( plt ) then begin

        if lx*ly eq sz[0] then begin
            xdata = indgen(sz[1])
            j = 0
            print, "wrong"
        endif
        if lx*ly lt sz[0] then begin
            xdata = data[0,*]
            j = 1
            print, "right"
        endif

        for i = 0, (lx*ly)-1 do begin
            ydata = data[j,*]
            graphic[i] = plot( xdata, ydata, $
                layout=[lx,ly,i+1], $
                margin=0.2, $
                /current, $
                _EXTRA=image_props)
            j = j + 1
        endfor
    endif


    ;; RETURN-------------------------------------------------------------------------------------
    return, graphic

end



;; Worry about these later

;; _EXTRA-------------------------------------------------------------------------------------------
;if n_elements(ex) ne 0 then begin
;    image_props = create_struct(image_props, ex)
;    plot_props = create_struct(plot_props, ex)
;endif 
;
;; Colorbar---------------------------------------------------------------------------------------
;    if keyword_set(cbar) then begin
        ; adjust window dimensions and graphic positions to make room for it
;    endif
;; Save-------------------------------------------------------------------------------------------
;    if keyword_set(savefile) then SAVE_FIGS, filename

;; Do I still need this?
;data = [ [[aia_1600_data[*,*,0]]], [[aia_1700_data[*,*,0]]] ]
;MY_IMAGE, hmi_data[*,*,0:3], image_props, 2, 2
