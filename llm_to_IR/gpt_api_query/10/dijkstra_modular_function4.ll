; Function: min_index
define i32 @min_index(i32* %arr, i32* %mask, i32 %n) {
entry:
  %best_i = alloca i32, align 4
  %best_val = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 -1, i32* %best_i, align 4
  store i32 2147483647, i32* %best_val, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cond = icmp slt i32 %i.val, %n
  br i1 %cond, label %body, label %exit

body:
  %i1 = load i32, i32* %i, align 4
  %idx = sext i32 %i1 to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %idx
  %mask.val = load i32, i32* %mask.ptr, align 4
  %iszero = icmp eq i32 %mask.val, 0
  br i1 %iszero, label %check, label %inc

check:
  %i2 = load i32, i32* %i, align 4
  %idx2 = sext i32 %i2 to i64
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx2
  %arr.val = load i32, i32* %arr.ptr, align 4
  %cur.best = load i32, i32* %best_val, align 4
  %ge = icmp sge i32 %arr.val, %cur.best
  br i1 %ge, label %inc, label %update

update:
  store i32 %arr.val, i32* %best_val, align 4
  %i3 = load i32, i32* %i, align 4
  store i32 %i3, i32* %best_i, align 4
  br label %inc

inc:
  %i4 = load i32, i32* %i, align 4
  %i.next = add i32 %i4, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

exit:
  %ret = load i32, i32* %best_i, align 4
  ret i32 %ret
}