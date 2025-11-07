; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@qword_2038 = external global i64

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_percentzu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() #0 {
bb_10c0:
  %stack_cookie = alloca i64, align 8
  %queue_ptr = alloca i8*, align 8
  %rbx_idx = alloca i64, align 8
  %rsi_cnt = alloca i64, align 8
  %eax32 = alloca i32, align 4
  %order = alloca [64 x i64], align 16
  %arr_dist = alloca [64 x i32], align 16
  %arr_prevflag = alloca [64 x i32], align 16
  %arr_edge0 = alloca [64 x i32], align 16
  %arr_edge1 = alloca [64 x i32], align 16
  %arr_edge2 = alloca [64 x i32], align 16
  %arr_edge3 = alloca [64 x i32], align 16
  %arr_edge4 = alloca [64 x i32], align 16
  %arr_edge5 = alloca [64 x i32], align 16
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_now, i64* %stack_cookie, align 8
  %dist_i8 = bitcast [64 x i32]* %arr_dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist_i8, i8 -1, i64 256, i1 false)
  %pf_i8 = bitcast [64 x i32]* %arr_prevflag to i8*
  call void @llvm.memset.p0i8.i64(i8* %pf_i8, i8 0, i64 256, i1 false)
  %e0_i8 = bitcast [64 x i32]* %arr_edge0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e0_i8, i8 0, i64 256, i1 false)
  %e1_i8 = bitcast [64 x i32]* %arr_edge1 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e1_i8, i8 0, i64 256, i1 false)
  %e2_i8 = bitcast [64 x i32]* %arr_edge2 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e2_i8, i8 0, i64 256, i1 false)
  %e3_i8 = bitcast [64 x i32]* %arr_edge3 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e3_i8, i8 0, i64 256, i1 false)
  %e4_i8 = bitcast [64 x i32]* %arr_edge4 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e4_i8, i8 0, i64 256, i1 false)
  %e5_i8 = bitcast [64 x i32]* %arr_edge5 to i8*
  call void @llvm.memset.p0i8.i64(i8* %e5_i8, i8 0, i64 256, i1 false)
  %dist0_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 0
  store i32 0, i32* %dist0_ptr, align 4
  store i64 1, i64* %rsi_cnt, align 8
  store i64 0, i64* %rbx_idx, align 8
  %malloc_sz = call i8* @malloc(i64 56)
  store i8* %malloc_sz, i8** %queue_ptr, align 8
  %isnull = icmp eq i8* %malloc_sz, null
  br i1 %isnull, label %bb_1414, label %bb_1196

bb_1196:
  %qptr1 = load i8*, i8** %queue_ptr, align 8
  %q0 = bitcast i8* %qptr1 to i64*
  store i64 0, i64* %q0, align 8
  store i32 0, i32* %eax32, align 4
  br label %bb_11D3

bb_11C0:
  %qptr2 = load i8*, i8** %queue_ptr, align 8
  %rbx2 = load i64, i64* %rbx_idx, align 8
  %off2 = mul i64 %rbx2, 8
  %eltptr2b = getelementptr inbounds i8, i8* %qptr2, i64 %off2
  %eltptr2 = bitcast i8* %eltptr2b to i64*
  %rdx2 = load i64, i64* %eltptr2, align 8
  %mul8 = mul i64 %rdx2, 8
  %rax_tmp = sub i64 %mul8, %rdx2
  %pf_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_prevflag, i64 0, i64 %rax_tmp
  %eax_next = load i32, i32* %pf_ptr, align 4
  store i32 %eax_next, i32* %eax32, align 4
  br label %bb_11D3

bb_11D3:
  %rbx3 = load i64, i64* %rbx_idx, align 8
  %rbx_inc = add i64 %rbx3, 1
  store i64 %rbx_inc, i64* %rbx_idx, align 8
  %qptr3 = load i8*, i8** %queue_ptr, align 8
  %rbx_dec = add i64 %rbx_inc, -1
  %off3 = mul i64 %rbx_dec, 8
  %eltptr3b = getelementptr inbounds i8, i8* %qptr3, i64 %off3
  %eltptr3 = bitcast i8* %eltptr3b to i64*
  %rdx3 = load i64, i64* %eltptr3, align 8
  %ord_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 %rbx_dec
  store i64 %rdx3, i64* %ord_ptr, align 8
  %eax_cur = load i32, i32* %eax32, align 4
  %tst_eax = icmp eq i32 %eax_cur, 0
  br i1 %tst_eax, label %bb_1200, label %bb_11E5

bb_11E5:
  %dist0_ld = load i32, i32* %dist0_ptr, align 4
  %cmp_dist0 = icmp ne i32 %dist0_ld, -1
  br i1 %cmp_dist0, label %bb_1200, label %bb_11EB

bb_11EB:
  %dist_src_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src = load i32, i32* %dist_src_ptr, align 4
  %qptr4 = load i8*, i8** %queue_ptr, align 8
  %rsi4 = load i64, i64* %rsi_cnt, align 8
  %qdst_off = mul i64 %rsi4, 8
  %qdst_ptrb = getelementptr inbounds i8, i8* %qptr4, i64 %qdst_off
  %qdst_ptr = bitcast i8* %qdst_ptrb to i64*
  store i64 0, i64* %qdst_ptr, align 8
  %rsi_incf = add i64 %rsi4, 1
  store i64 %rsi_incf, i64* %rsi_cnt, align 8
  %dist_inc = add i32 %dist_src, 1
  store i32 %dist_inc, i32* %dist0_ptr, align 4
  br label %bb_1200

bb_1200:
  %mul8b = mul i64 %rdx3, 8
  %rcx7 = sub i64 %mul8b, %rdx3
  %e0_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge0, i64 0, i64 %rcx7
  %r11d = load i32, i32* %e0_ptr, align 4
  %tst_r11 = icmp eq i32 %r11d, 0
  br i1 %tst_r11, label %bb_1240, label %bb_121D

bb_121D:
  %dist1_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 1
  %dist1_ld = load i32, i32* %dist1_ptr, align 4
  %cmp_d1 = icmp ne i32 %dist1_ld, -1
  br i1 %cmp_d1, label %bb_1240, label %bb_1224

bb_1224:
  %dist_src2_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src2 = load i32, i32* %dist_src2_ptr, align 4
  %qptr5 = load i8*, i8** %queue_ptr, align 8
  %rsi5 = load i64, i64* %rsi_cnt, align 8
  %qoff5 = mul i64 %rsi5, 8
  %qdst5b = getelementptr inbounds i8, i8* %qptr5, i64 %qoff5
  %qdst5 = bitcast i8* %qdst5b to i64*
  store i64 1, i64* %qdst5, align 8
  %rsi5_inc = add i64 %rsi5, 1
  store i64 %rsi5_inc, i64* %rsi_cnt, align 8
  %d1_new = add i32 %dist_src2, 1
  store i32 %d1_new, i32* %dist1_ptr, align 4
  br label %bb_1240

bb_1240:
  %e1_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge1, i64 0, i64 %rcx7
  %r10d = load i32, i32* %e1_ptr, align 4
  %tst_r10 = icmp eq i32 %r10d, 0
  br i1 %tst_r10, label %bb_1270, label %bb_124A

bb_124A:
  %dist2_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 2
  %dist2_ld = load i32, i32* %dist2_ptr, align 4
  %cmp_d2 = icmp ne i32 %dist2_ld, -1
  br i1 %cmp_d2, label %bb_1270, label %bb_1251

bb_1251:
  %dist_src3_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src3 = load i32, i32* %dist_src3_ptr, align 4
  %qptr6 = load i8*, i8** %queue_ptr, align 8
  %rsi6 = load i64, i64* %rsi_cnt, align 8
  %qoff6 = mul i64 %rsi6, 8
  %qdst6b = getelementptr inbounds i8, i8* %qptr6, i64 %qoff6
  %qdst6 = bitcast i8* %qdst6b to i64*
  store i64 2, i64* %qdst6, align 8
  %rsi6_inc = add i64 %rsi6, 1
  store i64 %rsi6_inc, i64* %rsi_cnt, align 8
  %d2_new = add i32 %dist_src3, 1
  store i32 %d2_new, i32* %dist2_ptr, align 4
  br label %bb_1270

bb_1270:
  %e2_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge2, i64 0, i64 %rcx7
  %r9d = load i32, i32* %e2_ptr, align 4
  %tst_r9 = icmp eq i32 %r9d, 0
  br i1 %tst_r9, label %bb_12A0, label %bb_127A

bb_127A:
  %dist3_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 3
  %dist3_ld = load i32, i32* %dist3_ptr, align 4
  %cmp_d3 = icmp ne i32 %dist3_ld, -1
  br i1 %cmp_d3, label %bb_12A0, label %bb_1281

bb_1281:
  %dist_src4_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src4 = load i32, i32* %dist_src4_ptr, align 4
  %qptr7 = load i8*, i8** %queue_ptr, align 8
  %rsi7 = load i64, i64* %rsi_cnt, align 8
  %qoff7 = mul i64 %rsi7, 8
  %qdst7b = getelementptr inbounds i8, i8* %qptr7, i64 %qoff7
  %qdst7 = bitcast i8* %qdst7b to i64*
  store i64 3, i64* %qdst7, align 8
  %rsi7_inc = add i64 %rsi7, 1
  store i64 %rsi7_inc, i64* %rsi_cnt, align 8
  %d3_new = add i32 %dist_src4, 1
  store i32 %d3_new, i32* %dist3_ptr, align 4
  br label %bb_12A0

bb_12A0:
  %e3_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge3, i64 0, i64 %rcx7
  %r8d = load i32, i32* %e3_ptr, align 4
  %tst_r8 = icmp eq i32 %r8d, 0
  br i1 %tst_r8, label %bb_12D0, label %bb_12AA

bb_12AA:
  %dist4_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 4
  %dist4_ld = load i32, i32* %dist4_ptr, align 4
  %cmp_d4 = icmp ne i32 %dist4_ld, -1
  br i1 %cmp_d4, label %bb_12D0, label %bb_12B1

bb_12B1:
  %dist_src5_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src5 = load i32, i32* %dist_src5_ptr, align 4
  %qptr8 = load i8*, i8** %queue_ptr, align 8
  %rsi8 = load i64, i64* %rsi_cnt, align 8
  %qoff8 = mul i64 %rsi8, 8
  %qdst8b = getelementptr inbounds i8, i8* %qptr8, i64 %qoff8
  %qdst8 = bitcast i8* %qdst8b to i64*
  store i64 4, i64* %qdst8, align 8
  %rsi8_inc = add i64 %rsi8, 1
  store i64 %rsi8_inc, i64* %rsi_cnt, align 8
  %d4_new = add i32 %dist_src5, 1
  store i32 %d4_new, i32* %dist4_ptr, align 4
  br label %bb_12D0

bb_12D0:
  %e4_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge4, i64 0, i64 %rcx7
  %ecxv = load i32, i32* %e4_ptr, align 4
  %tst_ecx = icmp eq i32 %ecxv, 0
  br i1 %tst_ecx, label %bb_12F8, label %bb_12D8

bb_12D8:
  %dist5_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 5
  %dist5_ld = load i32, i32* %dist5_ptr, align 4
  %cmp_d5 = icmp ne i32 %dist5_ld, -1
  br i1 %cmp_d5, label %bb_12F8, label %bb_12DF

bb_12DF:
  %dist_src6_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src6 = load i32, i32* %dist_src6_ptr, align 4
  %qptr9 = load i8*, i8** %queue_ptr, align 8
  %rsi9 = load i64, i64* %rsi_cnt, align 8
  %qoff9 = mul i64 %rsi9, 8
  %qdst9b = getelementptr inbounds i8, i8* %qptr9, i64 %qoff9
  %qdst9 = bitcast i8* %qdst9b to i64*
  store i64 5, i64* %qdst9, align 8
  %rsi9_inc = add i64 %rsi9, 1
  store i64 %rsi9_inc, i64* %rsi_cnt, align 8
  %d5_new = add i32 %dist_src6, 1
  store i32 %d5_new, i32* %dist5_ptr, align 4
  br label %bb_12F8

bb_12F8:
  %e5_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_edge5, i64 0, i64 %rcx7
  %eaxv = load i32, i32* %e5_ptr, align 4
  %tst_eax2 = icmp eq i32 %eaxv, 0
  br i1 %tst_eax2, label %bb_1320, label %bb_1300

bb_1300:
  %dist6_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 6
  %dist6_ld = load i32, i32* %dist6_ptr, align 4
  %cmp_d6 = icmp ne i32 %dist6_ld, -1
  br i1 %cmp_d6, label %bb_1320, label %bb_1307

bb_1307:
  %dist_src7_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %rdx3
  %dist_src7 = load i32, i32* %dist_src7_ptr, align 4
  %qptr10 = load i8*, i8** %queue_ptr, align 8
  %rsi10 = load i64, i64* %rsi_cnt, align 8
  %qoff10 = mul i64 %rsi10, 8
  %qdst10b = getelementptr inbounds i8, i8* %qptr10, i64 %qoff10
  %qdst10 = bitcast i8* %qdst10b to i64*
  store i64 6, i64* %qdst10, align 8
  %rsi10_inc = add i64 %rsi10, 1
  store i64 %rsi10_inc, i64* %rsi_cnt, align 8
  %d6_new = add i32 %dist_src7, 1
  store i32 %d6_new, i32* %dist6_ptr, align 4
  br label %bb_1320

bb_1320:
  %rbx_now = load i64, i64* %rbx_idx, align 8
  %rsi_now = load i64, i64* %rsi_cnt, align 8
  %cmp_loop = icmp ult i64 %rbx_now, %rsi_now
  br i1 %cmp_loop, label %bb_11C0, label %bb_1329

bb_1329:
  %qptr11 = load i8*, i8** %queue_ptr, align 8
  call void @free(i8* %qptr11)
  %first_ord_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  %first_ord = load i64, i64* %first_ord_ptr, align 8
  %fmt_bfs1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call_hdr1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs1, i64 %first_ord)
  %rbx_after = load i64, i64* %rbx_idx, align 8
  %cmp_one = icmp ne i64 %rbx_after, 1
  br i1 %cmp_one, label %bb_13DD, label %bb_1360

bb_1360:
  %empty_ptr_cast = bitcast [1 x i8]* @.str_empty to i8*
  %fmt_ps = getelementptr inbounds [6 x i8], [6 x i8]* @.str_percentzu_s, i64 0, i64 0
  %call_ps = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ps, i64 %first_ord, i8* %empty_ptr_cast)
  br label %bb_1376

bb_1376:
  %nl_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl_ptr)
  store i64 0, i64* %rbx_idx, align 8
  br label %bb_1398

bb_1398:
  %idx_print = load i64, i64* %rbx_idx, align 8
  %dist_i32_ptr = getelementptr inbounds [64 x i32], [64 x i32]* %arr_dist, i64 0, i64 %idx_print
  %dist_i32 = load i32, i32* %dist_i32_ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dist, i64 0, i64 %idx_print, i32 %dist_i32)
  %idx_inc = add i64 %idx_print, 1
  store i64 %idx_inc, i64* %rbx_idx, align 8
  %cmp7 = icmp ne i64 %idx_inc, 7
  br i1 %cmp7, label %bb_1398, label %bb_13BA

bb_13BA:
  %guard_saved = load i64, i64* %stack_cookie, align 8
  %guard_cur = load i64, i64* @__stack_chk_guard, align 8
  %cmp_guard = icmp ne i64 %guard_saved, %guard_cur
  br i1 %cmp_guard, label %bb_142E, label %bb_13CD

bb_13CD:
  ret i32 0

bb_13DD:
  %rbx_cnt2 = load i64, i64* %rbx_idx, align 8
  %ord_end = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 %rbx_cnt2
  %rbp_start = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 1
  br label %bb_13F0

bb_13F0:
  %rbp_cur = phi i64* [ %rbp_start, %bb_13DD ], [ %rbp_next, %bb_13F0 ]
  %prev_elem_ptr = getelementptr inbounds i64, i64* %rbp_cur, i64 -1
  %elem_val = load i64, i64* %prev_elem_ptr, align 8
  %fmt_ps2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_percentzu_s, i64 0, i64 0
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %call_list = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ps2, i64 %elem_val, i8* %space_ptr)
  %rbp_next = getelementptr inbounds i64, i64* %rbp_cur, i64 1
  %cmp_end = icmp ne i64* %rbp_next, %ord_end
  br i1 %cmp_end, label %bb_13F0, label %bb_1360

bb_1414:
  %fmt_bfs2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call_hdr2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs2, i64 0)
  br label %bb_1376

bb_142E:
  call void @__stack_chk_fail()
  unreachable
}

attributes #0 = { "no-frame-pointer-elim"="true" }