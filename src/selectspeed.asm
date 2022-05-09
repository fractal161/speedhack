; Handle speed control
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