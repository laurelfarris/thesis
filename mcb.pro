;Copied from clipboard


; 07 September 2021 - use jd instead of integers
loc1 = (where( A[0].jd ge rhessi_xdata[0,0] ))[0]
loc2 = (where( A[0].jd le rhessi_xdata[-1,0] ))[-1]
aia1600ind = [loc1:loc2]

end

