; ModuleID = 'init_graph.ll'
source_filename = "init_graph.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @init_graph(i32* nocapture %base, i32 %n) {
entry:
  %n_le_zero = icmp sle i32 %n, 0
  br i1 %n_le_zero, label %exit, label %outer

outer:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer_inc ]
  %i64 = sext i32 %i to i64
  %row.off = mul nsw i64 %i64, 100
  %row.ptr = getelementptr i32, i32* %base, i64 %row.off
  br label %inner

inner:
  %j = phi i32 [ 0, %outer ], [ %j.next, %inner ]
  %j64 = sext i32 %j to i64
  %elt.ptr = getelementptr i32, i32* %row.ptr, i64 %j64
  store i32 0, i32* %elt.ptr, align 4
  %j.next = add nsw i32 %j, 1
  %j.cont = icmp slt i32 %j.next, %n
  br i1 %j.cont, label %inner, label %outer_inc

outer_inc:
  %i.next = add nsw i32 %i, 1
  %i.cont = icmp slt i32 %i.next, %n
  br i1 %i.cont, label %outer, label %exit

exit:
  ret void
}