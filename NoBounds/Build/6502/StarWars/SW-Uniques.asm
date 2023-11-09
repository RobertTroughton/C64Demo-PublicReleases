//; Raistlin / Genesis*Project

        .var SCROLLTEXT_LINE_LENGTH = 16

    SW_FontLookupTableLo:
        .fill 16, <(RemappedFont + (i * 15))
    SW_FontLookupTableHi:
        .fill 16, >(RemappedFont + (i * 15))

    FontData_0:
        .byte $ff, $ff, $fe, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $ff, $fe, $fc, $fc, $ff, $fc, $ff, $fc, $fc, $fc, $ff, $ff, $ff, $ff
    FontData_1:
        .byte $ff, $0f, $07, $67, $e7, $07, $ff, $0f, $07, $e7, $07, $07, $7f, $c7, $9f, $e7, $e7, $a7, $87, $47, $ff, $ff, $ff, $ff
    FontData_2:
        .byte $ff, $0f, $07, $63, $f3, $03, $ff, $0f, $07, $e3, $03, $03, $7f, $c3, $9f, $e7, $f3, $d3, $93, $23, $ff, $ff, $ff, $ff
    FontData_3:
        .byte $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $fe, $fe, $fe, $ff, $fe, $ff, $fe, $fe, $fe, $ff, $ff, $ff, $ff
    FontData_4:
        .byte $ff, $0f, $07, $63, $73, $03, $7f, $0f, $07, $63, $03, $03, $7f, $43, $9f, $67, $f3, $53, $13, $23, $ff, $ff, $ff, $ff
    FontData_5:
        .byte $ff, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $fe, $fe, $ff, $fe, $ff, $fe, $fe, $fe, $ff, $ff, $ff, $ff
    FontData_6:
        .byte $ff, $87, $03, $33, $73, $03, $7f, $07, $03, $73, $83, $03, $3f, $63, $cf, $73, $f3, $53, $43, $23, $ff, $ff, $ff, $ff
    FontData_7:
        .byte $ff, $87, $03, $31, $79, $01, $7f, $07, $03, $71, $81, $01, $3f, $61, $cf, $73, $f9, $59, $49, $21, $ff, $ff, $ff, $ff
    FontData_8:
        .byte $ff, $87, $03, $31, $39, $01, $3f, $07, $03, $31, $81, $01, $3f, $21, $cf, $33, $f9, $29, $09, $11, $ff, $ff, $ff, $ff
    FontData_9:
        .byte $ff, $83, $01, $19, $39, $01, $3f, $03, $01, $39, $81, $01, $1f, $31, $e7, $39, $f9, $29, $21, $11, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_10:
        .byte $ff, $c3, $81, $19, $39, $01, $3f, $03, $01, $39, $c1, $81, $1f, $31, $e7, $39, $f9, $29, $21, $11, $ff, $ff, $ff, $ff
    FontData_11:
        .byte $ff, $e1, $c0, $8c, $9c, $80, $9f, $81, $80, $9c, $e0, $c0, $8f, $98, $f3, $9c, $fc, $94, $90, $88, $ff, $ff, $ff, $ff
    FontData_12:
        .byte $ff, $e1, $c0, $8c, $9e, $80, $9f, $81, $80, $9c, $e0, $c0, $8f, $98, $f3, $9c, $fe, $96, $92, $88, $ff, $ff, $ff, $ff
    FontData_13:
        .byte $ff, $ff, $ff, $7f, $7f, $7f, $ff, $ff, $ff, $7f, $7f, $7f, $ff, $7f, $ff, $ff, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff
    FontData_14:
        .byte $ff, $e1, $c0, $cc, $ce, $c0, $cf, $c1, $c0, $cc, $e0, $c0, $cf, $c8, $f3, $cc, $fe, $ca, $c2, $c4, $ff, $ff, $ff, $ff
    FontData_15:
        .byte $ff, $e0, $c0, $c6, $ce, $c0, $cf, $c0, $c0, $ce, $e0, $c0, $c7, $cc, $f9, $ce, $fe, $ca, $c8, $c4, $ff, $ff, $ff, $ff
    FontData_16:
        .byte $ff, $ff, $7f, $7f, $7f, $7f, $ff, $ff, $7f, $7f, $7f, $7f, $ff, $7f, $ff, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff
    FontData_17:
        .byte $ff, $f0, $e0, $c6, $ce, $c0, $cf, $c0, $c0, $ce, $f0, $e0, $c7, $cc, $f9, $ce, $fe, $ca, $c8, $c4, $ff, $ff, $ff, $ff
    FontData_18:
        .byte $ff, $ff, $7f, $3f, $3f, $3f, $ff, $ff, $7f, $3f, $3f, $3f, $ff, $3f, $ff, $7f, $3f, $3f, $3f, $3f, $ff, $ff, $ff, $ff
    FontData_19:
        .byte $ff, $f0, $e0, $e6, $e7, $e0, $e7, $e0, $e0, $e6, $f0, $e0, $e7, $e4, $f9, $e6, $ff, $e5, $e1, $e2, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_20:
        .byte $ff, $f0, $e0, $e7, $e7, $e0, $e7, $e0, $e0, $e7, $f0, $e0, $e7, $e4, $f8, $e7, $ff, $e5, $e0, $e2, $ff, $ff, $ff, $ff
    FontData_21:
        .byte $ff, $7f, $3f, $3f, $3f, $3f, $ff, $7f, $3f, $3f, $3f, $3f, $ff, $3f, $ff, $3f, $3f, $3f, $3f, $3f, $ff, $ff, $ff, $ff
    FontData_22:
        .byte $ff, $f8, $f0, $e3, $e7, $e0, $e7, $e0, $e0, $e7, $f8, $f0, $e3, $e6, $fc, $e7, $ff, $e5, $e4, $e2, $ff, $ff, $ff, $ff
    FontData_23:
        .byte $ff, $fc, $f8, $f1, $f1, $f0, $f1, $f0, $f0, $f1, $fc, $f8, $f1, $f1, $fe, $f1, $ff, $f1, $f0, $f0, $ff, $ff, $ff, $ff
    FontData_24:
        .byte $ff, $3f, $1f, $8f, $cf, $0f, $ff, $3f, $1f, $8f, $0f, $0f, $ff, $0f, $7f, $9f, $cf, $4f, $4f, $8f, $ff, $ff, $ff, $ff
    FontData_25:
        .byte $ff, $fe, $f8, $f8, $f9, $f8, $f9, $f8, $f8, $f9, $fe, $f8, $f8, $f9, $ff, $f9, $ff, $f9, $f9, $f8, $ff, $ff, $ff, $ff
    FontData_26:
        .byte $ff, $1f, $0f, $cf, $cf, $0f, $ff, $1f, $0f, $cf, $0f, $0f, $ff, $8f, $3f, $cf, $cf, $4f, $0f, $8f, $ff, $ff, $ff, $ff
    FontData_27:
        .byte $ff, $fe, $fc, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $fe, $fc, $f8, $f8, $ff, $f8, $ff, $f8, $f8, $f8, $ff, $ff, $ff, $ff
    FontData_28:
        .byte $ff, $1f, $0f, $c7, $e7, $07, $ff, $1f, $0f, $c7, $07, $07, $ff, $87, $3f, $cf, $e7, $a7, $27, $47, $ff, $ff, $ff, $ff
    FontData_29:
        .byte $ff, $ff, $3f, $3f, $3f, $3f, $ff, $ff, $3f, $3f, $3f, $3f, $ff, $3f, $ff, $3f, $3f, $3f, $3f, $3f, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_30:
        .byte $ff, $7f, $3f, $1f, $1f, $1f, $ff, $7f, $3f, $1f, $1f, $1f, $ff, $1f, $ff, $3f, $1f, $1f, $1f, $1f, $ff, $ff, $ff, $ff
    FontData_31:
        .byte $ff, $f8, $f0, $f3, $f3, $f0, $f3, $f0, $f0, $f3, $f8, $f0, $f3, $f2, $fc, $f3, $ff, $f2, $f0, $f1, $ff, $ff, $ff, $ff
    FontData_32:
        .byte $ff, $7f, $1f, $1f, $9f, $1f, $ff, $7f, $1f, $1f, $1f, $1f, $ff, $1f, $ff, $1f, $9f, $9f, $9f, $1f, $ff, $ff, $ff, $ff
    FontData_33:
        .byte $ff, $fc, $f8, $f1, $f3, $f0, $f3, $f0, $f0, $f3, $fc, $f8, $f1, $f3, $fe, $f3, $ff, $f2, $f2, $f1, $ff, $ff, $ff, $ff
    FontData_34:
        .byte $ff, $3f, $1f, $8f, $8f, $0f, $ff, $3f, $1f, $8f, $0f, $0f, $ff, $0f, $7f, $9f, $8f, $8f, $0f, $0f, $ff, $ff, $ff, $ff
    FontData_35:
        .byte $ff, $fc, $f8, $f9, $f9, $f8, $f9, $f8, $f8, $f9, $fc, $f8, $f9, $f9, $fe, $f9, $ff, $f9, $f8, $f8, $ff, $ff, $ff, $ff
    FontData_36:
        .byte $ff, $1f, $0f, $8f, $cf, $0f, $ff, $1f, $0f, $8f, $0f, $0f, $ff, $0f, $7f, $8f, $cf, $4f, $4f, $8f, $ff, $ff, $ff, $ff
    FontData_37:
        .byte $ff, $f0, $e0, $e7, $e7, $e0, $e7, $e0, $e0, $e7, $f0, $e0, $e7, $e6, $f8, $e7, $ff, $e5, $e0, $e2, $ff, $ff, $ff, $ff
    FontData_38:
        .byte $ff, $f8, $f0, $e3, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $f0, $e3, $e2, $fc, $e3, $ff, $e2, $e0, $e1, $ff, $ff, $ff, $ff
    FontData_39:
        .byte $ff, $1f, $0f, $c7, $c7, $07, $ff, $1f, $0f, $c7, $07, $07, $ff, $87, $3f, $cf, $c7, $47, $07, $87, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_40:
        .byte $ff, $fe, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fe, $fc, $fc, $fc, $ff, $fc, $ff, $fc, $fc, $fc, $ff, $ff, $ff, $ff
    FontData_41:
        .byte $ff, $0f, $07, $e7, $e7, $07, $ff, $0f, $07, $e7, $07, $07, $ff, $87, $1f, $e7, $e7, $a7, $07, $47, $ff, $ff, $ff, $ff
    FontData_42:
        .byte $ff, $f8, $f0, $e3, $e7, $e0, $e7, $e0, $e0, $e7, $f8, $f0, $e3, $e6, $fc, $e7, $ff, $e6, $e4, $e1, $ff, $ff, $ff, $ff
    FontData_43:
        .byte $ff, $7f, $3f, $1f, $9f, $1f, $ff, $7f, $3f, $1f, $1f, $1f, $ff, $1f, $ff, $3f, $9f, $9f, $9f, $1f, $ff, $ff, $ff, $ff
    FontData_44:
        .byte $ff, $1f, $07, $c7, $e7, $07, $ff, $1f, $07, $c7, $07, $07, $ff, $87, $3f, $c7, $e7, $a7, $27, $47, $ff, $ff, $ff, $ff
    FontData_45:
        .byte $ff, $0f, $07, $63, $f3, $03, $ff, $0f, $07, $e3, $03, $03, $7f, $c3, $9f, $e7, $f3, $93, $93, $63, $ff, $ff, $ff, $ff
    FontData_46:
        .byte $ff, $e1, $c0, $8c, $9e, $80, $9f, $81, $80, $9c, $e0, $c0, $8f, $98, $f3, $9c, $fe, $92, $92, $8c, $ff, $ff, $ff, $ff
    FontData_47:
        .byte $ff, $f0, $e0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $f0, $e0, $c7, $cc, $f9, $ce, $ff, $c9, $c9, $c6, $ff, $ff, $ff, $ff
    FontData_48:
        .byte $ff, $fc, $f0, $f1, $f3, $f0, $f3, $f0, $f0, $f3, $fc, $f0, $f1, $f3, $fe, $f3, $ff, $f2, $f2, $f1, $ff, $ff, $ff, $ff
    FontData_49:
        .byte $ff, $3f, $1f, $8f, $cf, $0f, $ff, $3f, $1f, $8f, $0f, $0f, $ff, $0f, $7f, $9f, $cf, $cf, $4f, $0f, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_50:
        .byte $ff, $0f, $07, $63, $e3, $03, $ff, $0f, $07, $e3, $03, $03, $7f, $c3, $9f, $e7, $e3, $a3, $83, $43, $ff, $ff, $ff, $ff
    FontData_51:
        .byte $ff, $07, $03, $31, $71, $01, $7f, $07, $03, $71, $01, $01, $3f, $61, $cf, $73, $f1, $51, $41, $21, $ff, $ff, $ff, $ff
    FontData_52:
        .byte $ff, $83, $01, $39, $39, $01, $3f, $03, $01, $39, $81, $01, $3f, $31, $c7, $39, $f9, $29, $01, $11, $ff, $ff, $ff, $ff
    FontData_53:
        .byte $ff, $f0, $e0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $f0, $e0, $c7, $cc, $f9, $ce, $ff, $cb, $c9, $c4, $ff, $ff, $ff, $ff
    FontData_54:
        .byte $ff, $f8, $e0, $e3, $e7, $e0, $e7, $e0, $e0, $e7, $f8, $e0, $e3, $e6, $fc, $e7, $ff, $e5, $e4, $e2, $ff, $ff, $ff, $ff
    FontData_55:
        .byte $ff, $fc, $f8, $f8, $f9, $f8, $f9, $f8, $f8, $f9, $fc, $f8, $f8, $f9, $ff, $f9, $ff, $f9, $f9, $f8, $ff, $ff, $ff, $ff
    FontData_56:
        .byte $ff, $07, $03, $71, $71, $01, $7f, $07, $03, $71, $01, $01, $7f, $61, $8f, $73, $f1, $51, $01, $21, $ff, $ff, $ff, $ff
    FontData_57:
        .byte $ff, $83, $01, $39, $39, $01, $3f, $03, $01, $39, $81, $01, $3f, $21, $c7, $39, $f9, $29, $01, $11, $ff, $ff, $ff, $ff
    FontData_58:
        .byte $ff, $c1, $80, $9c, $9c, $80, $9f, $81, $80, $9c, $c0, $80, $9f, $98, $e3, $9c, $fc, $94, $80, $88, $ff, $ff, $ff, $ff
    FontData_59:
        .byte $ff, $fe, $fc, $f8, $f9, $f8, $f9, $f8, $f8, $f9, $fe, $fc, $f8, $f9, $ff, $f9, $ff, $f9, $f9, $f8, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_60:
        .byte $ff, $07, $03, $63, $73, $03, $7f, $07, $03, $63, $03, $03, $7f, $43, $9f, $63, $f3, $53, $13, $23, $ff, $ff, $ff, $ff
    FontData_61:
        .byte $ff, $e1, $c0, $8c, $9e, $80, $9f, $81, $80, $9c, $e0, $c0, $8f, $98, $f3, $9c, $fe, $9a, $92, $84, $ff, $ff, $ff, $ff
    FontData_62:
        .byte $ff, $f0, $e0, $c6, $c7, $c0, $c7, $c0, $c0, $c6, $f0, $e0, $c7, $c4, $f9, $c6, $ff, $c5, $c1, $c2, $ff, $ff, $ff, $ff
    FontData_63:
        .byte $ff, $3f, $1f, $9f, $9f, $1f, $ff, $3f, $1f, $9f, $1f, $1f, $ff, $1f, $7f, $9f, $9f, $9f, $1f, $1f, $ff, $ff, $ff, $ff
    FontData_64:
        .byte $ff, $c3, $81, $18, $3c, $00, $3f, $03, $01, $38, $c0, $80, $1f, $30, $e7, $39, $fc, $24, $24, $18, $ff, $ff, $ff, $ff
    FontData_65:
        .byte $ff, $ff, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $ff, $fc, $fc, $fc, $ff, $fc, $ff, $fc, $fc, $fc, $ff, $ff, $ff, $ff
    FontData_66:
        .byte $ff, $0f, $07, $63, $f3, $03, $ff, $0f, $07, $e3, $03, $03, $7f, $c3, $9f, $e7, $f3, $b3, $93, $43, $ff, $ff, $ff, $ff
    FontData_67:
        .byte $ff, $83, $01, $31, $79, $01, $7f, $03, $01, $71, $81, $01, $3f, $61, $cf, $71, $f9, $69, $49, $11, $ff, $ff, $ff, $ff
    FontData_68:
        .byte $ff, $f0, $c0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $f0, $c0, $c7, $cc, $f9, $ce, $ff, $c9, $c9, $c6, $ff, $ff, $ff, $ff
    FontData_69:
        .byte $ff, $3f, $1f, $1f, $9f, $1f, $ff, $3f, $1f, $1f, $1f, $1f, $ff, $1f, $ff, $1f, $9f, $9f, $9f, $1f, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_70:
        .byte $ff, $0f, $03, $63, $f3, $03, $ff, $0f, $03, $e3, $03, $03, $7f, $c3, $9f, $e3, $f3, $93, $93, $63, $ff, $ff, $ff, $ff
    FontData_71:
        .byte $ff, $e0, $c0, $8c, $9e, $80, $9f, $80, $80, $9c, $e0, $c0, $8f, $98, $f3, $9c, $fe, $9a, $92, $84, $ff, $ff, $ff, $ff
    FontData_72:
        .byte $ff, $f0, $e0, $c7, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c7, $c6, $f8, $c7, $ff, $c5, $c0, $c2, $ff, $ff, $ff, $ff
    FontData_73:
        .byte $ff, $0f, $07, $c7, $e7, $07, $ff, $0f, $07, $c7, $07, $07, $ff, $87, $3f, $c7, $e7, $a7, $27, $47, $ff, $ff, $ff, $ff
    FontData_74:
        .byte $ff, $c3, $01, $18, $3c, $00, $3f, $03, $01, $38, $c0, $00, $1f, $30, $e7, $39, $fc, $24, $24, $18, $ff, $ff, $ff, $ff
    FontData_75:
        .byte $ff, $e0, $c0, $8e, $8e, $80, $8f, $80, $80, $8e, $e0, $c0, $8f, $88, $f1, $8e, $fe, $8a, $80, $84, $ff, $ff, $ff, $ff
    FontData_76:
        .byte $ff, $f0, $e0, $e3, $e7, $e0, $e7, $e0, $e0, $e7, $f0, $e0, $e3, $e6, $fc, $e7, $ff, $e5, $e4, $e2, $ff, $ff, $ff, $ff
    FontData_77:
        .byte $ff, $1f, $0f, $c7, $c7, $07, $ff, $1f, $0f, $c7, $07, $07, $ff, $07, $3f, $cf, $c7, $47, $07, $87, $ff, $ff, $ff, $ff
    FontData_78:
        .byte $ff, $83, $01, $38, $38, $00, $3f, $03, $01, $38, $80, $00, $3f, $20, $c7, $39, $f8, $28, $00, $10, $ff, $ff, $ff, $ff
    FontData_79:
        .byte $ff, $e1, $80, $8c, $9e, $80, $9f, $81, $80, $9c, $e0, $80, $8f, $98, $f3, $9c, $fe, $92, $92, $8c, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_80:
        .byte $ff, $fc, $f8, $f1, $f3, $f0, $f3, $f0, $f0, $f3, $fc, $f8, $f1, $f3, $fe, $f3, $ff, $f3, $f2, $f0, $ff, $ff, $ff, $ff
    FontData_81:
        .byte $ff, $83, $01, $38, $38, $00, $3f, $03, $01, $38, $80, $00, $3f, $30, $c7, $39, $f8, $28, $00, $10, $ff, $ff, $ff, $ff
    FontData_82:
        .byte $ff, $07, $03, $71, $71, $01, $7f, $07, $03, $71, $01, $01, $7f, $41, $8f, $73, $f1, $51, $01, $21, $ff, $ff, $ff, $ff
    FontData_83:
        .byte $ff, $c1, $00, $18, $3c, $00, $3f, $01, $00, $38, $c0, $00, $1f, $30, $e7, $38, $fc, $34, $24, $08, $ff, $ff, $ff, $ff
    FontData_84:
        .byte $ff, $e0, $c0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $e0, $c0, $c7, $cc, $f9, $ce, $ff, $c9, $c9, $c6, $ff, $ff, $ff, $ff
    FontData_85:
        .byte $ff, $f8, $f0, $e3, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $f0, $e3, $e3, $fc, $e3, $ff, $e2, $e0, $e1, $ff, $ff, $ff, $ff
    FontData_86:
        .byte $ff, $0f, $07, $e3, $e3, $03, $ff, $0f, $07, $e3, $03, $03, $ff, $83, $1f, $e7, $e3, $a3, $03, $43, $ff, $ff, $ff, $ff
    FontData_87:
        .byte $ff, $f8, $e0, $e3, $e7, $e0, $e7, $e0, $e0, $e7, $f8, $e0, $e3, $e6, $fc, $e7, $ff, $e6, $e4, $e1, $ff, $ff, $ff, $ff
    FontData_88:
        .byte $ff, $1f, $07, $c7, $e7, $07, $ff, $1f, $07, $c7, $07, $07, $ff, $87, $3f, $c7, $e7, $27, $27, $c7, $ff, $ff, $ff, $ff
    FontData_89:
        .byte $ff, $07, $03, $71, $79, $01, $7f, $07, $03, $71, $01, $01, $7f, $61, $8f, $73, $f9, $59, $09, $21, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_90:
        .byte $ff, $c1, $80, $1c, $1c, $00, $1f, $01, $00, $1c, $c0, $80, $1f, $10, $e3, $1c, $fc, $14, $00, $08, $ff, $ff, $ff, $ff
    FontData_91:
        .byte $ff, $f0, $e0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $f0, $e0, $c7, $cc, $f9, $ce, $ff, $cd, $c9, $c2, $ff, $ff, $ff, $ff
    FontData_92:
        .byte $ff, $3f, $0f, $8f, $cf, $0f, $ff, $3f, $0f, $8f, $0f, $0f, $ff, $0f, $7f, $8f, $cf, $4f, $4f, $8f, $ff, $ff, $ff, $ff
    FontData_93:
        .byte $ff, $e0, $80, $8c, $9e, $80, $9f, $80, $80, $9c, $e0, $80, $8f, $98, $f3, $9c, $fe, $9a, $92, $84, $ff, $ff, $ff, $ff
    FontData_94:
        .byte $ff, $3f, $1f, $0f, $8f, $0f, $ff, $3f, $1f, $0f, $0f, $0f, $ff, $0f, $ff, $1f, $8f, $8f, $8f, $0f, $ff, $ff, $ff, $ff
    FontData_95:
        .byte $ff, $0f, $07, $c3, $e3, $03, $ff, $0f, $07, $c3, $03, $03, $ff, $83, $3f, $c7, $e3, $a3, $23, $43, $ff, $ff, $ff, $ff
    FontData_96:
        .byte $ff, $83, $01, $30, $78, $00, $7f, $03, $01, $70, $80, $00, $3f, $60, $cf, $71, $f8, $68, $48, $10, $ff, $ff, $ff, $ff
    FontData_97:
        .byte $ff, $83, $00, $38, $3c, $00, $3f, $03, $00, $38, $80, $00, $3f, $30, $c7, $38, $fc, $2c, $04, $10, $ff, $ff, $ff, $ff
    FontData_98:
        .byte $ff, $e0, $c0, $86, $8f, $80, $8f, $80, $80, $8e, $e0, $c0, $87, $8c, $f9, $8e, $ff, $89, $89, $86, $ff, $ff, $ff, $ff
    FontData_99:
        .byte $ff, $1f, $0f, $87, $c7, $07, $ff, $1f, $0f, $87, $07, $07, $ff, $07, $7f, $8f, $c7, $47, $47, $87, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_100:
        .byte $ff, $07, $03, $71, $f1, $01, $ff, $07, $03, $f1, $01, $01, $7f, $c1, $8f, $f3, $f1, $d1, $81, $21, $ff, $ff, $ff, $ff
    FontData_101:
        .byte $ff, $fc, $f8, $f0, $f1, $f0, $f1, $f0, $f0, $f1, $fc, $f8, $f0, $f1, $ff, $f1, $ff, $f1, $f1, $f0, $ff, $ff, $ff, $ff
    FontData_102:
        .byte $ff, $1f, $07, $c7, $e7, $07, $ff, $1f, $07, $c7, $07, $07, $ff, $87, $3f, $c7, $e7, $67, $27, $87, $ff, $ff, $ff, $ff
    FontData_103:
        .byte $ff, $03, $01, $31, $79, $01, $7f, $03, $01, $71, $01, $01, $3f, $61, $cf, $71, $f9, $49, $49, $31, $ff, $ff, $ff, $ff
    FontData_104:
        .byte $ff, $e0, $c0, $8e, $8f, $80, $8f, $80, $80, $8e, $e0, $c0, $8f, $8c, $f1, $8e, $ff, $8b, $81, $84, $ff, $ff, $ff, $ff
    FontData_105:
        .byte $ff, $f8, $f0, $e1, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $f0, $e1, $e3, $fe, $e3, $ff, $e2, $e2, $e1, $ff, $ff, $ff, $ff
    FontData_106:
        .byte $ff, $3f, $0f, $8f, $cf, $0f, $ff, $3f, $0f, $8f, $0f, $0f, $ff, $0f, $7f, $8f, $cf, $cf, $4f, $0f, $ff, $ff, $ff, $ff
    FontData_107:
        .byte $ff, $07, $03, $63, $f3, $03, $ff, $07, $03, $e3, $03, $03, $7f, $c3, $9f, $e3, $f3, $93, $93, $63, $ff, $ff, $ff, $ff
    FontData_108:
        .byte $ff, $f0, $e0, $c7, $cf, $c0, $cf, $c0, $c0, $cf, $f0, $e0, $c7, $cc, $f8, $cf, $ff, $cd, $c8, $c2, $ff, $ff, $ff, $ff
    FontData_109:
        .byte $ff, $07, $01, $71, $79, $01, $7f, $07, $01, $71, $01, $01, $7f, $61, $8f, $71, $f9, $59, $09, $21, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_110:
        .byte $ff, $c1, $80, $0c, $1e, $00, $1f, $01, $00, $1c, $c0, $80, $0f, $18, $f3, $1c, $fe, $12, $12, $0c, $ff, $ff, $ff, $ff
    FontData_111:
        .byte $ff, $07, $03, $61, $f1, $01, $ff, $07, $03, $e1, $01, $01, $7f, $c1, $9f, $e3, $f1, $d1, $91, $21, $ff, $ff, $ff, $ff
    FontData_112:
        .byte $ff, $c1, $80, $1c, $1e, $00, $1f, $01, $00, $1c, $c0, $80, $1f, $18, $e3, $1c, $fe, $16, $02, $08, $ff, $ff, $ff, $ff
    FontData_113:
        .byte $ff, $f0, $e0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c3, $c6, $fc, $c7, $ff, $c4, $c4, $c3, $ff, $ff, $ff, $ff
    FontData_114:
        .byte $ff, $f0, $c0, $c6, $cf, $c0, $cf, $c0, $c0, $ce, $f0, $c0, $c7, $cc, $f9, $ce, $ff, $cd, $c9, $c2, $ff, $ff, $ff, $ff
    FontData_115:
        .byte $ff, $1f, $0f, $c7, $e7, $07, $ff, $1f, $0f, $c7, $07, $07, $ff, $87, $3f, $cf, $e7, $67, $27, $87, $ff, $ff, $ff, $ff
    FontData_116:
        .byte $ff, $f8, $f0, $f1, $f3, $f0, $f3, $f0, $f0, $f3, $f8, $f0, $f1, $f3, $fe, $f3, $ff, $f2, $f2, $f1, $ff, $ff, $ff, $ff
    FontData_117:
        .byte $ff, $0f, $03, $e3, $f3, $03, $ff, $0f, $03, $e3, $03, $03, $ff, $c3, $1f, $e3, $f3, $b3, $13, $43, $ff, $ff, $ff, $ff
    FontData_118:
        .byte $ff, $81, $00, $18, $3c, $00, $3f, $01, $00, $38, $80, $00, $1f, $30, $e7, $38, $fc, $24, $24, $18, $ff, $ff, $ff, $ff
    FontData_119:
        .byte $ff, $f0, $e0, $c7, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c7, $c4, $f8, $c7, $ff, $c5, $c0, $c2, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_120:
        .byte $ff, $83, $01, $38, $78, $00, $7f, $03, $01, $78, $80, $00, $3f, $60, $c7, $79, $f8, $68, $40, $10, $ff, $ff, $ff, $ff
    FontData_121:
        .byte $ff, $03, $01, $30, $78, $00, $7f, $03, $01, $70, $00, $00, $3f, $60, $cf, $71, $f8, $48, $48, $30, $ff, $ff, $ff, $ff
    FontData_122:
        .byte $ff, $fc, $f0, $f1, $f3, $f0, $f3, $f0, $f0, $f3, $fc, $f0, $f1, $f3, $fe, $f3, $ff, $f3, $f2, $f0, $ff, $ff, $ff, $ff
    FontData_123:
        .byte $ff, $e0, $80, $8e, $9e, $80, $9f, $80, $80, $9e, $e0, $80, $8f, $98, $f1, $9e, $fe, $9a, $90, $84, $ff, $ff, $ff, $ff
    FontData_124:
        .byte $ff, $f8, $e0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f8, $e0, $c3, $c6, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_125:
        .byte $ff, $07, $03, $61, $f1, $01, $ff, $07, $03, $e1, $01, $01, $7f, $c1, $9f, $e3, $f1, $91, $91, $61, $ff, $ff, $ff, $ff
    FontData_126:
        .byte $ff, $c0, $80, $0e, $1e, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $18, $f1, $1e, $fe, $1a, $10, $04, $ff, $ff, $ff, $ff
    FontData_127:
        .byte $ff, $83, $00, $38, $7c, $00, $7f, $03, $00, $78, $80, $00, $3f, $60, $c7, $78, $fc, $6c, $44, $10, $ff, $ff, $ff, $ff
    FontData_128:
        .byte $ff, $f0, $c0, $c7, $cf, $c0, $cf, $c0, $c0, $cf, $f0, $c0, $c7, $cc, $f8, $cf, $ff, $cd, $c8, $c2, $ff, $ff, $ff, $ff
    FontData_129:
        .byte $ff, $0f, $07, $c3, $e3, $03, $ff, $0f, $07, $c3, $03, $03, $ff, $83, $3f, $c7, $e3, $23, $23, $c3, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_130:
        .byte $ff, $0f, $03, $e3, $e3, $03, $ff, $0f, $03, $e3, $03, $03, $ff, $83, $1f, $e3, $e3, $a3, $03, $43, $ff, $ff, $ff, $ff
    FontData_131:
        .byte $ff, $ff, $3f, $1f, $1f, $1f, $ff, $ff, $3f, $1f, $1f, $1f, $ff, $1f, $ff, $3f, $1f, $1f, $1f, $1f, $ff, $ff, $ff, $ff
    FontData_132:
        .byte $ff, $1f, $07, $c3, $e3, $03, $ff, $1f, $07, $c3, $03, $03, $ff, $83, $3f, $c7, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_133:
        .byte $ff, $7f, $1f, $0f, $8f, $0f, $ff, $7f, $1f, $0f, $0f, $0f, $ff, $0f, $ff, $1f, $8f, $8f, $8f, $0f, $ff, $ff, $ff, $ff
    FontData_134:
        .byte $ff, $0f, $03, $e1, $f1, $01, $ff, $0f, $03, $e1, $01, $01, $ff, $c1, $1f, $e3, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_135:
        .byte $ff, $3f, $0f, $87, $c7, $07, $ff, $3f, $0f, $87, $07, $07, $ff, $07, $7f, $8f, $c7, $c7, $47, $07, $ff, $ff, $ff, $ff
    FontData_136:
        .byte $ff, $c0, $80, $0c, $1e, $00, $1f, $00, $00, $1c, $c0, $80, $0f, $18, $f3, $1c, $fe, $12, $12, $0c, $ff, $ff, $ff, $ff
    FontData_137:
        .byte $ff, $81, $00, $1c, $3c, $00, $3f, $01, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fc, $34, $20, $08, $ff, $ff, $ff, $ff
    FontData_138:
        .byte $ff, $07, $01, $70, $78, $00, $7f, $07, $01, $70, $00, $00, $7f, $60, $8f, $71, $f8, $58, $08, $20, $ff, $ff, $ff, $ff
    FontData_139:
        .byte $ff, $e0, $c0, $8e, $8f, $80, $8f, $80, $80, $8e, $e0, $c0, $8f, $8c, $f1, $8e, $ff, $89, $81, $86, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_140:
        .byte $ff, $c1, $00, $1c, $3e, $00, $3f, $01, $00, $3c, $c0, $00, $1f, $30, $e3, $3c, $fe, $36, $22, $08, $ff, $ff, $ff, $ff
    FontData_141:
        .byte $ff, $f8, $e0, $e3, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $e0, $e3, $e3, $fc, $e3, $ff, $e2, $e0, $e1, $ff, $ff, $ff, $ff
    FontData_142:
        .byte $ff, $03, $01, $70, $78, $00, $7f, $03, $01, $70, $00, $00, $7f, $60, $8f, $71, $f8, $48, $08, $30, $ff, $ff, $ff, $ff
    FontData_143:
        .byte $ff, $e0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $c0, $87, $8c, $f8, $8f, $ff, $89, $88, $86, $ff, $ff, $ff, $ff
    FontData_144:
        .byte $ff, $fc, $f0, $e1, $e3, $e0, $e3, $e0, $e0, $e3, $fc, $f0, $e1, $e3, $fe, $e3, $ff, $e3, $e2, $e0, $ff, $ff, $ff, $ff
    FontData_145:
        .byte $ff, $1f, $07, $c7, $c7, $07, $ff, $1f, $07, $c7, $07, $07, $ff, $07, $3f, $c7, $c7, $47, $07, $87, $ff, $ff, $ff, $ff
    FontData_146:
        .byte $ff, $81, $00, $38, $3c, $00, $3f, $01, $00, $38, $80, $00, $3f, $30, $c7, $38, $fc, $2c, $04, $10, $ff, $ff, $ff, $ff
    FontData_147:
        .byte $ff, $07, $01, $71, $f9, $01, $ff, $07, $01, $f1, $01, $01, $7f, $e1, $8f, $f1, $f9, $d9, $89, $21, $ff, $ff, $ff, $ff
    FontData_148:
        .byte $ff, $0f, $03, $e3, $f3, $03, $ff, $0f, $03, $e3, $03, $03, $ff, $83, $1f, $e3, $f3, $b3, $13, $43, $ff, $ff, $ff, $ff
    FontData_149:
        .byte $ff, $81, $00, $1c, $3c, $00, $3f, $01, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fc, $24, $20, $18, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_150:
        .byte $ff, $1f, $0f, $87, $c7, $07, $ff, $1f, $0f, $87, $07, $07, $ff, $07, $7f, $8f, $c7, $c7, $47, $07, $ff, $ff, $ff, $ff
    FontData_151:
        .byte $ff, $03, $00, $38, $78, $00, $7f, $03, $00, $78, $00, $00, $3f, $60, $c7, $78, $f8, $68, $40, $10, $ff, $ff, $ff, $ff
    FontData_152:
        .byte $ff, $f0, $e0, $c7, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c7, $c6, $f8, $c7, $ff, $c4, $c0, $c3, $ff, $ff, $ff, $ff
    FontData_153:
        .byte $ff, $ff, $fc, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $ff, $fc, $f8, $f8, $ff, $f8, $ff, $f8, $f8, $f8, $ff, $ff, $ff, $ff
    FontData_154:
        .byte $ff, $07, $01, $71, $f9, $01, $ff, $07, $01, $f1, $01, $01, $7f, $c1, $8f, $f1, $f9, $d9, $89, $21, $ff, $ff, $ff, $ff
    FontData_155:
        .byte $ff, $e0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $c0, $87, $8c, $f8, $8f, $ff, $8d, $88, $82, $ff, $ff, $ff, $ff
    FontData_156:
        .byte $ff, $7f, $1f, $1f, $1f, $1f, $ff, $7f, $1f, $1f, $1f, $1f, $ff, $1f, $ff, $1f, $1f, $1f, $1f, $1f, $ff, $ff, $ff, $ff
    FontData_157:
        .byte $ff, $07, $03, $e1, $f1, $01, $ff, $07, $03, $e1, $01, $01, $ff, $c1, $1f, $e3, $f1, $91, $11, $61, $ff, $ff, $ff, $ff
    FontData_158:
        .byte $ff, $e0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $e0, $80, $0f, $18, $f1, $1e, $ff, $1b, $11, $04, $ff, $ff, $ff, $ff
    FontData_159:
        .byte $ff, $c0, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $c0, $00, $1f, $38, $e3, $3c, $fe, $36, $22, $08, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_160:
        .byte $ff, $f0, $e0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c3, $c6, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_161:
        .byte $ff, $f8, $e0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f8, $e0, $c3, $c7, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_162:
        .byte $ff, $f0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $f0, $c0, $87, $8e, $f8, $8f, $ff, $8d, $88, $82, $ff, $ff, $ff, $ff
    FontData_163:
        .byte $ff, $07, $01, $71, $f1, $01, $ff, $07, $01, $f1, $01, $01, $7f, $c1, $8f, $f1, $f1, $91, $81, $61, $ff, $ff, $ff, $ff
    FontData_164:
        .byte $ff, $07, $03, $e1, $f1, $01, $ff, $07, $03, $e1, $01, $01, $ff, $c1, $1f, $e3, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_165:
        .byte $ff, $0f, $03, $e3, $e3, $03, $ff, $0f, $03, $e3, $03, $03, $ff, $83, $1f, $e3, $e3, $23, $03, $c3, $ff, $ff, $ff, $ff
    FontData_166:
        .byte $ff, $fc, $f0, $f1, $f1, $f0, $f1, $f0, $f0, $f1, $fc, $f0, $f1, $f1, $fe, $f1, $ff, $f1, $f0, $f0, $ff, $ff, $ff, $ff
    FontData_167:
        .byte $ff, $03, $01, $70, $f8, $00, $ff, $03, $01, $f0, $00, $00, $7f, $e0, $8f, $f1, $f8, $d8, $88, $20, $ff, $ff, $ff, $ff
    FontData_168:
        .byte $ff, $07, $01, $70, $f8, $00, $ff, $07, $01, $f0, $00, $00, $7f, $c0, $8f, $f1, $f8, $d8, $88, $20, $ff, $ff, $ff, $ff
    FontData_169:
        .byte $ff, $c0, $80, $0e, $1e, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $18, $f1, $1e, $fe, $12, $10, $0c, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_170:
        .byte $ff, $0f, $03, $e1, $f1, $01, $ff, $0f, $03, $e1, $01, $01, $ff, $81, $1f, $e3, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_171:
        .byte $ff, $c0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $18, $f1, $1e, $ff, $1b, $11, $04, $ff, $ff, $ff, $ff
    FontData_172:
        .byte $ff, $fe, $f8, $f0, $f1, $f0, $f1, $f0, $f0, $f1, $fe, $f8, $f0, $f1, $ff, $f1, $ff, $f1, $f1, $f0, $ff, $ff, $ff, $ff
    FontData_173:
        .byte $ff, $e0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $e0, $80, $0f, $1c, $f1, $1e, $ff, $19, $11, $06, $ff, $ff, $ff, $ff
    FontData_174:
        .byte $ff, $fe, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $fe, $f8, $f8, $f8, $ff, $f8, $ff, $f8, $f8, $f8, $ff, $ff, $ff, $ff
    FontData_175:
        .byte $ff, $e0, $80, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $80, $87, $8c, $f8, $8f, $ff, $89, $88, $86, $ff, $ff, $ff, $ff
    FontData_176:
        .byte $ff, $f0, $c0, $c7, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $c0, $c7, $c6, $f8, $c7, $ff, $c4, $c0, $c3, $ff, $ff, $ff, $ff
    FontData_177:
        .byte $ff, $03, $00, $78, $78, $00, $7f, $03, $00, $78, $00, $00, $7f, $60, $87, $78, $f8, $48, $00, $30, $ff, $ff, $ff, $ff
    FontData_178:
        .byte $ff, $3f, $0f, $8f, $8f, $0f, $ff, $3f, $0f, $8f, $0f, $0f, $ff, $0f, $7f, $8f, $8f, $8f, $0f, $0f, $ff, $ff, $ff, $ff
    FontData_179:
        .byte $ff, $03, $00, $38, $7c, $00, $7f, $03, $00, $78, $00, $00, $3f, $60, $c7, $78, $fc, $6c, $44, $10, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_180:
        .byte $ff, $81, $00, $38, $7c, $00, $7f, $01, $00, $78, $80, $00, $3f, $70, $c7, $78, $fc, $6c, $44, $10, $ff, $ff, $ff, $ff
    FontData_181:
        .byte $ff, $81, $00, $38, $3c, $00, $3f, $01, $00, $38, $80, $00, $3f, $30, $c7, $38, $fc, $24, $04, $18, $ff, $ff, $ff, $ff
    FontData_182:
        .byte $ff, $1f, $07, $c3, $c3, $03, $ff, $1f, $07, $c3, $03, $03, $ff, $03, $3f, $c7, $c3, $43, $03, $83, $ff, $ff, $ff, $ff
    FontData_183:
        .byte $ff, $80, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fe, $36, $22, $08, $ff, $ff, $ff, $ff
    FontData_184:
        .byte $ff, $fc, $f0, $e1, $e1, $e0, $e1, $e0, $e0, $e1, $fc, $f0, $e1, $e1, $fe, $e1, $ff, $e1, $e0, $e0, $ff, $ff, $ff, $ff
    FontData_185:
        .byte $ff, $07, $03, $e1, $f1, $01, $ff, $07, $03, $e1, $01, $01, $ff, $81, $1f, $e3, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_186:
        .byte $ff, $1f, $07, $87, $c7, $07, $ff, $1f, $07, $87, $07, $07, $ff, $07, $7f, $87, $c7, $47, $47, $87, $ff, $ff, $ff, $ff
    FontData_187:
        .byte $ff, $81, $00, $1c, $3e, $00, $3f, $01, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fe, $36, $22, $08, $ff, $ff, $ff, $ff
    FontData_188:
        .byte $ff, $0f, $07, $c3, $e3, $03, $ff, $0f, $07, $c3, $03, $03, $ff, $83, $3f, $c7, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_189:
        .byte $ff, $c0, $00, $1c, $1e, $00, $1f, $00, $00, $1c, $c0, $00, $1f, $18, $e3, $1c, $fe, $12, $02, $0c, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_190:
        .byte $ff, $01, $00, $38, $7c, $00, $7f, $01, $00, $78, $00, $00, $3f, $70, $c7, $78, $fc, $6c, $44, $10, $ff, $ff, $ff, $ff
    FontData_191:
        .byte $ff, $80, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $80, $00, $1f, $38, $e3, $3c, $fe, $36, $22, $08, $ff, $ff, $ff, $ff
    FontData_192:
        .byte $ff, $c0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $1c, $f1, $1e, $ff, $1b, $11, $04, $ff, $ff, $ff, $ff
    FontData_193:
        .byte $ff, $07, $01, $f1, $f1, $01, $ff, $07, $01, $f1, $01, $01, $ff, $c1, $0f, $f1, $f1, $91, $01, $61, $ff, $ff, $ff, $ff
    FontData_194:
        .byte $ff, $f0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $f0, $c0, $87, $8e, $f8, $8f, $ff, $8c, $88, $83, $ff, $ff, $ff, $ff
    FontData_195:
        .byte $ff, $03, $00, $38, $7c, $00, $7f, $03, $00, $78, $00, $00, $3f, $60, $c7, $78, $fc, $4c, $44, $30, $ff, $ff, $ff, $ff
    FontData_196:
        .byte $ff, $81, $00, $1c, $3e, $00, $3f, $01, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fe, $26, $22, $18, $ff, $ff, $ff, $ff
    FontData_197:
        .byte $ff, $c0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $18, $f1, $1e, $ff, $13, $11, $0c, $ff, $ff, $ff, $ff
    FontData_198:
        .byte $ff, $fc, $f0, $f0, $f1, $f0, $f1, $f0, $f0, $f1, $fc, $f0, $f0, $f1, $ff, $f1, $ff, $f1, $f1, $f0, $ff, $ff, $ff, $ff
    FontData_199:
        .byte $ff, $0f, $03, $e1, $f1, $01, $ff, $0f, $03, $e1, $01, $01, $ff, $81, $1f, $e3, $f1, $31, $11, $c1, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_200:
        .byte $ff, $f0, $c0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $c0, $c3, $c6, $fc, $c7, $ff, $c4, $c4, $c3, $ff, $ff, $ff, $ff
    FontData_201:
        .byte $ff, $f8, $f0, $e1, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $f0, $e1, $e3, $fe, $e3, $ff, $e3, $e2, $e0, $ff, $ff, $ff, $ff
    FontData_202:
        .byte $ff, $fe, $f8, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $fe, $f8, $f0, $f0, $ff, $f0, $ff, $f0, $f0, $f0, $ff, $ff, $ff, $ff
    FontData_203:
        .byte $ff, $3f, $0f, $0f, $8f, $0f, $ff, $3f, $0f, $0f, $0f, $0f, $ff, $0f, $ff, $0f, $8f, $8f, $8f, $0f, $ff, $ff, $ff, $ff
    FontData_204:
        .byte $ff, $f8, $e0, $e1, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $e0, $e1, $e3, $fe, $e3, $ff, $e2, $e2, $e1, $ff, $ff, $ff, $ff
    FontData_205:
        .byte $ff, $1f, $07, $c3, $e3, $03, $ff, $1f, $07, $c3, $03, $03, $ff, $03, $3f, $c7, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_206:
        .byte $ff, $f0, $e0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $e0, $c3, $c7, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_207:
        .byte $ff, $f8, $e0, $c3, $c3, $c0, $c3, $c0, $c0, $c3, $f8, $e0, $c3, $c3, $fc, $c3, $ff, $c2, $c0, $c1, $ff, $ff, $ff, $ff
    FontData_208:
        .byte $ff, $c0, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $c0, $00, $1f, $38, $e3, $3c, $fe, $32, $22, $0c, $ff, $ff, $ff, $ff
    FontData_209:
        .byte $ff, $01, $00, $38, $7c, $00, $7f, $01, $00, $78, $00, $00, $3f, $60, $c7, $78, $fc, $6c, $44, $10, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_210:
        .byte $ff, $c0, $00, $1e, $1e, $00, $1f, $00, $00, $1e, $c0, $00, $1f, $18, $e1, $1e, $fe, $12, $00, $0c, $ff, $ff, $ff, $ff
    FontData_211:
        .byte $ff, $07, $01, $e1, $f1, $01, $ff, $07, $01, $e1, $01, $01, $ff, $c1, $1f, $e1, $f1, $91, $11, $61, $ff, $ff, $ff, $ff
    FontData_212:
        .byte $ff, $f0, $c0, $87, $87, $80, $87, $80, $80, $87, $f0, $c0, $87, $86, $f8, $87, $ff, $84, $80, $83, $ff, $ff, $ff, $ff
    FontData_213:
        .byte $ff, $3f, $0f, $87, $87, $07, $ff, $3f, $0f, $87, $07, $07, $ff, $07, $7f, $8f, $87, $87, $07, $07, $ff, $ff, $ff, $ff
    FontData_214:
        .byte $ff, $81, $00, $38, $7c, $00, $7f, $01, $00, $78, $80, $00, $3f, $70, $c7, $78, $fc, $64, $44, $18, $ff, $ff, $ff, $ff
    FontData_215:
        .byte $ff, $03, $01, $70, $f8, $00, $ff, $03, $01, $f0, $00, $00, $7f, $c0, $8f, $f1, $f8, $d8, $88, $20, $ff, $ff, $ff, $ff
    FontData_216:
        .byte $ff, $81, $00, $3c, $3c, $00, $3f, $01, $00, $3c, $80, $00, $3f, $30, $c3, $3c, $fc, $24, $00, $18, $ff, $ff, $ff, $ff
    FontData_217:
        .byte $ff, $0f, $03, $c1, $e1, $01, $ff, $0f, $03, $c1, $01, $01, $ff, $81, $3f, $c3, $e1, $21, $21, $c1, $ff, $ff, $ff, $ff
    FontData_218:
        .byte $ff, $e0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $c0, $87, $8e, $f8, $8f, $ff, $8d, $88, $82, $ff, $ff, $ff, $ff
    FontData_219:
        .byte $ff, $0f, $03, $c3, $e3, $03, $ff, $0f, $03, $c3, $03, $03, $ff, $83, $3f, $c3, $e3, $23, $23, $c3, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_220:
        .byte $ff, $c0, $80, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $80, $0f, $1c, $f1, $1e, $ff, $19, $11, $06, $ff, $ff, $ff, $ff
    FontData_221:
        .byte $ff, $03, $00, $70, $f8, $00, $ff, $03, $00, $f0, $00, $00, $7f, $e0, $8f, $f0, $f8, $c8, $88, $30, $ff, $ff, $ff, $ff
    FontData_222:
        .byte $ff, $0f, $03, $e1, $e1, $01, $ff, $0f, $03, $e1, $01, $01, $ff, $81, $1f, $e3, $e1, $21, $01, $c1, $ff, $ff, $ff, $ff
    FontData_223:
        .byte $ff, $e0, $80, $0f, $0f, $00, $0f, $00, $00, $0f, $e0, $80, $0f, $0c, $f0, $0f, $ff, $09, $00, $06, $ff, $ff, $ff, $ff
    FontData_224:
        .byte $ff, $03, $00, $78, $7c, $00, $7f, $03, $00, $78, $00, $00, $7f, $60, $87, $78, $fc, $4c, $04, $30, $ff, $ff, $ff, $ff
    FontData_225:
        .byte $ff, $c0, $00, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $00, $0f, $18, $f1, $1e, $ff, $13, $11, $0c, $ff, $ff, $ff, $ff
    FontData_226:
        .byte $ff, $07, $01, $70, $f8, $00, $ff, $07, $01, $f0, $00, $00, $7f, $c0, $8f, $f1, $f8, $98, $88, $60, $ff, $ff, $ff, $ff
    FontData_227:
        .byte $ff, $c0, $00, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $00, $0f, $18, $f1, $1e, $ff, $1b, $11, $04, $ff, $ff, $ff, $ff
    FontData_228:
        .byte $ff, $03, $00, $70, $f8, $00, $ff, $03, $00, $f0, $00, $00, $7f, $e0, $8f, $f0, $f8, $d8, $88, $20, $ff, $ff, $ff, $ff
    FontData_229:
        .byte $ff, $1f, $07, $83, $c3, $03, $ff, $1f, $07, $83, $03, $03, $ff, $03, $7f, $87, $c3, $43, $43, $83, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_230:
        .byte $ff, $f0, $c0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $c0, $c3, $c6, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_231:
        .byte $ff, $80, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $80, $00, $1f, $30, $e3, $3c, $fe, $26, $22, $18, $ff, $ff, $ff, $ff
    FontData_232:
        .byte $ff, $e0, $80, $07, $0f, $00, $0f, $00, $00, $0f, $e0, $80, $07, $0c, $f8, $0f, $ff, $09, $08, $06, $ff, $ff, $ff, $ff
    FontData_233:
        .byte $ff, $07, $01, $e1, $f1, $01, $ff, $07, $01, $e1, $01, $01, $ff, $c1, $1f, $e1, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_234:
        .byte $ff, $f0, $c0, $83, $87, $80, $87, $80, $80, $87, $f0, $c0, $83, $86, $fc, $87, $ff, $84, $84, $83, $ff, $ff, $ff, $ff
    FontData_235:
        .byte $ff, $07, $01, $f0, $f0, $00, $ff, $07, $01, $f0, $00, $00, $ff, $c0, $0f, $f1, $f0, $90, $00, $60, $ff, $ff, $ff, $ff
    FontData_236:
        .byte $ff, $03, $00, $78, $fc, $00, $ff, $03, $00, $f8, $00, $00, $7f, $e0, $87, $f8, $fc, $cc, $84, $30, $ff, $ff, $ff, $ff
    FontData_237:
        .byte $ff, $f8, $e0, $e1, $e3, $e0, $e3, $e0, $e0, $e3, $f8, $e0, $e1, $e3, $fe, $e3, $ff, $e3, $e2, $e0, $ff, $ff, $ff, $ff
    FontData_238:
        .byte $ff, $0f, $03, $c3, $e3, $03, $ff, $0f, $03, $c3, $03, $03, $ff, $83, $3f, $c3, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_239:
        .byte $ff, $81, $00, $3c, $3e, $00, $3f, $01, $00, $3c, $80, $00, $3f, $30, $c3, $3c, $fe, $26, $02, $18, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_240:
        .byte $ff, $80, $00, $1c, $3e, $00, $3f, $00, $00, $3c, $80, $00, $1f, $38, $e3, $3c, $fe, $32, $22, $0c, $ff, $ff, $ff, $ff
    FontData_241:
        .byte $ff, $03, $01, $70, $f8, $00, $ff, $03, $01, $f0, $00, $00, $7f, $c0, $8f, $f1, $f8, $98, $88, $60, $ff, $ff, $ff, $ff
    FontData_242:
        .byte $ff, $f8, $e0, $c1, $c3, $c0, $c3, $c0, $c0, $c3, $f8, $e0, $c1, $c3, $fe, $c3, $ff, $c2, $c2, $c1, $ff, $ff, $ff, $ff
    FontData_243:
        .byte $ff, $0f, $07, $c3, $e3, $03, $ff, $0f, $07, $c3, $03, $03, $ff, $03, $3f, $c7, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_244:
        .byte $ff, $c0, $80, $0f, $1f, $00, $1f, $00, $00, $1f, $c0, $80, $0f, $1c, $f0, $1f, $ff, $19, $10, $06, $ff, $ff, $ff, $ff
    FontData_245:
        .byte $ff, $7f, $1f, $0f, $0f, $0f, $ff, $7f, $1f, $0f, $0f, $0f, $ff, $0f, $ff, $1f, $0f, $0f, $0f, $0f, $ff, $ff, $ff, $ff
    FontData_246:
        .byte $ff, $f0, $c0, $c3, $c7, $c0, $c7, $c0, $c0, $c7, $f0, $c0, $c3, $c7, $fc, $c7, $ff, $c6, $c4, $c1, $ff, $ff, $ff, $ff
    FontData_247:
        .byte $ff, $1f, $07, $83, $c3, $03, $ff, $1f, $07, $83, $03, $03, $ff, $03, $7f, $87, $c3, $c3, $43, $03, $ff, $ff, $ff, $ff
    FontData_248:
        .byte $ff, $c0, $00, $1e, $1f, $00, $1f, $00, $00, $1e, $c0, $00, $1f, $18, $e1, $1e, $ff, $13, $01, $0c, $ff, $ff, $ff, $ff
    FontData_249:
        .byte $ff, $03, $00, $78, $f8, $00, $ff, $03, $00, $f8, $00, $00, $7f, $e0, $87, $f8, $f8, $c8, $80, $30, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_250:
        .byte $ff, $0f, $03, $c1, $e1, $01, $ff, $0f, $03, $c1, $01, $01, $ff, $81, $3f, $c3, $e1, $61, $21, $81, $ff, $ff, $ff, $ff
    FontData_251:
        .byte $ff, $01, $00, $3c, $7c, $00, $7f, $01, $00, $7c, $00, $00, $3f, $70, $c3, $7c, $fc, $64, $40, $18, $ff, $ff, $ff, $ff
    FontData_252:
        .byte $ff, $c0, $00, $1e, $3f, $00, $3f, $00, $00, $3e, $c0, $00, $1f, $38, $e1, $3e, $ff, $33, $21, $0c, $ff, $ff, $ff, $ff
    FontData_253:
        .byte $ff, $e0, $80, $0f, $1f, $00, $1f, $00, $00, $1f, $e0, $80, $0f, $1c, $f0, $1f, $ff, $19, $10, $06, $ff, $ff, $ff, $ff
    FontData_254:
        .byte $ff, $01, $00, $38, $7c, $00, $7f, $01, $00, $78, $00, $00, $3f, $70, $c7, $78, $fc, $64, $44, $18, $ff, $ff, $ff, $ff
    FontData_255:
        .byte $ff, $fc, $f0, $e0, $e1, $e0, $e1, $e0, $e0, $e1, $fc, $f0, $e0, $e1, $ff, $e1, $ff, $e1, $e1, $e0, $ff, $ff, $ff, $ff
    FontData_256:
        .byte $ff, $07, $03, $e1, $f1, $01, $ff, $07, $03, $e1, $01, $01, $ff, $81, $1f, $e3, $f1, $31, $11, $c1, $ff, $ff, $ff, $ff
    FontData_257:
        .byte $ff, $e0, $80, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $80, $87, $8e, $f8, $8f, $ff, $8d, $88, $82, $ff, $ff, $ff, $ff
    FontData_258:
        .byte $ff, $3f, $0f, $07, $87, $07, $ff, $3f, $0f, $07, $07, $07, $ff, $07, $ff, $0f, $87, $87, $87, $07, $ff, $ff, $ff, $ff
    FontData_259:
        .byte $ff, $03, $01, $f0, $f8, $00, $ff, $03, $01, $f0, $00, $00, $ff, $c0, $0f, $f1, $f8, $98, $08, $60, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_260:
        .byte $ff, $07, $01, $e1, $f1, $01, $ff, $07, $01, $e1, $01, $01, $ff, $81, $1f, $e1, $f1, $b1, $11, $41, $ff, $ff, $ff, $ff
    FontData_261:
        .byte $ff, $f0, $c0, $83, $87, $80, $87, $80, $80, $87, $f0, $c0, $83, $86, $fc, $87, $ff, $86, $84, $81, $ff, $ff, $ff, $ff
    FontData_262:
        .byte $ff, $1f, $07, $87, $c7, $07, $ff, $1f, $07, $87, $07, $07, $ff, $07, $7f, $87, $c7, $c7, $47, $07, $ff, $ff, $ff, $ff
    FontData_263:
        .byte $ff, $e0, $80, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $80, $87, $8e, $f8, $8f, $ff, $8c, $88, $83, $ff, $ff, $ff, $ff
    FontData_264:
        .byte $ff, $c0, $00, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $00, $0f, $1c, $f1, $1e, $ff, $1b, $11, $04, $ff, $ff, $ff, $ff
    FontData_265:
        .byte $ff, $07, $01, $e0, $f0, $00, $ff, $07, $01, $e0, $00, $00, $ff, $c0, $1f, $e1, $f0, $b0, $10, $40, $ff, $ff, $ff, $ff
    FontData_266:
        .byte $ff, $01, $00, $38, $7c, $00, $7f, $01, $00, $78, $00, $00, $3f, $60, $c7, $78, $fc, $4c, $44, $30, $ff, $ff, $ff, $ff
    FontData_267:
        .byte $ff, $e0, $80, $07, $0f, $00, $0f, $00, $00, $0f, $e0, $80, $07, $0e, $f8, $0f, $ff, $0d, $08, $02, $ff, $ff, $ff, $ff
    FontData_268:
        .byte $ff, $e0, $c0, $87, $8f, $80, $8f, $80, $80, $8f, $e0, $c0, $87, $8e, $f8, $8f, $ff, $8c, $88, $83, $ff, $ff, $ff, $ff
    FontData_269:
        .byte $ff, $01, $00, $78, $7c, $00, $7f, $01, $00, $78, $00, $00, $7f, $60, $87, $78, $fc, $4c, $04, $30, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_270:
        .byte $ff, $07, $01, $e1, $f1, $01, $ff, $07, $01, $e1, $01, $01, $ff, $81, $1f, $e1, $f1, $31, $11, $c1, $ff, $ff, $ff, $ff
    FontData_271:
        .byte $ff, $f0, $c0, $83, $87, $80, $87, $80, $80, $87, $f0, $c0, $83, $87, $fc, $87, $ff, $86, $84, $81, $ff, $ff, $ff, $ff
    FontData_272:
        .byte $ff, $c0, $00, $0e, $1f, $00, $1f, $00, $00, $1e, $c0, $00, $0f, $1c, $f1, $1e, $ff, $19, $11, $06, $ff, $ff, $ff, $ff
    FontData_273:
        .byte $ff, $07, $01, $f0, $f8, $00, $ff, $07, $01, $f0, $00, $00, $ff, $c0, $0f, $f1, $f8, $98, $08, $60, $ff, $ff, $ff, $ff
    FontData_274:
        .byte $ff, $80, $00, $3c, $3e, $00, $3f, $00, $00, $3c, $80, $00, $3f, $30, $c3, $3c, $fe, $26, $02, $18, $ff, $ff, $ff, $ff
    FontData_275:
        .byte $ff, $03, $00, $70, $f8, $00, $ff, $03, $00, $f0, $00, $00, $7f, $c0, $8f, $f0, $f8, $98, $88, $60, $ff, $ff, $ff, $ff
    FontData_276:
        .byte $ff, $0f, $03, $c1, $e1, $01, $ff, $0f, $03, $c1, $01, $01, $ff, $01, $3f, $c3, $e1, $61, $21, $81, $ff, $ff, $ff, $ff
    FontData_277:
        .byte $ff, $80, $00, $1e, $3e, $00, $3f, $00, $00, $3e, $80, $00, $1f, $38, $e1, $3e, $fe, $32, $20, $0c, $ff, $ff, $ff, $ff
    FontData_278:
        .byte $ff, $01, $00, $78, $fc, $00, $ff, $01, $00, $f8, $00, $00, $7f, $e0, $87, $f8, $fc, $cc, $84, $30, $ff, $ff, $ff, $ff
    FontData_279:
        .byte $ff, $80, $00, $3c, $7e, $00, $7f, $00, $00, $7c, $80, $00, $3f, $70, $c3, $7c, $fe, $66, $42, $18, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_280:
        .byte $ff, $f8, $e0, $c1, $c3, $c0, $c3, $c0, $c0, $c3, $f8, $e0, $c1, $c3, $fe, $c3, $ff, $c3, $c2, $c0, $ff, $ff, $ff, $ff
    FontData_281:
        .byte $ff, $07, $01, $e0, $f0, $00, $ff, $07, $01, $e0, $00, $00, $ff, $80, $1f, $e1, $f0, $30, $10, $c0, $ff, $ff, $ff, $ff
    FontData_282:
        .byte $ff, $00, $00, $3c, $7e, $00, $7f, $00, $00, $7c, $00, $00, $3f, $70, $c3, $7c, $fe, $66, $42, $18, $ff, $ff, $ff, $ff
    FontData_283:
        .byte $ff, $80, $00, $1e, $3f, $00, $3f, $00, $00, $3e, $80, $00, $1f, $38, $e1, $3e, $ff, $33, $21, $0c, $ff, $ff, $ff, $ff
    FontData_284:
        .byte $ff, $01, $00, $3c, $7e, $00, $7f, $01, $00, $7c, $00, $00, $3f, $70, $c3, $7c, $fe, $66, $42, $18, $ff, $ff, $ff, $ff
    FontData_285:
        .byte $ff, $03, $00, $70, $f8, $00, $ff, $03, $00, $f0, $00, $00, $7f, $c0, $8f, $f0, $f8, $d8, $88, $20, $ff, $ff, $ff, $ff
    FontData_286:
        .byte $ff, $e0, $80, $07, $0f, $00, $0f, $00, $00, $0f, $e0, $80, $07, $0c, $f8, $0f, $ff, $0d, $08, $02, $ff, $ff, $ff, $ff
    FontData_287:
        .byte $ff, $c0, $00, $0f, $1f, $00, $1f, $00, $00, $1f, $c0, $00, $0f, $1c, $f0, $1f, $ff, $19, $10, $06, $ff, $ff, $ff, $ff
    FontData_288:
        .byte $ff, $03, $00, $f0, $f8, $00, $ff, $03, $00, $f0, $00, $00, $ff, $c0, $0f, $f0, $f8, $98, $08, $60, $ff, $ff, $ff, $ff
    FontData_289:
        .byte $ff, $e0, $80, $07, $0f, $00, $0f, $00, $00, $0f, $e0, $80, $07, $0e, $f8, $0f, $ff, $0c, $08, $03, $ff, $ff, $ff, $ff
        .fill 16, $00
    FontData_290:
        .byte $ff, $0f, $03, $c3, $e3, $03, $ff, $0f, $03, $c3, $03, $03, $ff, $03, $3f, $c3, $e3, $63, $23, $83, $ff, $ff, $ff, $ff
    FontData_291:
        .byte $ff, $07, $01, $e0, $f0, $00, $ff, $07, $01, $e0, $00, $00, $ff, $80, $1f, $e1, $f0, $b0, $10, $40, $ff, $ff, $ff, $ff
    FontData_292:
        .byte $ff, $07, $01, $e0, $f0, $00, $ff, $07, $01, $e0, $00, $00, $ff, $c0, $1f, $e1, $f0, $90, $10, $60, $ff, $ff, $ff, $ff
    FontData_293:
        .byte $ff, $83, $01, $31, $39, $01, $3f, $03, $01, $31, $81, $01, $3f, $21, $cf, $31, $f9, $29, $09, $11, $ff, $ff, $ff, $ff
    FontData_294:
        .byte $ff, $e1, $c0, $8c, $8e, $80, $8f, $81, $80, $8c, $e0, $c0, $8f, $88, $f3, $8c, $fe, $8a, $82, $84, $ff, $ff, $ff, $ff
//;Total Size: 7544
