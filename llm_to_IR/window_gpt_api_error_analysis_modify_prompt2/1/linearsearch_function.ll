target triple = "x86_64-pc-windows-msvc"

define i32 @linear_search(i32* %arr, i32 %count, i32 %value) {
entry:
  br label %loop.test

loop.test:
  %i = phi i32 [ 0, %entry ], [ %i.inc, %inc ]
  %cmplimit = icmp slt i32 %i, %count
  br i1 %cmplimit, label %loop.body, label %notfound

loop.body:
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %equals = icmp eq i32 %value, %elem
  br i1 %equals, label %found, label %inc

inc:
  %i.inc = add nsw i32 %i, 1
  br label %loop.test

found:
  ret i32 %i

notfound:
  ret i32 -1
}