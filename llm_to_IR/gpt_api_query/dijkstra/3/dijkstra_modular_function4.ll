; LLVM IR for: int min_index(int* arr, int* mask, int len)

define dso_local i32 @min_index(i32* %arr, i32* %mask, i32 %len) {
entry:
  %bestIdx = alloca i32, align 4
  %bestVal = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 -1, i32* %bestIdx, align 4
  store i32 2147483647, i32* %bestVal, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %exit = icmp sge i32 %i.val, %len
  br i1 %exit, label %done, label %body

body:
  %i.ext = sext i32 %i.val to i64
  %mask.ptr = getelementptr inbounds i32, i32* %mask, i64 %i.ext
  %mask.val = load i32, i32* %mask.ptr, align 4
  %mask.nz = icmp ne i32 %mask.val, 0
  br i1 %mask.nz, label %inc, label %check

check:
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %curBest = load i32, i32* %bestVal, align 4
  %lt = icmp slt i32 %arr.val, %curBest
  br i1 %lt, label %update, label %inc

update:
  store i32 %arr.val, i32* %bestVal, align 4
  %i.curr = load i32, i32* %i, align 4
  store i32 %i.curr, i32* %bestIdx, align 4
  br label %inc

inc:
  %i.curr2 = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.curr2, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

done:
  %ret = load i32, i32* %bestIdx, align 4
  ret i32 %ret
}