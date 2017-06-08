;; Last modified:   07 June 2017 19:39:54

;; Images

;; Rotation rate??
x = 2400
y = 1650
r = 1000
x1 = x-r
x2 = x+r
y1 = y-r
y2 = y+r

;w = my_window(512,512)
w = my_window(800,800, /del)

;im = image( (hmi_data[x1:x2,y1:y2,200]), current=1, layout=[1,1,1], margin=0)

im = image( (hmi_data[*,*,200]), current=1, layout=[1,1,1], margin=0 )
;im = image( (aia_data[*,*,20])^0.5, current=1, layout=[1,1,1], margin=0 )
STOP

im = image( (hmi_data[x1:x2,y1:y2,0])^0.5, current=1, layout=[2,1,1], margin=0.1, $
    title="First image")
im = image( (hmi_data[x1:x2,y1:y2,-1])^0.5, current=1, layout=[2,1,2], margin=0.1, $
    title="Last image")

STOP
im = image( (hmi_data[*,*,15])^0.5, current=1, layout=[1,1,1], margin=0 )
STOP

i=0
for j = 15, 20 do begin
    im = image( (aia_data[*,*,j])^0.5, current=1, layout=[2,3,i+1] )
    i=i+1
endfor


STOP


;; Plots

ytitle=["frequency", "power spectrum", "phase", "amplitude"]

;resolve_routine, "graphic_configs"
e = graphic_configs(2)
w = my_window( 700, 700, /del )
for i = 0, 3 do begin
    p = plot(h_result[i,*], layout=[2,2,i+1], /current, $
    ytitle=ytitle[i], xtitle="", title="HMI",  _EXTRA=e)
endfor

STOP

w2 = my_window( 700,500 )
p1 = plot(h, layout=[1,1,1], _EXTRA=e)
end



STOP



;; Movie
xstepper, data ;, info_array, xsize=xsize, ysize=ysize, /interp, start=start, /noscale


end
