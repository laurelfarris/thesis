;; Last modified:   19 July 2017 13:42:24





pro MAKE_IMAGE, _EXTRA=ex

end


pro image, _EXTRA=ex

    def = { $
        name     : "Image", $
        xticklen : 0.03, $
        yticklen : 0.03, $
        }

    if n_elements(ex) ne 0 then $
        ex = create_struct( 'property', value, ex ) $
    else $
        ex = { property : value }


    help, ex

    ;; Call 
    ;MAKE_IMAGE, _EXTRA=ex

end


wrap

end
