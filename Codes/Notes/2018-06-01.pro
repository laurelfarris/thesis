

goto, start



; 01 June 2018


A[0].flux = total(total(A[0].data,1),1)


mapsum = total( total( map, 1), 1)
sz = size(map, /dimensions)

dz = 42
fluxsum = fltarr(sz[2])
fmin = 0.0048
fmax = 0.0060

result = fourier2( indgen(dz), 24 )
frequency = reform(result[0,*])
bandwidth = where(frequency ge fmin and frequency le fmax) 

for i = 0, 200 do begin
    result = fourier2( A[0].flux[i:i+dz-1], 24, /norm )
    power = reform(result[1,*])
    fluxsum[i] = mean(power[bandwidth])
endfor


test = { $
    t1: { data:fluxsum, title:'AIA 1600 3m power from intgrated flux' }, $
    t2: { data:mapsum, title:'AIA 1600 3m power from spatially resolved maps'} $
}


for i = 0, 1 do begin
    p = plot2( test.(i).data, title=test.(i).title )
    endfor
end
