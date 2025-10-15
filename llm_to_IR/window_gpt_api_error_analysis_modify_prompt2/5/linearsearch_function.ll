target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %key) {
entry:
  %i.addr = alloca i32, align 4
  store i32 0, i32* %i.addr, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i.addr, align 4
  %cmp = icmp slt i32 %i.val, %len
  br i1 %cmp, label %loop.body, label %ret.neg1

loop.body:
  %i64 = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %key, %elem
  br i1 %eq, label %found, label %inc

found:
  %retidx = load i32, i32* %i.addr, align 4
  ret i32 %retidx

inc:
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i.addr, align 4
  br label %loop.cond

ret.neg1:
  ret i32 -1
}