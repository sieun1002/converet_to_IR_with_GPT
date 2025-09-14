; ModuleID = 'sbox_lookup.ll'
source_filename = "sbox_lookup"
target triple = "x86_64-unknown-linux-gnu"

@SBOX_1 = external constant [256 x i8], align 1

define dso_local zeroext i8 @sbox_lookup(i8 zeroext %x) {
entry:
  %idx = zext i8 %x to i64
  %eltptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val = load i8, i8* %eltptr, align 1
  ret i8 %val
}