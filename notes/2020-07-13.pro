;+
;- 13 July 2020
;-
;-
;-
;- Make "A" structures active for all 3 flares simultaneously.
;-

XX = A
undefine, A

MM = A
undefine, A

CC = A
undefine, A

;- save to make process much easier in future; simply restore one (or all)
;-   of the following .sav files!

save, XX, MM, CC, filename="multiflare_structures.sav"

save, XX, filename="multiflare_structures_X22.sav"
save, MM, filename="multiflare_structures_M73.sav"
save, CC, filename="multiflare_structures_C30.sav"

restore, "multiflare_structures.sav"

;- check that each flare was read into the proper variable
print, CC.date
print, MM.date
print, XX.date

;- delete first file with all 3 variables saved
;-   (probably is a better way to do this, but this is def. an improvement
;-    over editing parameters, then running struc_aia, then restore_maps,
;-    then finally creating new variables or plotting or whatever, then
;-    replacing variables with different flare only to find I screwed up the
;-    first one and have to repeat the entire process all over again.
;- If something in struc_aia.pro needs to change, then will need to re-run for
;-  each flare and save the variables/structures to whatever.sav again, but
;-  not every single idl session :)
;-


;- To do :
;-   [] remove data and map tags and save those elsewhere.
;-      save "headers" in idl .sav file, don't have to run struc_aia every time!

;=============================================================================


;- 17:35  exit, re-start sswidl

;- restore all three flare structures
restore, 'multiflare_structures_X22.sav'
restore, 'multiflare_structures_M73.sav'
restore, 'multiflare_structures_C30.sav'

ccc = cc
undefine, cc
mmm = mm
undefine, mm
xxx = xx
undefine, xx

;- 
;- 

cc = 0
;cc = 1
;
@parameters
dz = 64

;- Derive BDA z_start values (from 2020-06-19)
time = strmid( CCC[cc].time, 0, 5 )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind = [z1, z2, z3]
print, zind


c30_1600_before = CCC[0].map[*,*,z1]
c30_1600_during = CCC[0].map[*,*,z2]
c30_1600_after  = CCC[0].map[*,*,z3]
;
c30_1700_before = CCC[1].map[*,*,z1]
c30_1700_during = CCC[1].map[*,*,z2]
c30_1700_after  = CCC[1].map[*,*,z3]


m73_1600_before = MMM[0].map[*,*,z1]
m73_1600_during = MMM[0].map[*,*,z2]
m73_1600_after  = MMM[0].map[*,*,z3]
;
m73_1700_before = MMM[1].map[*,*,z1]
m73_1700_during = MMM[1].map[*,*,z2]
m73_1700_after  = MMM[1].map[*,*,z3]


x22_1600_before = XXX[0].map[*,*,z1]
x22_1600_during = XXX[0].map[*,*,z2]
x22_1600_after  = XXX[0].map[*,*,z3]
;
x22_1700_before = XXX[1].map[*,*,z1]
x22_1700_during = XXX[1].map[*,*,z2]
x22_1700_after  = XXX[1].map[*,*,z3]





format = '(e0.5)'

print, min(CCC.map)
print, min(MMM.map)
print, min(XXX.map)

print, max(c30_1600_during), format=format
print, max(m73_1600_during), format=format
print, max(x22_1600_during), format=format


aia1600maps = [ $
    [[ c30_1600_before ]], $
    [[ c30_1600_during ]], $
    [[ c30_1600_after ]], $
    [[ m73_1600_before ]], $
    [[ m73_1600_during ]], $
    [[ m73_1600_after ]], $
    [[ x22_1600_before ]], $
    [[ x22_1600_during ]], $
    [[ x22_1600_after ]] $
]
help, aia1600maps

aia1700maps = [ $
    [[ c30_1700_before ]], $
    [[ c30_1700_during ]], $
    [[ c30_1700_after ]], $
    [[ m73_1700_before ]], $
    [[ m73_1700_during ]], $
    [[ m73_1700_after ]], $
    [[ x22_1700_before ]], $
    [[ x22_1700_during ]], $
    [[ x22_1700_after ]] $
]
help, aia1700maps


print, max(aia1600maps), format=format
print, max(aia1700maps), format=format
;
print, min(aia1600maps), format=format
print, min(aia1700maps), format=format

save, aia1600maps, aia1700maps, filename='BDAmaps.sav'

;----------------------------------------------------------------------
;-
;- 19:43
;- IDL> .reset_session
;-


restore, 'BDAmaps.sav'


restore, 'multiflare_structures_X22.sav'
restore, 'multiflare_structures_M73.sav'
restore, 'multiflare_structures_C30.sav'


;- success!!!


;- re-save with variables that I don't already use often:
;-   -->  CC was overwritten by cc=0|1 ...
ccc = cc
undefine, cc
mmm = mm
undefine, mm
xxx = xx
undefine, xx

save, CCC, filename='multiflare_structures_C30.sav'
save, MMM, filename='multiflare_structures_M73.sav'
save, XXX, filename='multiflare_structures_X22.sav'
;-  NOTE: this overwrites existing .sav files without confirmation or warning!!


;+
;- Derive BDA z_start values (from 2020-06-19)
;-

cc = 0
dz = 64

;- C3.0 flare
@parameters
time = strmid( CCC[cc].time, 0, 5 )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind_C30 = [z1, z2, z3]
;
print, zind_C30
print, CCC[cc].time[zind_C30]


;- M7.3 flare
@parameters
time = strmid( MMM[cc].time, 0, 5 )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind_M73 = [z1, z2, z3]
;
print, zind_M73
print, MMM[cc].time[zind_M73]


;- X2.2 flare
@parameters
time = strmid( XXX[cc].time, 0, 5 )
z2 = (where( time eq strmid(gstart,0,5) ))[0]
z1 = z2 - dz
z3 = z2 + dz
zind_X22 = [z1, z2, z3]
;
print, zind_X22
print, XXX[cc].time[zind_X22]

undefine, zind


bda_zind = [ [zind_C30], [zind_M73], [zind_X22] ]
print, bda_zind

print, time[bda_zind]

bda_time = time[bda_zind]



save, aia1600maps, aia1700maps, bda_zind, bda_time, filename='BDAmaps.sav'
;-  Again no warning about overwriting existing file...




end
