import matplotlib.pyplot as plt
import numpy as np
import math
import pdb
import matplotlib
matplotlib.rc('font',**{'family':'serif','serif':['Times']})
matplotlib.rc('text', usetex=True)


'''
# Read in all data from a single file
i = 0
for line in f:
    if not line.startswith('#'):
        distance[i], cc[i] = np.loadtxt(f, unpack=True)
    else:
 Plots!
fig = plt.figure()
'''

''' Create plots/axes '''
fig = plt.figure()

''' number of central pixels '''
points = 4

for i in range(0,points):
    f = open('interesting' + str(i+1) + '.dat')
    a,b,c = np.loadtxt(f, unpack=True)
    ax = fig.add_subplot(2,2,i+1)
    ax.scatter(a,b,marker='.',s=2)#,color='purple')
    ax.tick_params(axis='both',labelsize='small')
    ax.set_xlabel('distance [pixels]')
    ax.set_ylabel('correlation')

#plt.savefig('cc_distance.png',dpi=300)
#plt.savefig('cc_tau.png',dpi=300)
#plt.savefig('tau_distance.png',dpi=300)
plt.show()



