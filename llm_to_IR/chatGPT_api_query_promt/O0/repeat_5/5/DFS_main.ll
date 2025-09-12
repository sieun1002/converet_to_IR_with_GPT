; ModuleID = 'dfs'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* nocapture %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %countp) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_zero, label %alloc

early_zero:                                          ; preds = %entry
  store i64 0, i64* %countp, align 8
  ret void

alloc:                                                ; preds = %entry
  %n_shl2 = shl i64 %n, 2
  %v_raw = call i8* @malloc(i64 %n_shl2)
  %visited = bitcast i8* %v_raw to i32*

  %n_shl3_1 = shl i64 %n, 3
  %ni_raw = call i8* @malloc(i64 %n_shl3_1)
  %nextIdx = bitcast i8* %ni_raw to i64*

  %n_shl3_2 = shl i64 %n, 3
  %s_raw = call i8* @malloc(i64 %n_shl3_2)
  %stack = bitcast i8* %s_raw to i64*

  %v_null = icmp eq i8* %v_raw, null
  %ni_null = icmp eq i8* %ni_raw, null
  %s_null = icmp eq i8* %s_raw, null
  %any_null1 = or i1 %v_null, %ni_null
  %any_null = or i1 %any_null1, %s_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:                                           ; preds = %alloc
  call void @free(i8* %v_raw)
  call void @free(i8* %ni_raw)
  call void @free(i8* %s_raw)
  store i64 0, i64* %countp, align 8
  ret void

init:                                                 ; preds = %alloc
  br label %init.loop

init.loop:                                            ; preds = %init.body, %init
  %i = phi i64 [ 0, %init ], [ %i.next, %init.body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init.body, label %init.done

init.body:                                            ; preds = %init.loop
  %v.gep = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %v.gep, align 4
  %ni.gep = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %ni.gep, align 8
  %i.next = add i64 %i, 1
  br label %init.loop

init.done:                                            ; preds = %init.loop
  store i64 0, i64* %countp, align 8

  %st.gep0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %st.gep0, align 8

  %v_idx_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %v_idx_ptr, align 4

  %oldcnt0 = load i64, i64* %countp, align 8
  %oldcnt0.gep = getelementptr inbounds i64, i64* %out, i64 %oldcnt0
  store i64 %start, i64* %oldcnt0.gep, align 8
  %newcnt0 = add i64 %oldcnt0, 1
  store i64 %newcnt0, i64* %countp, align 8

  br label %outer.loop

outer.loop:                                           ; preds = %after.iter, %init.done
  %ss = phi i64 [ 1, %init.done ], [ %ss.next, %after.iter ]
  %ss_is_zero = icmp eq i64 %ss, 0
  br i1 %ss_is_zero, label %finish, label %loop.body

loop.body:                                            ; preds = %outer.loop
  %ss_minus1 = add i64 %ss, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss_minus1
  %cur = load i64, i64* %top_ptr, align 8

  %ni_cur_ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %cur
  %j0 = load i64, i64* %ni_cur_ptr, align 8
  br label %scan

scan:                                                 ; preds = %j_incr, %loop.body
  %j = phi i64 [ %j0, %loop.body ], [ %j.inc, %j_incr ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %check_edge, label %j_done

check_edge:                                           ; preds = %scan
  %mul = mul i64 %cur, %n
  %idx = add i64 %mul, %j
  %a.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %a.ptr, align 4
  %edge_zero = icmp eq i32 %a, 0
  br i1 %edge_zero, label %j_incr, label %check_vis

check_vis:                                            ; preds = %check_edge
  %vj.ptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vj = load i32, i32* %vj.ptr, align 4
  %vis_zero = icmp eq i32 %vj, 0
  br i1 %vis_zero, label %visit_neighbor, label %j_incr

visit_neighbor:                                       ; preds = %check_vis
  %j.plus1 = add i64 %j, 1
  store i64 %j.plus1, i64* %ni_cur_ptr, align 8

  store i32 1, i32* %vj.ptr, align 4

  %oldcnt = load i64, i64* %countp, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %j, i64* %out.ptr, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %countp, align 8

  %push.ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %j, i64* %push.ptr, align 8
  %ss2 = add i64 %ss, 1
  br label %after.iter

j_incr:                                               ; preds = %check_vis, %check_edge
  %j.inc = add i64 %j, 1
  br label %scan

j_done:                                               ; preds = %scan
  %ss.pop = add i64 %ss, -1
  br label %after.iter

after.iter:                                           ; preds = %j_done, %visit_neighbor
  %ss.next = phi i64 [ %ss2, %visit_neighbor ], [ %ss.pop, %j_done ]
  br label %outer.loop

finish:                                               ; preds = %outer.loop
  call void @free(i8* %v_raw)
  call void @free(i8* %ni_raw)
  call void @free(i8* %s_raw)
  ret void
}