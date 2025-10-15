; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@fmt_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@msg_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@msg_after = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cond.empty = icmp ule i64 %n, 1
  br i1 %cond.empty, label %ret, label %outer

outer:
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %inner, label %ret

inner:
  %minIdx = phi i64 [ %i, %outer ], [ %minIdx.next, %inner.body ]
  %j = phi i64 [ %i, %outer ], [ %j.next, %inner.body ]
  %cmp.j = icmp ult i64 %j, %n
  br i1 %cmp.j, label %inner.body, label %swap

inner.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val.j = load i32, i32* %gep.j, align 4
  %gep.min = getelementptr inbounds i32, i32* %arr, i64 %minIdx
  %val.min = load i32, i32* %gep.min, align 4
  %lt = icmp slt i32 %val.j, %val.min
  %minIdx.next = select i1 %lt, i64 %j, i64 %minIdx
  %j.next = add i64 %j, 1
  br label %inner

swap:
  %same = icmp eq i64 %minIdx, %i
  br i1 %same, label %outer.inc, label %do.swap

do.swap:
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.i = load i32, i32* %gep.i, align 4
  %gep.min2 = getelementptr inbounds i32, i32* %arr, i64 %minIdx
  %val.min2 = load i32, i32* %gep.min2, align 4
  store i32 %val.min2, i32* %gep.i, align 4
  store i32 %val.i, i32* %gep.min2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @msg_before, i64 0, i64 0
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @msg_after, i64 0, i64 0
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @fmt_d, i64 0, i64 0
  %call.before = call i32 @printf(i8* %before.ptr)
  br label %print.loop

print.loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.cont ]
  %cmp.i = icmp ult i64 %i, 9
  br i1 %cmp.i, label %print.body, label %print.end

print.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call.print = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %print.cont

print.cont:
  %i.next = add i64 %i, 1
  br label %print.loop

print.end:
  %nl1 = call i32 @putchar(i32 10)
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.decay, i64 9)
  %call.after = call i32 @printf(i8* %after.ptr)
  br label %print2.loop

print2.loop:
  %j = phi i64 [ 0, %print.end ], [ %j.next, %print2.cont ]
  %cmp.j = icmp ult i64 %j, 9
  br i1 %cmp.j, label %print2.body, label %done

print2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call.print2 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem2)
  br label %print2.cont

print2.cont:
  %j.next = add i64 %j, 1
  br label %print2.loop

done:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}