; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: In-place stable bottom-up merge sort of 32-bit integers ascending (confidence=0.95). Evidence: iterative runs doubling, merging into temp buffer; final memcpy if buffer is source.
; Preconditions: %dest points to at least %n 32-bit integers; %n is element count (not bytes).
; Postconditions: If malloc succeeds and %n > 1, %dest is sorted ascending (stable). On malloc failure or %n <= 1, %dest is unchanged.

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %tmp_raw = call noalias i8* @malloc(i64 %size_bytes)
  %nullchk = icmp eq i8* %tmp_raw, null
  br i1 %nullchk, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp_raw to i32*
  br label %outer.header

outer.header:
  %run = phi i64 [ 1, %init ], [ %run.next, %post_pass_swap ]
  %src.curr = phi i32* [ %dest, %init ], [ %buf.next, %post_pass_swap ]
  %buf.curr = phi i32* [ %tmp, %init ], [ %src.next, %post_pass_swap ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %pass.init, label %finish

pass.init:
  br label %chunk.header

chunk.header:
  %base = phi i64 [ 0, %pass.init ], [ %base.next, %after_merge ]
  %base_lt_n = icmp ult i64 %base, %n
  br i1 %base_lt_n, label %merge.set, label %post_pass_swap

merge.set:
  %left = add i64 %base, 0
  %mid.cand = add i64 %base, %run
  %mid.cmp = icmp ule i64 %mid.cand, %n
  %mid = select i1 %mid.cmp, i64 %mid.cand, i64 %n
  %two_run = shl i64 %run, 1
  %right.cand = add i64 %base, %two_run
  %right.cmp = icmp ule i64 %right.cand, %n
  %right = select i1 %right.cmp, i64 %right.cand, i64 %n
  br label %merge.loop.header

merge.loop.header:
  %i = phi i64 [ %left, %merge.set ], [ %i.next, %store.join ]
  %j = phi i64 [ %mid, %merge.set ], [ %j.next, %store.join ]
  %k = phi i64 [ %left, %merge.set ], [ %k.next, %store.join ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %check_i, label %after_merge

check_i:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %pick.right

check_j:
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %j_lt_right, label %cmp_vals, label %pick.left

cmp_vals:
  %gep_i = getelementptr inbounds i32, i32* %src.curr, i64 %i
  %val_i = load i32, i32* %gep_i, align 4
  %gep_j = getelementptr inbounds i32, i32* %src.curr, i64 %j
  %val_j = load i32, i32* %gep_j, align 4
  %i_le_j = icmp sle i32 %val_i, %val_j
  br i1 %i_le_j, label %pick.left, label %pick.right

pick.left:
  %gep_i.pl = getelementptr inbounds i32, i32* %src.curr, i64 %i
  %val.pick.l = load i32, i32* %gep_i.pl, align 4
  %i.inc = add i64 %i, 1
  br label %store

pick.right:
  %gep_j.pr = getelementptr inbounds i32, i32* %src.curr, i64 %j
  %val.pick.r = load i32, i32* %gep_j.pr, align 4
  %j.inc = add i64 %j, 1
  br label %store

store:
  %val = phi i32 [ %val.pick.l, %pick.left ], [ %val.pick.r, %pick.right ]
  %i.next = phi i64 [ %i.inc, %pick.left ], [ %i, %pick.right ]
  %j.next = phi i64 [ %j, %pick.left ], [ %j.inc, %pick.right ]
  %gep_k = getelementptr inbounds i32, i32* %buf.curr, i64 %k
  store i32 %val, i32* %gep_k, align 4
  %k.next = add i64 %k, 1
  br label %store.join

store.join:
  br label %merge.loop.header

after_merge:
  %base.next = add i64 %base, %two_run
  br label %chunk.header

post_pass_swap:
  ; swap src and buffer pointers, double run
  %src.next = phi i32* [ %src.curr, %chunk.header ]
  %buf.next = phi i32* [ %buf.curr, %chunk.header ]
  %run.next = shl i64 %run, 1
  br label %outer.header

finish:
  %src.ne.dest = icmp ne i32* %src.curr, %dest
  br i1 %src.ne.dest, label %do_copy, label %skip_copy

do_copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.curr to i8*
  %ignored = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size_bytes)
  br label %skip_copy

skip_copy:
  call void @free(i8* %tmp_raw)
  br label %ret

ret:
  ret void
}