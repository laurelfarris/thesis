;- Fri Dec 14 04:39:25 MST 2018



function stats, data, display=display



    struc = { $
        min : min(data), $
        max : max(data), $
        mean : (moment(data))[0], $
        ;variance : (moment(data))[1], $
        variance : variance(data), $
        ;stddev : sqrt( (moment(data))[1] ), $
        stddev : stddev(data), $
        abs : mean( abs(data) ) $
    }


    if keyword_set(display) then begin
        format = '(e0.2)'
        print, format='( "min = ", e0.2)', struc.min
        print, format='( "max = ", e0.2)', struc.max
;        print, struc.min, format=format
;        print, 'max = '
;        print, struc.max, format=format

;- Get errors here because format syntax is wrong... needs to be in same
;-  set of strings as 'MIN: ', etc. for some reason. One of the less intuitive
;-  IDL syntax...
;        print, 'MIN: ', struc.min, format=format
;        print, 'MAX: ', struc.max, format=format
;        print, 'MEAN: ', struc.mean, format=format
;        print, 'VARIANCE: ', struc.variance, format=format
;        print, 'STDDEV: ', struc.stddev, format=format
;        print, 'ABS: ', struc.abs, format=format
    endif

    return, struc




end

test = stats(H[0].data[*,*,0])
help, test


end
