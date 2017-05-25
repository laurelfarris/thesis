import matplotlib.pyplot as plt
import numpy as np
import math
import pdb

import matplotlib
matplotlib.rc('font',**{'family':'serif','serif':['Times']})
matplotlib.rc('text', usetex=True)

f = open('radial_cc.dat')
x,y,xx,yy,r,c,t = np.loadtxt(f, unpack=True)

colors = ['purple','green','blue','red']

fig = plt.figure()
#plt.xlabel('distance [pixels]')#,fontsize=18
#plt.ylabel('correlation')

i=0
ax = fig.add_subplot(2,2,i+1)
ax.text(1.9,0.9,'('+str(int(x[0]))+','+str(int(y[0]))+')')
ax.set_xlabel('distance [pixels]')
ax.set_ylabel('correlation')
ax.tick_params(axis='both',labelsize='small')
for j in range(0,len(x)-1):
    if xx[j] >= x[j] and yy[j] >= y[j]:
        color=colors[0]
    if xx[j] <= x[j] and yy[j] >= y[j]:
        color=colors[1]
    if xx[j] <= x[j] and yy[j] <= y[j]:
        color=colors[2]
    if xx[j] >= x[j] and yy[j] <= y[j]:
        color=colors[3]
    ax.scatter(r[j],c[j],marker='.',s=2,color=color)
    ''' Create subplot for next BP '''
    if x[j+1] != x[j]:
        i=i+1
        ax = fig.add_subplot(2,2,i+1)
        ax.text(1.9,0.9,'('+str(int(x[j+1]))+','+str(int(y[j+1]))+')')
        ax.set_xlabel('distance [pixels]')
        ax.set_ylabel('correlation')
        ax.tick_params(axis='both',labelsize='small')

plt.savefig('cool.png')


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

'''
points = 4  # number of central pixels
for i in range(0,points):
    #f = open('interesting' + str(i+1) + '.dat')
    f = open('radial_cc.dat')
    x,y,xx,yy,r,c,t = np.loadtxt(f, unpack=True)
    ax = fig.add_subplot(2,2,i+1)
    ax.scatter(a,b,marker='.',s=2,color='purple')
    ax.tick_params(axis='both',labelsize='small')
    ax.set_xlabel('distance [pixels]')
    ax.set_ylabel('correlation')

i=0
ax = fig.add_subplot(2,2,i+1)

#plt.savefig('cc_distance.png',dpi=300)
#plt.savefig('cc_tau.png',dpi=300)
#plt.savefig('tau_distance.png',dpi=300)
'''

