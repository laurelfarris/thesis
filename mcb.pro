;Copied from clipboard


z0 = 0
z_ind_1 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tstart ))[0]
z_ind_2 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tpeak ))[0]
z_ind_3 = (where( strmid( index.date_obs, 11, 5 ) eq m10.tend ))[0]
z_ind_4 = -1

end

