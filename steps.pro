;-
;- 5/18/2020
;- huge waste of time...


dates = [ '3/04','4/16','4/20','5/04','5/08','5/14','5/17' ]

steps_i = [ 13086,  5265,  1714,   928,   927,  1057,  2162 ]
steps_f = [ 17488, 10031,  6808,  5988,  6729,  6143,  7162 ]

steps_in_5k = steps_f - steps_i

print, mean(steps_in_5k)


end
