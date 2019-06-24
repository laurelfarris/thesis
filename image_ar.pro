
;-
;- 23 October 2018

function GET_IMAGE_DATA

    ;- Read data from fits files to show images.
    ;- Return structure with data and other info to show in images

    ;- Show both AIA channels at 01:44 (beginning of GOES flare).
    ;- Read in HMI B_LOS and HMI continuum, and overplot both contours on AIA.
    ;- Save both image files, and use whichever is better in paper/presentation.
    ;-
    ;-
    ;- Needed information:
    ;-  * Center coordinates of AR at desired date_obs
    ;-      (know coords of first image and approximate rotation rate...
    ;-       simple calculation?)
    ;-  *
    ;-
    ;- First read fits files with NODATA=1 to get observation times from header.
    ;- Need this to figure out index of desired time for inst with different cadence,
    ;-   later improve read_my_fits.pro to take time (or array of times) to do this.
    ;-
    ;-
    ;-
    ;- 17 December 2018
    ;-   I think the purpose of this was solely to create figure with intensity
    ;-   images for the Data/Obs section of paper. No analysis is done here.
    ;-   This was also before I had a working routine for hmi_prep, though this
    ;-   at least doesn't read in the entire array just to show one image, and
    ;-   prep routines don't contain full disk images.
    ;-   This needs some work though... there's a lot of repeats when creating
    ;-   the structures for each instrument/channel.



    @parameters


    ;- date_obs of image(s) to display
    display_time = '01:44'




    ;- HMI --------

    instr = 'hmi'

;    ; HMI continuum
;    channel = 'cont'
;
;    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1 ;ind=[0]
;    time = strmid(index.date_obs, 11, 5)
;    ind = (where( time eq display_time ))[0]
;
;    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, prepped=1, ind=ind
;    sz = size( data, /dimensions )
;    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
;    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
;    time = strmid(index.date_obs, 11, 11)
;    hmi_cont = { $
;        data : data, $
;        X : X, $
;        Y : Y, $
;        extra : { title : 'HMI continuum' + time + ' UT' } }


    ; HMI B_LOS
    channel='mag'

    resolve_routine, 'read_my_fits'
    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1, $ ;ind=[0]
        year=year, month=month, day=day
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, prepped=1, ind=ind, $
        year=year, month=month, day=day
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    hmi_BLOS = { $
        data : data, $
        ;data : data<300>(-300), $
        X : X, $
        Y : Y, $
        extra : { title : 'HMI B$_{LOS}$ ' + time + ' UT'} }



    ;- AIA --------
    instr='aia'

    ; AIA 1600
    channel='1600'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1, $
        year=year, month=month, day=day
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, ind=ind, prepped=1, $
        year=year, month=month, day=day
    ;print, 'Processing level = ', strtrim(index.lvl_num,1), ' for AIA ', channel
    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=fix(channel), r, g, b
    aia1600 = { $
        data : aia_intscale(data,wave=fix(channel), exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA ' + channel + '$\AA$ ' + time + ' UT', $
            rgb_table : [[r],[g],[b]] } }

    ; AIA 1700
    channel='1700'

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=1, prepped=1, $
        year=year, month=month, day=day
    time = strmid(index.date_obs, 11, 5)
    ind = (where( time eq display_time ))[0]

    READ_MY_FITS, index, data, instr=instr, channel=channel, nodata=0, ind=ind, prepped=1, $
        year=year, month=month, day=day
    ;print, 'Processing level = ', strtrim(index.lvl_num,1), ' for AIA ', channel

    sz = size( data, /dimensions )
    X = (indgen(sz[0]) - index.crpix1) * index.cdelt1
    Y = (indgen(sz[1]) - index.crpix2) * index.cdelt2
    time = strmid(index.date_obs, 11, 11)
    aia_lct, wave=fix(channel), r, g, b
    aia1700 = { $
        data : aia_intscale(data, wave=fix(channel), exptime=index.exptime), $
        ;data : data, $
        X : X, $
        Y : Y, $
        extra : { $
            title : 'AIA ' + channel + '$\AA$ ' + time + ' UT', $
            rgb_table : [[r],[g],[b]] } }

    S = { $
        aia1600:aia1600, $
        aia1700:aia1700, $
        ;hmi_cont:hmi_cont, $
        hmi_BLOS:hmi_BLOS }

    return, S
end

pro IMAGE_STRUCTURE, S

    ; Specifically takes structure generated by 'get_image_data.pro'


    ; Center of AR* --> lower left corner of AR
    ;   *according to green book (page 50, February 2)
    x0 = 2375
    y0 = 1660
    xl = x0 - 250
    yl = y0 - 165


    ;- AR looked a little off center, but probably
    ;- need to shift x since time is now 01:44 instead of 00:00.
    ;- 1.75 hours at rotation rate of ~14 pixels per hour
    ;- --> 14 * (1. + (44./60.) ) = 24.266666
    xl = xl + 24
    ;- Graphic _02
    ;- Didn't really notice a change...

    common defaults

    cols = 3
    rows = 2
    im = objarr(cols,rows)

    top = 0.25
    left = 0.5
    ;bottom = 0.25
    ;right = 0.5

    ; width (w) and height (h) of individual panels
    w = 2.3
    h = w

    ;wx = 8.5/2
    ;wy = wx * (sz[1]/sz[0]) * 2
    wx = 8.0
    wy = 5.5
    dw
    win = window( dimensions=[wx,wy]*dpi, buffer=1, location=[700,0] )


    ; Need to speed this part up a little bit...
    for j = rows-1, 0, -1 do begin
        for i = 0, cols-1 do begin

            ; Set up X/Y axis labels in solar coords (arcsec, rel to disk center)
            if j eq 0 then begin
                data = crop_data(S.(i).data, center=[x0,y0])
                X = (S.(i).X)[xl:xl+500-1]
                Y = (S.(i).Y)[yl:yl+330-1]
            endif
            if j eq 1 then begin
                data = S.(i).data
                X = S.(i).X
                Y = S.(i).Y
            endif

            ; Image positions

            ; Multiply by i to add space between panels
            x1 = 0.75 + i*(w+0.1)

            ; shift in h moves TOP row up and down
            y1 = 0.40 + j*(h)
            ;y1 = 0.40 + j*(h-0.5) ; not enough space
            ;y1 = 0.40 + j*(h+0.5) ; too much space

            position=[x1,y1,x1+w,y1+h]

            ;data = aia_intscale(data, wave=wave, exptime=exptime)

            im[i,j] = image2( $
                data, X, Y, $
                /current, /device, $
                position=position*dpi, $
                xshowtext=0, $
                yshowtext=0, $
                _EXTRA=S.(i).extra )

            ; Show x-labels for full disk and AR, since they don't match.
            ax = im[i,j].axes
            ax[0].showtext = 1

            ; Far left column
            if i eq 0 then begin
                ax[1].showtext = 1
                ax[1].title='Y (arcseconds)'
            endif

            ; bottom row
            if j eq 0 then begin
                im[i,j].title = ''
                ax[0].title='X (arcseconds)'
            endif
        endfor
    endfor

    stop

    resolve_routine, 'save2', /either
    file = 'color_images'
    save2, file;, /add_timestamp
    return

    ; Polygons - Draw rectangle around (temporary) area of interest.
    ;rec = polygon2( x1, y1, x2, y2, target=im[i])
    ;rec = polygon2( 40, 90, 139, 189, target=[im[0,0],im[1,0],im[2,0])
    rec = polygon2( xl, yl, xl+500, yl+330,/device, target=[im[0,0],im[1,0],im[2,0]])

    ; Add text to graphics
    txt = [ '(a)', '(b)' ]
    t = text2( $
        position[0,i], position[3,i], $  ; upper left corner of each panel
        ;0.03, 0.9, $
        txt[i], $
        device=1, $
        ;relative=1, $
        target=im[i], $
        vertical_alignment=1.0, $
        color='white' )
end


pro IMAGE_AR_ONLY, S
;- 12 February 2019

    common defaults

    ; Center of AR* --> lower left corner of AR
    ;   *according to green book (page 50, February 2)
    x0 = 2375 + 24
    y0 = 1660
    xl = x0 - 250
    yl = y0 - 165

    imdata = [ $
        [[ crop_data( S.(0).data,  center=[x0,y0]) ]], $
        [[ crop_data( S.(1).data,  center=[x0,y0]) ]], $
        [[ crop_data( S.(2).data,  center=[x0,y0]) ]] ]
    XX = (S.(0).X)[xl:xl+500-1]
    YY = (S.(0).Y)[yl:yl+330-1]

    title = strarr(n_tags(S))
    for ii = 0, n_tags(S)-1 do title[ii] = S.(ii).extra.title

    resolve_routine, 'image3', /either
    im = image3( $
        imdata, XX, YY, buffer=1, $
        title=title, $
        xtitle='X (arcseconds)', ytitle='Y (arcseconds)', $
        top=0.25, $
        bottom=0.5, $
        ygap=0.65, $
        left=0.75, $
        right=0.75, $
        wx=3.75, $
        rows=3, cols=1 )

    for ii = 0, 1 do im[ii].rgb_table = S.(ii).extra.rgb_table


    ;- HMI Contours:
    contourr = CONTOUR2( $
        imdata[*,*,2], $
        XX, YY, $
        ;overplot=im[2], $
        c_value=[-300, 300], $
        c_thick=[0.5,0.1], $
        ;c_color=['black', 'white'], $
        c_color=[ ['000000'x], ['303030'x] ], $  ; black, gray
        name = ['-300 G', '+300 G'] )


    ;- Label each of the four sunspots
    ;- (same coords as in subregions.pro, and hmi_spectra.pro)

;    center = [ $
;        [390, 225], $
;        [170, 220], $
;        [245, 105], $
;        [ 20,  75] ]
    center = [ $
        [350, 250], $
        [160, 210], $
        [200,  90], $
        [ 10,  75] ]
    nn = (size(center, /dimensions))[1]

    label = [ 'AR_1p', 'AR_1n', 'AR_2p', 'AR_2n' ]
    color = [ 'white', 'black', 'white', 'black' ]

    sunspot = objarr(nn)
    cdelt = 0.65
    resolve_routine, 'text2', /either
    for ii = 0, nn-1 do begin

        sunspot[ii] = TEXT2( $
            center[0,ii]*cdelt + XX[0], $
            center[1,ii]*cdelt + yy[0], $
            label[ii], $
            font_size=fontsize-1, $
            target=im[2], $
            /data, $
            color = color[ii] )
    endfor
end


;- return graphic info in structure 'S' and create image.
;S = GET_IMAGE_DATA()
;IMAGE_STRUCTURE, S
IMAGE_AR_ONLY, S

save2, 'images';, /add_timestamp, idl_code='image_ar'


end
