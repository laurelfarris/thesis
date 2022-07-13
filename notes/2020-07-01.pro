;+
;oo  01-02 July 2020
;oo 
;oo





@parameters
;- .RUN struc_aia
cc = 1
dz = 64
;
print, A[cc].channel
;
restore, '../' + year + month + day + '/aia' + A[cc].channel + 'map_SHORT.sav'
help, map
;
sz = size(A[cc].data, /dimensions)
;
undefine, map


;oo  Test to see if setting kw changes original variable
color=['blue','red']
print, color
plt = plot( [1,2,3], [4,5,6], color=color[0], buffer=1)
print, color
;oo    (it does not -- 'color' is still ['blue','red'], not ['blue'] ).


;oo---------------------------------------------------------------------------
;oo  01 July 2020:
;oo    Compute AIA 1700 power maps for C3.0 flare. Save to file at intervals.
;oo    NOTE: struc_aia returns data and other structure values in 'A', but this
;oo      is one case (of many) where only one channel is needed: 1700...
;oo      Half of 'A' is a waste of memory. Need a better way to read in
;oo      only what I need...

map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, $
    z_start=z_start[0:99] )
help, map
save, map, filename='map1.sav'

undefine, map

z_start=[  0: 99]
z_start=[100:199]
z_start=[200:299]
z_start=[300:399]
z_start=[400:499]
z_start=[500:599]
map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, $



for zz = 0, 500, 100 do print, zz

for zz = 0, 500, 100 do begin
    z_start = [zz:zz+99]
    print, min(z_start), max(z_start)
    ;   ... aka z_start[0] and z_start[-1]
    map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=z_start )
    save, map, filename = 'map'
endfor


;oo  A better way... Ignore everything above.

z_start = [0, 100, 200, 300, 400, 500]

foreach zz, z_start, ii do begin
    print, ii, zz
    map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=[zz:zz+99] )
        ;oo  02 July 2020
        ;oo   Probably faster to pass a small subset of A.data each loop iteration
        ;oo   instead of the entire data cube when don't need most of it.
    filename = 'map' + strtrim(ii,1) + '.sav'
    print, filename
    save, map, filename=filename
    undefine, map
endforeach



;oo --  02 July 2020

z_start = [600:sz[2]-dz+1]
    ;oo  "Illegal subscript range..." Good thing I put a test code in
    ;oo    compute_powermaps.pro to make sure z_start is IN range before
    ;oo    wasting time computing the power map.  :)

z_start = [600:sz[2]-dz]

;oo  compute final bit of power map:
map = COMPUTE_POWERMAPS( A[cc].data, A[cc].cadence, dz=dz, z_start=z_start )
help, map

;oo  save final map to file
filename='map' + strtrim(ii,1) + '.sav'
print, filename

save, map, filename=filename


;oo  restore all maps, combine into one cube, and save final variable to file:

fls = file_search( "./map*.sav" )
print, fls

finalmap = []
foreach savefile, fls, ii do begin
    ;restore, 'map' + strtrim(ii,1) + '.sav'
    print, savefile
    restore, savefile
    finalmap = [ [[finalmap]], [[map]] ]
    undefine, map
endforeach




savename = 'aia' + A[cc].channel + 'map.sav' 
print, savename

map = finalmap
undefine, finalmap

save, map, filename=savename

end
