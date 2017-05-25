import numpy as np
from scipy.interpolate import interp2d


def alignoffset(image, reference):
    ''' Determine the offsets of an image with respect to a reference image '''
    si = image.shape
    sr = reference.shape

    ''' Check that images have the same dimensions '''
    if not (si[1] == sr[1] and si[0] == sr[0]):
        print 'Incompatible Images : alignoffset'
        return [0, 0.]

    ''' ? '''
    nx = 2**( int( np.log(si[1]) / np.log(2.) ) )
    nx = nx * ( 1 + (si[1] > nx) )
    ny = 2**( int( np.log(si[0])/np.log(2.) ) )
    ny = ny * ( 1 + (si[0] > ny) )

    ''' Subtract median values '''
    image1 = image - np.mean(image)
    reference1 = reference - np.mean(image)
    if nx != si[1] or ny != si[2]:
        # Need a python equivalent of congrid!
        image1 = congrid(image1, nx, ny, cubic=-0.5) #IDL
        reference1 = congrid(reference1, nx, ny, cubic=-0.5) #IDL

    sigma_x = nx/6.
    sigma_y = ny/6.
    xx = (np.matrix(np.arange(nx))).reshape(nx.shape[0],1) * np.matrix(np.ones(ny))
    xx = xx - nx * (xx > nx/2)
    yy = (np.matrix(np.ones(nx))).reshape(nx.shape[0],1) * np.matrix(np.arange(ny))
    yy = yy - ny * (yy > ny/2)
    ### window = np.roll()
    window = np.sqrt(window)



    return cor
