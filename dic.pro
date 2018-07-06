

pro dic
    ; procedure goes here.

end

result = dictionary( 'name', 'AIA 1600$\AA$', 'cadence', 24 )

print, result['name']
print, result.name

;print, result.Count()
;result.IsFoldCase()
;result.Keys()
;print, result.HasKey('namee')

;result.Remove, 'cadence'
;print, result.Remove( 'cadence' )
;print, result.Remove( 'name' )

end
