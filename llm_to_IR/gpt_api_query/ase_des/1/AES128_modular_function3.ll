; ModuleID = 'xtime'
define dso_local i32 @xtime(i32 %arg) local_unnamed_addr {
entry:
  ; use only the low 8 bits of the argument
  %b.tr = trunc i32 %arg to i8
  %b.zx = zext i8 %b.tr to i32

  ; ecx = x << 1
  %dbl = shl i32 %b.zx, 1

  ; msb = (x >> 7) & 1
  %msb8 = lshr i8 %b.tr, 7
  %msb = zext i8 %msb8 to i32

  ; poly = 27 * msb (0x1B if msb==1 else 0)
  %poly = mul nuw nsw i32 %msb, 27

  ; result = (x << 1) ^ poly
  %res = xor i32 %dbl, %poly
  ret i32 %res
}