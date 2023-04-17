import numpy as np

class LZW():
    def __init__(self,text,A):
        print("================================================")
        print("Initializing LZW")
        print(f"Text to be encoded: '{text}'")
        print("================================================")
        self.text = text
        self.A = A
        self.dictionary = []
        self.indices = []
        self.codewords = []
        self.binary = []

    def calcCompressionRatio(self):
        orig = len(self.text) * 8
        encoded = np.sum(self.binary)
        return orig / encoded
        
    def getBinary(self):
        return self.binary

    def init_ascii(self,text,D,I):
        for char in text:
            I.append(ord(char))
        I = sorted(list(set(I)))
        
        for ascii_val in I:
            D.append(chr(ascii_val))

        return [D,I]
    
    def findMatchIndices(self,xn,d,n):
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
                #print(f"elem: '{dictElem}' comparing to '{text[n-1:n+k-1]}', ? {dictElem == text[n-1:n+k-1]}")
                if dictElem == text[n-1:n+k-1]:
                    l += k - 1
                
                L.append(l)
        return L    

    
    def getResult(self):
        lendiff = len(self.dictionary) - len(self.codewords)
        adjusted_codewords = []
        for i in range(len(self.dictionary)):
            if i < lendiff:
                adjusted_codewords.append('-')
            else:
                adjusted_codewords.append(self.codewords[i-lendiff])

        return np.transpose([self.indices, adjusted_codewords, self.dictionary])


    def encode_lzw(self,text):
        indices = []
        codewords = []
        dictionary = []
        binary = []
        
        # Initialize dictionary with complete alphabet
        # init with ASCII table
        [dictionary, indices] = self.init_ascii(text,dictionary,indices)
        print("Initial ASCII dictionary: ", dictionary)
        print("Initial indices: ", indices)

        n = 1
        # Ind = |A| + 1
        Ind = self.A

        while n <= len(text):
            # Find xn in the dictionary
            xn = text[n-1]
            #print(f"\nn = {n}, x[n] = '{xn}'")

            # first get all the matching indices 
            match_indices = self.findMatchIndices(xn,dictionary,n)
            #print("Found matching indices: ", match_indices)

            # find longest matching strings
            L = self.findLongestMatch(match_indices,dictionary,text,n)
            l = max(L)
            #print(f"L: {L}, l = {l}")

            # set codeword to (Ind_m)
            match_index = match_indices[np.argmax(L)]
            #print(f"Match index chosen: {match_index}")
            Ind_m = indices[match_index]
            codewords.append(Ind_m)

            # add to dictionary and add Ind to indices list
            dictionary.append(text[n-1:n+l])
            indices.append(Ind)

            # add the number of bits required in the binary list
            binary.append(np.ceil(np.log2(Ind)))
            #print("Updated Dictionary: ", dictionary)
            # print("Indices: ", indices)
            # print("Codewords: ", codewords)

            # update variables
            n = n + l
            Ind = Ind + 1
        
        # update class attributes
        self.indices = indices
        self.dictionary = dictionary
        self.codewords = codewords
        self.binary = binary

        return codewords
        
        
        
    
    


