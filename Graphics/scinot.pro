

;- 13 December 2018

;- Purpose:
;-  Format yticklabels in scientific notation ( 1.0 \times 10^{n} )

;- Problems:
;-  Rounding and setting the rounded values as ytickname
;-  causes the numerical values to be unevenly spaced.
;-  May have to manual set the desired tickvalues first.

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


ytest = [ 2.987e3, 1.98423e5, 9.83746e7]
xtest = indgen(n_elements(ytest))
ytickname = SCINOT(ytest)

p = plot2( xtest, ytest, ytickname=ytickname )

end
