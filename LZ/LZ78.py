import numpy as np

class LZ78():
    def __init__(self,text):
        print("================================================")
        print("Initializing LZ78")
        print(f"Text to be encoded: '{text}'")
        print("================================================")

    def calcCompressionRatio(self,codewords,binaries,text):
        orig = len(text) * 8
        prefix_bits = np.sum(binaries)
        char_bits = len(codewords) * 8
        return orig / (prefix_bits + char_bits)


    def findMatchIndices(self,xn,d):
        indices = []
        for i in range(len(d)):
            k = len(d[i])
            if k > 1:
                if xn == d[i][0]:
                    indices.append(i)
            if xn == d[i]:
                indices.append(i)
                
        return indices

    def findLongestMatch(self,matchIndices,d,text,n):
        # return the longest matching strings in a vector L
        L = [1]
        for i in matchIndices:
            l = 1
            dictElem = d[i]
            k = len(dictElem)
            if k > 1:
                print(f"elem: '{dictElem}' comparing to '{text[n-1:n+k-1]}', ? {dictElem == text[n-1:n+k-1]}")
                if dictElem == text[n-1:n+k-1]:
                    l += k - 1
                
                L.append(l)
        return L  
            


    def encode_lz78(self,text):
        codewords = []
        binary = []
        # Initialization
        dictionary = [''] # dictionary containing only empty symbol
        n = 1
        Ind = 1

        ## MAIN LOOP ##
        while n < len(text):
            xn = text[n-1]
            print(f"\nn = {n}, x[n] = '{xn}'")
            matchIndices = self.findMatchIndices(xn,dictionary)
            print("Match indices: ", matchIndices)
            print("Dictionary: ", dictionary)
            if len(matchIndices) > 0 and n < len(text) - 1:
                # find longest match in dictionary
                L = self.findLongestMatch(matchIndices,dictionary,text,n)
                l = max(L)
                print("l = ", l)

                # find index of longest match in dictionary
                Ind_m = matchIndices[np.argmax(L)]
                # set codeword to (Ind_m, x[n+l])
                codewords.append([Ind_m,text[n+l-1]])
                # add to dictionary
                dictionary.append(text[n-1:n+l])
                n = n + l + 1
            else:
                # set codeword to (0,x[n])
                codewords.append([0,xn])
                # add xn to dictionary
                dictionary.append(xn)
                n = n + 1
            
            #print("Codewords: ", codewords)
            # calc bits for index
            b = np.ceil(np.log2(Ind))
            binary.append(b)
            Ind = Ind + 1


        return [codewords,binary]
            


    


