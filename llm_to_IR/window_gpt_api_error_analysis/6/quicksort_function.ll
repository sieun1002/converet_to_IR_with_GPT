; ModuleID = 'quick_sort_module'
source_filename = "quick_sort.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* nocapture %arr, i32 %left, i32 %right) {
entry:
  br label %while.header

while.header:                                    ; preds = %entry, %choose.left, %choose.right
  %curL = phi i32 [ %left, %entry ], [ %nextL.left, %choose.left ], [ %nextL.right, %choose.right ]
  %curR = phi i32 [ %right, %entry ], [ %nextR.left, %choose.left ], [ %nextR.right, %choose.right ]
  %cmp.lr = icmp slt i32 %curL, %curR
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:                                  ; preds = %while.header
  %diff = sub i32 %curR, %curL
  %half = sdiv i32 %diff, 2
  %mid = add i32 %curL, %half
  %mid64 = sext i32 %mid to i64
  %ptrmid = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %ptrmid, align 4
  %i0 = add i32 %curL, 0
  %j0 = add i32 %curR, 0
  br label %loop.header

loop.header:                                     ; preds = %swap.do, %partition.init
  %i.loop = phi i32 [ %i0, %partition.init ], [ %i.next, %swap.do ]
  %j.loop = phi i32 [ %j0, %partition.init ], [ %j.next, %swap.do ]
  br label %i.advance

i.advance:                                       ; preds = %i.advance.inc, %loop.header
  %i.cur = phi i32 [ %i.loop, %loop.header ], [ %i.inc, %i.advance.inc ]
  %i.cur64 = sext i32 %i.cur to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur64
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %i.advance.inc, label %i.advance.exit

i.advance.inc:                                   ; preds = %i.advance
  %i.inc = add i32 %i.cur, 1
  br label %i.advance

i.advance.exit:                                  ; preds = %i.advance
  %i.fixed = add i32 %i.cur, 0
  br label %j.advance

j.advance:                                       ; preds = %j.advance.dec, %i.advance.exit
  %j.cur = phi i32 [ %j.loop, %i.advance.exit ], [ %j.dec, %j.advance.dec ]
  %i.stable = phi i32 [ %i.fixed, %i.advance.exit ], [ %i.stable, %j.advance.dec ]
  %j.cur64 = sext i32 %j.cur to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur64
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.j, label %j.advance.dec, label %compare

j.advance.dec:                                   ; preds = %j.advance
  %j.dec = add i32 %j.cur, -1
  br label %j.advance

compare:                                         ; preds = %j.advance
  %cmp.le = icmp sle i32 %i.stable, %j.cur
  br i1 %cmp.le, label %swap.do, label %partition.done

swap.do:                                         ; preds = %compare
  %i.ptr64 = sext i32 %i.stable to i64
  %j.ptr64 = sext i32 %j.cur to i64
  %ptr.swap.i = getelementptr inbounds i32, i32* %arr, i64 %i.ptr64
  %ptr.swap.j = getelementptr inbounds i32, i32* %arr, i64 %j.ptr64
  %val.swap.i = load i32, i32* %ptr.swap.i, align 4
  %val.swap.j = load i32, i32* %ptr.swap.j, align 4
  store i32 %val.swap.j, i32* %ptr.swap.i, align 4
  store i32 %val.swap.i, i32* %ptr.swap.j, align 4
  %i.next = add i32 %i.stable, 1
  %j.next = add i32 %j.cur, -1
  br label %loop.header

partition.done:                                  ; preds = %compare
  %i.final = add i32 %i.stable, 0
  %j.final = add i32 %j.cur, 0
  %left.size = sub i32 %j.final, %curL
  %right.size = sub i32 %curR, %i.final
  %left.smaller = icmp slt i32 %left.size, %right.size
  br i1 %left.smaller, label %choose.left, label %choose.right

choose.left:                                     ; preds = %partition.done
  %need.left.call = icmp slt i32 %curL, %j.final
  br i1 %need.left.call, label %do.left.call, label %skip.left.call

do.left.call:                                    ; preds = %choose.left
  call void @quick_sort(i32* %arr, i32 %curL, i32 %j.final)
  br label %left.after.call

skip.left.call:                                  ; preds = %choose.left
  br label %left.after.call

left.after.call:                                 ; preds = %skip.left.call, %do.left.call
  %nextL.left = add i32 %i.final, 0
  %nextR.left = add i32 %curR, 0
  br label %while.header

choose.right:                                    ; preds = %partition.done
  %need.right.call = icmp slt i32 %i.final, %curR
  br i1 %need.right.call, label %do.right.call, label %skip.right.call

do.right.call:                                   ; preds = %choose.right
  call void @quick_sort(i32* %arr, i32 %i.final, i32 %curR)
  br label %right.after.call

skip.right.call:                                 ; preds = %choose.right
  br label %right.after.call

right.after.call:                                ; preds = %skip.right.call, %do.right.call
  %nextL.right = add i32 %curL, 0
  %nextR.right = add i32 %j.final, 0
  br label %while.header

ret:                                             ; preds = %while.header
  ret void
}