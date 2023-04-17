import numpy as np

from LZ77 import LZ77
from LZ78 import LZ78
from LZSS import LZSS
from LZW import LZW


if __name__ == "__main__":

    
    ################ LZ77 encoding ################
    ###############################################
    #text = "IF IF = THEN THEN THEN = ELSE ELSE ELSE = IF;"
    text = "Nat the bat swat at Matt the gnat"
    S = 10
    B = 3
    lz77 = LZ77(S,B,text)
    codewords = lz77.encode_lz77(text,S,B)

    for i in range(len(codewords)):
        print(f"\ni={i+1}: {codewords[i]}")

    print(f"\nNumber of codewords: {len(codewords)}")

    compression_ratio = lz77.calcCompressionRatio(codewords)
    print("Compression ratio for LZ77 = ", compression_ratio)


    ################ LZSS encoding ################
    ###############################################
    text = "Nat the bat swat at Matt the gnat"
    S = 10
    B = 3
    lzss = LZSS(S,B,text)
    codewords = lzss.encode_lzss(text,S,B)
    for i in range(len(codewords)):
        print(f"\ni={i+1}: {codewords[i]}")
    print(f"\nNumber of codewords: {len(codewords)}")
    compression_ratio = lzss.calcCompressionRatio(codewords)
    print("Compression ratio for LZSS = ", compression_ratio)


    ################ LZ78 encoding ################
    ###############################################
    #text = "IF IF = THEN THEN THEN = ELSE ELSE ELSE = IF;"
    text = "Nat the bat swat at Matt the gnat"
    #text = "tim the thin twin tinsmith"

    lz78 = LZ78(text)
    # OBSERVE that the last codeword may be incorrect
    codewords = lz78.encode_lz78(text)[0]
    binary = lz78.encode_lz78(text)[1]

    for i in range(len(codewords)):
        print(f"\ni={i+1}: {codewords[i]}")

    print(f"\nNumber of codewords: {len(codewords)}")
    # Compression ratio
    compression_ratio = lz78.calcCompressionRatio(codewords,binary,text)
    print("Compression ratio for LZ78 = ", compression_ratio)



    ################ LZW encoding ################
    ##############################################
    text = "Nat the bat swat at Matt the gnat"
    alphabet = 256
    lzw = LZW(text, alphabet)
    codewords = lzw.encode_lzw(text)
    binary = lzw.getBinary()
    result = lzw.getResult()

    print("Idx  Codeword  Dict")
    for i in range(len(result)):
        print(f"{result[i][0]} -> '{result[i][1]}' -> '{result[i][2]}'")

    print(f"\nNumber of codewords: {len(codewords)}")
    # Compression ratio
    compression_ratio = lzw.calcCompressionRatio()
    print("Compression ratio for LZW = ", compression_ratio)