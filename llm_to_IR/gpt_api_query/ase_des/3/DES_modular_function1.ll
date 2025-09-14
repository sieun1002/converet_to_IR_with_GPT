; ModuleID = 'permute'
source_filename = "permute.ll"

define i64 @permute(i64 %value, i32* %arr, i32 %n, i32 %base) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %res = phi i64 [ 0, %entry ], [ %res.new, %loop.body ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %loop.body, label %exit

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i32 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %shift32 = sub i32 %base, %elem
  %cl8 = trunc i32 %shift32 to i8
  %amt32 = zext i8 %cl8 to i32
  %amt64 = zext i32 %amt32 to i64
  %amt6 = and i64 %amt64, 63
  %shifted = lshr i64 %value, %amt6
  %bit = and i64 %shifted, 1
  %res.shl = shl i64 %res, 1
  %res.new = or i64 %res.shl, %bit
  %inc = add i32 %i, 1
  br label %loop.header

exit:
  ret i64 %res
}