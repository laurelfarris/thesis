;- Thu Feb 21 05:29:41 MST 2019




cc = 0
zz = 217

;- even out xstepper.. not worth the time right now.
min_value = min(A[cc].data)
max_value = max(A[cc].data)


aia_lct, r, g, b, wave=1600, /load




imdata = A[cc].data

;xstepper, alog10(imdata)



win = win_quick(dimensions=[10,10]*dpi)

im = image2( $
    alog10(imdata[*,*,zz]), $
    /current, $
    layout=[1,1,1], $
    margin=0.1, $
    rgb_table = A[cc].ct $
)



end
