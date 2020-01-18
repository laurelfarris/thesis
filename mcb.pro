;Copied from clipboard


@parameters
ind = [(where(time eq my_start))[0],(where(time eq my_end))[0]] ;X2.2
print, ind
print, time[ind]

end

