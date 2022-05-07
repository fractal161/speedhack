nmi:    pha
        txa
        pha
        tya
        pha
; Check if active piece control
        lda     playState
        cmp     #$01
        bne     @skipIrq
; Check if next scanline is now, or sometime in the future

; If in the future, schedule next poll

@skipIrq:
        lda     #$00
        sta     oamStagingLength
        jsr     render
        dec     sleepCounter
        lda     sleepCounter
        cmp     #$FF
        bne     @jumpOverIncrement
        inc     sleepCounter
@jumpOverIncrement:
        jsr     copyOamStagingToOam
        lda     frameCounter
        clc
        adc     #$01
        sta     frameCounter
        lda     #$00
        adc     frameCounter+1
        sta     frameCounter+1
        jsr     generateNextPseudorandomNumber
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        sta     gameCycleCount
        lda     #$01
        sta     verticalBlankingInterval
        jsr     pollControllerButtons
        pla
        tay
        pla
        tax
        pla
        rti