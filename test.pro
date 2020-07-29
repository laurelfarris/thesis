;-
;- 21 July 2020
;-


function MYTEST, arg1, arg2, kw1=kw1, kw2=kw2


    print, n_params()
    ;-
    ;- = number of ARGUMENTS supplied by user when calling this function.
    ;-   (kws do not appear to be included, whether passed to function or not).
    ;-

    return, 0

end


result = mytest( [2,3,4], kw1=2, kw2='blah')


end
