; LLVM IR (.ll) for: permute
; Semantics recovered from the given x86-64 SysV disassembly.

define dso_local i64 @permute(i64 %value, i32* nocapture readonly %arr, i32 %count, i32 %bits) local_unnamed_addr nounwind readonly {
entry:
  br label %loop.head

loop.head:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %loop.body ]
  %cmp = icmp slt i32 %i, %count
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %delta = sub i32 %bits, %elem
  %delta.mask6 = and i32 %delta, 63
  %shamt = zext i32 %delta.mask6 to i64
  %shifted = lshr i64 %value, %shamt
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %inc = add i32 %i, 1
  br label %loop.head

exit:
  ret i64 %acc
}