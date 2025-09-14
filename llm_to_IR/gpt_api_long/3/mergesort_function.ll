; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable bottom-up merge sort of a 32-bit integer array into-place using a temporary buffer (confidence=0.95). Evidence: malloc of n*4, iterative 2-way merge with run doubling, final memcpy back and free.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %buf.i8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %ret, label %post_alloc

post_alloc:
  %tmp.init = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %post_alloc ], [ %run.next, %after_pass ]
  %src = phi i32* [ %dest, %post_alloc ], [ %src.next, %after_pass ]
  %tmp = phi i32* [ %tmp.init, %post_alloc ], [ %tmp.next, %after_pass ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %chunks.entry, label %done_outer

chunks.entry:
  br label %chunks.loop

chunks.loop:
  %i = phi i64 [ 0, %chunks.entry ], [ %i.next, %chunk.after ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %do_chunk, label %after_pass

do_chunk:
  %mid0 = add i64 %i, %run
  %mid_sel = icmp ult i64 %mid0, %n
  %mid = select i1 %mid_sel, i64 %mid0, i64 %n
  %two = add i64 %run, %run
  %right0 = add i64 %i, %two
  %right_sel = icmp ult i64 %right0, %n
  %right = select i1 %right_sel, i64 %right0, i64 %n
  br label %merge.loop

merge.loop:
  %p = phi i64 [ %i, %do_chunk ], [ %p.inc, %take_left ], [ %p.keep, %take_right ]
  %q = phi i64 [ %mid, %do_chunk ], [ %q.keep, %take_left ], [ %q.inc, %take_right ]
  %k = phi i64 [ %i, %do_chunk ], [ %k.inc.l, %take_left ], [ %k.inc.r, %take_right ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose_left_check, label %merge.done

choose_left_check:
  %p_lt_mid = icmp ult i64 %p, %mid
  br i1 %p_lt_mid, label %p_has, label %take_right

p_has:
  %q_lt_right = icmp ult i64 %q, %right
  br i1 %q_lt_right, label %both_have, label %take_left

both_have:
  %ploc = getelementptr inbounds i32, i32* %src, i64 %p
  %pval = load i32, i32* %ploc, align 4
  %qloc = getelementptr inbounds i32, i32* %src, i64 %q
  %qval = load i32, i32* %qloc, align 4
  %left_gt_right = icmp sgt i32 %pval, %qval
  br i1 %left_gt_right, label %take_right, label %take_left

take_left:
  %ploc.tl = getelementptr inbounds i32, i32* %src, i64 %p
  %pval.tl = load i32, i32* %ploc.tl, align 4
  %dst.tl = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %pval.tl, i32* %dst.tl, align 4
  %p.inc = add i64 %p, 1
  %q.keep = %q
  %k.inc.l = add i64 %k, 1
  br label %merge.loop

take_right:
  %qloc.tr = getelementptr inbounds i32, i32* %src, i64 %q
  %qval.tr = load i32, i32* %qloc.tr, align 4
  %dst.tr = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %qval.tr, i32* %dst.tr, align 4
  %p.keep = %p
  %q.inc = add i64 %q, 1
  %k.inc.r = add i64 %k, 1
  br label %merge.loop

merge.done:
  br label %chunk.after

chunk.after:
  %i.next = add i64 %i, %two
  br label %chunks.loop

after_pass:
  %src.next = %tmp
  %tmp.next = %src
  %run.next = shl i64 %run, 1
  br label %outer

done_outer:
  %src.final = phi i32* [ %src, %outer ]
  %need_copy = icmp ne i32* %src.final, %dest
  br i1 %need_copy, label %do_copy, label %after_copy

do_copy:
  %dst.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %bytes = shl i64 %n, 2
  call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %bytes)
  br label %after_copy

after_copy:
  call void @free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}