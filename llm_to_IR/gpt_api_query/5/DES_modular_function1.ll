; ModuleID = 'permute'
source_filename = "permute"
target triple = "x86_64-pc-linux-gnu"

define i64 @permute(i64 %value, i32* %positions, i32 %count, i32 %base) nounwind {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body ]
  %cond = icmp slt i32 %i, %count
  br i1 %cond, label %body, label %exit

body:
  %i64 = sext i32 %i to i64
  %p = getelementptr i32, i32* %positions, i64 %i64
  %elem = load i32, i32* %p, align 4
  %diff = sub i32 %base, %elem
  %diff64 = zext i32 %diff to i64
  %shifted = lshr i64 %value, %diff64
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i64 %acc
}