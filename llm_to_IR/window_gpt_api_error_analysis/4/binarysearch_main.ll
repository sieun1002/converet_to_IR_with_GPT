; ModuleID = 'binsearch_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* %arr, i64 %len, i32 %key) {
entry:
  %len_minus1 = add i64 %len, -1
  br label %loop

loop:
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %latch ]
  %hi = phi i64 [ %len_minus1, %entry ], [ %hi.next, %latch ]
  %cond = icmp sle i64 %lo, %hi
  br i1 %cond, label %body, label %notfound

body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %cont

cont:
  %lt = icmp slt i32 %val, %key
  br i1 %lt, label %update_lo, label %update_hi

update_lo:
  %mid_plus = add i64 %mid, 1
  br label %latch

update_hi:
  %mid_minus = add i64 %mid, -1
  br label %latch

latch:
  %lo.next = phi i64 [ %mid_plus, %update_lo ], [ %lo, %update_hi ]
  %hi.next = phi i64 [ %hi, %update_lo ], [ %mid_minus, %update_hi ]
  br label %loop

found:
  %mid32 = trunc i64 %mid to i32
  ret i32 %mid32

notfound:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4
  %queries = alloca [3 x i32], align 16
  %q0 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 0
  store i32 2, i32* %q0, align 4
  %q1 = getelementptr inbounds i32, i32* %q0, i64 1
  store i32 5, i32* %q1, align 4
  %q2 = getelementptr inbounds i32, i32* %q0, i64 2
  store i32 -5, i32* %q2, align 4
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_body ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %kptr = getelementptr inbounds i32, i32* %q0, i64 %i
  %key = load i32, i32* %kptr, align 4
  %res = call i32 @binary_search(i32* %arr0, i64 9, i32 %key)
  %neg = icmp slt i32 %res, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call_ok = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i32 %res)
  br label %after_body

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call_nf = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %after_body

after_body:
  %i.next = add i64 %i, 1
  br label %loop

exit:
  ret i32 0
}