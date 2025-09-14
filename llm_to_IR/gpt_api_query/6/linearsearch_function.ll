; ModuleID = 'linear_search'
define i32 @linear_search(i32* %arr, i32 %n, i32 %target) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %n
  br i1 %cmp, label %loop.body, label %notfound

loop.body:                                        ; preds = %loop.cond
  %i.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %target, %elem
  br i1 %eq, label %found, label %inc

inc:                                              ; preds = %loop.body
  %incv = add nsw i32 %i.val, 1
  store i32 %incv, i32* %i, align 4
  br label %loop.cond

found:                                            ; preds = %loop.body
  ret i32 %i.val

notfound:                                         ; preds = %loop.cond
  ret i32 -1
}