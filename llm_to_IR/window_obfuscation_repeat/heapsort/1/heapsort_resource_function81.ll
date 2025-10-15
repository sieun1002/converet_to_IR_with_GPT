; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@Format = dso_local constant [9 x i8] c"Before: \00", align 1
@aD = dso_local constant [4 x i8] c"%d \00", align 1
@byte_14000400D = dso_local constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @vprintf(i8*, i8*)
declare dso_local i32 @putchar(i32)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_1400018F0() {
entry:
  ret void
}

define dso_local i32 @sub_140002960(i8* %fmt, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  %call = call i32 @vprintf(i8* %fmt, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}

define dso_local void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp.n = icmp ult i64 %n, 2
  br i1 %cmp.n, label %ret, label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.end
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.end ]
  %n1 = sub i64 %n, 1
  %i.lt = icmp ult i64 %i, %n1
  br i1 %i.lt, label %inner.cond, label %ret

inner.cond:                                       ; preds = %outer.cond, %inner.body.end
  %j = phi i64 [ 0, %outer.cond ], [ %j.next, %inner.body.end ]
  %limit = sub i64 %n1, %i
  %j.lt = icmp ult i64 %j, %limit
  br i1 %j.lt, label %inner.body, label %outer.end

inner.body:                                       ; preds = %inner.cond
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.plus1 = add i64 %j, 1
  %j1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  %vj = load i32, i32* %j.ptr, align 4
  %vj1 = load i32, i32* %j1.ptr, align 4
  %cmp.swap = icmp sgt i32 %vj, %vj1
  br i1 %cmp.swap, label %swap, label %noswap

swap:                                             ; preds = %inner.body
  store i32 %vj, i32* %j1.ptr, align 4
  store i32 %vj1, i32* %j.ptr, align 4
  br label %inner.body.end

noswap:                                           ; preds = %inner.body
  br label %inner.body.end

inner.body.end:                                   ; preds = %noswap, %swap
  %j.next = add i64 %j, 1
  br label %inner.cond

outer.end:                                        ; preds = %inner.cond
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:                                              ; preds = %outer.cond, %entry
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.base, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 3, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 9, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 4, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 8, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 2, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 5, i32* %idx8, align 4
  %fmt.before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @Format, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @sub_140002960(i8* %fmt.before.ptr)
  %fmt.num.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  br label %for1.cond

for1.cond:                                        ; preds = %entry, %for1.inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %for1.inc ]
  %i.lt = icmp ult i64 %i, 9
  br i1 %i.lt, label %for1.body, label %for1.end

for1.body:                                        ; preds = %for1.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %call.num1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt.num.ptr, i32 %val)
  br label %for1.inc

for1.inc:                                         ; preds = %for1.body
  %i.next = add i64 %i, 1
  br label %for1.cond

for1.end:                                         ; preds = %for1.cond
  %nl1 = call i32 @putchar(i32 10)
  call void @sub_140001450(i32* %arr.base, i64 9)
  %fmt.after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @byte_14000400D, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @sub_140002960(i8* %fmt.after.ptr)
  br label %for2.cond

for2.cond:                                        ; preds = %for1.end, %for2.inc
  %j = phi i64 [ 0, %for1.end ], [ %j.next, %for2.inc ]
  %j.lt = icmp ult i64 %j, 9
  br i1 %j.lt, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.cond
  %elem2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %call.num2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt.num.ptr, i32 %val2)
  br label %for2.inc

for2.inc:                                         ; preds = %for2.body
  %j.next = add i64 %j, 1
  br label %for2.cond

for2.end:                                         ; preds = %for2.cond
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}