; ModuleID = 'permute.ll'
source_filename = "permute"

define i64 @permute(i64 %value, i32* %arr, i32 %len, i32 %base) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %v = load i32, i32* %ptr, align 4
  %t = sub i32 %base, %v
  %t64 = zext i32 %t to i64
  %shamt = and i64 %t64, 63
  %shifted = lshr i64 %value, %shamt
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add i32 %i, 1
  br label %loop.latch

loop.latch:
  br label %loop.cond

exit:
  ret i64 %acc
}