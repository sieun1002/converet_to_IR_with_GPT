; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %len, i32 %target) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp2 = icmp slt i32 %i, %len
  br i1 %cmp2, label %loop.body, label %notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp = icmp eq i32 %elem, %target
  br i1 %cmp, label %found, label %inc

inc:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

found:
  ret i32 %i

notfound:
  ret i32 -1
}