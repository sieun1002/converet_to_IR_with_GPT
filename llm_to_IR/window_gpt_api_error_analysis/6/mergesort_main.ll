; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp.base = icmp ule i64 %n, 1
  br i1 %cmp.base, label %ret, label %split

ret:
  ret void

split:
  %half = lshr i64 %n, 1
  %rest = sub i64 %n, %half
  %arr2 = getelementptr inbounds i32, i32* %arr, i64 %half
  call void @merge_sort(i32* %arr, i64 %half)
  call void @merge_sort(i32* %arr2, i64 %rest)
  %tmp = alloca i32, i64 %n, align 16
  br label %cond.merge

cond.merge:
  %i.phi = phi i64 [ 0, %split ], [ %i.next, %merge.step ]
  %j.phi = phi i64 [ 0, %split ], [ %j.next, %merge.step ]
  %k.phi = phi i64 [ 0, %split ], [ %k.next, %merge.step ]
  %i.lt = icmp ult i64 %i.phi, %half
  %j.lt = icmp ult i64 %j.phi, %rest
  %both = and i1 %i.lt, %j.lt
  br i1 %both, label %body.merge, label %merge.after.main

body.merge:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.phi
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %arr2, i64 %j.phi
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp.le = icmp sle i32 %left.val, %right.val
  br i1 %cmp.le, label %merge.sel.left, label %merge.sel.right

merge.sel.left:
  %tmp.ptrL = getelementptr inbounds i32, i32* %tmp, i64 %k.phi
  store i32 %left.val, i32* %tmp.ptrL, align 4
  %k.incL = add i64 %k.phi, 1
  %i.inc = add i64 %i.phi, 1
  br label %merge.step

merge.sel.right:
  %tmp.ptrR = getelementptr inbounds i32, i32* %tmp, i64 %k.phi
  store i32 %right.val, i32* %tmp.ptrR, align 4
  %k.incR = add i64 %k.phi, 1
  %j.inc = add i64 %j.phi, 1
  br label %merge.step

merge.step:
  %i.next = phi i64 [ %i.inc, %merge.sel.left ], [ %i.phi, %merge.sel.right ]
  %j.next = phi i64 [ %j.phi, %merge.sel.left ], [ %j.inc, %merge.sel.right ]
  %k.next = phi i64 [ %k.incL, %merge.sel.left ], [ %k.incR, %merge.sel.right ]
  br label %cond.merge

merge.after.main:
  %i.exit = phi i64 [ %i.phi, %cond.merge ]
  %j.exit = phi i64 [ %j.phi, %cond.merge ]
  %k.exit = phi i64 [ %k.phi, %cond.merge ]
  br label %left.cond

left.cond:
  %i.l = phi i64 [ %i.exit, %merge.after.main ], [ %i.l.next, %left.body ]
  %k.l = phi i64 [ %k.exit, %merge.after.main ], [ %k.l.next, %left.body ]
  %left.rem = icmp ult i64 %i.l, %half
  br i1 %left.rem, label %left.body, label %right.cond

left.body:
  %lv.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.l
  %lv = load i32, i32* %lv.ptr, align 4
  %tmp.ptr.l = getelementptr inbounds i32, i32* %tmp, i64 %k.l
  store i32 %lv, i32* %tmp.ptr.l, align 4
  %i.l.next = add i64 %i.l, 1
  %k.l.next = add i64 %k.l, 1
  br label %left.cond

right.cond:
  %j.r = phi i64 [ %j.exit, %left.cond ], [ %j.r.next, %right.body ]
  %k.r = phi i64 [ %k.l, %left.cond ], [ %k.r.next, %right.body ]
  %right.rem = icmp ult i64 %j.r, %rest
  br i1 %right.rem, label %right.body, label %copy.back.cond

right.body:
  %rv.ptr = getelementptr inbounds i32, i32* %arr2, i64 %j.r
  %rv = load i32, i32* %rv.ptr, align 4
  %tmp.ptr.r = getelementptr inbounds i32, i32* %tmp, i64 %k.r
  store i32 %rv, i32* %tmp.ptr.r, align 4
  %j.r.next = add i64 %j.r, 1
  %k.r.next = add i64 %k.r, 1
  br label %right.cond

copy.back.cond:
  br label %copy.back.loop

copy.back.loop:
  %cb.i = phi i64 [ 0, %copy.back.cond ], [ %cb.i.next, %copy.back.body ]
  %cb.cmp = icmp ult i64 %cb.i, %n
  br i1 %cb.cmp, label %copy.back.body, label %merge.ret

copy.back.body:
  %tmp.elem.ptr = getelementptr inbounds i32, i32* %tmp, i64 %cb.i
  %elem = load i32, i32* %tmp.elem.ptr, align 4
  %arr.dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %cb.i
  store i32 %elem, i32* %arr.dest.ptr, align 4
  %cb.i.next = add i64 %cb.i, 1
  br label %copy.back.loop

merge.ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 9
  store i32 0, i32* %a9, align 4
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  call void @merge_sort(i32* %arr.ptr, i64 10)
  br label %loop.cond

loop.cond:
  %i.phi = phi i64 [ 0, %entry ], [ %i.next2, %print.cont ]
  %cmp = icmp ult i64 %i.phi, 10
  br i1 %cmp, label %print.body, label %after.loop

print.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %i.phi
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i32 0, i32 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %print.cont

print.cont:
  %i.next2 = add i64 %i.phi, 1
  br label %loop.cond

after.loop:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}