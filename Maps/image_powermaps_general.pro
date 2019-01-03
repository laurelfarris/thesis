;-
;- 20 December 2018
;-
;-   image_powermaps.pro - SINGLE image.
;-   bda.pro - ARRAY of images.
;-   bda_powermaps.pro - not sure... kind of a mess.
;- Should combine all routines that image powermaps... no need to have a
;- completely separate imaging routine just because layout is different.
;- How??
;-


function IMAGE_POWERMAPS_GENERAL, $
    struc, $
    _EXTRA = e

    ;- struc must contain appropriate tags, which are passed into image3 below.
    ;- These are usually values that can't really be assigned defaults,
    ;- and/or are pulled from ML variables. Note that tags in structure are
    ;- NOT part of _EXTRA.
    ;-   (e.g. the data itself).

    ;- Set struc.imdata = alog10(whatever) if want log.
    ;-   Don't alter values inside this routine.
    ;imdata = alog10(struc.imdata)

    ;- Everything that is the same for every power map imaging routine needs
    ;- to be here. If there's not much here, maybe this routine isn't necessary...

    resolve_routine, 'image3', /either
    ;- NOTE: image3 returns object array
    im = image3( $
        struc.imdata, $
        title = struc.title, $
        min_value=min(imdata), $
        max_value=max(imdata), $
        xshowtext=0, yshowtext=0, $
        wx = 8.0, $
        rows = 1, $
        cols = 1, $
        left = 0.10, right = 0.10, bottom = 0.10, top = 0.50, $ ;image_powermaps.pro
        ;left = 0.2, right = 1.0, $  ; space for colorbar to the right
        xgap=0.05, ygap=0.05, $
        buffer=1, $
        _EXTRA = e )
    return, im
end


;- Different code for each type of powermap image(s) I decide to make?
;- Then each one calls this to make figure...

;function POWERMAP_STRUC, z_start

;- Are structures really necessary?
;-   Would prevent having to constantly re-define the same variables every
;-   time switch between BDA..
;- Call this from other routine, or keep at ML and just .RUN it...

;- Define z indices
z_start = [0, 16, 27, 58, 80, 90, 147, 175, 196]

;- Define x/y indices if looking at subregions
;xind = [x1:x2]
;yind = [y1:y2]

    struc = { $
        imdata : A[cc].map[xind,yind,z_start], $
        title : A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)', $
        file : 'aia' + A[cc].channel + 'map' }
;end

cc = 0
dz = 64
time = strmid(A[cc].time,0,5)

;----------------------------------------------------------------------------------------
;- image_powermaps.pro --> single z_start value
z_start = [197] ;- pre-flare
;z_start = [204] ;- pre-flare/impulsive
;z_start = [450] ;- post-flare
;----------------------------------------------------------------------------------------
;- bda.pro --> 27 values for z_start (9 for each BDA phase)

;phase = "during"
;z_start = [197, 200, 203, 216, 248, 265, 280, 291, 311]
;phase = "after"
;z_start = [ 387, 405, 450, 467, 475, 525, 625, 660, 685 ]


;- General:

NN = n_elements(z_start)
imdata = fltarr(500,330) ; Unless subregions...

title = strarr(NN*2)
foreach zz, z_start, ii do begin
    title[ii] = A[cc].name + ' 5.6 mHz (' + $
                time[zz] + '-' + time[zz+dz-1] + ' UT)'
    ;title[ii] = time[zz] + '-' + time[zz+dz-1] + ' UT'
endforeach
;title = time[z_start] + '-' + time[z_start+dz-1] + ' UT'
;- Test to see if this works, without using a for loop.


;- AIA intensity
intensity = { $
    imdata : mean(A[cc].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    ;imdata : aia_intscale( data, wave=1600, exptime=1.0 ) ;exptime=A[cc].exptime ), $
    title : A[cc].name + ' (' + A[cc].time[zz] + '-' + A[cc].time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_image' }

;- HMI
hmi = { $
    imdata : mean(H[0].data[*,*,[z_start:z_start+dz-1]], dim=3), $
    title : H[0].name, $
    file : 'hmi' + H[0].channel + 'big_image' }

;- Maps
map = { $
    imdata : A[cc].map[*,*,z_start], $
    title : A[cc].name + ' 5.6 mHz (' + time[zz] + '-' + time[zz+dz-1] + ' UT)', $
    file : 'aia' + A[cc].channel + 'big_map' }


;- Call image_powermaps with name of struc you want to image.
im = IMAGE_POWERMAPS( <struc_name>, rgb_table = A[cc].ct )




end
