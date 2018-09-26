

fls = file_search( 'Modules/*.pro' )
print, fls

foreach subroutine, fls do begin

    resolve_routine, subroutine

endforeach


end
