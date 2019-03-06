
;- 18 October 2018


pro ADD_LETTERS, $
    graphic, $
    ;target=target, $  not sure yet if best to use graphic or target kw
    _EXTRA=e

    common defaults

    ; string array of letters: (a), (b), ..., (z)
    alph = '(' + string( bindgen(1,26)+(byte('a'))[0] ) + ')'

    NN = n_elements(graphic)
        ; (9/18/2018) This only makes sense if first create array of
        ;  graphics, then add text in a separate loop... which may
        ;  have been my intention, but it's been too long since I've
        ;  edited this code.

    t = objarr(NN)
    win = GetWindows(/current)

    for ii = 0, NN-1 do begin

        pos = graphic[ii].position

        ;new_pos = convert_coord( [ pos[0], pos[2] ], [ pos[1], pos[3] ], /normal, /to_device )
        ;-   Not accessing window... input 'win' as argument?

        ;- Put text in upper left corner of each panel
        ;tx = new_pos[0]
        ;ty = new_pos[3]

        ;- Syntax:
        ;-   result = TEXT( x, y, string, ... )

        tx = 0.9
        ty = 0.9

        t[ii] = TEXT( $
            tx, ty, $
            alph[ii], $
            target = graphic[ii], $
            ;/data, $
            ;/normal, $
            /relative, $
            ;/device, $
            alignment = 1.0, $
            vertical_alignment = 1.0, $
            fill_background = 0, $
            ;fill_color = 'white', $  ; does nothing if fill_background isn't set?
            font_color = 'white', $
            font_style=1, $
            font_size=fontsize-1, $
            _EXTRA=e )
    endfor
end


function IMAGE_POWERMAPS, $
    map, $
    rows=rows, $
    cols=cols, $
    titles=titles, $
    _EXTRA=e

    common defaults
    resolve_routine, 'colorbar2', /either

    sz = size(map, /dimensions)

    wx = 8.5
    wy = wx * (float(rows)/cols) * (float(sz[1])/sz[0])
    dw
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    width = 2.30
    height = width * float(sz[1])/sz[0]

    left=0.25
    right=0.25
    top=0.25
    bottom=0.1
    xgap=0.15

    resolve_routine, 'get_position', /either

    im = objarr(cols*rows)

    for ii = 0, n_elements(im)-1 do begin
        position = GET_POSITION( $
            layout=[cols,rows,ii+1], $
            width=width, $
            height=height, $
            wy=wy, $
            left=left, $
            right=right, $
            top=top, $
            bottom=bottom, $
            xgap=xgap )

        im[ii] = image2( $
            ;image_data[*,*,ii], $ Defined when scaling was applied I assume...
            map[*,*,ii], $
            /current, /device, $
            position=position*dpi, $
            ;min_value=1.2*min(map), $
            ;max_value=0.5*max(map), $
            xshowtext=0, $
            yshowtext=0, $
            title=titles[ii], $
            _EXTRA=e )

        ;- Colorbar
        cpos = im[ii].position
        c_width = 0.02
        c_gap = 0.01

        cx1 = cpos[2] + c_gap
        cy1 = cpos[1]
        cx2 = cx1 + c_width
        cy2 = cpos[3]

        cbar = COLORBAR2( $
            target = im[ii], $
            position=[cx1,cy1,cx2,cy2], $
            ;tickformat='(I0)', $
            ;major=11, $
            title='3-minute power' )

    endfor
    return, im
end


;-------------------------------------------------------------------------------------------------------

goto, start
journal, '2018-10-18.pro'

;- Detour to write a thing to convert Angstroms to keV for the GOES 0.5-4.0\AA{} band:

;- wavelengths in Angstroms
lambda = [1.0, 8.0]
lambda = [0.5, 4.0]

;- Energy of a photon: E = hc/lambda
;- hc = ~1240 eV. Conversion to cgs: 1 erg = 6.2415 x 10^{11} eV
;- eV * (1 erg / 6.2415e11 eV erg^{-1})
hc = 1240.0 / 6.2415e11

;- Convert wavelength to cgs: 1\AA{} = 10^{-10} m = 10^{-8} cm
lambda = lambda * 1.e-8

;- Get energy in keV by converting wavelengths to cm 
E = hc/lambda

print, E, ' eV = ', E/1000., ' keV'

;- Should be 1.5 and 10 keV
;- Not getting the correct numbers, but I've spent way too much time on this...


stop


;- Power maps:
;-   Multiply power maps by mask, which can be created using any threshold.
;-   Compare same power map using multiple thresholds.
;-   Show images used to compute maps: running average? standard deviation?
;-   How should power maps be scaled visually?  @methods
;-


dz = 32
dz = 45

;- Instead of declaring numerical values for endpoints of frequency bandpass,
;-   just center the bandpass on the frequency of interest, pick a bandWIDTH,
;-   and do a few extra calculations. It's the bettter way :)


;-  dz = 45 returns frequency corresponding to 180 seconds exactly.
;-  Could pick a shorter dz (like, I dunno, 32...) and maybe pad with zeros to get back up to 45?
;-  Still feel like this is cheating, and I don't have time to dick around anymore.


dz = 45

fcenter = 1./180
;bandwidth = 0.005
;bandwidth = 0.003
bandwidth = 0.001
fmin = fcenter - (bandwidth/2.)
fmax = fcenter + (bandwidth/2.)


;- See what frequencies are inside chosen bandwidth.
result = fourier2( indgen(dz), 24. )
frequency = result[0,*]
ind = where( frequency ge fmin AND frequency le fmax )

;- Frequency (mHz)
print, fmin*1000.
print, (frequency[ind])*1000., format='(F0.2)'
print, fmax*1000.

;- Period (seconds)
;print, 1./frequency[ind], format='(F0.2)'

stop

;sz = size(data, /dimensions) ; --> won't be able to do this if data is defined after this...
;xx = sz[0]
;yy = sz[1]

; Hard coding! Bleh.
xx = 500
yy = 330

;--- Be careful about using same variable name in multiple places!
;---  'ind' starts as indices of freq within bandpass and then turns into z-indices of data cube.
;---  Subroutines! Can use the same variable names all over the place, and they never meet.


;-  NN maps for each channel, 2 channels (eventually)
NN = 4

;- From Milligan2017 wavelet figure, visible enhancement starts around 01:41 UT for AIA 1700.

;- Only need to define ONE starting z value:
;-   z0 (aka 'z_start' in older codes) = starting index for first map,
;-   then shift z-indices ('ind') as much as you like.

cc = 0
time = strmid(A[cc].time, 0, 5)

z0 = (where( time eq '01:23' ))[0]

;- initialize arrays for power map and saturation mask (which better have same dimensions)

aia_maps = fltarr( xx, yy, NN, 2)




threshold = 10000

;- Generate saturation mask, then image - make sure nothing looks weird.
;- NOTE: This is a 2-step process! Don't confuse the image masks with the map masks.

cc = 1
data=A[cc].data[*,*,207:386]
sz = size(data, /dimensions)

;- Step 1:
;-  'mask' is cube of individual images, with pixels set to 0 or 1.
;-  No map considerations yet... nothing has been combined over dz images yet.

;-  Create mask from data values (saturated pixels = 0.0, others = 1.0)
;mask = fltarr( xx, yy, NN, 2)
mask = fltarr( sz )


mask[where( data lt threshold )] = 1.0
mask[where( data ge threshold )] = 0.0
stop


;- Step 2:
;-  'mask_map' is obtained by taking the product over data cube from i to i+dz
;-  This is what will be multiplied by power maps.
;-  If one wanted to exclude saturated pixels from images, use 'mask'

;aia1700mask = mask[*,*,*,1]

aia_map_mask = fltarr( 500, 330, 4, 2)

;titles = []

for cc = 1, 1 do begin
    for ii = 0, NN-1 do begin

        ;-  z indices (int array of length dz, shifted forward to starting z value)
        ind = indgen(dz) + ( z0 + (dz*ii) )

        ;data = A[cc].data[*,*,ind]

        ;- Titles could be computed before maps... as long as loop is set up the same way,
        ;- Especially since it'll calculate twice, once for each AIA channel...
        ;titles = [ titles, time[ind[0]] + ' - ' + time[ind[-1]]  ]

    ;-  Calculate power maps. Calling sequence:
    ;-  result = POWER_MAPS( data, cadence, $
    ;-      fmin=fmin, fmax=fmax, threshold=threshold, z=z, dz=dz, norm=norm )

            ;aia_maps[*,*,ii,cc] = POWER_MAPS( data, A[cc].cadence, fmin=fmin, fmax=fmax )

            aia_map_mask[*,*,ii,cc] = product( mask[*,*,ind], 3 )
    endfor
endfor
;- Didn't preserve any values here... How much data was used in total to do calculations?

start:;-------------------------------------------------------------------------------------------------

dw
win = window(/buffer)
for ii = 0, 3 do begin
    im = image( aia_map_mask[*,*,ii,1], /current, $
        layout=[2,2,ii+1], margin=0.1, $
        title = 'mask map' )
endfor
save2, 'saturation.pdf'
stop

;- Image power maps.
;- Too tired and in too much of a hurry to mess with generalizing this right now
;- Maybe make a routine I can read into each code, and make fast tweaks without re-writing the
;- whole thing every single time???!?? What brilliant ideas I have when sleep deprived.
;- Same idea as copying my most recent latex file every time I need to make a new document.
;- Can't remember the last time I wrote a tex file from scratch.

map = aia_maps[*,*,*,1]

cc = 1
aia1700titles = 'AIA ' + A[cc].channel + '$\AA$  ' + titles[4:7] + ' UT'
for ii = 0, 3 do print, aia1700titles[ii]

stop


;- Separate file for each channel?
;- --> yes, since not really comparing them to each other anyway

;for cc = 1, 1 do begin
    im = IMAGE_POWERMAPS( $
        ;aia_maps[*,*,*,cc], $
        alog10(map), $
        rows = 2, $
        cols = 2, $
        rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ), $
        titles = aia1700titles )

    ;- What's the point of returning 'im'? Not doing anything with it..
    ;ADD_LETTERS, im
    ;- So it can be passed to lettering routine, apparently.

    file = 'aia1700map_45.pdf'
    resolve_routine, 'save2', /either
    save2, file
;endfor

stop

;map = AIA_INTSCALE( A[cc].map, wave=fix(channel), exptime=A[cc].exptime )
;sz = size(map, /dimensions)
;time = strmid(A[ii].time,0,8)
;index = indgen(n_elements(time))
;time_range = time + '-' + shift(time, -(dz-1)) + ' (' + strtrim(index,1) + '-' + strtrim(shift(index, -(dz-1)), 1)  + ')'
;time_range = time_range[ 0 : sz[2]-1 ]
;ind = [ 0 : sz[2]-1 : 40 ]

;-------------------------------------------------------------------------------------------------------

;-  Could remove 'threshold' kw from power_maps.pro since not using it anymore, but
;-  an unused kw shouldn't cause any problems... at least I hope not.

;-  power_maps.pro is written to take entire data set and an array of starting indices.
;-  This is probably faster than passing hugs arrays back and forth when computing a bunch of maps...
;-  not sure what the best coding practice would be in this case, if there even is one.
;-  kws are optional: if z isn't specified then default is to start at index 0
;-  and if dz isn't set then map is calculated over entire data cube.

;-  This is actully one of the best codes I've written - able to keep coming back to it
;-   and make little, if any changes, and don't get a ton of errors because of subroutines
;-   that no longer exist, changes in calling sequence, or being unable to figure out what
;-   the hell I was trying to do.


stop
print, ''
print, '--> Type .CONTINUE to close journal.'
print, ''
stop
journal

end
