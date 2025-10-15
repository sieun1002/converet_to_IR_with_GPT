; ModuleID = 'quick_sort_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* noundef %arr, i32 noundef %low, i32 noundef %high) {
entry:
  br label %outer

outer:
  %low.phi = phi i32 [ %low, %entry ], [ %low.next, %loop_back ]
  %high.phi = phi i32 [ %high, %entry ], [ %high.next, %loop_back ]
  %cmp0 = icmp slt i32 %low.phi, %high.phi
  br i1 %cmp0, label %partition, label %exit

partition:
  %diff = sub i32 %high.phi, %low.phi
  %half = sdiv i32 %diff, 2
  %mid = add i32 %low.phi, %half
  %mid64 = sext i32 %mid to i64
  %p.mid = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %p.mid, align 4
  br label %scan_loop

scan_loop:
  %i.cur = phi i32 [ %low.phi, %partition ], [ %i.next2, %after_swap ]
  %j.cur = phi i32 [ %high.phi, %partition ], [ %j.next2, %after_swap ]
  br label %left_scan

left_scan:
  %i.l = phi i32 [ %i.cur, %scan_loop ], [ %i.l.inc, %left_inc ]
  %i.l64 = sext i32 %i.l to i64
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i.l64
  %val.i = load i32, i32* %p.i, align 4
  %cmp.left = icmp slt i32 %val.i, %pivot
  br i1 %cmp.left, label %left_inc, label %right_scan_entry

left_inc:
  %i.l.inc = add i32 %i.l, 1
  br label %left_scan

right_scan_entry:
  br label %right_scan

right_scan:
  %i.fixed = phi i32 [ %i.l, %right_scan_entry ], [ %i.fixed, %right_dec ]
  %j.r = phi i32 [ %j.cur, %right_scan_entry ], [ %j.r.dec, %right_dec ]
  %j.r64 = sext i32 %j.r to i64
  %p.j = getelementptr inbounds i32, i32* %arr, i64 %j.r64
  %val.j = load i32, i32* %p.j, align 4
  %cmp.right = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.right, label %right_dec, label %compare

right_dec:
  %j.r.dec = add i32 %j.r, -1
  br label %right_scan

compare:
  %cmpij = icmp sle i32 %i.fixed, %j.r
  br i1 %cmpij, label %do_swap, label %split

do_swap:
  %i64.swap = sext i32 %i.fixed to i64
  %p.i2 = getelementptr inbounds i32, i32* %arr, i64 %i64.swap
  %v.i2 = load i32, i32* %p.i2, align 4
  %j64.swap = sext i32 %j.r to i64
  %p.j2 = getelementptr inbounds i32, i32* %arr, i64 %j64.swap
  %v.j2 = load i32, i32* %p.j2, align 4
  store i32 %v.j2, i32* %p.i2, align 4
  store i32 %v.i2, i32* %p.j2, align 4
  %i.next2 = add i32 %i.fixed, 1
  %j.next2 = add i32 %j.r, -1
  br label %after_swap

after_swap:
  br label %scan_loop

split:
  %leftLen = sub i32 %j.r, %low.phi
  %rightLen = sub i32 %high.phi, %i.fixed
  %cmpSmallLeft = icmp slt i32 %leftLen, %rightLen
  br i1 %cmpSmallLeft, label %smallLeft, label %smallRight

smallLeft:
  %cmpCallLeft = icmp slt i32 %low.phi, %j.r
  br i1 %cmpCallLeft, label %doCallLeft, label %skipCallLeft

doCallLeft:
  call void @quick_sort(i32* %arr, i32 %low.phi, i32 %j.r)
  br label %skipCallLeft

skipCallLeft:
  %low.new.left = add i32 %i.fixed, 0
  %high.new.left = add i32 %high.phi, 0
  br label %loop_back

smallRight:
  %cmpCallRight = icmp slt i32 %i.fixed, %high.phi
  br i1 %cmpCallRight, label %doCallRight, label %skipCallRight

doCallRight:
  call void @quick_sort(i32* %arr, i32 %i.fixed, i32 %high.phi)
  br label %skipCallRight

skipCallRight:
  %low.new.right = add i32 %low.phi, 0
  %high.new.right = add i32 %j.r, 0
  br label %loop_back

loop_back:
  %low.next = phi i32 [ %low.new.left, %skipCallLeft ], [ %low.new.right, %skipCallRight ]
  %high.next = phi i32 [ %high.new.left, %skipCallLeft ], [ %high.new.right, %skipCallRight ]
  br label %outer

exit:
  ret void
}