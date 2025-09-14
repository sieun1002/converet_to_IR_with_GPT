; ModuleID = 'merge_sort_module'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef writeonly, i8* noundef readonly, i64 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %malloc.raw = call noalias i8* @malloc(i64 noundef %size.bytes)
  %malloc.null = icmp eq i8* %malloc.raw, null
  br i1 %malloc.null, label %ret, label %setup

setup:
  %buf.init = bitcast i8* %malloc.raw to i32*
  br label %outer

outer:
  %run.phi = phi i64 [ 1, %setup ], [ %run.next, %after_pass ]
  %src.phi = phi i32* [ %dest, %setup ], [ %src.next, %after_pass ]
  %buf.phi = phi i32* [ %buf.init, %setup ], [ %buf.next, %after_pass ]
  %cmp.run = icmp ult i64 %run.phi, %n
  br i1 %cmp.run, label %pass, label %after_outer

pass:
  br label %loop_base

loop_base:
  %base.phi = phi i64 [ 0, %pass ], [ %base.next, %after_merge ]
  %cmp.base = icmp ult i64 %base.phi, %n
  br i1 %cmp.base, label %compute_bounds, label %after_pass

compute_bounds:
  %mid.tmp = add i64 %base.phi, %run.phi
  %mid.cond = icmp ult i64 %mid.tmp, %n
  %mid = select i1 %mid.cond, i64 %mid.tmp, i64 %n
  %two.run = shl i64 %run.phi, 1
  %end.tmp = add i64 %base.phi, %two.run
  %end.cond = icmp ult i64 %end.tmp, %n
  %end = select i1 %end.cond, i64 %end.tmp, i64 %n
  br label %merge

merge:
  %i.phi = phi i64 [ %base.phi, %compute_bounds ], [ %i.next, %loop_latch ]
  %j.phi = phi i64 [ %mid, %compute_bounds ], [ %j.next, %loop_latch ]
  %k.phi = phi i64 [ %base.phi, %compute_bounds ], [ %k.next, %loop_latch ]
  %cmp.k = icmp ult i64 %k.phi, %end
  br i1 %cmp.k, label %decide_0, label %after_merge

decide_0:
  %i.lt.mid = icmp ult i64 %i.phi, %mid
  br i1 %i.lt.mid, label %decide_1, label %emit_j_simple

decide_1:
  %j.lt.end = icmp ult i64 %j.phi, %end
  br i1 %j.lt.end, label %compare_vals, label %emit_i_simple

compare_vals:
  %ptr.i = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.j = load i32, i32* %ptr.j, align 4
  %i.le.j = icmp sle i32 %val.i, %val.j
  br i1 %i.le.j, label %emit_i_valready, label %emit_j_valready

emit_i_simple:
  %ptr.i.s = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.i.s = load i32, i32* %ptr.i.s, align 4
  %dst.i.s = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.i.s, i32* %dst.i.s, align 4
  %i.inc.s = add i64 %i.phi, 1
  %j.pass.s = %j.phi
  %k.inc.s = add i64 %k.phi, 1
  br label %loop_latch

emit_i_valready:
  %dst.i.v = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.i, i32* %dst.i.v, align 4
  %i.inc.v = add i64 %i.phi, 1
  %j.pass.v = %j.phi
  %k.inc.v = add i64 %k.phi, 1
  br label %loop_latch

emit_j_simple:
  %ptr.j.s = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.j.s = load i32, i32* %ptr.j.s, align 4
  %dst.j.s = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.j.s, i32* %dst.j.s, align 4
  %i.pass.s = %i.phi
  %j.inc.s = add i64 %j.phi, 1
  %k.inc.sj = add i64 %k.phi, 1
  br label %loop_latch

emit_j_valready:
  %dst.j.v = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.j, i32* %dst.j.v, align 4
  %i.pass.v = %i.phi
  %j.inc.v = add i64 %j.phi, 1
  %k.inc.v = add i64 %k.phi, 1
  br label %loop_latch

loop_latch:
  %i.next = phi i64 [ %i.inc.s, %emit_i_simple ], [ %i.inc.v, %emit_i_valready ], [ %i.pass.s, %emit_j_simple ], [ %i.pass.v, %emit_j_valready ]
  %j.next = phi i64 [ %j.pass.s, %emit_i_simple ], [ %j.pass.v, %emit_i_valready ], [ %j.inc.s, %emit_j_simple ], [ %j.inc.v, %emit_j_valready ]
  %k.next = phi i64 [ %k.inc.s, %emit_i_simple ], [ %k.inc.v, %emit_i_valready ], [ %k.inc.sj, %emit_j_simple ], [ %k.inc.v, %emit_j_valready ]
  br label %merge

after_merge:
  %two.run.2 = shl i64 %run.phi, 1
  %base.next = add i64 %base.phi, %two.run.2
  br label %loop_base

after_pass:
  %tmp.swap = %src.phi
  %src.next = %buf.phi
  %buf.next = %tmp.swap
  %run.next = shl i64 %run.phi, 1
  br label %outer

after_outer:
  %src.eq.dest = icmp eq i32* %src.phi, %dest
  br i1 %src.eq.dest, label %free_and_ret, label %do_memcpy

do_memcpy:
  %nbytes.final = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %memcpy.call = call i8* @memcpy(i8* noundef %dest.i8, i8* noundef %src.i8, i64 noundef %nbytes.final)
  br label %free_and_ret

free_and_ret:
  call void @free(i8* noundef %malloc.raw)
  br label %ret

ret:
  ret void
}