; http://bobrost.com/nes/files/mmc3irqs.txt
; When you want to set up the IRQ: (do this in your NMI/vblank routine)
; 1. Write to $E000 to acknowledge any currently pending interrupts
; 2. Write the number of scanlines you want to wait to $C000 and then $C001
; 3. Write to $E000 again to latch in the countdown value
; 4. Write to $E001 to enable the IRQ counter

; faster while loop concept
; sec
; @mod10: sbc #$A
; bcs @mod10
; adc #$A

irq:
; Acknowledge interrupt
        sta     $E000
        pha
        txa
        pha
        tya
        pha
; Actual polling
        jsr     pollController
        jsr     generateNextPseudorandomNumber
        inc     pollsThisFrame
        jsr     setNextPollIndex
        jsr     setupIrq
        pla
        tay
        pla
        tax
        pla
        rti

setNextPollIndex:
; Try and figure out next poll
        lda     pollIndex
        sta     pollTmp
        clc
        adc     subFrameTop
@while:
        cmp     pollsPerFrame
        bcc     @ret
        sec
        sbc     pollsPerFrame
        inc     framesToWait
        jmp     @while
@ret:
        sta     pollIndex
        rts
; very likely mod 241 issues
; pollTmp has old index pollIndex has new index
setupIrq:
        lda     framesToWait
        bne     @ret ; Wait for nmi
        ldy     pollIndex
        lda     (pollAddr),y
        ldy     pollTmp
        sec
        sbc     (pollAddr),y ; COULD BE OFF BY 1
        jsr     makeIrqRequest
@ret:
        rts ; shouldn't need to write to $E000 because irq is already acknowledged?

; Assumes a already has the number of scanlines to wait
makeIrqRequest:
        sta     $C000
        sta     $C001
        sta     $E000
        sta     $E001
        rts
