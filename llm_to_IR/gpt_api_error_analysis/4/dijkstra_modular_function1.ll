; ModuleID = 'init_graph.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @init_graph(i32* nocapture %graph, i32 %n) local_unnamed_addr nounwind {
entry:
  br label %outer.cond

outer.cond:
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i.ph, %n
  br i1 %cmp.outer, label %inner.cond, label %end

inner.cond:
  %j.ph = phi i32 [ 0, %outer.cond ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j.ph, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:
  %i.ext = sext i32 %i.ph to i64
  %j.ext = sext i32 %j.ph to i64
  %i.mul = mul nsw i64 %i.ext, 100
  %rowoff = add nsw i64 %i.mul, %j.ext
  %elt.ptr = getelementptr inbounds i32, i32* %graph, i64 %rowoff
  store i32 0, i32* %elt.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j.ph, 1
  br label %inner.cond

outer.inc:
  %i.next = add nsw i32 %i.ph, 1
  br label %outer.cond

end:
  ret void
}