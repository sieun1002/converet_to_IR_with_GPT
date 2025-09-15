; ModuleID = 'min_index'
source_filename = "min_index.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* %values, i32* %mask, i32 %n) {
entry:
  %cmp.npos = icmp sgt i32 %n, 0
  br i1 %cmp.npos, label %loop, label %exit_empty

loop:                                             ; preds = %entry, %inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %minVal = phi i32 [ 2147483647, %entry ], [ %minVal.next, %inc ]
  %minIdx = phi i32 [ -1, %entry ], [ %minIdx.next, %inc ]

  %mask.ptr = getelementptr inbounds i32, i32* %mask, i32 %i
  %mask.val = load i32, i32* %mask.ptr, align 4
  %is.zero = icmp eq i32 %mask.val, 0
  br i1 %is.zero, label %check_val, label %inc_nochange

check_val:                                       ; preds = %loop
  %val.ptr = getelementptr inbounds i32, i32* %values, i32 %i
  %val = load i32, i32* %val.ptr, align 4
  %is.less = icmp slt i32 %val, %minVal
  br i1 %is.less, label %do_update, label %inc_nochange2

do_update:                                       ; preds = %check_val
  br label %inc

inc_nochange:                                    ; preds = %loop
  br label %inc

inc_nochange2:                                   ; preds = %check_val
  br label %inc

inc:                                             ; preds = %inc_nochange, %do_update, %inc_nochange2
  %minVal.next = phi i32 [ %minVal, %inc_nochange ], [ %val, %do_update ], [ %minVal, %inc_nochange2 ]
  %minIdx.next = phi i32 [ %minIdx, %inc_nochange ], [ %i, %do_update ], [ %minIdx, %inc_nochange2 ]
  %i.next = add nsw i32 %i, 1
  %cont = icmp slt i32 %i.next, %n
  br i1 %cont, label %loop, label %exit

exit:                                            ; preds = %inc
  ret i32 %minIdx.next

exit_empty:                                      ; preds = %entry
  ret i32 -1
}