;Copied from clipboard


;cc = 0
cc = 1
;
;imdata = alog10(aia1600maps)
imdata = alog10(aia1700maps)
;
dw
resolve_routine, 'image3', /is_function
im = IMAGE3( $
    imdata, $
    cols=3, rows=3, $
    axis_style=0, $
    rgb_table=AIA_GCT(wave=A[cc].channel), $
    buffer=buffer $
)
;
filename = 'aia' + A[cc].channel + 'maps_multiflare'
print, filename
;
save2, filename

end

