;+
;- 03 June 2021
;-
;- TO DO:
;-  [] Lightcurves for all flares! (one at a time... deal with multiflare structures later)
;-  [] interpolate missing 1700 images, save final cube + index (prob not shifts)
;-  [] ==>> see ML code in ./Lightcurves/plot_lc.pro
;-
;-
;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00
;-
;-
;-
;-





buffer = 1
@par2


;-
;flare = multiflare.C83
;flare = multiflare.M10
flare = multiflare.M15
;flare = multiflare.X22
;-


help, flare



instr = 'aia'
channel = 1600
;channel = 1700
;
class = 'm15'
date = flare.year + flare.month + flare.day
print, date

path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;
print, file_exist(path+filename)

restore, path + filename

flux = total(total(cube,1),1)
help, flux

plt = plot2 ( flux, buffer=buffer )

save2, "m15_lightcurve", /timestamp, idl_code="today.pro"


end
