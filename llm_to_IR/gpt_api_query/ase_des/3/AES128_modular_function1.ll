; ModuleID = 'sbox_lookup.ll'
target triple = "x86_64-pc-linux-gnu"

@SBOX_1 = external dso_local constant [256 x i8], align 16

define dso_local zeroext i8 @sbox_lookup(i8 zeroext %x) #0 {
entry:
  %idx = zext i8 %x to i64
  %elt = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val = load i8, i8* %elt, align 1
  ret i8 %val
}

attributes #0 = { nounwind readonly }