MENU_SIZE  = 4

; a is current value, restrict to interval [tmp1 ,tmp2)
restrictToRange:
        cmp     tmp1
        bmi     @tooLow
        cmp     tmp2
        bpl     @tooHigh
        rts
@tooLow:
        lda     tmp1
        rts
@tooHigh:
        dec     tmp2
        lda     tmp2
        rts

gameMode_levelMenu:
        inc     initRam
        jsr     updateAudio2
        lda     #$01
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
        jsr     bulkCopyToPpu
        .addr   menu_palette
        jsr     bulkCopyToPpu
        .addr   level_menu_nametable
;         lda     gameType
;         bne     @skipTypeBHeightDisplay
;         jsr     bulkCopyToPpu
;         .addr   height_menu_nametablepalette_patch
; @skipTypeBHeightDisplay:
        jsr     showHighScores
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$00
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging

gameMode_levelMenu_processPlayerNavigation:
        lda     newlyPressedButtons
        and     #$10
        beq     @notStart
        lda     #$00
        sta     gameModeState
        lda     #$02
        sta     soundEffectSlot1Init
        inc     gameMode
        rts
@notStart:
        jsr     gameMode_levelMenu_processConfigInput
        jsr     stageCursorSprites
        ; jsr     menuMusic
        lda     newlyPressedButtons
        cmp     #$20
        bne     @chooseRandomHole_1
        lda     #$02
        sta     soundEffectSlot1Init
        dec     gameMode
        rts

@chooseRandomHole_1:
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
        and     #$0F
        cmp     #$0A
        bpl     @chooseRandomHole_1
        sta     garbageHole
@chooseRandomHole_2:
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
        and     #$0F
        cmp     #$0A
        bpl     @chooseRandomHole_2
        sta     garbageHole
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jmp     gameMode_levelMenu_processPlayerNavigation

gameMode_levelMenu_processConfigInput:
; start with right
        lda     newlyPressedButtons
        cmp     #$01
        bne     @checkLeftPressed
        inc     menuX
        ldx     menuY
        lda     gameType
; since level select has more options with b-type height
        beq     @dontAddBTypeOffset
        txa
        clc
        adc     #MENU_SIZE
        tax
@dontAddBTypeOffset:
        lda     menuX
        cmp     menuOptionCount,x
        bcc     @inRange
        dec     menuX
@inRange:
        jmp     @enableSfx

@checkLeftPressed:
        lda     newlyPressedButtons
        cmp     #$02
        bne     @checkDownPressed
        lda     menuX
        beq     @enableSfx
        dec     menuX
        jmp     @enableSfx
@checkDownPressed:
        lda     newlyPressedButtons
        cmp     #$04
        bne     @checkUpPressed
        lda     menuY
        clc
        adc     #$01
        cmp     #MENU_SIZE
        bcs     @atMaxRow
        sta     menuY
        lda     #$00
        sta     menuX
        jmp     @enableSfx
@atMaxRow:
        sec
        sbc     #$01
        sta     menuY
        jmp     @enableSfx
@checkUpPressed:
        lda     newlyPressedButtons
        cmp     #$08
        bne     @checkAPressed
        lda     menuY
        sec
        sbc     #$01
        cmp     #$FF
        beq     @atMinRow
        sta     menuY
        lda     #$00
        sta     menuX
        jmp     @enableSfx
@atMinRow:
        clc
        adc     #$01
        sta     menuY
        jmp     @enableSfx
@checkAPressed:
        lda     newlyPressedButtons
        cmp     #$80
        bne     @checkBPressed
        lda     #$01
        sta     generalCounter
        jmp     @updateMenuItem
@checkBPressed:
        lda     newlyPressedButtons
        cmp     #$40
        bne     @ret
        lda     #$FF
        sta     generalCounter
@updateMenuItem:
        jsr     updateMenuAddr
@enableSfx:
        lda     #$01
        sta     soundEffectSlot1Init
@ret:
        rts

updateMenuAddr:
        lda     menuY
        jsr     switch_s_plus_2a
        .addr   levelMenu_gameType
        .addr   levelMenu_music
        .addr   levelMenu_level
        .addr   levelMenu_speed

levelMenu_gameType:
        lda     gameType
        eor     #$01
        sta     gameType
        lda     #$01
        sta     menuBuffer
        lda     #$21
        sta     menuBuffer+1
        lda     #$0C
        sta     menuBuffer+2
        lda     #$0A
        clc
        adc     gameType
        sta     menuBuffer+3
        lda     #$02
        sta     menuBuffer+4
        lda     #$21
        sta     menuBuffer+5
        lda     #$8E
        sta     menuBuffer+6
; check whether to show or clear b-type height
        lda     gameType
        bne     @bType
        lda     #$FF
        sta     menuBuffer+7
        sta     menuBuffer+8
        jmp     @finish
@bType:
        lda     #$24
        sta     menuBuffer+7
        lda     startHeight
        sta     menuBuffer+8
@finish:
        lda     #$00
        sta     menuBuffer+9
        rts

levelMenu_music:
        lda     #$01
        sta     menuBuffer
        lda     #$21
        sta     menuBuffer+1
        lda     #$4C
        sta     menuBuffer+2
        lda     #$00
        sta     menuBuffer+4
        lda     generalCounter
        clc
        adc     musicType
        ldx     #$00
        stx     tmp1
        ldx     #$04
        stx     tmp2
        jsr     restrictToRange
        sta     musicType
        sta     menuBuffer+3
        tax
        lda     musicSelectionTable,x
        jsr     setMusicTrack
@ret:
        rts

levelMenu_level: ; starts at 218c
        lda     #$01
        sta     menuBuffer
        lda     #$21
        sta     menuBuffer+1
        lda     #$00
        sta     menuBuffer+4
        sta     tmp1
        lda     menuX
        cmp     #$02
        beq     @changeHeight
        cmp     #$00
        beq     @changeTens
        lda     #$0A
        sta     tmp2
        lda     #$8D
        sta     menuBuffer+2
        lda     generalCounter
        clc
        adc     startLevelOnes
        jsr     restrictToRange
        sta     startLevelOnes
        sta     menuBuffer+3
        jsr     setStartLevel
        rts
@changeTens:
        lda     #$03
        sta     tmp2
        lda     #$8C
        sta     menuBuffer+2
        lda     generalCounter
        clc
        adc     startLevelTens
        jsr     restrictToRange
        sta     startLevelTens
        sta     menuBuffer+3
        jsr     setStartLevel
        rts

@changeHeight:
        lda     #$06
        sta     tmp2
        lda     generalCounter
        clc
        adc     startHeight
        jsr     restrictToRange
        sta     startHeight
        sta     menuBuffer+3
        lda     #$8F
        sta     menuBuffer+2
        rts

setStartLevel:
        ldx     startLevelTens
        lda     multBy10Table,x
        clc
        adc     startLevelOnes
        sta     startLevel
        rts

levelMenu_speed:
        rts

; first row is for a-type, second is for b-type
menuOptionCount:
        .byte   $01, $01, $02, $02
        .byte   $01, $01, $03, $02

menuOptionOffset:
        .byte   $00, $01, $02, $04

menuOptionLimits:
        .byte   $01, $03, $02, $09, maxPollRate-1, maxPollRate-1

stageCursorSprites:
; row sprite
        ldx     oamStagingLength
        lda     menuY
        asl
        asl
        asl
        asl
        sta     tmp1
        clc
        adc     #$3F
        sta     oamStaging,x
        lda     #$27
        sta     oamStaging+1,x
        lda     #$00
        sta     oamStaging+2,x
        lda     #$22
        sta     oamStaging+3,x
        txa
        clc
        adc     #$04
        tax
; arrow sprites
        lda     tmp1
        clc
        adc     #$34
        sta     oamStaging,x
        lda     #$92
        sta     oamStaging+1,x
        lda     #$00
        sta     oamStaging+2,x
        jsr     getArrowX ; stores arrow x in tmp2
        lda     tmp2
        sta     oamStaging+3,x
        txa
        clc
        adc     #$04
        tax
        lda     tmp1
        adc     #$49
        sta     oamStaging,x
        lda     #$A2
        sta     oamStaging+1,x
        lda     #$00
        sta     oamStaging+2,x
        lda     tmp2
        sta     oamStaging+3,x
        txa
        clc
        adc     #$04
        sta     oamStagingLength
        rts

getArrowX:
        lda     menuX
        asl
        asl
        asl
        tay
        clc
        adc     #$60
        sta     tmp2
        tya
        ora     menuY
        ; if (x,y) is (2,2) or (1,3) add 8
        cmp     #$12 ; 8 * 2 + 2
        beq     @addOffset
        cmp     #$0B ; 8 * 1 + 3
        beq     @addOffset
        rts
@addOffset:
        lda     tmp2
        clc
        adc     #$08
        sta     tmp2
        rts

; Handle speed control
oldSpeedMenu:
        lda     newlyPressedButtons
        and     #$01
        beq     @rightNotPressed
        inc     pollsPerFrame
        lda     pollsPerFrame
        cmp     #maxPollRate+1
        bne     @notMaxPollRate
        dec     pollsPerFrame
@notMaxPollRate:
        lda     #$01
        sta     soundEffectSlot1Init
@rightNotPressed:
        lda     newlyPressedButtons
        and     #$02
        beq     @leftNotPressed
        dec     pollsPerFrame
        lda     pollsPerFrame
        cmp     #$00
        bne     @notMinPollRate
        inc     pollsPerFrame
@notMinPollRate:
        lda     #$01
        sta     soundEffectSlot1Init
@leftNotPressed:
        lda     newlyPressedButtons
        and     #$08
        beq     @upNotPressed
        inc     subFrameTop
        lda     subFrameTop
        cmp     #maxPollRate+1
        bne     @notMaxTop
        dec     subFrameTop
@notMaxTop:
        lda     #$01
        sta     soundEffectSlot1Init
@upNotPressed:
        lda     newlyPressedButtons
        and     #$04
        beq     @downNotPressed
        dec     subFrameTop
        lda     subFrameTop
        cmp     #$00
        bne     @notMinTop
        inc     subFrameTop
@notMinTop:
        lda     #$01
        sta     soundEffectSlot1Init
@downNotPressed:
; Update index
        ldx     pollsPerFrame
        lda     scanlineIndexTable,x
        sta     pollAddr
        lda     #>scanlinePollTable ; high byte
        sta     pollAddr+1
