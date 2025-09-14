; ModuleID = 'rotl28'
source_filename = "rotl28.c"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @rotl28(i32 %x, i32 %s) {
entry:
  %x28 = and i32 %x, 268435455
  %s_mod32 = and i32 %s, 31
  %shl_part = shl i32 %x28, %s_mod32
  %sub = sub i32 28, %s
  %r_mod32 = and i32 %sub, 31
  %shr_part = lshr i32 %x28, %r_mod32
  %combined = or i32 %shl_part, %shr_part
  %result = and i32 %combined, 268435455
  ret i32 %result
}