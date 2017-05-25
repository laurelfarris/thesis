'''
Produce image from data??
'''
import matplotlib.pyplot as plt
import numpy as np
import math
import pdb
from scipy.io.idl import readsav
from scipy import ndimage

import matplotlib
matplotlib.rc('font',**{'family':'serif','serif':['Times']})
matplotlib.rc('text', usetex=True)

bp1 = readsav('bp_first.sav')
bp1 = np.array(bp1)
print bp1.dtype

#from PIL import Image
#from scipy.misc import toimage
#toimage(bp1).show()

#plt.imshow(bp1, interpolation='nearest')
#plt.show()

#w, h = 512, 512
#data = np.zeros((h, w, 3), dtype=np.uint8)
#data[256, 256] = [255, 0, 0]
#img = Image.fromarray(bp1, 'RGB')
#img.show()
#img.save('my.png')

'''
#time,intensity = np.loadtxt(f, unpack=True)
intensity = np.loadtxt(f, unpack=True)
#ax.plot(time,intensity)
ax.plot(intensity)
#plt.show()
plt.savefig('lightcurve2.png',dpi=300)

fig = plt.figure()
ax=fig.add_subplot(1,1,1)
ax.set_xlabel('time [cadence]')
ax.set_ylabel('intensity [arbitrary]')
ax.tick_params(axis='both',labelsize='small')

'''
