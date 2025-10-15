; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-windows-msvc"

@.str_prefix1 = private unnamed_addr constant [16 x i8] c"Original array:\00"
@.str_prefix2 = private unnamed_addr constant [14 x i8] c"Sorted array:\00"
@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00"

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)
declare dllimport void @qsort(i8*, i64, i64, i32 (i8*, i8*)*)

define void @__main() {
entry:
  ret void
}

define i32 @cmp_int(i8* noundef %pa, i8* noundef %pb) {
entry:
  %a_ptr = bitcast i8* %pa to i32*
  %b_ptr = bitcast i8* %pb to i32*
  %a = load i32, i32* %a_ptr, align 4
  %b = load i32, i32* %b_ptr, align 4
  %lt = icmp slt i32 %a, %b
  br i1 %lt, label %ret_neg, label %check_gt

ret_neg:
  ret i32 -1

check_gt:
  %gt = icmp sgt i32 %a, %b
  br i1 %gt, label %ret_pos, label %ret_zero

ret_pos:
  ret i32 1

ret_zero:
  ret i32 0
}

define void @heap_sort(i32* noundef %arr, i64 noundef %len) {
entry:
  %base = bitcast i32* %arr to i8*
  call void @qsort(i8* %base, i64 %len, i64 4, i32 (i8*, i8*)* @cmp_int)
  ret void
}

define i32 @main() {
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
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %pfx1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_prefix1, i64 0, i64 0
  %callpfx1 = call i32 (i8*, ...) @printf(i8* %pfx1)
  br label %for1.cond

for1.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %for1.body, label %for1.exit

for1.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %callnum = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %i, 1
  br label %for1.cond

for1.exit:
  %nl1 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* %arrdecay, i64 9)
  %pfx2 = getelementptr inbounds [14 x i8], [14 x i8]* @.str_prefix2, i64 0, i64 0
  %callpfx2 = call i32 (i8*, ...) @printf(i8* %pfx2)
  br label %for2.cond

for2.cond:
  %j = phi i64 [ 0, %for1.exit ], [ %jinc, %for2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %for2.body, label %for2.exit

for2.body:
  %elem2.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %callnum2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val2)
  %jinc = add i64 %j, 1
  br label %for2.cond

for2.exit:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}