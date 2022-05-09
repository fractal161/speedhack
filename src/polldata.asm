; Store this in pointer somewhere
scanlineIndexTable:
        .byte   $00,$00,$01,$03,$06,$0A,$0F,$15,$1C,$24,$2D
.align $100 ; so pointers work. 22*23/2=253 so this realistically will always work
scanlinePollTable:
        .byte   $F1
        .byte   $F1, $6E
        .byte   $F1, $42, $9A
        .byte   $F1, $2D, $6E, $B0
        .byte   $F1, $20, $54, $88, $BD
        .byte   $F1, $17, $42, $6E, $9A, $C5
        .byte   $F1, $11, $36, $5B, $81, $A6, $CC
        .byte   $F1, $0C, $2D, $4D, $6E, $8F, $B0, $D0
        .byte   $F1, $08, $25, $42, $60, $7D, $9A, $B7, $D4
        .byte   $F1, $05, $20, $3A, $54, $6E, $88, $A3, $BD, $D7