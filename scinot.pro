
;- Scientific notation

function SCINOT, tickvalues

    new = strarr(n_elements(tickvalues))

    format = '(F0.1)'
    foreach xx, tickvalues, ii do begin
        b = floor(alog10(abs(xx)))
        a = xx * 10.^(-b)

        ;print, (float(round(a*10)))/10., format=format
        a2 = (float(round(a*10)))/10.

        ;print, strmid(strtrim(a2,1),0,3)
        new[ii] = strmid(strtrim(a2,1),0,3) + '!Z(d7)10!U' + strtrim(b,1)
    endforeach
    return, new
end

;tickname = plt[0].ytickname
;tickvalues = plt[0].ytickvalues

;print, tickvalues
;print, tickname


testvalues = [ 2.987e3, 1.98423e5, 9.83746e7]
test = scinot(testvalues)
;print, test
end
