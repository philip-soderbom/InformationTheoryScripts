import numpy as np
from typing import List, Union


class InfoTheory:
    def Entropy(self, P: Union[float, np.ndarray]) -> Union[float, np.ndarray]:
        """
        Calculate entropy of probability distribution(s).

        Parameters
        ----------
        P : float or numpy.ndarray
            Matrix (2-dim array): Each row is a probability distribution, calculate its entropy,
            Row vector (1Xm matrix): The row is a probability distribution, calculate its entropy,
            Column vector (nX1 matrix): Derive the binary entropy function for each entry,
            Single value (1X1 matrix): Derive the binary entropy function

        Returns
        -------
        H : float or numpy.ndarray
            array with entropies
        """
        s = np.shape(P)
        #print("P size:",s)

        ## P scalar, binary entropy function h(p)
        if isinstance(P, float) or isinstance(P, int):
            if P == 0 or P == 1:
                #print('P: Scalar')
                H = 0
            else:
                H = -P * np.log2(P) - (1 - P) * np.log2(1 - P)

        ## P column vector
        elif s[1] == 1:
            #print('P: Column vector')
            H = np.zeros(s[0])
            for i in range(s[0]):
                p = P[i, 0]
                if p == 0 or p == 1:
                    H[i] = 0
                else:
                    H[i] = -p * np.log2(p) - (1-p)*np.log2(1-p)

    
            

        ## P matrix
        elif s[0] > 1 and s[1] > 1:
            #print('P: ',s[0], 'x', s[1], 'Matrix')
            rows = s[0]
            cols = s[1] 
            H = np.zeros(rows)
            for row in range(rows):
                for col in range(cols):
                    p = P[row, col]
                    if p == 0 or p == 1:
                        H[row] += 0
                    else:
                        H[row] += -p * np.log2(p)
                H
                #H[0, col] = -H[0, col]


        
        ## P row vector
        elif s[0] == 1:
            #print('P: Row vector')
            cols = s[1]
            H = np.zeros(1)
            for i in range(cols):
                p = P[0,i]
                if p == 0:
                    H[0] += 0
                else:
                    H[0] += -p * np.log2(p)
            H
            
        
        return H
    
    def MutualInformation(self,P):
        PxPy = self.calcProbDistrVector(P)

        Px = np.array([PxPy[0]])
        Py = np.array([PxPy[1]])

        print('Px = ', Px)
        print('Py = ', Py)

        Hx = self.Entropy(Px)
        Hy = self.Entropy(Py)
        Hxy = np.sum(self.Entropy(P))

        print('Hx =', Hx)
        print('Hy =', Hy)
        print('Hxy =', Hxy)

   
        I = Hx + Hy - Hxy
        return I
    

    def calcProbDistrVector(self,P):
        sz = np.shape(P)
        rows = sz[0]
        cols = sz[1]

        # Empty probability distribution (column) vectors
        Px = np.zeros(cols)
        Py = np.zeros(cols)

        # calculate prob distr. vector for Y and X
        for i in range(cols):
            Py[i] = np.sum(P[:,i])
        
        for i in range(rows):
            Px[i] = np.sum(P[i,:])
    
        return [Px,Py]

if __name__ == "__main__":
    ### init
    IT = InfoTheory()  
    print('================ TESTS =================')
    ### 1st test
    P1 = np.transpose(np.array([np.arange(0.0,1.1,0.25)])) # column vector
    H1 = IT.Entropy(P1)
    print('P1 =',P1)
    print('H1 =',H1)
    print('===============================================================================')
    

    ### 2nd test, 3x4-matrix
    P2 = np.array([[0.3, 0.1, 0.3, 0.3],
                 [0.4, 0.3, 0.2, 0.1],
                 [0.8, 0.0, 0.2, 0.0]])
    H2 = IT.Entropy(P2)
    print('P2 =',P2)
    print('H2 =',H2)
    print('===============================================================================')


    P_row = np.array([[0.125, 0.875]])
    print('Pe', P_row)
    H4 = IT.Entropy(P_row)
    print('He',H4)
    print('===============================================================================')
    

    ### 3rd test
    P3 = np.array([[0, 3/4],[1/8, 1/8]])
    I3 = IT.MutualInformation(P3)
    print('P3 =',P3)
    print('I3 =',I3)
    print('===============================================================================')


    ### 4th test
    P4 = np.array([[1/12, 1/6, 1/3], [1/4,  0,   1/6]])
    H = IT.Entropy(P4)
    I4 = IT.MutualInformation(P4)
    print('P4 =',P4)
    print('H =',H)
    print('I4 =',I4)


    print('================================ CUSTOM PROBLEMS =================================')
    P = np.array([[1/8, 1/4, 1/8],
                  [0, 0, 1/2]])
    print('INPUT P(X,Y):\n ', P)
    res = IT.MutualInformation(P)
    print('RESULT, I(X;Y) = ', res)

    print('h = ', IT.Entropy(0.6))
