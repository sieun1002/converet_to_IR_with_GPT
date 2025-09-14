; ModuleID = 'permute'
source_filename = "permute"
target triple = "x86_64-pc-linux-gnu"

define i64 @permute(i64 %src, i32* %tbl, i32 %count, i32 %base) {
entry:
  %n_is_pos = icmp sgt i32 %count, 0
  br i1 %n_is_pos, label %loop, label %exit

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %res = phi i64 [ 0, %entry ], [ %res.next, %loop ]
  %idx = zext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %tbl, i64 %idx
  %v = load i32, i32* %ptr, align 4
  %diff = sub i32 %base, %v
  %mask = and i32 %diff, 63
  %shamt = zext i32 %mask to i64
  %shifted = lshr i64 %src, %shamt
  %bit = and i64 %shifted, 1
  %res.shl = shl i64 %res, 1
  %res.next = or i64 %res.shl, %bit
  %i.next = add i32 %i, 1
  %cont = icmp slt i32 %i.next, %count
  br i1 %cont, label %loop, label %exit

exit:
  %res.final = phi i64 [ 0, %entry ], [ %res.next, %loop ]
  ret i64 %res.final
}