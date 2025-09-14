; ModuleID = 'init_graph_module'
source_filename = "init_graph.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %inner.cond.preheader, label %return

inner.cond.preheader:                             ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                       ; preds = %inner.cond.preheader, %inner.inc
  %j = phi i32 [ 0, %inner.cond.preheader ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %body, label %outer.inc

body:                                             ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %mul = mul i64 %i.ext, 100
  %j.ext = sext i32 %j to i64
  %idx = add i64 %mul, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %ptr
  br label %inner.inc

inner.inc:                                        ; preds = %body
  %j.next = add i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add i32 %i, 1
  br label %outer.cond

return:                                           ; preds = %outer.cond
  ret void
}