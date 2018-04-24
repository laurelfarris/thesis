

pro image_powermaps, map, name, time, pos

    common defaults

    i = 0
    w = window2( dimensions=[8.5,9.0] )
    rows = 5
    cols = 3
    im = objarr(cols,rows)
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            layout=[cols,rows,i+1], $
            margin=[0.1, 0.1, 1.50, 0.75]*dpi, $
            /current, $
            /device, $
            min_value=0.0, $
            max_value=max(data), $
            rgb_table=39, $
            title=tc[i]+'   (' + strtrim(nc[i],1) + ')', $
            axis_style=0 )
        im[x,y].position =  $
            im[x,y].position + [x*xoff, y*yoff, x*xoff, y*yoff]
        t = text2( 0.07, 0.85, time[i], $
            /device, /relative, target=im[x,y], color='white')

            tc[i]+'   (' + strtrim(nc[i],1) + ')', $
        i = i + 1
    endfor
    endfor
end

goto, start
start:


xoff = -0.05
yoff = 0.00

;; Original indices (n_elem(z) = sz[2] of power maps
z = [0:680:5]
;; Center time ( +/- 25.6 minutes )
tc = A[0].time[z+32]



;; START (so to speak)
;; Definitely need to keep track of time that goes with power maps.
;data = (A[0].map2)^0.5
;ind = [24:38] ; Before
;ind = [39:53] ; During
;ind = [54:68] ; After
ind = [33:77:3]
tc = tc[ind]
nc = z[ind] + 32

;; Data to show - pretty major thing that changes every time...
data = A[0].map2[*,*,ind]^0.5


; Should this also be in a different subroutine?
;    rows and cols may be necessary for this to work.
cx1 = (im[-1,-1].position)[2] + 0.01
cy1 = (im[-1,-1].position)[1]
cx2 = cx1 + 0.03
cy2 = (im[-1,0].position)[3]
c = colorbar2( position=[cx1,cy1,cx2,cy2], $
    tickformat='(I0)', $
    major=11, $
    range=[0,mx], $
    title='3-minute power^0.5' )

map = A[0].map[*,*,z]
image_powermaps, map^0.5, 'powermaps_AIA1600', time, pos
map = A[1].map[*,*,z]
image_powermaps, map^0.5, 'powermaps_AIA1700', time, pos

;locs = where( data ge 0.3*max(data) )
;print, n_elements(locs)
;tempind = array_indices( data, locs )
;tempdata = data[*,*,3]
;tempdata[tempind] 
;im = image( tempdata, layout=[1,1,1], margin=0.0, rgb_table=5, $
;max_value=0.003*max(data))



end
