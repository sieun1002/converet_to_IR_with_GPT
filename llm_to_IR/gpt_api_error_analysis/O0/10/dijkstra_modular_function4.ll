; ModuleID = 'min_index.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %best_val = phi i32 [ 2147483647, %entry ], [ %best_val.next, %inc ]
  %best_idx = phi i32 [ -1, %entry ], [ %best_idx.next, %inc ]
  %cont = icmp slt i32 %i, %n
  br i1 %cont, label %check, label %exit

check:
  %i.ext = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.ext
  %b.val = load i32, i32* %b.ptr, align 4
  %b.nonzero = icmp ne i32 %b.val, 0
  br i1 %b.nonzero, label %inc, label %load_a

load_a:
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.ext
  %a.val = load i32, i32* %a.ptr, align 4
  %lt = icmp slt i32 %a.val, %best_val
  br i1 %lt, label %update, label %inc

update:
  br label %inc

inc:
  %best_val.next = phi i32 [ %best_val, %check ], [ %best_val, %load_a ], [ %a.val, %update ]
  %best_idx.next = phi i32 [ %best_idx, %check ], [ %best_idx, %load_a ], [ %i, %update ]
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i32 %best_idx
}