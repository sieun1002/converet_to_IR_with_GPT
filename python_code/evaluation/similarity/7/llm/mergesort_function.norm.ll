; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/mergesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/mergesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64 noundef)

declare void @free(i8* noundef)

declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp.n.le1 = icmp ult i64 %n, 2
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %bytes = shl i64 %n, 2
  %rawbuf = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %rawbuf, null
  br i1 %isnull, label %ret, label %init

init:                                             ; preds = %alloc
  %buf = bitcast i8* %rawbuf to i32*
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %init
  %width = phi i64 [ 1, %init ], [ %width.next, %after.inner ]
  %src.cur = phi i32* [ %dest, %init ], [ %out.cur, %after.inner ]
  %out.cur = phi i32* [ %buf, %init ], [ %src.cur, %after.inner ]
  %cond.width = icmp ult i64 %width, %n
  br i1 %cond.width, label %inner.header, label %after.outer

inner.header:                                     ; preds = %outer.header, %merge.done
  %i = phi i64 [ %i.plus.tw, %merge.done ], [ 0, %outer.header ]
  %cond.i = icmp ult i64 %i, %n
  br i1 %cond.i, label %merge.prepare, label %after.inner

merge.prepare:                                    ; preds = %inner.header
  %i.plus.w = add i64 %i, %width
  %mid.lt.n = icmp ult i64 %i.plus.w, %n
  %mid = select i1 %mid.lt.n, i64 %i.plus.w, i64 %n
  %tw = shl i64 %width, 1
  %i.plus.tw = add i64 %i, %tw
  %r.lt.n = icmp ult i64 %i.plus.tw, %n
  %r = select i1 %r.lt.n, i64 %i.plus.tw, i64 %n
  br label %merge.cond

merge.cond:                                       ; preds = %take.right, %take.left, %merge.prepare
  %li = phi i64 [ %i, %merge.prepare ], [ %li.next, %take.left ], [ %li, %take.right ]
  %ri = phi i64 [ %mid, %merge.prepare ], [ %ri, %take.left ], [ %ri.next, %take.right ]
  %oi = phi i64 [ %i, %merge.prepare ], [ %oi.nextL, %take.left ], [ %oi.nextR, %take.right ]
  %oi.lt.r = icmp ult i64 %oi, %r
  br i1 %oi.lt.r, label %choose, label %merge.done

choose:                                           ; preds = %merge.cond
  %li.lt.mid = icmp ult i64 %li, %mid
  br i1 %li.lt.mid, label %check.ri, label %choose.take.right_crit_edge

choose.take.right_crit_edge:                      ; preds = %choose
  %src.r.ptr.phi.trans.insert = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %val.r.pre = load i32, i32* %src.r.ptr.phi.trans.insert, align 4
  br label %take.right

check.ri:                                         ; preds = %choose
  %ri.lt.r = icmp ult i64 %ri, %r
  br i1 %ri.lt.r, label %compare, label %check.ri.take.left_crit_edge

check.ri.take.left_crit_edge:                     ; preds = %check.ri
  %src.l.ptr.phi.trans.insert = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %val.l.pre = load i32, i32* %src.l.ptr.phi.trans.insert, align 4
  br label %take.left

compare:                                          ; preds = %check.ri
  %lptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %lval.c = load i32, i32* %lptr.c, align 4
  %rptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %rval.c = load i32, i32* %rptr.c, align 4
  %l.gt.r = icmp sgt i32 %lval.c, %rval.c
  br i1 %l.gt.r, label %take.right, label %take.left

take.left:                                        ; preds = %check.ri.take.left_crit_edge, %compare
  %val.l = phi i32 [ %val.l.pre, %check.ri.take.left_crit_edge ], [ %lval.c, %compare ]
  %out.l.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.l, i32* %out.l.ptr, align 4
  %li.next = add i64 %li, 1
  %oi.nextL = add i64 %oi, 1
  br label %merge.cond

take.right:                                       ; preds = %choose.take.right_crit_edge, %compare
  %val.r = phi i32 [ %val.r.pre, %choose.take.right_crit_edge ], [ %rval.c, %compare ]
  %out.r.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.r, i32* %out.r.ptr, align 4
  %ri.next = add i64 %ri, 1
  %oi.nextR = add i64 %oi, 1
  br label %merge.cond

merge.done:                                       ; preds = %merge.cond
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %width.next = shl i64 %width, 1
  br label %outer.header

after.outer:                                      ; preds = %outer.header
  %src.eq.dest = icmp eq i32* %src.cur, %dest
  br i1 %src.eq.dest, label %do.free, label %do.memcpy

do.memcpy:                                        ; preds = %after.outer
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dest.i8, i8* align 1 %src.i8, i64 %bytes, i1 false)
  br label %do.free

do.free:                                          ; preds = %do.memcpy, %after.outer
  call void @free(i8* %rawbuf)
  br label %ret

ret:                                              ; preds = %do.free, %alloc, %entry
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn }
