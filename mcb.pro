;Copied from clipboard


;-
;- SHIFT Y-data (correct offset between dY spanned by 1600 vs 1700:
resolve_routine, 'shift_ydata', /either
SHIFT_YDATA, plt
;
print, plt[0].yrange, format=format
print, plt[1].yrange, format=format
;
stop

end

