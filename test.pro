;; Last modified:   15 February 2018 10:37:11




pro getJD_test, index
    getJD, index=index, test
    test = test - shift(test,1)
    print, test[10]
    format = '(F30.15)'
    print, test[10], format=format
    test2 = float(test)
    print, test2[10], format=format
    help, test2
end


pro fourier2_test
    ; 224, 225 --> 374, 375
    y = S.(0).flux
    ; 150 images
    ;y = y[225:374]
    ; 151 images
    ;y = y[224:374]
    ;y = y[225:375]
    ; 152 images
    ;y = y[224:375]
    y = y[225:452]
    df = 0.184973
    result = fourier2( y, 24, /norm  )
    frequency = 1000.*(reform(result[0,*]))
    power = reform(result[1,*])
    df2 = (frequency-shift(frequency,1))[1]
    print, df2
    ;if df2 lt df then print, "yay"
    period = 1./frequency
    period = reverse(period,1)
    power = reverse(power)
    T = 180.0
    dt = 15.0
    ind = where( period ge T-dt AND period le T+dt )
    ;print, period[ind]
    ;print, power[ind]
    ;print, strmid(a6index[224].t_obs, 11, 5)
    ;print, strmid(a6index[375].t_obs, 11, 5)
    ;print, (frequency-shift(frequency,1))[5]
end





pro mypro, var
   var = var * 10 
   print, var
end

A = findgen(6)

x = 5
for i = 0, 5 do begin
    mypro, A[i]
endfor


end
