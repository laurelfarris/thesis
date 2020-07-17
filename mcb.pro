;Copied from clipboard


print, (max( aia1600maps[*,*,1])) / (max( mask[*,*,1,0] * aia1600maps[*,*,1] ))
print, (max( aia1600maps[*,*,4])) / (max( mask[*,*,4,0] * aia1600maps[*,*,4] ))
print, (max( aia1600maps[*,*,7])) / (max( mask[*,*,7,0] * aia1600maps[*,*,7] ))

end

