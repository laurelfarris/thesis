'''
Read in size data from file and plot it.
'''
import matplotlib.pyplot as plt
import numpy as np
import math
import pdb

import matplotlib
matplotlib.rc('font',**{'family':'serif','serif':['Times']})
matplotlib.rc('text', usetex=True)

fig = plt.figure()
ax=fig.add_subplot(1,1,1)
ax.set_xlabel('distance [pixels]')
ax.set_ylabel('intensity [arbitrary]')
ax.tick_params(axis='both',labelsize='small')

f = open('size.dat')
distance,intensity = np.loadtxt(f, unpack=True)
ax.scatter(distance,intensity,marker='.',s=2,color='black')
#plt.show()
plt.savefig('size.png',dpi=300)
