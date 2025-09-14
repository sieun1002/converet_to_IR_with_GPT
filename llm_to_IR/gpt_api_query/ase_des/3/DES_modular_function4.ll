; ModuleID = 'feistel_module'
target triple = "x86_64-unknown-linux-gnu"

@E = external global i8

declare i64 @permute(i64 %value, i8* %table, i32 %out_bits, i32 %in_bits)
declare i32 @sboxes_p(i64 %x)

define i32 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r64 = zext i32 %r to i64
  %perm = call i64 @permute(i64 %r64, i8* @E, i32 48, i32 32)
  %x = xor i64 %perm, %subkey
  %s = call i32 @sboxes_p(i64 %x)
  ret i32 %s
}