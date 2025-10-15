; target
target triple = "x86_64-w64-windows-gnu"

; globals
@.str0 = private unnamed_addr constant [11 x i8] c"Original: \00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str2 = private unnamed_addr constant [9 x i8] c"Sorted: \00", align 1

; externs
declare void @__main()
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

; definition
define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()

  %arr = alloca [9 x i32], align 16

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

  %fmt0.ptr = getelementptr inbounds [11 x i8], [11 x i8]* @.str0, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0.ptr)

  br label %loop.pre

loop.pre:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp0 = icmp ult i64 %i, 9
  br i1 %cmp0, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmtd.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elem.val)
  %i.next = add i64 %i, 1
  br label %loop.pre

loop.end:
  %call.putchar0 = call i32 @putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str2, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr)

  br label %loop2.pre

loop2.pre:
  %j = phi i64 [ 0, %loop.end ], [ %j.next, %loop2.body ]
  %cmp1 = icmp ult i64 %j, 9
  br i1 %cmp1, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2.val = load i32, i32* %elem2.ptr, align 4
  %fmtd2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str1, i64 0, i64 0
  %call.printf3 = call i32 (i8*, ...) @printf(i8* %fmtd2.ptr, i32 %elem2.val)
  %j.next = add i64 %j, 1
  br label %loop2.pre

loop2.end:
  %call.putchar1 = call i32 @putchar(i32 10)
  ret i32 0
}