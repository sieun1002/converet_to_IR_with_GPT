; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

; void init_graph(int *graph, int n)
define dso_local void @init_graph(i32* nocapture %graph, i32 %n) local_unnamed_addr {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                        ; i loop condition
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp sge i32 %i.val, %n
  br i1 %cmp.i, label %end, label %outer.body

outer.body:
  store i32 0, i32* %j, align 4
  br label %inner.cond

inner.cond:                                        ; j loop condition
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp sge i32 %j.val, %n
  br i1 %cmp.j, label %outer.inc, label %inner.body

inner.body:
  ; Compute address: base + i*0x190 bytes + j*4 bytes
  %base.i8 = bitcast i32* %graph to i8*
  %i.ext = sext i32 %i.val to i64
  %row.off.bytes = mul nsw i64 %i.ext, 400
  %row.ptr.i8 = getelementptr inbounds i8, i8* %base.i8, i64 %row.off.bytes
  %row.ptr.i32 = bitcast i8* %row.ptr.i8 to i32*
  %j.ext = sext i32 %j.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %row.ptr.i32, i64 %j.ext
  store i32 0, i32* %elem.ptr, align 4

  ; j++
  %j.next = add nsw i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

outer.inc:
  ; i++
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

end:
  ret void
}