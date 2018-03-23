;; Last modified:   23 March 2018 16:18:52




alph = string( bindgen(1,26)+(byte('a'))[0] )

@graphics

; If one graphic is selected, it's returned in array 'graphics'.
graphics = p.Window.GetSelect()
; Need a way to select ALL graphics (without clicking) in current window.
; See 'dw' routine.

for i = 0, n_elements(graphics)-1 do begin
    t = text( $
        x, y, $
        alph[i], $
        /device, /relative, $
        target=p[i], $
        ;alignment=, vertical_alignment=, $
        ;font_name=, $
        font_size=fontsize )
endfor

end
