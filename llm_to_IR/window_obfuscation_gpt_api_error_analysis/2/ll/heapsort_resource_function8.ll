; ModuleID = 'sub_14000171D_module'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@byte_14000400D = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @sub_1400018F0()
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.base, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5, i32* %p8, align 4
  %fmt1.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %call.printf.header1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr)
  br label %loop1.cond

loop1.cond:
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i.phi, 9
  br i1 %cmp1, label %loop1.body, label %after.loop1

loop1.body:
  %elt.ptr1 = getelementptr inbounds i32, i32* %arr.base, i64 %i.phi
  %elt1 = load i32, i32* %elt.ptr1, align 4
  %fmt.d.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.printf.val1 = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr1, i32 %elt1)
  %i.next = add i64 %i.phi, 1
  br label %loop1.cond

after.loop1:
  %nl1 = call i32 @putchar(i32 10)
  call void @sub_140001450(i32* %arr.base, i64 9)
  %fmt2.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call.printf.header2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr)
  br label %loop2.cond

loop2.cond:
  %j.phi = phi i64 [ 0, %after.loop1 ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j.phi, 9
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:
  %elt.ptr2 = getelementptr inbounds i32, i32* %arr.base, i64 %j.phi
  %elt2 = load i32, i32* %elt.ptr2, align 4
  %fmt.d.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.printf.val2 = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr2, i32 %elt2)
  %j.next = add i64 %j.phi, 1
  br label %loop2.cond

after.loop2:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}