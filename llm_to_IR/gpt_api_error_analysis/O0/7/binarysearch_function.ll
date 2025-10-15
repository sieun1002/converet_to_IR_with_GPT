target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %0, i64 %1, i32 %2) {
entry:
  br label %loop

loop:
  %3 = phi i64 [ 0, %entry ], [ %12, %10 ]
  %4 = phi i64 [ %1, %entry ], [ %13, %10 ]
  %5 = icmp ult i64 %3, %4
  br i1 %5, label %body, label %after

body:
  %6 = sub i64 %4, %3
  %7 = lshr i64 %6, 1
  %8 = add i64 %3, %7
  %9 = getelementptr inbounds i32, i32* %0, i64 %8
  %10val = load i32, i32* %9, align 4
  %11 = icmp sgt i32 %2, %10val
  br i1 %11, label %then, label %else

then:
  %12t = add i64 %8, 1
  br label %10

else:
  br label %10

10:
  %12 = phi i64 [ %12t, %then ], [ %3, %else ]
  %13 = phi i64 [ %4, %then ], [ %8, %else ]
  br label %loop

after:
  %14 = phi i64 [ %3, %loop ]
  %15 = icmp ult i64 %14, %1
  br i1 %15, label %check, label %ret_not

check:
  %16 = getelementptr inbounds i32, i32* %0, i64 %14
  %17 = load i32, i32* %16, align 4
  %18 = icmp eq i32 %2, %17
  br i1 %18, label %ret_yes, label %ret_not

ret_yes:
  ret i64 %14

ret_not:
  ret i64 -1
}