;; Last modified:   10 April 2018 21:21:38


goto, start

resolve_routine, 'read_my_fits', /either
read_my_fits, '304', index=aia304index, data=aia304data


temp = aia304data[*,*,0]

im = image2( temp^0.5, dimensions=[1000,1000] )

xstepper2, aia304data^0.5


aia304data = aia304data[2150:2650,1485:1815,0:435]
im = image2( temp^0.5, dimensions=[1000,660] )




p = plot2( aia304flux )


aia304 = PREP( '304' )
; This didn't work because there's no aligned .sav file to read in.






aia304 = { $
    name : 'AIA 304$\AA$', $
    data : aia304data, $
    cadence : 12.0, $
    jd : fltarr(436), $
    time : strarr(436), $
    flux : aia304flux, $
    flux_norm : aia304flux_norm, $
    color : '' $
}




aia304flux = total( total( aia304data, 1 ), 1 )
temp = aia304flux
temp = temp - min(temp)
temp = temp/max(temp)

start:;----------------------------------------------------------------------


aia304flux_norm = aia304flux - min(aia304flux)
aia304flux_norm = aia304flux_norm / max(aia304flux_norm)

y = aia304flux_norm
p = plot2( y )





end
