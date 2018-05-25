;; Last modified:   24 April 2018 16:19:09



; See Notes from February 15 and April 20.



pro hist



    dat = [2,2,3,3,3,5,9]
    dat = dat/10.

    binsize = 0.1

    result = histogram( dat, binsize=binsize )
    print, result

end


hist

end
