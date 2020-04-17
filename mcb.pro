;Copied from clipboard


resolve_routine, 'arrow2', /is_function
;-
;test = arrow2( [10,50], [10,50], color='magenta', line_thick=3.0, $
;    fill_background=1 )
myarrow = objarr(2)
for cc = 0, 1 do begin
    myarrow[cc] = ARROW2( $
        [x1,x2], [y1,y2], $
        target=im[cc+2], $
        thick=3.0, $
        line_thick=2.0, $
        head_angle=30, $   ;- default in my subroutine (arrow2) = 45 degrees.
        head_size=0.5, $    ;- forgot what this is...
        fill_background=1 )
        ;buffer=buffer )
endfor
;-
save2, filename + '_arrow'
;-

end

