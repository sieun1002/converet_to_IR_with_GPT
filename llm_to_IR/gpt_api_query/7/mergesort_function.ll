; ModuleID = 'merge_sort'
source_filename = "merge_sort.c"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %bufraw = call i8* @malloc(i64 %bytes)
  %buf = bitcast i8* %bufraw to i32*
  %isnull = icmp eq i32* %buf, null
  br i1 %isnull, label %ret, label %init

init:
  br label %outer.cond

outer.cond:
  %size = phi i64 [ 1, %init ], [ %size.next, %pass.end ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %pass.end ]
  %tmp = phi i32* [ %buf, %init ], [ %tmp.next, %pass.end ]
  %cond = icmp ult i64 %size, %n
  br i1 %cond, label %chunks.cond, label %outer.finish

chunks.cond:
  %start = phi i64 [ 0, %outer.cond ], [ %start.next, %chunks.aftermerge ]
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %merge.init, label %pass.end

merge.init:
  %size2 = shl i64 %size, 1
  %mid.tmp = add i64 %start, %size
  %mid.cmp = icmp ult i64 %mid.tmp, %n
  %mid = select i1 %mid.cmp, i64 %mid.tmp, i64 %n
  %right.tmp = add i64 %start, %size2
  %right.cmp = icmp ult i64 %right.tmp, %n
  %right = select i1 %right.cmp, i64 %right.tmp, i64 %n
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %start, %merge.init ], [ %i.next, %merge.body.end ]
  %j = phi i64 [ %mid, %merge.init ], [ %j.next, %merge.body.end ]
  %k = phi i64 [ %start, %merge.init ], [ %k.next, %merge.body.end ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %merge.body, label %chunks.aftermerge

merge.body:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %do_take_j_pre

check_j:
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %j_lt_right, label %compare, label %do_take_i_pre

compare:
  %src_i_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %vi = load i32, i32* %src_i_ptr, align 4
  %src_j_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %vj = load i32, i32* %src_j_ptr, align 4
  %cmpij = icmp sgt i32 %vi, %vj
  br i1 %cmpij, label %do_take_j, label %do_take_i

do_take_i_pre:
  %src_i_ptr.pre = getelementptr inbounds i32, i32* %src, i64 %i
  %vi.pre = load i32, i32* %src_i_ptr.pre, align 4
  br label %do_take_i

do_take_i:
  %vi.sel = phi i32 [ %vi, %compare ], [ %vi.pre, %do_take_i_pre ]
  %tmp_k_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %vi.sel, i32* %tmp_k_ptr, align 4
  %i.next = add i64 %i, 1
  %j.next = %j
  %k.next = add i64 %k, 1
  br label %merge.body.end

do_take_j_pre:
  %src_j_ptr.pre = getelementptr inbounds i32, i32* %src, i64 %j
  %vj.pre = load i32, i32* %src_j_ptr.pre, align 4
  br label %do_take_j

do_take_j:
  %vj.sel = phi i32 [ %vj, %compare ], [ %vj.pre, %do_take_j_pre ]
  %tmp_k_ptr2 = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %vj.sel, i32* %tmp_k_ptr2, align 4
  %i.next = %i
  %j.next = add i64 %j, 1
  %k.next = add i64 %k, 1
  br label %merge.body.end

merge.body.end:
  br label %merge.cond

chunks.aftermerge:
  %start.next = add i64 %start, %size2
  br label %chunks.cond

pass.end:
  %src.next = %tmp
  %tmp.next = %src
  %size.next = shl i64 %size, 1
  br label %outer.cond

outer.finish:
  %src.final = %src
  %cmp_src_dest = icmp eq i32* %src.final, %dest
  br i1 %cmp_src_dest, label %cleanup, label %do_memcpy

do_memcpy:
  %nbytes2 = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %ignored = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %nbytes2)
  br label %cleanup

cleanup:
  %buf.i8 = bitcast i32* %buf to i8*
  call void @free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}