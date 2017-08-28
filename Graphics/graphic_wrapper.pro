;; Last modified:   12 August 2017 17:23:43


pro MAKE_IMAGE, _EXTRA=ex

end


pro image_wrapper_1, _EXTRA=ex


    ;; Image properties
    @graphic_configs

    ;; 'property' --> default values
    if n_elements(ex) ne 0 then $
        ex = create_struct( 'property', value, ex ) $
    else $
        ex = { property : value }


    ;; Call subroutine that actually makes the images
    MAKE_IMAGE, _EXTRA=ex

end



pro image_wrapper_2, _EXTRA=ex

    defaults = { $
        name     : "Image", $
        xticklen : 0.03, $
        yticklen : 0.03, $
        }

    if n_elements(ex) ne 0 then $
        ex = create_struct( defaults, ex ) $
    else $
        ex = defaults


    ;; Call subroutine that actually makes the images
    MAKE_IMAGE, _EXTRA=ex

end
