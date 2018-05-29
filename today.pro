;; Last modified:   23 May 2018 23:00:49




pro test_tags
    ;; Wanted to record which tags were changed, and how
    path = '/solarstorm/laurel07/Data/AIA/'
    channel = '1600'
    files = '*aia*' + channel + '*2011-02-15*.fits'
    fls = (file_search( path + files ))[0]
    read_sdo, fls, oldindex, olddata
    aia_prep, oldindex, olddata, newindex, newdata
    oldtags = tag_names(oldindex)
    newtags = tag_names(newindex)
    print, where( oldtags ne newtags )
    for i = 0, 186 do begin
        if (oldindex.(i) ne newindex.(i)) then $
            print, i, '  ', (tag_names(oldindex))[i], $
                oldindex.(i), newindex.(i)
    endfor
    for i = 189, n_tags(oldindex)-1 do begin
        if (oldindex.(i) ne newindex.(i)) then $
            print, i, '  ', (tag_names(oldindex))[i], $
                oldindex.(i), newindex.(i)
    endfor
end


;pro test_struc_input, index=index
function test_struc_input, index
    print, n_elements(index)
    return, 0
    ;ML:
    ;test = test_struc_input( index[0] )
end

goto, start



; 23,26 May 2018
dz = 64
z = [0,64,128]
map = power_maps( aia1600.before, z=z, dz=dz, cadence=24 )
im = image_powermaps( map, layout=[3,1], rgb_table=aia1600.ct)
hmi = prep_hmi( index=index )

aia1600 = create_struct( aia1600, 'exptime', aia1600index.exptime )
aia1700 = create_struct( aia1700, 'exptime', aia1700index.exptime )
hmi = create_struct( aia1700, 'exptime', index.exptime )

A = [ aia1600, aia1700, hmi ]

xdata = indgen(748)
p = objarr(3)
for i = 0, 2 do begin
    ydata = A[i].flux/A[i].exptime
    p[i] = plot3( xdata, A[i].flux )
endfor




; 26 May 2018
; Looking for best center coords for hmi continuum data.
dw
print, x2 - ((x2-x1)/2)
print, y2 - ((y2-y1)/2)
x1 = 2115
y1 = 1500
x1 = x1 + 80
y1 = y1 + 60
;x2 = 2615
;y2 = 1830
x2 = x1 + 500 - 150
y2 = y1 + 330 - 130
im = image2( hmi.data[x1:x2,y1:y2, 0] )
stop

;x0 = 2370
x0 = 2365
;x0 = x0 + 70
y0 = 1660
hmi_cropped = crop_data( hmi.data[*,*,0], center=[x0,y0] )
im = image2( hmi_cropped[*,*,0] )
stop

; attempting to update structures with a loop
; Probably can't update array until all structures have been updated,
; otherwise arrays within structures won't match

test = { tag : 1, tag2 : 'value' }
test2 = { tag : 2, tag2 : 'blah' }

test_arr = [ test, test2 ]

for i = 0, 1 do begin

    struc = test_arr[i]
    struc = create_struct( struc, 'tag3', 'meh' )
    test_arr[i] = struc

endfor

;test_arr = [ test, test2 ]





; does AIA have cadence tag?? hmi does...
test = []
N = n_tags(aia1600index[0])
ind = [] 
for i = 0, N-1 do begin
    value = aia1600index[0].(i)
    ;if typename(value) eq 'DOUBLE' then test = [test, value ]
    if typename(value) eq 'LONG' then begin
        test = [test, value ]
        ind = [ind, i]
    endif
endfor
test = fix(test)
print, where( test eq 24 )
; waste of time...

test = get_jd( index.date_obs + 'Z' )



im = image( cube[*,*,0]^0.5 )
im = image( cube[*,*,-1]^0.5 )



; plot test
x = findgen(10) + 1
y = x^2
p = plot2(x,y)
x = 1./x
p = plot2(x,y)

stop

START:;--------------------------------------------------------------------

time = strmid(aia1600.time,0,5)
i1 = (where( time eq '01:30' ))[0]
i2 = (where( time eq '02:30' ))[0]

flux = aia1600.flux[i1:i2]


;for i = 0, 4 do begin
;    help, flux
;    flux = [ flux, flux ]
;endfor
; well that didn't work

; oversampling
;flux = [ flux, fltarr(100) ]

f_min = 1./400
f_max = 1./50

result = fourier2( flux, 24, /norm )
frequency = reform(result[0,*])
power = reform(result[1,*])

stop


ind = where(frequency ge f_min AND frequency le f_max)
frequency = frequency[ind]
power = power[ind]
period = 1./frequency

;p = plot_ft( 1000.*frequency, power )

resolve_routine, 'plot_ft', /is_function
p = plot_ft( period, power )

stop

sdbwave, flux


end
