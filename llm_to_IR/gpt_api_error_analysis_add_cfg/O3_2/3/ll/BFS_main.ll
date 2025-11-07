; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@qword_2038 = external global i64, align 8
@__stack_chk_guard = external global i64, align 8

@.str_bfs   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_nl    = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
bb10c0:
  %loc = alloca [312 x i8], align 16
  %can = alloca i64, align 8
  %base = getelementptr inbounds [312 x i8], [312 x i8]* %loc, i64 0, i64 0

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %can, align 8

  %dist = bitcast i8* %base to i32*
  store i32 -1, i32* %dist, align 4
  %d1 = getelementptr inbounds i32, i32* %dist, i64 1
  store i32 -1, i32* %d1, align 4
  %d2 = getelementptr inbounds i32, i32* %dist, i64 2
  store i32 -1, i32* %d2, align 4
  %d3 = getelementptr inbounds i32, i32* %dist, i64 3
  store i32 -1, i32* %d3, align 4
  %d4 = getelementptr inbounds i32, i32* %dist, i64 4
  store i32 -1, i32* %d4, align 4
  %d5 = getelementptr inbounds i32, i32* %dist, i64 5
  store i32 -1, i32* %d5, align 4
  %d6 = getelementptr inbounds i32, i32* %dist, i64 6
  store i32 -1, i32* %d6, align 4

  %adjbase_i8 = getelementptr inbounds i8, i8* %base, i64 96
  call void @llvm.memset.p0i8.i64(i8* align 1 %adjbase_i8, i8 0, i64 192, i1 false)

  %q2038 = load i64, i64* @qword_2038, align 8

  %p_var_DC = getelementptr inbounds i8, i8* %base, i64 124
  %p_var_DC_i32 = bitcast i8* %p_var_DC to i32*
  store i32 1, i32* %p_var_DC_i32, align 4

  %p_var_C0 = getelementptr inbounds i8, i8* %base, i64 152
  %p_var_C0_i32 = bitcast i8* %p_var_C0 to i32*
  store i32 1, i32* %p_var_C0_i32, align 4

  %p_var_F4 = getelementptr inbounds i8, i8* %base, i64 100
  %p_var_F4_i64 = bitcast i8* %p_var_F4 to i64*
  store i64 %q2038, i64* %p_var_F4_i64, align 8

  %p_var_A0 = getelementptr inbounds i8, i8* %base, i64 184
  %p_var_A0_i32 = bitcast i8* %p_var_A0 to i32*
  store i32 1, i32* %p_var_A0_i32, align 4

  %p_var_D0 = getelementptr inbounds i8, i8* %base, i64 136
  %p_var_D0_i64 = bitcast i8* %p_var_D0 to i64*
  store i64 %q2038, i64* %p_var_D0_i64, align 8

  %p_var_84 = getelementptr inbounds i8, i8* %base, i64 212
  %p_var_84_i32 = bitcast i8* %p_var_84 to i32*
  store i32 1, i32* %p_var_84_i32, align 4

  %p_var_F8_i32 = bitcast i8* %adjbase_i8 to i32*
  store i32 0, i32* %p_var_F8_i32, align 4

  %p_var_AC = getelementptr inbounds i8, i8* %base, i64 172
  %p_var_AC_i32 = bitcast i8* %p_var_AC to i32*
  store i32 1, i32* %p_var_AC_i32, align 4

  %p_var_64 = getelementptr inbounds i8, i8* %base, i64 244
  %p_var_64_i32 = bitcast i8* %p_var_64 to i32*
  store i32 1, i32* %p_var_64_i32, align 4

  %p_var_74 = getelementptr inbounds i8, i8* %base, i64 228
  %p_var_74_i32 = bitcast i8* %p_var_74 to i32*
  store i32 1, i32* %p_var_74_i32, align 4

  %p_var_5C = getelementptr inbounds i8, i8* %base, i64 252
  %p_var_5C_i32 = bitcast i8* %p_var_5C to i32*
  store i32 1, i32* %p_var_5C_i32, align 4

  %p_var_54 = getelementptr inbounds i8, i8* %base, i64 260
  %p_var_54_i32 = bitcast i8* %p_var_54 to i32*
  store i32 1, i32* %p_var_54_i32, align 4

  %p_var_3C = getelementptr inbounds i8, i8* %base, i64 284
  %p_var_3C_i32 = bitcast i8* %p_var_3C to i32*
  store i32 1, i32* %p_var_3C_i32, align 4

  %mp = call i8* @malloc(i64 56)
  %isnull = icmp eq i8* %mp, null
  br i1 %isnull, label %bb1414, label %bb1196

bb1196:
  %qptr = bitcast i8* %mp to i64*
  store i64 0, i64* %qptr, align 8
  store i32 0, i32* %dist, align 4
  %orderBase = getelementptr inbounds i8, i8* %base, i64 32
  %order64 = bitcast i8* %orderBase to i64*
  br label %bb11D3

bb11C0:
  %qelem_ptr_n = getelementptr inbounds i64, i64* %qptr_in, i64 %idx_cur
  %u_next = load i64, i64* %qelem_ptr_n, align 8
  %u_next_i32 = trunc i64 %u_next to i32
  %u_next_ext = sext i32 %u_next_i32 to i64
  %rowIdx_n = mul nsw i64 %u_next_ext, 7
  %col0_base_i8 = getelementptr inbounds i8, i8* %base, i64 96
  %col0_base = bitcast i8* %col0_base_i8 to i32*
  %cell0_ptr_n = getelementptr inbounds i32, i32* %col0_base, i64 %rowIdx_n
  %adj0_n = load i32, i32* %cell0_ptr_n, align 4
  br label %bb11D3

bb11D3:
  %pre_phi = phi i32 [ 0, %bb1196 ], [ %adj0_n, %bb11C0 ]
  %idx_prev = phi i64 [ 0, %bb1196 ], [ %idx_cur, %bb11C0 ]
  %qsize_in = phi i64 [ 1, %bb1196 ], [ %qsize_out, %bb11C0 ]
  %qptr_in = phi i64* [ %qptr, %bb1196 ], [ %qptr_in, %bb11C0 ]
  %order64_in = phi i64* [ %order64, %bb1196 ], [ %order64_in, %bb11C0 ]
  %idx_cur = add i64 %idx_prev, 1
  %idxm1 = add i64 %idx_cur, -1
  %qelem_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %idxm1
  %u = load i64, i64* %qelem_ptr, align 8
  %order_slot = getelementptr inbounds i64, i64* %order64_in, i64 %idxm1
  store i64 %u, i64* %order_slot, align 8
  %u_i32_for_dist = trunc i64 %u to i32
  %u_ext_for_dist = sext i32 %u_i32_for_dist to i64
  %dist_u_ptr_d = getelementptr inbounds i32, i32* %dist, i64 %u_ext_for_dist
  %pre_iszero = icmp eq i32 %pre_phi, 0
  br i1 %pre_iszero, label %bb1200, label %bb11E5

bb11E5:
  %dist0 = load i32, i32* %dist, align 4
  %dist0_is_m1 = icmp eq i32 %dist0, -1
  br i1 %dist0_is_m1, label %bb11EB, label %bb1200

bb11EB:
  %dist_u = load i32, i32* %dist_u_ptr_d, align 4
  %qslot0_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_in
  store i64 0, i64* %qslot0_ptr, align 8
  %qsize_after0 = add i64 %qsize_in, 1
  %dist0_new = add i32 %dist_u, 1
  store i32 %dist0_new, i32* %dist, align 4
  br label %bb1200

bb1200:
  %qsize_phi1200 = phi i64 [ %qsize_in, %bb11D3 ], [ %qsize_after0, %bb11EB ], [ %qsize_in, %bb11E5 ]
  %u_i32_b = trunc i64 %u to i32
  %u_ext_b = sext i32 %u_i32_b to i64
  %rowIdx = mul nsw i64 %u_ext_b, 7
  %col1_base_i8 = getelementptr inbounds i8, i8* %base, i64 100
  %col1_base = bitcast i8* %col1_base_i8 to i32*
  %cell1_ptr = getelementptr inbounds i32, i32* %col1_base, i64 %rowIdx
  %adj1 = load i32, i32* %cell1_ptr, align 4
  %adj1_is_zero = icmp eq i32 %adj1, 0
  br i1 %adj1_is_zero, label %bb1240, label %bb121D

bb121D:
  %dist1_ptr = getelementptr inbounds i32, i32* %dist, i64 1
  %dist1 = load i32, i32* %dist1_ptr, align 4
  %dist1_is_m1 = icmp eq i32 %dist1, -1
  br i1 %dist1_is_m1, label %bb1224, label %bb1240

bb1224:
  %dist_u2 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot1_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi1200
  store i64 1, i64* %qslot1_ptr, align 8
  %qsize_after1 = add i64 %qsize_phi1200, 1
  %dist1_new = add i32 %dist_u2, 1
  store i32 %dist1_new, i32* %dist1_ptr, align 4
  br label %bb1240

bb1240:
  %qsize_phi1240 = phi i64 [ %qsize_phi1200, %bb121D ], [ %qsize_after1, %bb1224 ], [ %qsize_phi1200, %bb1200 ]
  %col2_base_i8 = getelementptr inbounds i8, i8* %base, i64 104
  %col2_base = bitcast i8* %col2_base_i8 to i32*
  %cell2_ptr = getelementptr inbounds i32, i32* %col2_base, i64 %rowIdx
  %adj2 = load i32, i32* %cell2_ptr, align 4
  %adj2_is_zero = icmp eq i32 %adj2, 0
  br i1 %adj2_is_zero, label %bb1270, label %bb124A

bb124A:
  %dist2_ptr = getelementptr inbounds i32, i32* %dist, i64 2
  %dist2 = load i32, i32* %dist2_ptr, align 4
  %dist2_is_m1 = icmp eq i32 %dist2, -1
  br i1 %dist2_is_m1, label %bb1251, label %bb1270

bb1251:
  %dist_u3 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot2_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi1240
  store i64 2, i64* %qslot2_ptr, align 8
  %qsize_after2 = add i64 %qsize_phi1240, 1
  %dist2_new = add i32 %dist_u3, 1
  store i32 %dist2_new, i32* %dist2_ptr, align 4
  br label %bb1270

bb1270:
  %qsize_phi1270 = phi i64 [ %qsize_phi1240, %bb124A ], [ %qsize_after2, %bb1251 ], [ %qsize_phi1240, %bb1240 ]
  %col3_base_i8 = getelementptr inbounds i8, i8* %base, i64 108
  %col3_base = bitcast i8* %col3_base_i8 to i32*
  %cell3_ptr = getelementptr inbounds i32, i32* %col3_base, i64 %rowIdx
  %adj3 = load i32, i32* %cell3_ptr, align 4
  %adj3_is_zero = icmp eq i32 %adj3, 0
  br i1 %adj3_is_zero, label %bb12A0, label %bb127A

bb127A:
  %dist3_ptr = getelementptr inbounds i32, i32* %dist, i64 3
  %dist3 = load i32, i32* %dist3_ptr, align 4
  %dist3_is_m1 = icmp eq i32 %dist3, -1
  br i1 %dist3_is_m1, label %bb1281, label %bb12A0

bb1281:
  %dist_u4 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot3_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi1270
  store i64 3, i64* %qslot3_ptr, align 8
  %qsize_after3 = add i64 %qsize_phi1270, 1
  %dist3_new = add i32 %dist_u4, 1
  store i32 %dist3_new, i32* %dist3_ptr, align 4
  br label %bb12A0

bb12A0:
  %qsize_phi12A0 = phi i64 [ %qsize_phi1270, %bb127A ], [ %qsize_after3, %bb1281 ], [ %qsize_phi1270, %bb1270 ]
  %col4_base_i8 = getelementptr inbounds i8, i8* %base, i64 112
  %col4_base = bitcast i8* %col4_base_i8 to i32*
  %cell4_ptr = getelementptr inbounds i32, i32* %col4_base, i64 %rowIdx
  %adj4 = load i32, i32* %cell4_ptr, align 4
  %adj4_is_zero = icmp eq i32 %adj4, 0
  br i1 %adj4_is_zero, label %bb12D0, label %bb12AA

bb12AA:
  %dist4_ptr = getelementptr inbounds i32, i32* %dist, i64 4
  %dist4 = load i32, i32* %dist4_ptr, align 4
  %dist4_is_m1 = icmp eq i32 %dist4, -1
  br i1 %dist4_is_m1, label %bb12B1, label %bb12D0

bb12B1:
  %dist_u5 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot4_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi12A0
  store i64 4, i64* %qslot4_ptr, align 8
  %qsize_after4 = add i64 %qsize_phi12A0, 1
  %dist4_new = add i32 %dist_u5, 1
  store i32 %dist4_new, i32* %dist4_ptr, align 4
  br label %bb12D0

bb12D0:
  %qsize_phi12D0 = phi i64 [ %qsize_phi12A0, %bb12AA ], [ %qsize_after4, %bb12B1 ], [ %qsize_phi12A0, %bb12A0 ]
  %col5_base_i8 = getelementptr inbounds i8, i8* %base, i64 116
  %col5_base = bitcast i8* %col5_base_i8 to i32*
  %cell5_ptr = getelementptr inbounds i32, i32* %col5_base, i64 %rowIdx
  %adj5 = load i32, i32* %cell5_ptr, align 4
  %adj5_is_zero = icmp eq i32 %adj5, 0
  br i1 %adj5_is_zero, label %bb12F8, label %bb12D8

bb12D8:
  %dist5_ptr = getelementptr inbounds i32, i32* %dist, i64 5
  %dist5 = load i32, i32* %dist5_ptr, align 4
  %dist5_is_m1 = icmp eq i32 %dist5, -1
  br i1 %dist5_is_m1, label %bb12DF, label %bb12F8

bb12DF:
  %dist_u6 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot5_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi12D0
  store i64 5, i64* %qslot5_ptr, align 8
  %qsize_after5 = add i64 %qsize_phi12D0, 1
  %dist5_new = add i32 %dist_u6, 1
  store i32 %dist5_new, i32* %dist5_ptr, align 4
  br label %bb12F8

bb12F8:
  %qsize_phi12F8 = phi i64 [ %qsize_phi12D0, %bb12D8 ], [ %qsize_after5, %bb12DF ], [ %qsize_phi12D0, %bb12D0 ]
  %col6_base_i8 = getelementptr inbounds i8, i8* %base, i64 120
  %col6_base = bitcast i8* %col6_base_i8 to i32*
  %cell6_ptr = getelementptr inbounds i32, i32* %col6_base, i64 %rowIdx
  %adj6 = load i32, i32* %cell6_ptr, align 4
  %adj6_is_zero = icmp eq i32 %adj6, 0
  br i1 %adj6_is_zero, label %bb1320, label %bb1300

bb1300:
  %dist6_ptr = getelementptr inbounds i32, i32* %dist, i64 6
  %dist6 = load i32, i32* %dist6_ptr, align 4
  %dist6_is_m1 = icmp eq i32 %dist6, -1
  br i1 %dist6_is_m1, label %bb1307, label %bb1320

bb1307:
  %dist_u7 = load i32, i32* %dist_u_ptr_d, align 4
  %qslot6_ptr = getelementptr inbounds i64, i64* %qptr_in, i64 %qsize_phi12F8
  store i64 6, i64* %qslot6_ptr, align 8
  %qsize_after6 = add i64 %qsize_phi12F8, 1
  %dist6_new = add i32 %dist_u7, 1
  store i32 %dist6_new, i32* %dist6_ptr, align 4
  br label %bb1320

bb1320:
  %qsize_out = phi i64 [ %qsize_phi12F8, %bb12F8 ], [ %qsize_after6, %bb1307 ], [ %qsize_phi12F8, %bb1300 ]
  %cont = icmp ult i64 %idx_cur, %qsize_out
  br i1 %cont, label %bb11C0, label %bb1329

bb1329:
  %qptr_bytes = bitcast i64* %qptr_in to i8*
  call void @free(i8* %qptr_bytes)
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %_h = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs, i64 0)
  %first_elem_ptr = bitcast i8* %orderBase to i64*
  %first_elem = load i64, i64* %first_elem_ptr, align 8
  %is_one = icmp eq i64 %idx_cur, 1
  br i1 %is_one, label %bb1360, label %bb13DD

bb13DD:
  %end_ptr = getelementptr inbounds i64, i64* %order64_in, i64 %idx_cur
  %iter_ptr_init = getelementptr inbounds i64, i64* %order64_in, i64 1
  br label %bb13F0

bb13F0:
  %iter_ptr = phi i64* [ %iter_ptr_init, %bb13DD ], [ %iter_next, %bb1406 ]
  %cur = load i64, i64* %iter_ptr, align 8
  %fmt_zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %_p = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s, i64 %cur, i8* %space)
  br label %bb1406

bb1406:
  %iter_next = getelementptr inbounds i64, i64* %iter_ptr, i64 1
  %done = icmp eq i64* %iter_next, %end_ptr
  br i1 %done, label %bb140F, label %bb13F0

bb140F:
  br label %bb1360

bb1360:
  %fmt_zu_s2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %_q = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s2, i64 %first_elem, i8* %empty)
  br label %bb1376

bb1376:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %_n = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  br label %bb1398

bb1398:
  %i = phi i64 [ 0, %bb1376 ], [ %i_next, %bb13B4 ]
  %dist_idx_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  %dval = load i32, i32* %dist_idx_ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %_d = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dist, i64 0, i64 %i, i32 %dval)
  br label %bb13B4

bb13B4:
  %i_next = add i64 %i, 1
  %cont2 = icmp ne i64 %i_next, 7
  br i1 %cont2, label %bb1398, label %bb13BA

bb13BA:
  %guard_saved = load i64, i64* %can, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard_saved, %guard_now
  br i1 %ok, label %bb13CD, label %bb142e

bb13CD:
  ret i32 0

bb1414:
  %fmt_bfs2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %_h2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs2, i64 0)
  br label %bb1376

bb142e:
  call void @__stack_chk_fail()
  unreachable
}