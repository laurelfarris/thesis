
; Last modified: 25 April 2018


pro image_powermaps, map, title, cbar=cbar, _EXTRA=e

    common defaults

    xoff = -0.05
    yoff = 0.0

    i = 0
    rows = 5
    cols = 3
    im = objarr(cols,rows)
    w = window2( dimensions=[8.5,9.0] )
    for y = 0, rows-1 do begin
    for x = 0, cols-1 do begin
        im[x,y] = image2( $
            map[*,*,i], $
            layout=[cols,rows,i+1], $
            margin=[0.1, 0.1, 1.50, 0.75]*dpi, $
            /current, /device, $
            title=title[i], $
            axis_style=0, $
            _EXTRA=e )
        im[x,y].position = $
            im[x,y].position + [x*xoff, y*yoff, x*xoff, y*yoff]
        i = i + 1
    endfor
    endfor

    if keyword_set(cbar) then begin
        im_lower = im[cols-1,rows-1]
        im_upper = im[cols-1,0]
        cx1 = (im_lower.position)[2] + 0.01
        cy1 = (im_lower.position)[1]
        cx2 = cx1 + 0.03
        cy2 = (im_upper.position)[3]
        c = colorbar2( position=[cx1,cy1,cx2,cy2], $
            tickformat='(I0)', $
            major=11, $
            title='3-minute power^0.5' )
            ;range=[0,mx], $  mx = ??
    endif

end

goto, start
start:

;------------------------------------------------------------------------------------
; This is all a bunch of hacky shit to get the correct starting time for each
; starting z-value. Problems because z was set to every 5th value, and time is
; still only incrementing by 1.
;There's got to be a more elegant, streamlined way to do this.
; Also, this stuff shouldn't be in a graphics routine...
;; Original indices (n_elem(z) = sz[2] of power maps

z = [0:680:5]
; Every 5th element in array of observation times (to go with power maps)
; Add 32 to get center time rather than start time ( +/- 25.6 minutes )
time = A[0].time[z+32]
; Use structures to keep stuff like this matched up correctly?

;ind = [24:38] ; Before
;ind = [39:53] ; During
;ind = [54:68] ; After
ind = [33:77:3]
tc = tc[ind]
nc = z[ind] + 32
;------------------------------------------------------------------------------------

;; Data to show - pretty major thing that changes every time...
;data = A[0].map2[*,*,ind]^0.5

;; Is this from when I was trying to use 'name' to retrieve window?
;image_powermaps, map^0.5, 'powermaps_AIA1600', tc, nc

title=[]
for i = 0, 14 do $
    title=[ title, tc[i]+'   (' + strtrim(nc[i],1) + ')' ]


for i = 0, 1 do begin
    map = A[i].map[*,*,z]
    image_powermaps, $
        map^0.5, $
        title, $
        min_value=0.0, $
        max_value=max(data), rgb_table=39
endfor


end
