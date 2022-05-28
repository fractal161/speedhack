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
@checkLeftPressed:
        lda     newlyPressedButtons
        cmp     #$02
        bne     @checkDownPressed
@checkDownPressed:
        lda     newlyPressedButtons
        cmp     #$04
        bne     @checkUpPressed
@checkUpPressed:
        lda     newlyPressedButtons
        cmp     #$08
        bne     @checkAPressed
@checkAPressed:
        lda     newlyPressedButtons
        cmp     #$80
        bne     @checkBPressed
        lda     #$01
        sta     tmp1
        jmp     @updateMenuItem
@checkBPressed:
        lda     newlyPressedButtons
        cmp     #$40
        bne     @ret
        lda     #$FF
        sta     tmp1
@updateMenuItem:
        jsr     updateMenuAddr
@enableSfx:
        lda     #$01
        sta     soundEffectSlot1Init
@ret:
        rts

updateMenuAddr:
        lda     menuX
        jsr     switch_s_plus_2a
        .addr   levelMenu_gameType

levelMenu_gameType:
        lda     gameType
        eor     #$01
        sta     gameType
        lda     #$01
        sta     menuBufferSize
        lda     #$21
        sta     menuBufferAddr+1
        lda     #$0C
        sta     menuBufferAddr
        lda     #$0A
        clc
        adc     gameType
        sta     menuBuffer
        rts

menuOptionOffset:
        .byte   $00, $01, $02, $04

menuOptionLimits:
        .byte   $01, $03, $02, $09, maxPollRate-1, maxPollRate-1

stageCursorSprites:
; row sprite
        ldx     oamStagingLength
        lda     menuX
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
        adc     #$35
        sta     oamStaging,x
        lda     #$92
        sta     oamStaging+1,x
        lda     #$00
        sta     oamStaging+2,x
        lda     menuY
        asl
        asl
        asl
        clc
        adc     #$60
        sta     tmp2
        sta     oamStaging+3,x
        txa
        clc
        adc     #$04
        tax
        lda     tmp1
        adc     #$48
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
