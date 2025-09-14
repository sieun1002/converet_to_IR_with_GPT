; ModuleID = 'sub_bytes.ll'
target triple = "x86_64-unknown-linux-gnu"

declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %state) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx = sext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %state, i64 %idx
  %byte = load i8, i8* %ptr, align 1
  %b32 = zext i8 %byte to i32
  %res = call zeroext i8 @sbox_lookup(i32 %b32)
  store i8 %res, i8* %ptr, align 1
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}