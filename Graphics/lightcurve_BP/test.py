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

fig = plt.figure(figsize=(20,10))
f = open('bp1_lc_size.dat')
cad,num,intensity = np.loadtxt(f, unpack=True)
time = (cad*12.)/60.


fontsize=30
''' light/size curves '''
ax = fig.add_subplot(111)
ax.plot(time,intensity/num,'b')
ax.set_xlabel('time [minutes]',fontsize=fontsize)
ax.set_ylabel('intensity [counts per pixel]', color='b',
             fontsize=fontsize)
for tl in ax.get_yticklabels():
    tl.set_color('b')

ax2 = ax.twinx()
ax2.plot(time,num*(450.**2),'g')
ax2.set_ylabel('size [km$^2$]', color='g',
              fontsize=fontsize)
for tl in ax2.get_yticklabels():
    tl.set_color('g')

'''
fourier transform
ax3 = fig.add_subplot(2,1,2)
ax3.set_ylabel('fourier trans')
ax3.set_xlabel('frequency?')
#ax3.tick_params(axis='both',labelsize='small')
trans = np.fft.fft(intensity)
ax3.plot(trans)
'''

#plt.show()
plt.savefig("plot2.png",bbox_inches='tight', dpi=300)
