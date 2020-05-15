;+
;- 14 May 2020
;-
;-
;-
;-

;READ_MY_FITS, index, data, fls, instr='aia', channel=1600, ind=[0:9], prepped=1

help, index[0]
;help, data

print, n_tags(index[0])


mem = MEMORY()
help, mem


print, memory()
print, memory(/current)
print, memory(/highwater)
print, memory(/num_alloc)
print, memory(/num_free)


help, /memory

help, /files

print, memory(/structure)





end
