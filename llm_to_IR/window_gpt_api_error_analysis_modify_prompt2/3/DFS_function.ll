target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %arg0, i64 %arg8, i64 %arg10, i64* %arg18, i64* %arg20) {
entry:
  %block.addr = alloca i32*
  %parent.addr = alloca i64*
  %stack.addr = alloca i64*
  %i.addr = alloca i64
  %sp.addr = alloca i64
  %j.addr = alloca i64
  %v.addr = alloca i64
  %is_zero = icmp eq i64 %arg8, 0
  br i1 %is_zero, label %early, label %check_bounds

check_bounds:
  %in_bounds = icmp ult i64 %arg10, %arg8
  br i1 %in_bounds, label %allocs, label %early

early:
  store i64 0, i64* %arg20
  br label %ret

allocs:
  %size_block = shl i64 %arg8, 2
  %malloc1 = call i8* @malloc(i64 %size_block)
  %block.ptr = bitcast i8* %malloc1 to i32*
  %size_q = shl i64 %arg8, 3
  %malloc2 = call i8* @malloc(i64 %size_q)
  %parent.ptr = bitcast i8* %malloc2 to i64*
  %malloc3 = call i8* @malloc(i64 %size_q)
  %stack.ptr = bitcast i8* %malloc3 to i64*
  %null_block = icmp eq i32* %block.ptr, null
  %null_parent = icmp eq i64* %parent.ptr, null
  %null_stack = icmp eq i64* %stack.ptr, null
  %anynull.tmp = or i1 %null_block, %null_parent
  %anynull = or i1 %anynull.tmp, %null_stack
  br i1 %anynull, label %alloc_fail, label %init_loop_entry

alloc_fail:
  %free1 = bitcast i32* %block.ptr to i8*
  call void @free(i8* %free1)
  %free2 = bitcast i64* %parent.ptr to i8*
  call void @free(i8* %free2)
  %free3 = bitcast i64* %stack.ptr to i8*
  call void @free(i8* %free3)
  store i64 0, i64* %arg20
  br label %ret

init_loop_entry:
  store i32* %block.ptr, i32** %block.addr
  store i64* %parent.ptr, i64** %parent.addr
  store i64* %stack.ptr, i64** %stack.addr
  store i64 0, i64* %i.addr
  br label %init_loop_cond

init_loop_cond:
  %i.cur = load i64, i64* %i.addr
  %i.cmp = icmp ult i64 %i.cur, %arg8
  br i1 %i.cmp, label %init_loop_body, label %post_init

init_loop_body:
  %blk.base = load i32*, i32** %block.addr
  %blk.elem = getelementptr inbounds i32, i32* %blk.base, i64 %i.cur
  store i32 0, i32* %blk.elem
  %par.base = load i64*, i64** %parent.addr
  %par.elem = getelementptr inbounds i64, i64* %par.base, i64 %i.cur
  store i64 0, i64* %par.elem
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.addr
  br label %init_loop_cond

post_init:
  store i64 0, i64* %sp.addr
  store i64 0, i64* %arg20
  %sp0 = load i64, i64* %sp.addr
  %sp1 = add i64 %sp0, 1
  store i64 %sp1, i64* %sp.addr
  %stk.base0 = load i64*, i64** %stack.addr
  %stk.slot0 = getelementptr inbounds i64, i64* %stk.base0, i64 %sp0
  store i64 %arg10, i64* %stk.slot0
  %blk.base2 = load i32*, i32** %block.addr
  %blk.idx2 = getelementptr inbounds i32, i32* %blk.base2, i64 %arg10
  store i32 1, i32* %blk.idx2
  %cnt.old = load i64, i64* %arg20
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %arg20
  %out.slot0 = getelementptr inbounds i64, i64* %arg18, i64 %cnt.old
  store i64 %arg10, i64* %out.slot0
  br label %main_check

main_check:
  %sp.cur = load i64, i64* %sp.addr
  %sp.nz = icmp ne i64 %sp.cur, 0
  br i1 %sp.nz, label %main_process, label %finish

main_process:
  %sp.cur2 = load i64, i64* %sp.addr
  %spm1 = add i64 %sp.cur2, -1
  %stk.base1 = load i64*, i64** %stack.addr
  %stk.top.ptr = getelementptr inbounds i64, i64* %stk.base1, i64 %spm1
  %stk.top = load i64, i64* %stk.top.ptr
  store i64 %stk.top, i64* %v.addr
  %par.base1 = load i64*, i64** %parent.addr
  %par.v.ptr = getelementptr inbounds i64, i64* %par.base1, i64 %stk.top
  %j.init = load i64, i64* %par.v.ptr
  store i64 %j.init, i64* %j.addr
  br label %inner_check

inner_check:
  %j.cur = load i64, i64* %j.addr
  %j.lt = icmp ult i64 %j.cur, %arg8
  br i1 %j.lt, label %inner_body, label %after_inner

inner_body:
  %v.cur = load i64, i64* %v.addr
  %vmul = mul i64 %v.cur, %arg8
  %sum = add i64 %vmul, %j.cur
  %adj.ptr = getelementptr inbounds i32, i32* %arg0, i64 %sum
  %adj.val = load i32, i32* %adj.ptr
  %adj.nz = icmp ne i32 %adj.val, 0
  br i1 %adj.nz, label %check_block, label %inc_j

check_block:
  %blk.base3 = load i32*, i32** %block.addr
  %blk.j.ptr = getelementptr inbounds i32, i32* %blk.base3, i64 %j.cur
  %blk.j.val = load i32, i32* %blk.j.ptr
  %blk.j.zero = icmp eq i32 %blk.j.val, 0
  br i1 %blk.j.zero, label %found_neighbor, label %inc_j

found_neighbor:
  %j.plus = add i64 %j.cur, 1
  %par.base2 = load i64*, i64** %parent.addr
  %par.v.ptr2 = getelementptr inbounds i64, i64* %par.base2, i64 %v.cur
  store i64 %j.plus, i64* %par.v.ptr2
  %blk.base4 = load i32*, i32** %block.addr
  %blk.j.ptr2 = getelementptr inbounds i32, i32* %blk.base4, i64 %j.cur
  store i32 1, i32* %blk.j.ptr2
  %cnt.old2 = load i64, i64* %arg20
  %cnt.new2 = add i64 %cnt.old2, 1
  store i64 %cnt.new2, i64* %arg20
  %out.ptr = getelementptr inbounds i64, i64* %arg18, i64 %cnt.old2
  store i64 %j.cur, i64* %out.ptr
  %sp.old3 = load i64, i64* %sp.addr
  %sp.new3 = add i64 %sp.old3, 1
  store i64 %sp.new3, i64* %sp.addr
  %stk.base3 = load i64*, i64** %stack.addr
  %stk.slot = getelementptr inbounds i64, i64* %stk.base3, i64 %sp.old3
  store i64 %j.cur, i64* %stk.slot
  br label %after_inner

inc_j:
  %j.inc = add i64 %j.cur, 1
  store i64 %j.inc, i64* %j.addr
  br label %inner_check

after_inner:
  %j.after = load i64, i64* %j.addr
  %j.eq.end = icmp eq i64 %j.after, %arg8
  br i1 %j.eq.end, label %dec_sp, label %main_check

dec_sp:
  %sp.cur3 = load i64, i64* %sp.addr
  %sp.dec = add i64 %sp.cur3, -1
  store i64 %sp.dec, i64* %sp.addr
  br label %main_check

finish:
  %blk.free.ld = load i32*, i32** %block.addr
  %blk.free.bc = bitcast i32* %blk.free.ld to i8*
  call void @free(i8* %blk.free.bc)
  %par.free.ld = load i64*, i64** %parent.addr
  %par.free.bc = bitcast i64* %par.free.ld to i8*
  call void @free(i8* %par.free.bc)
  %stk.free.ld = load i64*, i64** %stack.addr
  %stk.free.bc = bitcast i64* %stk.free.ld to i8*
  call void @free(i8* %stk.free.bc)
  br label %ret

ret:
  ret void
}