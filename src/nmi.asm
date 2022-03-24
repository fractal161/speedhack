nmi:    pha
        txa
        pha
        tya
        pha
; Check if active piece control
        lda     playState
        cmp     #$01
        bne     @skipIrq
; DEBUG
        lda     #maxPollRate
        sta     pollsPerFrame
        cmp     #$01
        beq     @skipIrq
        ; lda     gameCycleCount
        ; cmp     pollsPerFrame
        ; beq     @dontCrash
        ; .byte   $02
@dontCrash:
        sta     $E000
        ldy     pollsPerFrame
        ldx     scanlineIndexTable,y
        lda     scanlineLengthTable,x
        sta     $C000
        sta     $C001
        sta     $E000
        sta     $E001
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
        sta     pollsThisFrame ; Since we've polled once during nmi
        jsr     pollControllerButtons
        pla
        tay
        pla
        tax
        pla
        rti