; ModuleID: merged_module
source_filename = "merged_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define void @__main() {
entry:
  ret void
}

define void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %temp = alloca i32, i64 %n, align 4
  %cmp.base = icmp ule i64 %n, 1
  br i1 %cmp.base, label %ret, label %recurse

recurse:
  %mid = lshr i64 %n, 1
  call void @merge_sort(i32* %arr, i64 %mid)
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %n_minus_mid = sub i64 %n, %mid
  call void @merge_sort(i32* %right.ptr, i64 %n_minus_mid)
  br label %merge_iter

merge_iter:
  %i = phi i64 [ 0, %recurse ], [ %i.nextL, %take_left ], [ %i.nextR, %take_right ]
  %j = phi i64 [ %mid, %recurse ], [ %j.keep, %take_left ], [ %j.next, %take_right ]
  %k = phi i64 [ 0, %recurse ], [ %k.nextL, %take_left ], [ %k.nextR, %take_right ]
  %cond.i = icmp ult i64 %i, %mid
  %cond.j = icmp ult i64 %j, %n
  %cond.both = and i1 %cond.i, %cond.j
  br i1 %cond.both, label %choose, label %merge_remainder

choose:
  %l.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %l.val = load i32, i32* %l.ptr, align 4
  %r.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %r.val = load i32, i32* %r.ptr, align 4
  %le = icmp sle i32 %l.val, %r.val
  br i1 %le, label %take_left, label %take_right

take_left:
  %t.ptrL = getelementptr inbounds i32, i32* %temp, i64 %k
  store i32 %l.val, i32* %t.ptrL, align 4
  %i.nextL = add i64 %i, 1
  %j.keep = add i64 %j, 0
  %k.nextL = add i64 %k, 1
  br label %merge_iter

take_right:
  %t.ptrR = getelementptr inbounds i32, i32* %temp, i64 %k
  store i32 %r.val, i32* %t.ptrR, align 4
  %i.nextR = add i64 %i, 0
  %j.next = add i64 %j, 1
  %k.nextR = add i64 %k, 1
  br label %merge_iter

merge_remainder:
  br label %copy_left.loop

copy_left.loop:
  %iL = phi i64 [ %i, %merge_remainder ], [ %iL.next, %copy_left.body ]
  %kL = phi i64 [ %k, %merge_remainder ], [ %kL.next, %copy_left.body ]
  %cond.left = icmp ult i64 %iL, %mid
  br i1 %cond.left, label %copy_left.body, label %copy_right.entry

copy_left.body:
  %srcL.ptr = getelementptr inbounds i32, i32* %arr, i64 %iL
  %vL = load i32, i32* %srcL.ptr, align 4
  %dstL.ptr = getelementptr inbounds i32, i32* %temp, i64 %kL
  store i32 %vL, i32* %dstL.ptr, align 4
  %iL.next = add i64 %iL, 1
  %kL.next = add i64 %kL, 1
  br label %copy_left.loop

copy_right.entry:
  br label %copy_right.loop

copy_right.loop:
  %jR = phi i64 [ %j, %copy_right.entry ], [ %jR.next, %copy_right.body ]
  %kR = phi i64 [ %kL, %copy_right.entry ], [ %kR.next, %copy_right.body ]
  %cond.right = icmp ult i64 %jR, %n
  br i1 %cond.right, label %copy_right.body, label %copyback.entry

copy_right.body:
  %srcR.ptr = getelementptr inbounds i32, i32* %arr, i64 %jR
  %vR = load i32, i32* %srcR.ptr, align 4
  %dstR.ptr = getelementptr inbounds i32, i32* %temp, i64 %kR
  store i32 %vR, i32* %dstR.ptr, align 4
  %jR.next = add i64 %jR, 1
  %kR.next = add i64 %kR, 1
  br label %copy_right.loop

copyback.entry:
  br label %copyback.loop

copyback.loop:
  %m = phi i64 [ 0, %copyback.entry ], [ %m.next, %copyback.body ]
  %cond.m = icmp ult i64 %m, %n
  br i1 %cond.m, label %copyback.body, label %ret

copyback.body:
  %srcM.ptr = getelementptr inbounds i32, i32* %temp, i64 %m
  %vM = load i32, i32* %srcM.ptr, align 4
  %dstM.ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  store i32 %vM, i32* %dstM.ptr, align 4
  %m.next = add i64 %m, 1
  br label %copyback.loop

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  store i64 10, i64* %len, align 8
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %p9, align 4
  %lenv = load i64, i64* %len, align 8
  call void @merge_sort(i32* %arr0, i64 %lenv)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %lt = icmp ult i64 %i, %lenv
  br i1 %lt, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}