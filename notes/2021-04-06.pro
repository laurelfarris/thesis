;+
;- 06 April 2021
;-


;+
;- TO DO:
;-  [] SCIENCE!!!  ==>>  compute powermaps
;-  [] interpolate to fill in missing 1700 images, save final cube + index (prob not shifts)
;-  [] Clean up code, write module, move to ./Align/ with GOOD DOCUMENTATION!
;-         ==>>  comments, update README, etc. ...
;-

buffer = 1
@par2

;- C8.3 2013-08-30 T~02:04:00
;- M1.0 2014-11-07 T~10:13:00
;- M1.5 2013-08-12 T~10:21:00

;-
;flare = multiflare.C83
flare = multiflare.M10
;flare = multiflare.M15
;-

;
instr = 'aia'
channel = 1600
;channel = 1700
;
date = flare.year + flare.month + flare.day
print, date
;
class = strsplit(flare.class, '.', /extract)
class = strlowcase(class[0] + class[1])
print, class
;
path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
;filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, file_exist(path + filename)
;

restore, path + filename


;+
;- Powermaps

cadence = 24

mapfilename = class + '_' + instr + strtrim(channel,1) + '_map.sav'
print, mapfilename
;
;

mapsyntax = COMPUTE_POWERMAPS( /syntax )

sz = size( cube, /dimensions )

dz = 64


z_start = indgen(sz[2]-dz+1)
help, z_start
print, z_start[-1]
print, z_start[-1]+dz-1
;-
;- NOTE: shouldn't have to figure out how to set up z_start every time... +1? -1? Neither?
;-  [] Modify compute_powermaps to handle that, user can set simple kw to either compute 3D map by
;-     stepping through each image zz, or specify interval, or set kw to compute one 2D map over entire
;-     z-range of input cube, or w/e. ==>> MAKE THIS EASY!
;-     (Also added this to Todoist in case I never look at this comment again...)
;-



;-
resolve_routine, 'compute_powermaps', /is_function
map = COMPUTE_POWERMAPS( cube, cadence, z_start=z_start, dz=dz )
;
save, index, map, filename=mapfilename
;- finished by __:__ on 06 April 2021





end
