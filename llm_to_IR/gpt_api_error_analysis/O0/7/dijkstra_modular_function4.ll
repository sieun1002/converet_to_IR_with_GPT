; ModuleID = 'min_index.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %best = phi i32 [ 2147483647, %entry ], [ %best.next, %cont ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check, label %exit

check:
  %i.sext = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.sext
  %b.val = load i32, i32* %b.ptr, align 4
  %iszero = icmp eq i32 %b.val, 0
  br i1 %iszero, label %maybe_update, label %cont_no_update

maybe_update:
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.sext
  %a.val = load i32, i32* %a.ptr, align 4
  %lt2 = icmp slt i32 %a.val, %best
  br i1 %lt2, label %do_update, label %cont_no_update

do_update:
  br label %cont

cont_no_update:
  br label %cont

cont:
  %best.next = phi i32 [ %a.val, %do_update ], [ %best, %cont_no_update ]
  %minidx.next = phi i32 [ %i, %do_update ], [ %minidx, %cont_no_update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 %minidx
}