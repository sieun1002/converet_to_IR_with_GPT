; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  %i.addr = alloca i32, align 4
  store i32 0, i32* %i.addr, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i.addr, align 4
  %cmp.len = icmp slt i32 %i.val, %len
  br i1 %cmp.len, label %body, label %ret.neg1

body:
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %ret.i, label %inc

inc:
  %next = add nsw i32 %i.val, 1
  store i32 %next, i32* %i.addr, align 4
  br label %loop

ret.i:
  ret i32 %i.val

ret.neg1:
  ret i32 -1
}