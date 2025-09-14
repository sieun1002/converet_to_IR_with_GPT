; ModuleID = 'merge_sort'
source_filename = "merge_sort.ll"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %alloc

alloc:
  %sizeBytes = shl i64 %n, 2
  %tmp.raw = call i8* @malloc(i64 %sizeBytes)
  %isnull = icmp eq i8* %tmp.raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp.raw to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run.next, %afterPass ]
  %src.cur = phi i32* [ %dest, %init ], [ %src.next, %afterPass ]
  %aux.cur = phi i32* [ %tmp, %init ], [ %aux.next, %afterPass ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %pass.init, label %afterOuter

pass.init:
  br label %for.i

for.i:
  %i = phi i64 [ 0, %pass.init ], [ %i.next, %for.i.latch ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %merge.init, label %afterPass

merge.init:
  %i_plus_run = add i64 %i, %run
  %mid.lt = icmp ult i64 %i_plus_run, %n
  %mid = select i1 %mid.lt, i64 %i_plus_run, i64 %n
  %twoRun = shl i64 %run, 1
  %i_plus_two = add i64 %i, %twoRun
  %end.lt = icmp ult i64 %i_plus_two, %n
  %end = select i1 %end.lt, i64 %i_plus_two, i64 %n
  br label %merge.loop

merge.loop:
  %out = phi i64 [ %i, %merge.init ], [ %out.nextL, %take_left ], [ %out.nextR, %take_right ]
  %lidx = phi i64 [ %i, %merge.init ], [ %lidx.nextL, %take_left ], [ %lidx.keep, %take_right ]
  %ridx = phi i64 [ %mid, %merge.init ], [ %ridx.keep, %take_left ], [ %ridx.nextR, %take_right ]
  %out_lt_end = icmp ult i64 %out, %end
  br i1 %out_lt_end, label %choose, label %merge.done

choose:
  %l_lt_mid = icmp ult i64 %lidx, %mid
  br i1 %l_lt_mid, label %check_right, label %load_right_only

load_right_only:
  %rptr_only = getelementptr inbounds i32, i32* %src.cur, i64 %ridx
  %rv2 = load i32, i32* %rptr_only, align 4
  br label %take_right

check_right:
  %r_lt_end = icmp ult i64 %ridx, %end
  br i1 %r_lt_end, label %compare, label %load_left_only

load_left_only:
  %lptr_only = getelementptr inbounds i32, i32* %src.cur, i64 %lidx
  %lv2 = load i32, i32* %lptr_only, align 4
  br label %take_left

compare:
  %lptr = getelementptr inbounds i32, i32* %src.cur, i64 %lidx
  %lv = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.cur, i64 %ridx
  %rv = load i32, i32* %rptr, align 4
  %l_gt_r = icmp sgt i32 %lv, %rv
  br i1 %l_gt_r, label %take_right, label %take_left

take_left:
  %valL = phi i32 [ %lv, %compare ], [ %lv2, %load_left_only ]
  %aux_out_ptrL = getelementptr inbounds i32, i32* %aux.cur, i64 %out
  store i32 %valL, i32* %aux_out_ptrL, align 4
  %out.nextL = add i64 %out, 1
  %lidx.nextL = add i64 %lidx, 1
  %ridx.keep = %ridx
  br label %merge.loop

take_right:
  %valR = phi i32 [ %rv, %compare ], [ %rv2, %load_right_only ]
  %aux_out_ptrR = getelementptr inbounds i32, i32* %aux.cur, i64 %out
  store i32 %valR, i32* %aux_out_ptrR, align 4
  %out.nextR = add i64 %out, 1
  %ridx.nextR = add i64 %ridx, 1
  %lidx.keep = %lidx
  br label %merge.loop

merge.done:
  %twoRun2 = shl i64 %run, 1
  %i.next = add i64 %i, %twoRun2
  br label %for.i.latch

for.i.latch:
  br label %for.i

afterPass:
  %src.next = %aux.cur
  %aux.next = %src.cur
  %run.next = shl i64 %run, 1
  br label %outer

afterOuter:
  %src_ne_dest = icmp ne i32* %src.cur, %dest
  br i1 %src_ne_dest, label %do_copy, label %free_and_ret

do_copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %_ = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %sizeBytes)
  br label %free_and_ret

free_and_ret:
  call void @free(i8* %tmp.raw)
  br label %ret

ret:
  ret void
}