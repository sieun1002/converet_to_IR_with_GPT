; target: x86_64 Windows PE/COFF
target triple = "x86_64-pc-windows-msvc"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.fmt    = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare i32 @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %arr.gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.gep8, align 4
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @sub_140002960(i8* %before.ptr)
  br label %loop1

loop1:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body_end ]
  %cmp.i = icmp ult i64 %i, 9
  br i1 %cmp.i, label %loop1.body, label %afterloop1

loop1.body:
  %eltptr.i = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val.i = load i32, i32* %eltptr.i, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.print.i = call i32 (i8*, ...) @sub_140002960(i8* %fmt.ptr, i32 %val.i)
  br label %loop1.body_end

loop1.body_end:
  %i.next = add i64 %i, 1
  br label %loop1

afterloop1:
  %call.nl1 = call i32 @sub_140002AF0(i32 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @sub_140001450(i32* %arr.base, i64 9)
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @sub_140002960(i8* %after.ptr)
  br label %loop2

loop2:
  %j = phi i64 [ 0, %afterloop1 ], [ %j.next, %loop2.body_end ]
  %cmp.j = icmp ult i64 %j, 9
  br i1 %cmp.j, label %loop2.body, label %afterloop2

loop2.body:
  %eltptr.j = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val.j = load i32, i32* %eltptr.j, align 4
  %fmt.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.print.j = call i32 (i8*, ...) @sub_140002960(i8* %fmt.ptr2, i32 %val.j)
  br label %loop2.body_end

loop2.body_end:
  %j.next = add i64 %j, 1
  br label %loop2

afterloop2:
  %call.nl2 = call i32 @sub_140002AF0(i32 10)
  ret i32 0
}