;+
;- 10 April 2020


buffer=1

imdata = findgen(300,300)
help, imdata
;-


;1. yellow
;     226 ffff00 [255, 255, 000] -- too light
;     220 ffff00 [255, 215, 000] -- too dark
;   ...
;2. green
;      30 008787  [000, 135, 135], $
;      31 0087af  [ ] <-- haven't tried this one yet
;3. cyan
;      24 005f87  [000, 095, 135], $
;4. Violet
;      53 5f005f [095, 000, 095]
;      54 5f0087 [095, 000, 135] <-- better, still not dark enough

;viridis = COLORTABLE( [ $
;    [255, 235, 000], $
;    [000, 215, 135], $
;    ;[000, 175, 135], $
;    ;[000, 175, 095], $
;    [000, 135, 135], $
;    [067, 000, 089] ], $  ; "Mulberry"
;    /reverse $
;)
;-
;-


;- 14 April 2020
;- Same as above, but with rgb colors
;-   in reverse order so no need for
;-   /reverse kw.
;viridis = COLORTABLE( [ $
;    [067, 000, 089], $  ; "Mulberry"
;    [000, 135, 135], $
;    [000, 215, 135], $
;    [255, 235, 000] ], $
;)

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


dw
im = image($
    rotate(imdata, 1), $
    margin=0.0, $
    rgb_table=viridis, $
    buffer=buffer $
)
;cbar = colorbar2( target=im )
;print, cbar.position
;-
save2, 'test_CT'
;-
;-

end
