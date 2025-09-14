; ModuleID = 'main.ll'
source_filename = "main"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32*, i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0

  store i32 9, i32* %arrdecay, align 4
  %p1 = getelementptr inbounds i32, i32* %arrdecay, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrdecay, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrdecay, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrdecay, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrdecay, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrdecay, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrdecay, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrdecay, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrdecay, i64 9
  store i32 0, i32* %p9, align 4

  %cond = icmp ugt i64 10, 1
  br i1 %cond, label %callqs, label %afterqs

callqs:
  call void @quick_sort(i32* %arrdecay, i64 0, i64 9)
  br label %afterqs

afterqs:
  br label %loop

loop:
  %i = phi i64 [ 0, %afterqs ], [ %inext, %loop_body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop_body, label %done

loop_body:
  %eltptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i
  %elt = load i32, i32* %eltptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elt)
  %inext = add i64 %i, 1
  br label %loop

done:
  %call2 = call i32 @putchar(i32 10)
  ret i32 0
}