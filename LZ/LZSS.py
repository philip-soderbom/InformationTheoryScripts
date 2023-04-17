import numpy as np

class LZSS():
    def __init__(self, sizeS, sizeB, text):
        print("================================================")
        print(f"Initializing LZSS with S={sizeS}, b={sizeB}")
        print(f"Text to be encoded: '{text}'")
        print("================================================")
        self.sizeS = sizeS
        self.sizeB = sizeB
        self.text = text
        self.nbr_matches = 0
    

    def calcCompressionRatio(self,codewords):
        orig = len(self.text) * 8
        match_bits = 1 + np.ceil(np.log2(self.sizeS+1)) + np.ceil(np.log2(self.sizeB+1))
        no_match_bits = 1 + 8
        encoded = self.sizeS*8 + self.nbr_matches*match_bits + (len(codewords)-self.nbr_matches)*no_match_bits
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
                if len(matches[i]) >= len(matches[lmi]):
                    lmi = i
            return lmi
    
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
        if end > len(self.text):
            for i in range(start,len(self.text)):
                B.append(self.text[i])
        else:
            for i in range(start,end):
                B.append(self.text[i])

    def encode_lzss(self,text,sizeS,sizeB):
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

            # there is at least one match
            if len(offsetIndices) > 0:
                self.nbr_matches += 1
                # Find the offset with the longest match                
                matches = self.determineLongestMatch(offsetIndices,S,B)
                #print(f"matches: {matches}")
                longest_match = max(matches)
                # check if all matches are of same length, then reverse offsetIndices
         
                # get the index of the longest match
                print("matches: ", matches)
                lmi = self.longest_item_index(matches)
                print("LMI: ", lmi)
                j = self.sizeS - offsetIndices[lmi]

                l = len(longest_match)
                print(f"Longest match: {longest_match} -> j = {j}, l = {l}")

                # set codeword to (0,j,l)
                codewords.append([0,j,l])
                print("Codewords: ", codewords)

                n = n + l
            
            # no matches
            else:
                # set codeowrd = (1,c = xn)
                codewords.append([1,text[n-1]])
                print("Codewords: ", codewords)
                n = n + 1
                
            # update S and B buffers
            self.updateS(n,S)
            self.updateB(n,B)

            
        return codewords