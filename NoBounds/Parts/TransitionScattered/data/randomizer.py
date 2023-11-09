import random

blocks = []

x_list = list(range(20))
y_list = list(range(12))



for x in x_list:
    for y in y_list:
        blocks.append((x*2,y*2))
        print(x*2,y*2)

#random.shuffle(blocks)

x_sequence = list()
y_sequence = list()

for block in blocks:
    x_sequence.append(block[0])
    y_sequence.append(block[1])


print((x_sequence))

print((y_sequence))
