; ModuleID = 'dfs'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @dfs(i32* %arg0, i64 %arg8, i64 %arg10, i64* %arg18, i64* %arg20) {
entry:
  %block = alloca i8*, align 8
  %var28 = alloca i8*, align 8
  %var30 = alloca i8*, align 8
  %i = alloca i64, align 8
  %sp = alloca i64, align 8
  %cur = alloca i64, align 8
  %next = alloca i64, align 8
  %n_is_zero = icmp eq i64 %arg8, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:
  %start_lt_n = icmp ult i64 %arg10, %arg8
  br i1 %start_lt_n, label %alloc, label %ret_zero

ret_zero:
  store i64 0, i64* %arg20, align 8
  br label %exit

alloc:
  %size_block = shl i64 %arg8, 2
  %m1 = call i8* @malloc(i64 %size_block)
  store i8* %m1, i8** %block, align 8
  %size_v28 = shl i64 %arg8, 3
  %m2 = call i8* @malloc(i64 %size_v28)
  store i8* %m2, i8** %var28, align 8
  %size_v30 = shl i64 %arg8, 3
  %m3 = call i8* @malloc(i64 %size_v30)
  store i8* %m3, i8** %var30, align 8
  %b0 = load i8*, i8** %block, align 8
  %nullb = icmp eq i8* %b0, null
  %v28p = load i8*, i8** %var28, align 8
  %nullv28 = icmp eq i8* %v28p, null
  %or1 = or i1 %nullb, %nullv28
  %v30p = load i8*, i8** %var30, align 8
  %nullv30 = icmp eq i8* %v30p, null
  %anynull = or i1 %or1, %nullv30
  br i1 %anynull, label %alloc_fail, label %init_prep

alloc_fail:
  %b1 = load i8*, i8** %block, align 8
  call void @free(i8* %b1)
  %v281 = load i8*, i8** %var28, align 8
  call void @free(i8* %v281)
  %v301 = load i8*, i8** %var30, align 8
  call void @free(i8* %v301)
  store i64 0, i64* %arg20, align 8
  br label %exit

init_prep:
  store i64 0, i64* %i, align 8
  br label %init_cond

init_cond:
  %iv = load i64, i64* %i, align 8
  %init_cmp = icmp ult i64 %iv, %arg8
  br i1 %init_cmp, label %init_body, label %after_init

init_body:
  %bptr2 = load i8*, i8** %block, align 8
  %btyped = bitcast i8* %bptr2 to i32*
  %bgep = getelementptr inbounds i32, i32* %btyped, i64 %iv
  store i32 0, i32* %bgep, align 4
  %v28p2 = load i8*, i8** %var28, align 8
  %v28typed = bitcast i8* %v28p2 to i64*
  %v28gep = getelementptr inbounds i64, i64* %v28typed, i64 %iv
  store i64 0, i64* %v28gep, align 8
  %iv1 = add i64 %iv, 1
  store i64 %iv1, i64* %i, align 8
  br label %init_cond

after_init:
  store i64 0, i64* %sp, align 8
  store i64 0, i64* %arg20, align 8
  %sp0 = load i64, i64* %sp, align 8
  %sp1 = add i64 %sp0, 1
  store i64 %sp1, i64* %sp, align 8
  %stackp = load i8*, i8** %var30, align 8
  %stack64 = bitcast i8* %stackp to i64*
  %stack_gep = getelementptr inbounds i64, i64* %stack64, i64 %sp0
  store i64 %arg10, i64* %stack_gep, align 8
  %bptr3 = load i8*, i8** %block, align 8
  %btyped3 = bitcast i8* %bptr3 to i32*
  %bgep3 = getelementptr inbounds i32, i32* %btyped3, i64 %arg10
  store i32 1, i32* %bgep3, align 4
  %oldcnt = load i64, i64* %arg20, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %arg20, align 8
  %out_gep = getelementptr inbounds i64, i64* %arg18, i64 %oldcnt
  store i64 %arg10, i64* %out_gep, align 8
  br label %main_check

main_check:
  %spv = load i64, i64* %sp, align 8
  %has_items = icmp ne i64 %spv, 0
  br i1 %has_items, label %process_top, label %cleanup

process_top:
  %topidx = add i64 %spv, -1
  %stackp2 = load i8*, i8** %var30, align 8
  %stack64_2 = bitcast i8* %stackp2 to i64*
  %top_gep = getelementptr inbounds i64, i64* %stack64_2, i64 %topidx
  %top = load i64, i64* %top_gep, align 8
  store i64 %top, i64* %cur, align 8
  %v28p3 = load i8*, i8** %var28, align 8
  %v28typed3 = bitcast i8* %v28p3 to i64*
  %curv = load i64, i64* %cur, align 8
  %next_gep0 = getelementptr inbounds i64, i64* %v28typed3, i64 %curv
  %next0 = load i64, i64* %next_gep0, align 8
  store i64 %next0, i64* %next, align 8
  br label %neighbor_cond

neighbor_cond:
  %nextv = load i64, i64* %next, align 8
  %has_neighbor = icmp ult i64 %nextv, %arg8
  br i1 %has_neighbor, label %neighbor_test, label %post_scan

neighbor_test:
  %curv2 = load i64, i64* %cur, align 8
  %mul = mul i64 %curv2, %arg8
  %sum = add i64 %mul, %nextv
  %adj_ptr = getelementptr inbounds i32, i32* %arg0, i64 %sum
  %adj = load i32, i32* %adj_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj, 0
  br i1 %adj_is_zero, label %neighbor_incr, label %check_visited

check_visited:
  %bptr4 = load i8*, i8** %block, align 8
  %btyped4 = bitcast i8* %bptr4 to i32*
  %blk_gep = getelementptr inbounds i32, i32* %btyped4, i64 %nextv
  %blk_val = load i32, i32* %blk_gep, align 4
  %visited = icmp ne i32 %blk_val, 0
  br i1 %visited, label %neighbor_incr, label %found_neighbor

found_neighbor:
  %v28p4 = load i8*, i8** %var28, align 8
  %v28typed4 = bitcast i8* %v28p4 to i64*
  %curv3 = load i64, i64* %cur, align 8
  %next_gep1 = getelementptr inbounds i64, i64* %v28typed4, i64 %curv3
  %next_plus1 = add i64 %nextv, 1
  store i64 %next_plus1, i64* %next_gep1, align 8
  %bptr5 = load i8*, i8** %block, align 8
  %btyped5 = bitcast i8* %bptr5 to i32*
  %blk_gep2 = getelementptr inbounds i32, i32* %btyped5, i64 %nextv
  store i32 1, i32* %blk_gep2, align 4
  %oldcnt2 = load i64, i64* %arg20, align 8
  %newcnt2 = add i64 %oldcnt2, 1
  store i64 %newcnt2, i64* %arg20, align 8
  %out_gep2 = getelementptr inbounds i64, i64* %arg18, i64 %oldcnt2
  store i64 %nextv, i64* %out_gep2, align 8
  %sp_before = load i64, i64* %sp, align 8
  %sp_inc = add i64 %sp_before, 1
  store i64 %sp_inc, i64* %sp, align 8
  %stackp3 = load i8*, i8** %var30, align 8
  %stack64_3 = bitcast i8* %stackp3 to i64*
  %stack_slot = getelementptr inbounds i64, i64* %stack64_3, i64 %sp_before
  store i64 %nextv, i64* %stack_slot, align 8
  br label %post_scan

neighbor_incr:
  %nextv2 = load i64, i64* %next, align 8
  %next_inc = add i64 %nextv2, 1
  store i64 %next_inc, i64* %next, align 8
  br label %neighbor_cond

post_scan:
  %nextv3 = load i64, i64* %next, align 8
  %done = icmp eq i64 %nextv3, %arg8
  br i1 %done, label %pop, label %main_check

pop:
  %sp_now = load i64, i64* %sp, align 8
  %sp_dec = add i64 %sp_now, -1
  store i64 %sp_dec, i64* %sp, align 8
  br label %main_check

cleanup:
  %bfree = load i8*, i8** %block, align 8
  call void @free(i8* %bfree)
  %v28free = load i8*, i8** %var28, align 8
  call void @free(i8* %v28free)
  %v30free = load i8*, i8** %var30, align 8
  call void @free(i8* %v30free)
  br label %exit

exit:
  ret void
}