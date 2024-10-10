mov ax, 1  ; OK.
hi:
mov ax, 1+
mov ax
mov ax
hi2:
mov ax, bx, cx  ; This should be rejected, but A72 accepts it as `mov ax, bx'.
hi:
nop  ; Good.
