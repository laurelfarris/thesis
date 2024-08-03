;+
;- 27 October 2020
;-   original filename was 2020-09-.pro (incomplete?).. not sure why.
;-   Comment below says 09-08, so probably safe to modify filename accordingly.
;-




;- 08 September 2020


flare_path = [ '../20131228/', '../20140418/', '../20110215/' ]
format = '(e0.2)'


print, '---------'
foreach path, flare_path, ii do begin
    restore, path + 'aia1600map.sav'
    aia1600power = total(total(map,1),1)

;    print, where( aia1600power eq max(aia1600power) )
;    print, where( aia1600power eq min(aia1600power) )
    print, min(aia1600power), format=format
    print, max(aia1600power), format=format
    dp = max(aia1600power) - min(aia1600power)
    print, dp, format=format

    print, '---------'

endforeach



end
