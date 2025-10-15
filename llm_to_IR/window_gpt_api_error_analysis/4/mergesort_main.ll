; ModuleID = 'merge_sort_module'
source_filename = "merge_sort_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  br label %for.i

for.i:                                             ; preds = %for.i.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.i.inc ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %for.body.i, label %for.end

for.body.i:                                        ; preds = %for.i
  %minIdx0 = add i64 %i, 0
  %j0 = add i64 %i, 1
  br label %for.j

for.j:                                             ; preds = %for.j.body, %for.body.i
  %minIdx = phi i64 [ %minIdx0, %for.body.i ], [ %minIdx.sel, %for.j.body ]
  %j = phi i64 [ %j0, %for.body.i ], [ %j.next, %for.j.body ]
  %cond.j = icmp ult i64 %j, %n
  br i1 %cond.j, label %for.j.body, label %for.j.end

for.j.body:                                        ; preds = %for.j
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val.j = load i32, i32* %gep.j, align 4
  %gep.min = getelementptr inbounds i32, i32* %arr, i64 %minIdx
  %val.min = load i32, i32* %gep.min, align 4
  %cmp.lt = icmp slt i32 %val.j, %val.min
  %minIdx.sel = select i1 %cmp.lt, i64 %j, i64 %minIdx
  %j.next = add i64 %j, 1
  br label %for.j

for.j.end:                                         ; preds = %for.j
  %need.swap = icmp ne i64 %minIdx, %i
  br i1 %need.swap, label %swap, label %for.i.inc

swap:                                              ; preds = %for.j.end
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %v.i = load i32, i32* %p.i, align 4
  %p.min = getelementptr inbounds i32, i32* %arr, i64 %minIdx
  %v.min = load i32, i32* %p.min, align 4
  store i32 %v.min, i32* %p.i, align 4
  store i32 %v.i, i32* %p.min, align 4
  br label %for.i.inc

for.i.inc:                                         ; preds = %swap, %for.j.end
  %i.next = add i64 %i, 1
  br label %for.i

for.end:                                           ; preds = %for.i
  ret void
}

define dso_local i32 @main(i32 noundef %argc, i8** noundef %argv) {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %i.addr = alloca i64, align 8
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %0, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %e9, align 4
  call void @merge_sort(i32* %0, i64 10)
  store i64 0, i64* %i.addr, align 8
  br label %loop

loop:                                              ; preds = %body, %entry
  %idx = load i64, i64* %i.addr, align 8
  %cmp = icmp ult i64 %idx, 10
  br i1 %cmp, label %body, label %after

body:                                              ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %idx
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %next = add i64 %idx, 1
  store i64 %next, i64* %i.addr, align 8
  br label %loop

after:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}