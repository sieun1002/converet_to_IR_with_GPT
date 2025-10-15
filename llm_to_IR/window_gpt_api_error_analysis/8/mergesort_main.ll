; ModuleID = 'merged'
source_filename = "merged.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @merge_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp.n = icmp ule i64 %n, 1
  br i1 %cmp.n, label %ret, label %split

ret:
  ret void

split:
  %mid = lshr i64 %n, 1
  %right_n = sub i64 %n, %mid
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  call void @merge_sort(i32* %arr, i64 %mid)
  call void @merge_sort(i32* %right_ptr, i64 %right_n)
  %tmp = alloca i32, i64 %n, align 16
  br label %merge.cond

merge.cond:
  %i = phi i64 [ 0, %split ], [ %i.next, %merge.body.then ], [ %i.next4, %merge.body.else ]
  %j = phi i64 [ 0, %split ], [ %j.next, %merge.body.then ], [ %j.next4, %merge.body.else ]
  %k = phi i64 [ 0, %split ], [ %k.next, %merge.body.then ], [ %k.next4, %merge.body.else ]
  %hasL = icmp ult i64 %i, %mid
  %hasR = icmp ult i64 %j, %right_n
  %both = and i1 %hasL, %hasR
  br i1 %both, label %merge.compare, label %merge.remainder

merge.compare:
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %right_ptr, i64 %j
  %rval = load i32, i32* %rptr, align 4
  %takeL = icmp sle i32 %lval, %rval
  br i1 %takeL, label %merge.body.then, label %merge.body.else

merge.body.then:
  %tmpkptr = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %lval, i32* %tmpkptr, align 4
  %i.next = add i64 %i, 1
  %k.next = add i64 %k, 1
  %j.next = add i64 %j, 0
  br label %merge.cond

merge.body.else:
  %tmpkptr4 = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %rval, i32* %tmpkptr4, align 4
  %j.next4 = add i64 %j, 1
  %k.next4 = add i64 %k, 1
  %i.next4 = add i64 %i, 0
  br label %merge.cond

merge.remainder:
  %needLeft = icmp ult i64 %i, %mid
  br i1 %needLeft, label %copy.left.loop.cond, label %copy.right.loop.cond

copy.left.loop.cond:
  %iL = phi i64 [ %i, %merge.remainder ], [ %iL.next, %copy.left.body ]
  %kL = phi i64 [ %k, %merge.remainder ], [ %kL.next, %copy.left.body ]
  %hasLeftRem = icmp ult i64 %iL, %mid
  br i1 %hasLeftRem, label %copy.left.body, label %after.copy

copy.left.body:
  %lptr2 = getelementptr inbounds i32, i32* %arr, i64 %iL
  %lval2 = load i32, i32* %lptr2, align 4
  %tmpkptr2 = getelementptr inbounds i32, i32* %tmp, i64 %kL
  store i32 %lval2, i32* %tmpkptr2, align 4
  %iL.next = add i64 %iL, 1
  %kL.next = add i64 %kL, 1
  br label %copy.left.loop.cond

copy.right.loop.cond:
  %jR = phi i64 [ %j, %merge.remainder ], [ %jR.next, %copy.right.body ]
  %kR = phi i64 [ %k, %merge.remainder ], [ %kR.next, %copy.right.body ]
  %hasRightRem = icmp ult i64 %jR, %right_n
  br i1 %hasRightRem, label %copy.right.body, label %after.copy

copy.right.body:
  %rptr2 = getelementptr inbounds i32, i32* %right_ptr, i64 %jR
  %rval2 = load i32, i32* %rptr2, align 4
  %tmpkptr3 = getelementptr inbounds i32, i32* %tmp, i64 %kR
  store i32 %rval2, i32* %tmpkptr3, align 4
  %jR.next = add i64 %jR, 1
  %kR.next = add i64 %kR, 1
  br label %copy.right.loop.cond

after.copy:
  br label %copyback.cond

copyback.cond:
  %t = phi i64 [ 0, %after.copy ], [ %t.next, %copyback.body ]
  %tcond = icmp ult i64 %t, %n
  br i1 %tcond, label %copyback.body, label %done

copyback.body:
  %vptr = getelementptr inbounds i32, i32* %tmp, i64 %t
  %val = load i32, i32* %vptr, align 4
  %aptr = getelementptr inbounds i32, i32* %arr, i64 %t
  store i32 %val, i32* %aptr, align 4
  %t.next = add i64 %t, 1
  br label %copyback.cond

done:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4
  call void @merge_sort(i32* %p0, i64 10)
  br label %print.cond

print.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.body ]
  %lt = icmp ult i64 %i, 10
  br i1 %lt, label %print.body, label %after.print

print.body:
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %print.cond

after.print:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}