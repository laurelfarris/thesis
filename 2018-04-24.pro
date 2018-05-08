;; Last modified:   24 April 2018 16:14:34

goto, start


xstepper, A[1].map^0.5
stop

z = [0:680:5]
tc = A[0].time[z+32]
ind = [21:40]
tc = tc[ind]
nc = z[ind] + 32

wx = 4.25 * 2
wy = 5.5 * 2
im = objarr(2)
w = window( dimensions=[wx,wy]*dpi )
for i = 0, 1 do begin
    temp = (total( A[i].map[*,*,21:40], 3))
    ; Tried scaling both maps between 0 and 1, but this didn't look good.
    ;temp = temp - min(temp)
    ;temp = temp/max(temp)
    im[i] = image2( temp, $
        /current, $
        /device, $
        layout=[1,2,i+1], $
        margin=[0.70, 0.25, 0.60, 0.25]*dpi,  $
        xtitle='X (pixels)', $
        ytitle='Y (pixels)', $
        title=A[i].name, $
        max_value=1e5, $
        rgb_table=A[i].ct )
    cx1 = (im[i].position)[2] + 0.01
    cx2 = cx1 + 0.03
    cy1 = (im[i].position)[1]
    cy2 = (im[i].position)[3]
    c = colorbar2( $
        target=im[i], $
        position=[cx1,cy1,cx2,cy2], $
        major=0, $
        title='3-minute power' )
endfor
stop

save2, 'power_preflare_big'
stop


; Tried running power_total as it is currently written.
; Only problem is total power isn't defined (it's a quick calculation,
; so the variable wasn't saved and included in structure in prep.pro.
; I should add that calculation to prep.pro...
; This would involve summing over each map in the saved/restored
; power maps (rather than using total flux). Still have yet to confirm
; whether or not either method results in the same total power.
; Actually, using the maps would cause problems because of saturated
; pixels being left out..
; LATER: the start command was after the block of code that calulated power.
; Which I didn't even read.

z = [0:680:5]
dz = 64
power = fltarr(137)

for i = 0, n_elements(z)-1 do begin
    result = fourier2( A[1].flux[ z[i]:z[i]+dz-1 ], 24 )
    frequency = reform(result[0,*])
    ind = where (frequency ge 0.0052 AND frequency le 0.0059)
    power[i] = TOTAL( (reform(result[1,*]))[ind] )
endfor

;aia1600 = create_struct( aia1600, 'power', power ) 
; This didn't work for some reason...
; The reason was I forgot to TOTAL the power at first. Derp.
aia1700 = create_struct( aia1700, 'power', power ) 


;ind = [0:*]
; ERROR --> can't use asterisk without array.

A = [ aia1600, aia1700 ]
; Now A does have the power tag! Back to plotting total power.

start:;------------------------------------------------------------------------------

;; HMI analysis


; lower left corner relative to center (according to older notes)
x0 = 1650 - (500/2)
y0 = 2500 - (330/2)

hmi_image = rot( hmi.data[x0:x0+500-1,y0:y0+330-1,0], 180 )

w = window( dimensions=[8.5,11]*dpi )
im = image2( $
    hmi_image, $
    /current, $
    layout=[1,2,1])
im = image2( $
    A[1].data[*,*,0], $
    /current, $
    layout=[1,2,2])


stop



; show image of AIA 1700 power maps to find non-saturated pixel
; that is enhanced a lot
; Trim depending on where enhancement is
x1=0
y1=0
x2=499
y2=329
temp = temp[x1:x2,y1:y2,*]




end
