; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %tmp_i8 = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %tmp_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp_i8 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run2, %after_pass ]
  %Src = phi i32* [ %arr, %init ], [ %Src2, %after_pass ]
  %Dst = phi i32* [ %tmp, %init ], [ %Dst2, %after_pass ]
  %cmp_run = icmp ult i64 %run, %n
  br i1 %cmp_run, label %pass_start, label %after_sort

pass_start:
  br label %outer_pass_loop

outer_pass_loop:
  %start = phi i64 [ 0, %pass_start ], [ %start_next, %after_merge_block ]
  %cmp_start = icmp ult i64 %start, %n
  br i1 %cmp_start, label %prep_block, label %end_pass

prep_block:
  %start_plus_run = add i64 %start, %run
  %mid_cond = icmp ult i64 %start_plus_run, %n
  %mid = select i1 %mid_cond, i64 %start_plus_run, i64 %n
  %double_run = shl i64 %run, 1
  %start_plus_2run = add i64 %start, %double_run
  %end_cond = icmp ult i64 %start_plus_2run, %n
  %end = select i1 %end_cond, i64 %start_plus_2run, i64 %n
  br label %merge_loop

merge_loop:
  %i = phi i64 [ %start, %prep_block ], [ %i_next, %merge_iter_end ]
  %j = phi i64 [ %mid, %prep_block ], [ %j_next, %merge_iter_end ]
  %k = phi i64 [ %start, %prep_block ], [ %k_next, %merge_iter_end ]
  %cmp_k = icmp ult i64 %k, %end
  br i1 %cmp_k, label %choose, label %after_merge_block

choose:
  %i_lt_mid = icmp ult i64 %i, %mid
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %i_lt_mid, label %check_j, label %take_j

check_j:
  br i1 %j_lt_end, label %compare_vals, label %take_i

compare_vals:
  %pi = getelementptr inbounds i32, i32* %Src, i64 %i
  %vi = load i32, i32* %pi, align 4
  %pj = getelementptr inbounds i32, i32* %Src, i64 %j
  %vj = load i32, i32* %pj, align 4
  %le = icmp sle i32 %vi, %vj
  br i1 %le, label %take_i_loaded, label %take_j_loaded

take_i:
  %pi2 = getelementptr inbounds i32, i32* %Src, i64 %i
  %vi2 = load i32, i32* %pi2, align 4
  br label %do_store_i

take_i_loaded:
  br label %do_store_i_with_loaded

do_store_i_with_loaded:
  %pk_i_loaded = getelementptr inbounds i32, i32* %Dst, i64 %k
  store i32 %vi, i32* %pk_i_loaded, align 4
  %i_inc_loaded = add i64 %i, 1
  %k_inc_loaded = add i64 %k, 1
  br label %merge_iter_end

do_store_i:
  %pk_i = getelementptr inbounds i32, i32* %Dst, i64 %k
  store i32 %vi2, i32* %pk_i, align 4
  %i_inc = add i64 %i, 1
  %k_inc = add i64 %k, 1
  br label %merge_iter_end

take_j:
  %pj2 = getelementptr inbounds i32, i32* %Src, i64 %j
  %vj2 = load i32, i32* %pj2, align 4
  br label %do_store_j

take_j_loaded:
  br label %do_store_j_with_loaded

do_store_j_with_loaded:
  %pk_j_loaded = getelementptr inbounds i32, i32* %Dst, i64 %k
  store i32 %vj, i32* %pk_j_loaded, align 4
  %j_inc_loaded = add i64 %j, 1
  %k_inc_loaded2 = add i64 %k, 1
  br label %merge_iter_end

do_store_j:
  %pk_j = getelementptr inbounds i32, i32* %Dst, i64 %k
  store i32 %vj2, i32* %pk_j, align 4
  %j_inc = add i64 %j, 1
  %k_inc2 = add i64 %k, 1
  br label %merge_iter_end

merge_iter_end:
  %i_next = phi i64 [ %i_inc_loaded, %do_store_i_with_loaded ], [ %i_inc, %do_store_i ], [ %i, %do_store_j_with_loaded ], [ %i, %do_store_j ]
  %j_next = phi i64 [ %j, %do_store_i_with_loaded ], [ %j, %do_store_i ], [ %j_inc_loaded, %do_store_j_with_loaded ], [ %j_inc, %do_store_j ]
  %k_next = phi i64 [ %k_inc_loaded, %do_store_i_with_loaded ], [ %k_inc, %do_store_i ], [ %k_inc_loaded2, %do_store_j_with_loaded ], [ %k_inc2, %do_store_j ]
  br label %merge_loop

after_merge_block:
  %double_run2 = shl i64 %run, 1
  %start_next = add i64 %start, %double_run2
  br label %outer_pass_loop

end_pass:
  %run2_tmp = shl i64 %run, 1
  br label %after_pass

after_pass:
  %Src2 = phi i32* [ %Dst, %end_pass ]
  %Dst2 = phi i32* [ %Src, %end_pass ]
  %run2 = phi i64 [ %run2_tmp, %end_pass ]
  br label %outer

after_sort:
  %cmp_src_arr = icmp eq i32* %Src, %arr
  br i1 %cmp_src_arr, label %free_block, label %do_memcpy

do_memcpy:
  %bytes2 = shl i64 %n, 2
  %dest_i8 = bitcast i32* %arr to i8*
  %src_i8 = bitcast i32* %Src to i8*
  %call_memcpy = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %bytes2)
  br label %free_block

free_block:
  %tmp_i8_2 = bitcast i32* %tmp to i8*
  call void @free(i8* %tmp_i8_2)
  br label %ret

ret:
  ret void
}