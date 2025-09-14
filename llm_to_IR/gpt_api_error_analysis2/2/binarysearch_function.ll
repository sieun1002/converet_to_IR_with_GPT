; ModuleID = 'binary_search'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %entry, %update
  %L = phi i64 [ 0, %entry ], [ %L.next, %update ]
  %R = phi i64 [ %n, %entry ], [ %R.next, %update ]
  %cmp = icmp ult i64 %L, %R
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %cond
  %diff = sub i64 %R, %L
  %half = lshr i64 %diff, 1
  %mid = add i64 %L, %half
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %idx.ptr, align 4
  %cmp_le = icmp sle i32 %key, %val
  br i1 %cmp_le, label %setR, label %setL

setR:                                             ; preds = %body
  br label %update

setL:                                             ; preds = %body
  %mid.inc = add i64 %mid, 1
  br label %update

update:                                           ; preds = %setR, %setL
  %L.next = phi i64 [ %L, %setR ], [ %mid.inc, %setL ]
  %R.next = phi i64 [ %mid, %setR ], [ %R, %setL ]
  br label %cond

after:                                            ; preds = %cond
  %lt_n = icmp ult i64 %L, %n
  br i1 %lt_n, label %checkval, label %retneg

checkval:                                         ; preds = %after
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %L
  %val2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %retfound, label %retneg

retfound:                                         ; preds = %checkval
  ret i64 %L

retneg:                                           ; preds = %checkval, %after
  ret i64 -1
}