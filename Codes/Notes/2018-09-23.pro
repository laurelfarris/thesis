

; 23 September 2018

goto, start

fmin = 0.005
fmax = 0.006

dz = 64

;- centering time segment around C-flare
z = [75]

;- AIA 1600 only for now...
cc = 0

; Checking if flux and data are corrected for exposure time already.
;print, max(A[cc].flux)
;test = total( total( A[cc].data, 1 ), 1 )
;print, max(test)
;print, (max(test))/A[cc].exptime
; Flux was, but data cube was not.

;- Correcting for exposure time before calculating maps
;cube = (A[cc].data)/A[cc].exptime
;   Changed this in prep.pro, so not needed here anymore.
; also no need to duplicate A[cc].data as 'cube'

A[cc].data = A[cc].data > 0
print, min(A[cc].data)

map = POWER_MAPS( $
    ;cube, $
    A[cc].data, $
    A[cc].cadence, $
    [fmin,fmax], $
    z=z, $
    dz=dz, $
    norm=0 )

dw

wave = fix(A[cc].channel)

im_data = AIA_INTSCALE( map, wave=wave, exptime=A[cc].exptime )
im = image2( im_data, layout=[1,1,1], margin=0.1, rgb_table=A[cc].ct )

im_z = [80,90,100]
im_data = AIA_INTSCALE( A[cc].data[*,*,im_z], wave=1600, exptime=A[cc].exptime )

if 0 gt 1 then begin
for i = 0, 2 do begin
    im = image2( $
        im_data[*,*,i], $
        layout=[1,1,1], $
        margin=0.1, $
        rgb_table=A[cc].ct )
endfor
endif


;im_data = mean( A[cc].data[*,*,z:z+dz-1], dimension=3 )

dat = (product( A[cc].data[*,*,z:z+dz-1], 3 ))^(1./dz)

im_data = AIA_INTSCALE( $
    dat, wave=wave, exptime=A[cc].exptime )

im = image2( $
    im_data, $
    layout=[1,1,1], $
    margin=0.1, $
    rgb_table=A[cc].ct )


start:;-------------------------------------------------------------------

fmin = 0.005
fmax = 0.006
dz = 64
z = [0:749-dz+1]


for cc = 0, 1 do begin

    file = 'aia' + A[cc].channel + 'map_2.sav'
    print, file

    map = POWER_MAPS( $
        ;cube, $
        A[cc].data, $
        A[cc].cadence, $
        [fmin,fmax], $
        z=z, $
        dz=dz, $
        norm=0 )

    save, map, file=file

endfor

end
