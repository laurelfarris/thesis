;Copied from clipboard


win = window( dimensions=[8.5,11.0]*dpi )
for ii = 0, 2 do begin
    im = image2( $
        imdata[*,*,ii], $
        /current, $
        layout=[1,3,ii+1], $
        margin=0.1 $
        )
endfor
        

        end

