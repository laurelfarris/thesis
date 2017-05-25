'''
Read in lightcurve data from file and plot it, along with its FT.
'''
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import math
import pdb

import matplotlib
matplotlib.rc('font',**{'family':'serif','serif':['Times']})
matplotlib.rc('text', usetex=True)

fig = plt.figure()
tot = 2

f = open('bp1_lc_size.dat')
cad,num,intensity = np.loadtxt(f, unpack=True)

time = (cad*12.)/60.

x = [time]
y = [intensity, intensity/num]

xtitle = 'time [minutes]'
ytitle = ['intensity','intensity per pixel']

for i in range(0,tot):
    ax = fig.add_subplot(tot,1,i+1)
    ax.set_xlabel(xtitle)
    ax.set_ylabel(ytitle[i])
    ax.tick_params(axis='both',labelsize='small')
    #ax.yaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
    ax.plot(time, y[i])

plt.show()

ax2 = fig.add_j
trans = np.fft.fft(intensity)

