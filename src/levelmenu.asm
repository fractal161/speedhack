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
        lda     gameType
        bne     @skipTypeBHeightDisplay
        jsr     bulkCopyToPpu
        .addr   height_menu_nametablepalette_patch
@skipTypeBHeightDisplay:
        jsr     showHighScores
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$00
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$00
        sta     originalY
        sta     dropSpeed
@forceStartLevelToRange:
        lda     startLevel
        cmp     #$0A
        bcc     gameMode_levelMenu_processPlayerNavigation
        sec
        sbc     #$0A
        sta     startLevel
        jmp     @forceStartLevelToRange

gameMode_levelMenu_processPlayerNavigation:
        lda     #$00
        sta     activePlayer
        lda     originalY
        sta     selectingLevelOrHeight
        jsr     gameMode_levelMenu_handleLevelHeightNavigation
        lda     selectingLevelOrHeight
        sta     originalY
        lda     newlyPressedButtons
        cmp     #$10
        bne     @checkBPressed
        lda     heldButtons
        cmp     #$90
        bne     @startAndANotPressed
        lda     startLevel
        clc
        adc     #$0A
        sta     startLevel
@startAndANotPressed:
        lda     #$00
        sta     gameModeState
        lda     #$02
        sta     soundEffectSlot1Init
        inc     gameMode
        rts

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

; Starts by checking if right pressed
gameMode_levelMenu_handleLevelHeightNavigation:
        lda     newlyPressedButtons
        cmp     #$01
        bne     @checkLeftPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     selectingLevelOrHeight
        bne     @rightPressedForHeightSelection
        lda     startLevel
        cmp     #$09
        beq     @checkLeftPressed
        inc     startLevel
        jmp     @checkLeftPressed

@rightPressedForHeightSelection:
        lda     startHeight
        cmp     #$05
        beq     @checkLeftPressed
        inc     startHeight
@checkLeftPressed:
        lda     newlyPressedButtons
        cmp     #$02
        bne     @checkDownPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     selectingLevelOrHeight
        bne     @leftPressedForHeightSelection
        lda     startLevel
        beq     @checkDownPressed
        dec     startLevel
        jmp     @checkDownPressed

@leftPressedForHeightSelection:
        lda     startHeight
        beq     @checkDownPressed
        dec     startHeight
@checkDownPressed:
        lda     newlyPressedButtons
        cmp     #$04
        bne     @checkUpPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     selectingLevelOrHeight
        bne     @downPressedForHeightSelection
        lda     startLevel
        cmp     #$05
        bpl     @checkUpPressed
        clc
        adc     #$05
        sta     startLevel
        jmp     @checkUpPressed

@downPressedForHeightSelection:
        lda     startHeight
        cmp     #$03
        bpl     @checkUpPressed
        inc     startHeight
        inc     startHeight
        inc     startHeight
@checkUpPressed:
        lda     newlyPressedButtons
        cmp     #$08
        bne     @checkAPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     selectingLevelOrHeight
        bne     @upPressedForHeightSelection
        lda     startLevel
        cmp     #$05
        bmi     @checkAPressed
        sec
        sbc     #$05
        sta     startLevel
        jmp     @checkAPressed

@upPressedForHeightSelection:
        lda     startHeight
        cmp     #$03
        bmi     @checkAPressed
        dec     startHeight
        dec     startHeight
        dec     startHeight
@checkAPressed:
        lda     gameType
        beq     @showSelection
        lda     newlyPressedButtons
        cmp     #$80
        bne     @showSelection
        lda     #$01
        sta     soundEffectSlot1Init
        lda     selectingLevelOrHeight
        eor     #$01
        sta     selectingLevelOrHeight
@showSelection:
        lda     selectingLevelOrHeight
        bne     @showSelectionLevel
        lda     frameCounter
        and     #$03
        beq     @skipShowingSelectionLevel
@showSelectionLevel:
        ldx     startLevel
        lda     levelToSpriteYOffset,x
        sta     spriteYOffset
        lda     #$00
        sta     spriteIndexInOamContentLookup
        ldx     startLevel
        lda     levelToSpriteXOffset,x
        sta     spriteXOffset
        lda     activePlayer
        cmp     #$01
        bne     @stageLevelSelectCursor
        clc
        lda     spriteYOffset
        adc     #$50
        sta     spriteYOffset
@stageLevelSelectCursor:
        jsr     loadSpriteIntoOamStaging
@skipShowingSelectionLevel:
        lda     gameType
        beq     @ret
        lda     selectingLevelOrHeight
        beq     @showSelectionHeight
        lda     frameCounter
        and     #$03
        beq     @ret
@showSelectionHeight:
        ldx     startHeight
        lda     heightToPpuHighAddr,x
        sta     spriteYOffset
        lda     #$00
        sta     spriteIndexInOamContentLookup
        ldx     startHeight
        lda     heightToPpuLowAddr,x
        sta     spriteXOffset
        lda     activePlayer
        cmp     #$01
        bne     @stageHeightSelectCursor
        clc
        lda     spriteYOffset
        adc     #$50
        sta     spriteYOffset
@stageHeightSelectCursor:
        jsr     loadSpriteIntoOamStaging
@ret:   rts

levelToSpriteYOffset:
        .byte   $53,$53,$53,$53,$53,$63,$63,$63
        .byte   $63,$63
levelToSpriteXOffset:
        .byte   $34,$44,$54,$64,$74,$34,$44,$54
        .byte   $64,$74
heightToPpuHighAddr:
        .byte   $53,$53,$53,$63,$63,$63
heightToPpuLowAddr:
        .byte   $9C,$AC,$BC,$9C,$AC,$BC


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