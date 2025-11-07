; ModuleID = 'main.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0

  %gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %gep8, align 4

  br label %print.preheader

print.preheader:
  br label %print.header

print.header:
  %i = phi i64 [ 0, %print.preheader ], [ %i.next, %print.body ]
  %cmp0 = icmp ult i64 %i, 9
  br i1 %cmp0, label %print.body, label %print.end

print.body:
  %elem.ptr0 = getelementptr inbounds i32, i32* %base, i64 %i
  %elem0 = load i32, i32* %elem.ptr0, align 4
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem0)
  %i.next = add i64 %i, 1
  br label %print.header

print.end:
  %nl0 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* %base, i64 9)
  br label %print2.preheader

print2.preheader:
  br label %print2.header

print2.header:
  %j = phi i64 [ 0, %print2.preheader ], [ %j.next, %print2.body ]
  %cmp1 = icmp ult i64 %j, 9
  br i1 %cmp1, label %print2.body, label %print2.end

print2.body:
  %elem.ptr1 = getelementptr inbounds i32, i32* %base, i64 %j
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem1)
  %j.next = add i64 %j, 1
  br label %print2.header

print2.end:
  %nl1 = call i32 @putchar(i32 10)
  ret i32 0
}