;Copied from clipboard


wx = 8.0
wy = 8.0
dw
foreach zz, zind, ii do begin
    imdata = alog10(A[cc].map[*,*,zz])
    ;help, imdata
    ;
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer)
    ;
    im = IMAGE2( $
        imdata, $
        /current, $
        margin=0, $ 
        layout=[1,1,1], $
        rgb_table=A[cc].ct, $
        title=A[cc].time[zz], $
        buffer=buffer $
    )
    ;
    save2, 'map' + strtrim(ii,1)
    ;
endforeach

end

