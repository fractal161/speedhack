nmi:    pha
        txa
        pha
        tya
        pha
        lda     #$00
        sta     pollsThisFrame
        sta     gameCycleCount
; Check if active piece control
        lda     playState
        cmp     #$01
        bne     @notInGame
        dec     framesToWait
        ; lda     framesToWait
        bne     @restOfNmi
        lda     pollIndex
        bne     @scheduleNextPoll
        jsr     pollControllerButtons
        jsr     generateNextPseudorandomNumber
        inc     pollsThisFrame
        jsr     setNextPollIndex
@scheduleNextPoll:
; If framesToWait == 0, immediately create irq
        lda     framesToWait ; feels redundant
        bne     @restOfNmi
        ldy     pollIndex
        lda     (pollAddr),y
        jsr     makeIrqRequest
        jmp     @restOfNmi
@notInGame:
        jsr     pollControllerButtons
        jsr     generateNextPseudorandomNumber
@restOfNmi:
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
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        lda     #$01
        sta     verticalBlankingInterval
        pla
        tay
        pla
        tax
        pla
        rti