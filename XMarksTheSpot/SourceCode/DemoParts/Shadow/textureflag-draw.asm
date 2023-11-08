// *************************************************
// Waving textured flag for Commodore 64
// by Andreas Gustafsson aka. Shadow/Genesis Project
// September/October 2018
// *************************************************

	//; nb. these must match the ones in textureflag.asm
	.var ZP_SCRPTR=$02
	.var ZP_STRETCH_PTR=$04
	.var ZP_STRETCH_CODE=$06
	.var ZP_TEXTURE=$40 // + 128 bytes forward

.pc=$5400 "Sprites"
sprites:
.var mastBmp1=LoadPicture("..\..\..\SourceData\Shadow-Flag\mastsprites.png",List().add($7564DA,$94520D,$553900,$CA6B60))
.for(var s=0;s<6;s++)
{
	.for(var y=0;y<21;y++)
	{
		.fill 3,mastBmp1.getMulticolorByte(s*3+i,y)
	}
	.byte 0
}

.var mastBmp2=LoadPicture("..\..\..\SourceData\Shadow-Flag\mastsprites.png",List().add($7564DA,$94520D,$000000,$CA6B60))
.for(var s=0;s<2;s++)
{
	.for(var y=0;y<21;y++)
	{
		.fill 3,mastBmp2.getMulticolorByte((s+6)*3+i,y)
	}
	.byte 0
}

.pc=$5800 "Unrolled code"
	.import source "stretch_code.asm"

.var skullBmp=LoadPicture("..\..\..\SourceData\Shadow-Flag\skull_redcrab2.png",List().add($ff00ff,$000000,$757575,$ffffff))
.var myZeroPageBytes = List(104)
.macro Texturerow(row)
{
	.if(row == 0)
	{
		.for(var ZPIndex = 0; ZPIndex < 104; ZPIndex++)
		{
			.eval myZeroPageBytes.set(ZPIndex, -1)
		}
	}
    .for(var i=0;i<256;i++)
    {
        .var flag=false
        .for(var j=0;j<104;j++)
        {
			.if(myZeroPageBytes.get(j) != i)
			{
				.if(skullBmp.getMulticolorByte(row,j)==i)
				{
					.if(!flag)
					{
						lda #i
						.eval flag=true
					}
					sta ZP_TEXTURE+j+8
					.eval myZeroPageBytes.set(j, i)
				}
			}
        }
    }
    rts
}

.pc=$b000 "Texture code" //; *

texture_ptrs:
	.word texture_row0
	.word texture_row1
	.word texture_row2
	.word texture_row3
	.word texture_row4
	.word texture_row5
	.word texture_row6
	.word texture_row7
	.word texture_row8
	.word texture_row9
	.word texture_row10
	.word texture_row11
	.word texture_row12
	.word texture_row13
	.word texture_row14
	.word texture_row15

texture_row0:
	:Texturerow(0)
texture_row1:
	:Texturerow(1)
texture_row2:
	:Texturerow(2)
texture_row3:
	:Texturerow(3)
texture_row4:
	:Texturerow(4)
texture_row5:
	:Texturerow(5)
texture_row6:
	:Texturerow(6)
texture_row7:
	:Texturerow(7)
texture_row8:
	:Texturerow(8)
texture_row9:
	:Texturerow(9)
texture_row10:
	:Texturerow(10)
texture_row11:
	:Texturerow(11)
texture_row12:
	:Texturerow(12)
texture_row13:
	:Texturerow(13)
texture_row14:
	:Texturerow(14)
texture_row15:
	:Texturerow(15)

