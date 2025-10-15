; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@unk_140004000 = dso_local unnamed_addr constant [9 x i8] c"Original\00", align 1
@unk_140004009 = dso_local unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_14000400D = dso_local unnamed_addr constant [7 x i8] c"Sorted\00", align 1

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
  %ap.load = load i8*, i8** %ap, align 8
  %call = call i32 @vprintf(i8* %fmt, i8* %ap.load)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}

define dso_local void @sub_140002AF0(i32 %ch) {
entry:
  %call = call i32 @putchar(i32 %ch)
  ret void
}

define dso_local void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmpn = icmp ule i64 %n, 1
  br i1 %cmpn, label %ret, label %outer_cond

outer_cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer_cond_end ]
  %check = icmp ult i64 %i, %n
  br i1 %check, label %outer_body, label %ret

outer_body:
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %iptr, align 4
  %j.init = add i64 %i, -1
  br label %inner_cond

inner_cond:
  %j = phi i64 [ %j.init, %outer_body ], [ %j.dec, %inner_body ]
  %j_ge0 = icmp sge i64 %j, 0
  br i1 %j_ge0, label %inner_check, label %inner_exit

inner_check:
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %aj = load i32, i32* %jptr, align 4
  %cmpaj = icmp sgt i32 %aj, %key
  br i1 %cmpaj, label %inner_body, label %inner_exit

inner_body:
  %jp1 = add i64 %j, 1
  %jp1ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1
  store i32 %aj, i32* %jp1ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner_cond

inner_exit:
  %jp1b = add i64 %j, 1
  %jp1bptr = getelementptr inbounds i32, i32* %arr, i64 %jp1b
  store i32 %key, i32* %jp1bptr, align 4
  br label %outer_cond_end

outer_cond_end:
  %i.next = add i64 %i, 1
  br label %outer_cond

ret:
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  call void @sub_1400018F0()
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
  %p0 = getelementptr inbounds [9 x i8], [9 x i8]* @unk_140004000, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @sub_140002960(i8* %p0)
  br label %loop1.cond

loop1.cond:
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmtnum1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %callnum1 = call i32 (i8*, ...) @sub_140002960(i8* %fmtnum1, i32 %val1)
  %i1.next = add i64 %i1, 1
  br label %loop1.cond

loop1.end:
  call void @sub_140002AF0(i32 10)
  %arrptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @sub_140001450(i32* %arrptr0, i64 9)
  %p1 = getelementptr inbounds [7 x i8], [7 x i8]* @unk_14000400D, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140002960(i8* %p1)
  br label %loop2.cond

loop2.cond:
  %i2 = phi i64 [ 0, %loop1.end ], [ %i2.next, %loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmtnum2 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %callnum2 = call i32 (i8*, ...) @sub_140002960(i8* %fmtnum2, i32 %val2)
  %i2.next = add i64 %i2, 1
  br label %loop2.cond

loop2.end:
  call void @sub_140002AF0(i32 10)
  ret i32 0
}