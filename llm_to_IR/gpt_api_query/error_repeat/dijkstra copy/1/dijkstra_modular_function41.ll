; ModuleID = 'min_index'
source_filename = "min_index.c"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %best_idx = phi i32 [ -1, %entry ], [ %best_idx.next, %inc ]
  %best_val = phi i32 [ 2147483647, %entry ], [ %best_val.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %i64 = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i64
  %bval = load i32, i32* %b.ptr, align 4
  %is_zero = icmp eq i32 %bval, 0
  br i1 %is_zero, label %check_a, label %inc

check_a:                                          ; preds = %body
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %aval = load i32, i32* %a.ptr, align 4
  %less = icmp slt i32 %aval, %best_val
  %best_val.sel = select i1 %less, i32 %aval, i32 %best_val
  %best_idx.sel = select i1 %less, i32 %i, i32 %best_idx
  br label %inc

inc:                                              ; preds = %check_a, %body
  %best_val.next = phi i32 [ %best_val, %body ], [ %best_val.sel, %check_a ]
  %best_idx.next = phi i32 [ %best_idx, %body ], [ %best_idx.sel, %check_a ]
  %i.next = add nsw i32 %i, 1
  br label %loop

done:                                             ; preds = %loop
  ret i32 %best_idx
}