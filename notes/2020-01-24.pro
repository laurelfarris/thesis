;- 19 January 2020


yy = A[0].flux

;- compare plots of:
;- log(y), y^{-1}, 1/y, sqrt(y)


;- ^-1 --> inverse, plot is basically upside down

dw
plt = plot2( sqrt(yy) )  
plt2 = plot2( yy^0.1 , $
    overplot=0, $
    color='blue')

;-----------------------------------------------

;- Can probably delete everything above



format = '(e0.6)'

;- Min/Max of flux
for cc = 0, 1 do $
    print, max(A[cc].flux), format=format

;- Exptime-corrected flux
for cc = 0, 1 do $
    print, max(A[cc].flux/A[cc].exptime), format=format


;- Flux per pixel
for cc = 0, 1 do $
    print, max(A[cc].flux) / (500.*330.), format=format

for cc = 0, 1 do $
    print, max(A[cc].flux/A[cc].exptime) / (500.*330.), format=format



;-----------------------------------------------

@restore_maps

cc = 0
ii=280
im = image2( A[cc].map[*,*,ii] )


cadence = 24
dz = 64
;ii = 0
ii = 252
cc = 0
data = A[cc].data[*,*,ii:ii+(dz-1)]
map1 = compute_powermaps( data, cadence, norm=0 )
map2 = compute_powermaps( data/A[cc].exptime, cadence, norm=0 )

format='(e0.9)'
print, min(map1), format=format
print, max(map1), format=format
;print, max(map1)/min(map1), format=format
;print, max(map1)-min(map1), format=format
;print, min(map2), format=format
;print, max(map2), format=format
print, max(map2)/min(map2), format=format
;print, max(map2)-min(map2), format=format


print, A[cc].time[ii]



@parameters
path = '/solarstorm/laurel07/' + year+month+day + '/'

;restore, path + 'aia1600map.sav'
restore, path + 'aia1600map_2.sav'

print, max(map)
print, min(map)

ii=253
cc=0
imdata = map[*,*,ii]
dw
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )


print, max(aia1600map[*,*,ii])
print, max(map1)
print, max(map2)






aia1600map = map

;restore, path + 'aia1700map.sav'
restore, path + 'aia1700map_2.sav'
print, max(map)
aia1700map = map
;undefine, map


print, max(aia1600map)
print, max(aia1700map)

print, min(aia1600map)
print, min(aia1700map)

print, min(A[cc].map[*,*,ii]), format=format
print, max(A[cc].map[*,*,ii]), format=format


;------------------------------------------------------
;- 23 January 2020

;- arrow test (general)
dw
xdata = findgen(10)
ydata = xdata^2
plt = plot2(xdata,ydata) 
xx = [2,5]
yy = [2,25]
myarrow = ARROW(xx,yy,/data, $
    line_thick = 5, $
    color='magenta')
myarrow.color = 'blue'
myarrow.line_thick = 3
myarrow.fill_color = 'orange'
myarrow.thick = 5.0



;- test arrow on power map

dw
ii=253
cc=0
imdata = A[0].map[*,*,ii]

xx = [[358,375], [143,183]]
yy = [[168,185], [128,168]]

dw
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )

myarrow.delete
myarrow = ARROW( xx, yy, /data , $
    color=['yellow', 'magenta'], $
    thick=[1.8,2.2], $
    head_size=1.0, $
    head_angle=30, $
    head_indent=0.0 )


myarrow = objarr(2)
color=['yellow', 'magenta']
thick=[1.8,2.2]
head_size=[1.0,0.2]
head_angle=[30, 60]
head_indent=[0.0, 0.0]
for jj = 0, n_elements(myarrow)-1 do begin
    myarrow[jj] = arrow( xx[*,jj], yy[*,jj], /data, $
        color=color[jj], $
        thick=thick[jj], $
        head_size=head_size[jj], $
        head_angle=head_angle[jj], $
        head_indent=head_indent[jj] $
    )
endfor
help, myarrow

myarrow.color=['black', 'blue']
;myarrow.arrow_style=4
myarrow.head_angle=60
myarrow.thick=2
myarrow.color='yellow'






;------------------------------------------------------
;- 23 January 2020



restore, path + 'aia1600map.sav'
satmap = map
restore, path + 'aia1600map_2.sav'
help, satmap
help, map

minloc = where(A[0].flux eq min(A[0].flux))
print, minloc
;-  664
print, A[0].time[minloc]
;-  04:26:17.12


print, max(satmap[*,*,minloc])
print, max(map[*,*,minloc])


print, where( max(A[0].flux) le 15000 )
print, where( (A[0].flux/(500.*330)) le 15000 )


maxflux = fltarr(749)
for ii = 0, 748 do begin
    maxflux[ii] = max( A[0].data[*,*,ii] )
endfor
print, min(maxflux) ;-  2955.66
print, max(maxflux) ;- 16754.1


print,  where(maxflux eq min(maxflux))

loc =   where(maxflux eq min(maxflux))
print, max(satmap[*,*,loc])
print, max(map[*,*,loc])



ii=loc
cc=0
imdata = map[*,*,ii]
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )
imdata = satmap[*,*,ii]
im = image2( $
    alog10(imdata), $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )


imdata = A[0].data[*,*,ii]
im = image2( $
    imdata, $
    rgb_table = AIA_COLORS( wave=fix(A[cc].channel) ) )





dz = 64
maxflux = fltarr(749-dz+1)
for ii = 0, 748 do begin
    maxflux[ii] = max( A[cc].data[*,*,ii:ii+dz-1] )
endfor
print, min(maxflux) ;-
print, max(maxflux) ;-




end
