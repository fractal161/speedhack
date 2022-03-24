scheduleNextPoll:
; Index points to the current scanline.
;       adc subFrameTop
; Take mod subFrameBottom
; If 0, then indicate nmi poll should happen, disable interrupts
; Else, configure scanline counter
; At some point also say if there are no more polls so game loop knows to exit
        rts
scanlineIndexTable:
        .byte   $00,$00,$00,$01,$03,$06,$0A,$0F
        .byte   $15,$1C,$24,$2D,$37,$42,$4E,$5B
        .byte   $69,$78,$88,$99,$AB
scanlinePollTable:
        .byte   $76
        .byte   $4A, $A1
        .byte   $34, $76, $B7
        .byte   $27, $5B, $90, $C4
        .byte   $1E, $4A, $76, $A1, $CD
        .byte   $18, $3E, $63, $88, $AE, $D3
        .byte   $13, $34, $55, $76, $96, $B7, $D8
        .byte   $10, $2D, $4A, $67, $84, $A1, $BE, $DC
        .byte   $0D, $27, $41, $5B, $76, $90, $AA, $C4, $DE

; Starts with 120hz. First entry is -20 of what's expected because nmi
scanlineLengthTable:
        .byte   $77
        .byte   $4B, $56
        .byte   $35, $41, $40
        .byte   $28, $33, $34, $33
        .byte   $1F, $2B, $2B, $2A, $2B
        .byte   $19, $25, $24, $24, $25, $24
        .byte   $14, $20, $20, $20, $1F, $20, $20
        .byte   $11, $1C, $1C, $1C, $1C, $1C, $1C, $1D
        .byte   $0E, $19, $19, $19, $1A, $19, $19, $19, $19
        .byte   $0B, $17, $17, $17, $17, $17, $16, $17, $17, $17
        .byte   $09, $15, $15, $15, $15, $15, $14, $15, $15, $15, $15
        .byte   $08, $13, $13, $13, $13, $14, $13, $13, $13, $13, $13, $13
        .byte   $06, $12, $12, $12, $11, $12, $12, $11, $12, $12, $12, $11, $12
        .byte   $05, $11, $10, $11, $10, $10, $11, $10, $11, $10, $11, $10, $11, $10
        .byte   $04, $0F, $10, $0F, $10, $0F, $0F, $10, $0F, $0F, $10, $0F, $10, $0F, $0F
        .byte   $03, $0E, $0F, $0E, $0F, $0E, $0F, $0E, $0E, $0F, $0E, $0F, $0E, $0E, $0F, $0E
        .byte   $02, $0E, $0D, $0E, $0D, $0E, $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0D, $0E, $0E, $0D
        .byte   $01, $0D, $0D, $0D, $0D, $0C, $0D, $0D, $0D, $0D, $0C, $0D, $0D, $0D, $0C, $0D, $0D, $0D
        .byte   $01, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0D, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0D
