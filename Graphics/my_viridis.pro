;+
;- 14 April 2020
function my_viridis

    ;+
    ;- colors from bookdown.org (see Enote from today)
    viridis = COLORTABLE( [ $
        [068, 001, 084], $
        [072, 040, 120], $
        [062, 074, 137], $
        [049, 104, 142], $
        [038, 130, 142], $
        [031, 158, 137], $
        [053, 183, 121], $
        [109, 205, 089], $
        [180, 222, 044], $
        [253, 231, 037] ] $
    )

    return, viridis

end
