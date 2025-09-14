; ModuleID = 'linear_search.ll'
source_filename = "linear_search"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %len
  br i1 %cmp, label %body, label %notfound

body:
  %i.val2 = load i32, i32* %i, align 4
  %idxprom = sext i32 %i.val2 to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %target
  br i1 %eq, label %found, label %incr

found:
  %ret = load i32, i32* %i, align 4
  ret i32 %ret

incr:
  %i.old = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

notfound:
  ret i32 -1
}