;; Last modified:   02 February 2018 20:04:45




GOTO, START

;; Just a6 for now...


start:

a7data = fix(a7data)

data = { $
    b6 : a6data[*,*,0:224], $
    b7 : a7data[*,*,0:224], $
    d6 : a6data[*,*,225:376], $
    d7 : a7data[*,*,225:376], $
    a6 : a6data[*,*,377:525], $
    a7 : a7data[*,*,377:525]  $
}


;; make an array(s) of start/stop times instead of copying chunks of data.
;; No point in taking up memory for no reason!


function power_maps, data, indices, spectral_band, delt, T, dT, map=map

    sz = size( data, /dimensions )
    n = n_elements(indices) - 1
    map = fltarr( sz[0], sz[1], n )

    for i = 0, n-1 do begin
        ;arr = data.(j)
        t1 = indices[i]
        t2 = indices[i+1]-1
        arr = data[ *, *, t1:t2 ]
        for y = 0, sz[1]-1 do begin
        for x = 0, sz[0]-1 do begin
            result = fourier2( arr[x,y,*], delt )
            frequency = reform( result[0,*] )
            power = reform( result[1,*] )
            ;power = reverse( power, 1 )
            ;period = reverse( (1./frequency), 1 )
            ;band = where( period gt 170.0 and period lt 190.0 )
             
            f1 = where( frequency spectral_band[0]
            f2 = spectral_band[1]

            f1 = 1./(T+dt)
            f2 = 1./(T-dt)
            i1 = (where( frequency ge f1 ))[ 0]
            i2 = (where( frequency le f2 ))[-1]

            map[x,y,i] = total( power[ i1 : i2 ] )
            ;; Used mean last time... may want to compare, or make sure this
            ;;    is the right way to do it.

        endfor
        endfor
    endfor


indices = [0,224,376,525]



names = [ $
    "AIA 1600 12:30-01:30", $
    "AIA 1700 12:30-01:30", $
    "AIA 1600 01:30-02:30", $
    "AIA 1700 01:30-02:30", $
    "AIA 1600 02:30-03:30", $
    "AIA 1700 02:30-03:30" ]


wx = 900
wy = 1100
w = window( dimensions=[wx,wy] )
im = objarr(6)
for i=0,5 do begin

    im[i] = image( $
        (map[*,*,i])^0.5, $
        /current, $
        layout=[2,3,i+1], $
        margin=[ 0.1, 0.1, 0.2, 0.1], $
        title=names[i], $
        rgb_table=39 $ 
        )

    pos = im[i].position

    c = colorbar( target=im[i], orientation=1 , $
        position=[ pos[2]+0.01,pos[1],pos[2]+0.03,pos[3] ], $ 
        title="Power", font_size=9, $
        textpos=1 $
    )
endfor




end
