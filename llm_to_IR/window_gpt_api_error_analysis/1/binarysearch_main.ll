; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\n\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\n\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  %cmp0 = icmp eq i64 %n, 0
  br i1 %cmp0, label %ret_neg, label %init

ret_neg:
  ret i32 -1

init:
  %high_init = add i64 %n, -1
  br label %loop.header

loop.header:
  %low_phi = phi i64 [ 0, %init ], [ %low_phi, %left ], [ %low_next, %right ]
  %high_phi = phi i64 [ %high_init, %init ], [ %high_next, %left ], [ %high_phi, %right ]
  %cond = icmp sle i64 %low_phi, %high_phi
  br i1 %cond, label %loop.body, label %notfound

loop.body:
  %range = sub i64 %high_phi, %low_phi
  %half = lshr i64 %range, 1
  %mid = add i64 %low_phi, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %is_lt = icmp slt i32 %elem, %key
  br i1 %is_lt, label %right, label %check_gt

check_gt:
  %is_gt = icmp sgt i32 %elem, %key
  br i1 %is_gt, label %left, label %found

right:
  %low_next = add i64 %mid, 1
  br label %loop.header

left:
  %high_next = add i64 %mid, -1
  br label %loop.header

found:
  %mid_i32 = trunc i64 %mid to i32
  ret i32 %mid_i32

notfound:
  ret i32 -1
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16

  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8.ptr, align 4

  %keys0.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0.ptr, align 4
  %keys1.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1.ptr, align 4
  %keys2.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2.ptr, align 4

  br label %loop.header

loop.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %loop.body, label %loop.end

loop.body:
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %key.ptr = getelementptr inbounds i32, i32* %keys.base, i64 %i
  %key = load i32, i32* %key.ptr, align 4

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i32 @binary_search(i32* %arr.base, i64 9, i32 %key)

  %isneg = icmp slt i32 %res, 0
  br i1 %isneg, label %print_nf, label %print_found

print_found:
  %fmt_found.gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call_pf = call i32 (i8*, ...) @printf(i8* %fmt_found.gep, i32 %key, i32 %res)
  br label %loop.inc

print_nf:
  %fmt_nf.gep = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %call_pn = call i32 (i8*, ...) @printf(i8* %fmt_nf.gep, i32 %key)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop.header

loop.end:
  ret i32 0
}