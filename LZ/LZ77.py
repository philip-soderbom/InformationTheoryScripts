import numpy as np

class LZ77():
    def __init__(self, sizeS, sizeB,text):
        print("================================================")
        print(f"Initializing LZ77 with S={sizeS}, B={sizeB}")
        print(f"Text to be encoded: '{text}'")
        print("================================================")
        self.sizeS = sizeS
        self.sizeB = sizeB
        self.text = text

    def calcCompressionRatio(self,codewords):
        orig = len(self.text) * 8
        # find largest j and l
        js = []
        ls = []
        for codeword in codewords:
            js.append(codeword[0])
            ls.append(codeword[1])
        jmax = max(js)
        lmax = max(ls)
        # number of bits required
        jbits = np.ceil(np.log2(jmax))
        lbits = np.ceil(np.log2(lmax))

        encoded = self.sizeS * 8 + len(codewords)*(jbits + lbits + 8)

        return orig/encoded
        

    def findOffsetIndices(self,xn,S):
            offsets = []
            for i in reversed(range(len(S))):
                if S[i] == xn:
                    offsets.append(len(S) - i)
            
            # normalize indices
            for i in range(len(offsets)):
                newElem = self.sizeS - offsets[i]
                offsets[i] = newElem

            offsets = offsets[::-1]

            return offsets

    def determineLongestMatch(self,offsetIndices,S,B):
            # return all matches
            matches = []
            for i in offsetIndices:
                l = 0
                shift = 1
                for n in range(i,len(S)):
                    left = S[i:n+1]
                    right = B[0:shift]
                    shift+=1
                    
                    if left == right:
                        l+=1

                matches.append(S[i:i+l])

            return matches

    def longest_item_index(self,matches):
            # return the longest matching index (lmi)
            lmi = 0
            for i in range(1, len(matches)):
                # if matches are of equal length
                # the latest shall be chosen
                if len(matches[i]) >= len(matches[lmi]):
                    lmi = i
            return lmi

    def all_same(self,list):
        return all(x == list[0] for x in list)
    
    def reverseList(self,list):
        return list[::-1]
            
    def updateS(self,n,S):
        start = n - self.sizeS - 1
        end = n - 1
        S.clear()
        for i in range(start,end):
            S.append(self.text[i])

    def updateB(self,n,B):
        start = n - 1
        end = n + self.sizeB - 1
        B.clear()
        # check index out of bounds
        if end > len(self.text):
            for i in range(start,len(self.text)):
                B.append(self.text[i])
        else:
            for i in range(start,end):
                B.append(self.text[i])

    def encode_lz77(self,text,sizeS,sizeB):
        codewords = []
        # Initialization
        n = sizeS + 1
        S = []
        B = []
        for i in range(sizeS):
            S.append(text[i])
        for i in range(sizeS, sizeS + sizeB):
            B.append(text[i])
            
        ## MAIN LOOP ##
        while n <= len(text):
            print(f"\nn = {n}, S: {S}, B: {B}")
            # Find all offset indices (all offsets)
            offsetIndices = self.findOffsetIndices(B[0],S)
            print(f"Offset indices: {offsetIndices}")

            if len(offsetIndices) > 0:
                # Find the offset with the longest match                
                matches = self.determineLongestMatch(offsetIndices,S,B)
                #print(f"matches: {matches}")
                longest_match = max(matches)
                
                # check if all matches are of same length, then reverse offsetIndices
                # lengths = []
                # for match in matches:
                #     lengths.append(len(match))
                # if self.all_same(lengths):
                #     offsetIndices = self.reverseList(offsetIndices)
         
                # get the index of the longest match
                lmi = self.longest_item_index(matches)
                j = self.sizeS - offsetIndices[lmi]

                l = len(longest_match)
                print(f"Longest match: {longest_match} -> j = {j}, l = {l}")

                #print("Current n: ", n)
                # Check if a given l causes n to exceed the length of the text
                if n + l > len(text):
                    diff = (n + l) - len(text)
                    l -= diff
                #print("updated n: ",n)

                # set codeword to (j,l,c = x[n+l])
                c = text[n+l-1]
                codewords.append([j,l,c])
                print("Codewords: ", codewords)

                n = n + l + 1
                
            else:
                # set codeowrd = (0,0,xn)
                codewords.append([0,0,text[n-1]])
                print("Codewords: ", codewords)
                n = n + 1
                
            # update S and B buffers
            self.updateS(n,S)
            self.updateB(n,B)

            
        return codewords


