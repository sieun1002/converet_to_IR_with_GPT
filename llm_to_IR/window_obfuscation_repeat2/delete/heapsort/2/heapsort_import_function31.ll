; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare void @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

@unk_140004000 = external constant i8
@unk_140004009 = external constant i8
@unk_14000400D = external constant i8

define i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  store i64 9, i64* %len, align 8
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004000)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop1.body, label %after.loop1

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

after.loop1:                                     ; preds = %loop1.cond
  call void @sub_140002AF0(i32 10)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @sub_140001450(i32* %arr.ptr, i64 %len2)
  %call2 = call i32 (i8*, ...) @sub_140002960(i8* @unk_14000400D)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %after.loop1
  %j.val = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len3
  br i1 %cmp2, label %loop2.body, label %after.loop2

loop2.body:                                      ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %call3 = call i32 (i8*, ...) @sub_140002960(i8* @unk_140004009, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

after.loop2:                                     ; preds = %loop2.cond
  call void @sub_140002AF0(i32 10)
  ret i32 0
}