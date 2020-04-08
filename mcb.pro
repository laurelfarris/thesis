;Copied from clipboard


for ii = 0, 3 do begin
    ;print, min(imdata[*,*,ii])
    im = image2( imdata[*,*,ii], buffer=buffer )
    save2, 'test' + strcompress(ii, /remove_all)
endfor
dw

end

