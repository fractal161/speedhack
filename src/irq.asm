irq:
; Acknowledge interrupt
        sta     $E000
        pha
        txa
        pha
        tya
        pha
; Make next scanline request
        ldx     pollsPerFrame
        lda     scanlineIndexTable,x
        clc
        adc     pollsThisFrame
        tax
        lda     scanlineLengthTable,x
        sta     $C000
        sta     $C001
        sta     $E000
        sta     $E001
; Wait for some number of cycles
; What we actually care about
        jsr     pollController
        inc     pollsThisFrame
        jsr     generateNextPseudorandomNumber
; Disable irq if this is the last one
        lda     pollsThisFrame
        cmp     pollsPerFrame
        bne     @finish
        sta     $E000
@finish:
        pla
        tay
        pla
        tax
        pla
        rti
