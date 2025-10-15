target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @linear_search(i32* %0, i32 %1, i32 %2) {
entry:
  br label %cond

cond:
  %3 = phi i32 [ 0, %entry ], [ %7, %inc ]
  %4 = icmp slt i32 %3, %1
  br i1 %4, label %body, label %notfound

body:
  %5 = sext i32 %3 to i64
  %6 = getelementptr inbounds i32, i32* %0, i64 %5
  %7 = load i32, i32* %6, align 4
  %8 = icmp eq i32 %2, %7
  br i1 %8, label %found, label %inc

inc:
  %9 = add nsw i32 %3, 1
  br label %cond

found:
  ret i32 %3

notfound:
  ret i32 -1
}