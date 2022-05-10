;+
;- LAST MODIFIED:
;-   20 January 2020
;-
;- PURPOSE:
;-
;- INPUT:
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-
;+




;- specific to what exactly is being imaged

buffer = 1


cc = 0
ii = 253
imdata = map[*,*,ii]


;-------------

;- general imaging code

cc = 0
ii = 253
imdata = map[*,*,ii]
dw
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ), $
    buffer=buffer $
)


instr='aia'
filename = instr + A[cc].channel + 'bda_maps' + class
save2, filename


end
