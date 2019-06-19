

cad = 24
nn = 64
;nn = 120
;nn = 500
tt = cad * nn
df = 1000./tt


result = fourier2( indgen(nn), cad )
freq = result[0,*]

print, ""

print, "dz =", nn

print, "# returned frequencies:", n_elements(freq)
print, "frequency resolution (mHz):", df

print, "min freq =", 1000.*min(freq)
print, "max freq =", 1000.*max(freq)

end
