; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop.check

loop.body:
  %i.val = load i32, i32* %i, align 4
  %i.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp = icmp eq i32 %elem, %target
  br i1 %cmp, label %found, label %inc

inc:
  %i.val2 = load i32, i32* %i, align 4
  %incv = add nsw i32 %i.val2, 1
  store i32 %incv, i32* %i, align 4
  br label %loop.check

loop.check:
  %i.val3 = load i32, i32* %i, align 4
  %cond = icmp slt i32 %i.val3, %len
  br i1 %cond, label %loop.body, label %notfound

found:
  %retv = load i32, i32* %i, align 4
  ret i32 %retv

notfound:
  ret i32 -1
}