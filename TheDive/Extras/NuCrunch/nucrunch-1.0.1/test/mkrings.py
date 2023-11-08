import numpy as np
def saveAsPrg(fn,address,data):
    fo=open(fn,"wb")
    header=np.array((address&255,address/256),np.uint8).tostring()
    fo.write(header)
    fo.write(data)
    fo.close()

y,x=np.indices((200,320))
yy=(y*2+1-100)**2
xx=(x*2+1-160)**2
r=(xx+yy)**.5
bits=(r/6).astype(np.int)%2

bits=bits.reshape((25,8,40,8))
bits=bits.transpose((0,2,1,3))
bits=np.sum(bits*[128,64,32,16,8,4,2,1],axis=3)
if 1:
    bits[-1,-1,:]=[
        0xe8,
        0xd4,
        0xb2,
        0x71,
        0x8e,
        0x4d,
        0x2b,
        0x17,
        ]


saveAsPrg("test/rings.prg",0x2000,bits.astype(np.uint8).tostring())
