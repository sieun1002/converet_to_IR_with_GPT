; ModuleID = 'mod'
source_filename = "mod.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dllimport i32 @printf(i8*, ...)

define void @__main() {
entry:
  ret void
}

define void @selection_sort(i32* %arr, i32 %len) {
entry:
  %len.gt1 = icmp sgt i32 %len, 1
  br i1 %len.gt1, label %outer.init, label %ret

outer.init:
  %lenm1 = add i32 %len, -1
  br label %outer

outer:
  %i = phi i32 [ 0, %outer.init ], [ %i.next, %outer.end ]
  %cond.outer = icmp slt i32 %i, %lenm1
  br i1 %cond.outer, label %inner.init, label %ret

inner.init:
  %min0 = add i32 %i, 0
  %j0 = add i32 %i, 1
  br label %inner

inner:
  %j = phi i32 [ %j0, %inner.init ], [ %j.next, %inner ]
  %min = phi i32 [ %min0, %inner.init ], [ %min.next, %inner ]
  %cmpj = icmp slt i32 %j, %len
  br i1 %cmpj, label %inner.cmp, label %after_inner

inner.cmp:
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min to i64
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %minptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vj = load i32, i32* %jptr, align 4
  %vmin = load i32, i32* %minptr, align 4
  %isless = icmp slt i32 %vj, %vmin
  %min.updated = select i1 %isless, i32 %j, i32 %min
  %min.next = add i32 %min.updated, 0
  %j.next = add i32 %j, 1
  br label %inner

after_inner:
  %min.final = phi i32 [ %min, %inner ]
  %cmpmin = icmp ne i32 %min.final, %i
  br i1 %cmpmin, label %do_swap, label %outer.end

do_swap:
  %i64 = sext i32 %i to i64
  %minf64 = sext i32 %min.final to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %minfptr = getelementptr inbounds i32, i32* %arr, i64 %minf64
  %vi = load i32, i32* %iptr, align 4
  %vminf = load i32, i32* %minfptr, align 4
  store i32 %vminf, i32* %iptr, align 4
  store i32 %vi, i32* %minfptr, align 4
  br label %outer.end

outer.end:
  %i.next = add i32 %i, 1
  br label %outer

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %a0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %a0ptr, align 4
  %a1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %a1ptr, align 4
  %a2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %a2ptr, align 4
  %a3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %a3ptr, align 4
  %a4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %a4ptr, align 4
  store i32 5, i32* %len, align 4
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %lenval = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arr0, i32 %lenval)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt1)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %ival = load i32, i32* %i, align 4
  %lenval2 = load i32, i32* %len, align 4
  %lt = icmp slt i32 %ival, %lenval2
  br i1 %lt, label %body, label %end

body:
  %idx64 = sext i32 %ival to i64
  %elemptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %elem = load i32, i32* %elemptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add i32 %ival, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

end:
  ret i32 0
}