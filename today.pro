;+
;- 15 May 2020
;-
;- Define three separate array structures
;-  i.e. A, B, C (or something else)
;-  Lots of code written to access "A[cc].whatever"...
;-



;+
;- ML code in struc_aia.pro:
;-

aia1600 = STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' )
aia1700 = STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' )


A = [ aia1600, aia1700 ]
undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data
A[0].color = 'blue'
A[1].color = 'red'



end
