; Store this in pointer somewhere
scanlineIndexTable:
        .byte   $00,$00,$01,$03
; .align $100 ; so pointers work. 22*23/2=253 so this realistically will always work
scanlinePollTable:
        .byte   $F0
        .byte   $F0, $6E
        .byte   $F0, $42, $99