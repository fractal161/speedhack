scheduleNextPoll:
; Index points to the current scanline.
;       adc subFrameTop
; Take mod subFrameBottom
; If 0, then indicate nmi poll should happen, disable interrupts
; Else, configure scanline counter
; At some point also say if there are no more polls so game loop knows to exit
        rts
; Store this in pointer somewhere
scanlineIndexTable:
        .byte   $00,$00,$00,$01,$03,$06,$0A,$0F
        .byte   $15,$1C,$24,$2D,$37,$42,$4E,$5B
        .byte   $69,$78,$88,$99,$AB
; Make sure this is aligned so pointer stuff works
scanlinePollTable:

