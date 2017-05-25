'''
Last modified: 20 May 2017
Finished! Needs to be tested though
'''

import numpy as np
from scipy.interpolate import interp2d


def align_cube3(cube):

    sz = cube.shape


    ''' Use middle image as reference (3D --> 2D) '''
    ref = np.reshape( cube[ :, :, (sz[2])/2 ], (sz[0], sz[1]) )
    shifts = np.zeros((sz[2], 2))

    print "Start: " + str(datetime.now())

    for i in range( sz[2] ):
        offset = alignoffset(cube[:,:,i], ref)
        cube[:,:,i] = shift_sub( cube[:,:,i], -offset[0], -offset[1] )
        shifts[i,:] = -offset

    print "Finish: " + str(datetime.now())
    x_sdv = np.std(shifts[0,:])
    y_sdv = np.std(shifts[1,:])

    print "x stddev: {:.4f}".format(x_sdv)
    print "y stddev: {:.4f}".format(y_sdv)


    return cube
