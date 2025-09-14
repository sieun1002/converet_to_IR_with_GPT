; ModuleID = '_sub_bytes'
source_filename = "_sub_bytes.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8 @sbox_lookup(i32)

define void @_sub_bytes(i8* %buf) {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %i64 = sext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %i64
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %sb = call i8 @sbox_lookup(i32 %b32)
  store i8 %sb, i8* %p, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %cond

exit:
  ret void
}