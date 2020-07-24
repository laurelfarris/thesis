;+
;- 21 July 2020
;-



restore, 'multiflare_struc.sav'


help, multiflare_struc.(0)

help, multiflare_struc.s2.date

print, multiflare_struc.s2.channel
;- -->  1600  1700
;- Seems to work!!!
;-


;-
;-  []  rename variable "multiflare_struc" to something easeir
;-      to type repeatedly...


;---------------



help, A.map

buffer=1
;
cc = 0
;



time = strmid(A[cc].time,0,5)
z1 = (where( time eq '01:00' ))[0]
z1 = (where( time eq '01:00' ))[0]
;z1 = (where( time eq '01:05' ))[0]
z2 = (where( time eq '01:20' ))[0]
;


;start_times = ['00:00', '00:30', '01:00', '01:30', '02:00', '02:30' ]
;zind = (where( time eq start_times ));[0]
;zind = (where( time eq start_times[0] OR time eq start_times[1] ))[0]
;print, time[z1]
;print, time[z2]


;zind = [ $ ]

zind = [z1, z2]

;
;- test
foreach zz, zind, ii do begin
    print, strtrim(ii,1)
    print, zz
    print, time[zz]
endforeach

;zind = [0, 74, 149, 224, 299, 374, 449]

;--------------------------------


zind = [0:200:10]
;print, zind
print, time[zind]


wx = 8.0
wy = 8.0
dw
foreach zz, zind, ii do begin
    imdata = alog10(A[cc].map[*,*,zz])
    ;help, imdata
    ;
    win = window( dimensions=[wx,wy]*dpi, buffer=buffer)
    ;
    im = IMAGE2( $
        imdata, $
        /current, $
        margin=0, $ 
        layout=[1,1,1], $
        rgb_table=A[cc].ct, $
        title=A[cc].time[zz], $
        buffer=buffer $
    )
    ;
    save2, 'map' + strtrim(ii,1)
    ;
endforeach


end
