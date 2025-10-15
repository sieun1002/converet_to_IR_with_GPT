; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@unk_140004000 = dso_local unnamed_addr constant [9 x i8] c"Before: \00", align 1
@unk_140004009 = dso_local unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_14000400D = dso_local unnamed_addr constant [8 x i8] c"After: \00", align 1

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
  %ap_cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_cast)
  %ap_load = load i8*, i8** %ap, align 8
  %call = call i32 @vprintf(i8* %fmt, i8* %ap_load)
  call void @llvm.va_end(i8* %ap_cast)
  ret i32 %call
}

define dso_local void @sub_140002AF0(i32 %ch) {
entry:
  %call = call i32 @putchar(i32 %ch)
  ret void
}

define dso_local void @sub_140001450(i32* %arr, i64 %count) {
entry:
  br label %outer.loop

outer.loop:                                        ; preds = %outer.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp ult i64 %i, %count
  br i1 %cmp.outer, label %init.inner, label %outer.end

init.inner:                                        ; preds = %outer.loop
  %min.init = add i64 %i, 0
  %j.init = add i64 %i, 1
  br label %inner.loop

inner.loop:                                        ; preds = %inner.body, %init.inner
  %min.idx = phi i64 [ %min.init, %init.inner ], [ %min.next, %inner.body ]
  %j = phi i64 [ %j.init, %init.inner ], [ %j.next, %inner.body ]
  %cmp.inner = icmp ult i64 %j, %count
  br i1 %cmp.inner, label %inner.body, label %inner.end

inner.body:                                        ; preds = %inner.loop
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx
  %min.val = load i32, i32* %min.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %is.less = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %is.less, i64 %j, i64 %min.idx
  %min.next = add i64 %min.sel, 0
  %j.next = add i64 %j, 1
  br label %inner.loop

inner.end:                                         ; preds = %inner.loop
  %min.final = phi i64 [ %min.idx, %inner.loop ]
  %need.swap = icmp ne i64 %min.final, %i
  br i1 %need.swap, label %do.swap, label %outer.inc

do.swap:                                           ; preds = %inner.end
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %i.ptr, align 4
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.final
  %b = load i32, i32* %min.ptr2, align 4
  store i32 %b, i32* %i.ptr, align 4
  store i32 %a, i32* %min.ptr2, align 4
  br label %outer.inc

outer.inc:                                         ; preds = %do.swap, %inner.end
  %i.next = add i64 %i, 1
  br label %outer.loop

outer.end:                                         ; preds = %outer.loop
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  call void @sub_1400018F0()
  %arr = alloca [9 x i32], align 16
  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8.ptr, align 4
  %count = add i64 9, 0
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @unk_140004000, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @sub_140002960(i8* %before.ptr)
  br label %loop1

loop1:                                             ; preds = %loop1.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.inc ]
  %cmp1 = icmp ult i64 %i, %count
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                        ; preds = %loop1
  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call.print = call i32 (i8*, ...) @sub_140002960(i8* %fmt.ptr, i32 %val)
  br label %loop1.inc

loop1.inc:                                         ; preds = %loop1.body
  %i.next = add i64 %i, 1
  br label %loop1

loop1.end:                                         ; preds = %loop1
  call void @sub_140002AF0(i32 10)
  %arr.first = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @sub_140001450(i32* %arr.first, i64 %count)
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @unk_14000400D, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @sub_140002960(i8* %after.ptr)
  br label %loop2

loop2:                                             ; preds = %loop2.inc, %loop1.end
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.inc ]
  %cmp2 = icmp ult i64 %j, %count
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                        ; preds = %loop2
  %base2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %elem2.ptr = getelementptr inbounds i32, i32* %base2.ptr, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call.print2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt2.ptr, i32 %val2)
  br label %loop2.inc

loop2.inc:                                         ; preds = %loop2.body
  %j.next = add i64 %j, 1
  br label %loop2

loop2.end:                                         ; preds = %loop2
  call void @sub_140002AF0(i32 10)
  ret i32 0
}