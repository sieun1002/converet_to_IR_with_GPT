; ModuleID = 'quicksort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @quick_sort(i32* %arr, i32 %low, i32 %high) {
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %recurse, label %ret

recurse:
  %high64 = sext i32 %high to i64
  %pivotptr = getelementptr inbounds i32, i32* %arr, i64 %high64
  %pivot = load i32, i32* %pivotptr, align 4
  %i.init = add nsw i32 %low, -1
  br label %loop

loop:
  %i.phi = phi i32 [ %i.init, %recurse ], [ %i.next, %loop.end ]
  %j.phi = phi i32 [ %low, %recurse ], [ %j.next, %loop.end ]
  %cond = icmp slt i32 %j.phi, %high
  br i1 %cond, label %loop.body, label %after

loop.body:
  %j64 = sext i32 %j.phi to i64
  %e.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %e.val = load i32, i32* %e.ptr, align 4
  %le = icmp sle i32 %e.val, %pivot
  br i1 %le, label %if.then, label %if.else

if.then:
  %i.inc = add nsw i32 %i.phi, 1
  %i64 = sext i32 %i.inc to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %ival = load i32, i32* %iptr, align 4
  store i32 %e.val, i32* %iptr, align 4
  store i32 %ival, i32* %e.ptr, align 4
  %j.next.then = add nsw i32 %j.phi, 1
  br label %loop.end

if.else:
  %j.next.else = add nsw i32 %j.phi, 1
  br label %loop.end

loop.end:
  %i.next = phi i32 [ %i.inc, %if.then ], [ %i.phi, %if.else ]
  %j.next = phi i32 [ %j.next.then, %if.then ], [ %j.next.else, %if.else ]
  br label %loop

after:
  %ip1 = add nsw i32 %i.phi, 1
  %ip1_64 = sext i32 %ip1 to i64
  %ip1ptr = getelementptr inbounds i32, i32* %arr, i64 %ip1_64
  %arrip1 = load i32, i32* %ip1ptr, align 4
  store i32 %arrip1, i32* %pivotptr, align 4
  store i32 %pivot, i32* %ip1ptr, align 4
  %left_high = add nsw i32 %ip1, -1
  call void @quick_sort(i32* %arr, i32 %low, i32 %left_high)
  %right_low = add nsw i32 %ip1, 1
  call void @quick_sort(i32* %arr, i32 %right_low, i32 %high)
  br label %ret

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %n, align 8
  %nv = load i64, i64* %n, align 8
  %cmp = icmp ule i64 %nv, 1
  br i1 %cmp, label %skip, label %dosort

dosort:
  %nv2 = load i64, i64* %n, align 8
  %nminus1 = add i64 %nv2, -1
  %high32 = trunc i64 %nminus1 to i32
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i32 0, i32 %high32)
  br label %skip

skip:
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %iVal = load i64, i64* %i, align 8
  %nval = load i64, i64* %n, align 8
  %lt = icmp ult i64 %iVal, %nval
  br i1 %lt, label %loop.body, label %afterloop

loop.body:
  %base2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr2 = getelementptr inbounds i32, i32* %base2, i64 %iVal
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem2)
  %inext = add i64 %iVal, 1
  store i64 %inext, i64* %i, align 8
  br label %loop.cond

afterloop:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}