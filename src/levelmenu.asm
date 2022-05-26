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

@checkBPressed:
        lda     newlyPressedButtons
        cmp     #$40
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