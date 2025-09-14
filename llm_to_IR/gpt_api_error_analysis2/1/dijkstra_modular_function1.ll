; ModuleID = 'init_graph_module'
source_filename = "init_graph.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @init_graph(i32* %graph, i32 %n) {
entry:
  %cmp.entry = icmp sle i32 %n, 0
  br i1 %cmp.entry, label %exit, label %outer.loop

outer.loop:
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  br label %inner.loop

inner.loop:
  %j.phi = phi i32 [ 0, %outer.loop ], [ %j.next, %inner.inc ]
  %j.cmp = icmp slt i32 %j.phi, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:
  %i.ext = sext i32 %i.phi to i64
  %row.off = mul nsw i64 %i.ext, 100
  %row.ptr = getelementptr inbounds i32, i32* %graph, i64 %row.off
  %j.ext = sext i32 %j.phi to i64
  %elt.ptr = getelementptr inbounds i32, i32* %row.ptr, i64 %j.ext
  store i32 0, i32* %elt.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j.phi, 1
  br label %inner.loop

after.inner:
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i.phi, 1
  %i.cmp.next = icmp slt i32 %i.next, %n
  br i1 %i.cmp.next, label %outer.loop, label %exit

exit:
  ret void
}