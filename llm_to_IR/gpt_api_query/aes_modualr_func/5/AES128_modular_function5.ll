; ModuleID = 'sub_bytes'
source_filename = "sub_bytes"
target triple = "x86_64-unknown-linux-gnu"

declare i8 @sbox_lookup(i32)

define void @_sub_bytes(i8* %state) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %i64 = zext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %state, i64 %i64
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %r = call i8 @sbox_lookup(i32 %b32)
  store i8 %r, i8* %p, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

exit:
  ret void
}