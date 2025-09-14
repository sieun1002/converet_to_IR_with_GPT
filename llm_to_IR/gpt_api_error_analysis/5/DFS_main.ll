; Target info
target triple = "x86_64-pc-linux-gnu"

; External declarations
declare i8* @malloc(i64)
declare void @free(i8*)

; void dfs(i32* adj, i64 n, i64 start, i64* out, i64* out_count_ptr)
define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count_ptr) {
entry:
  %visited.ptr = alloca i32*, align 8
  %nextidx.ptr = alloca i64*, align 8
  %stack.ptr = alloca i64*, align 8
  %stack.size = alloca i64, align 8
  %i.var = alloca i64, align 8
  %u.var = alloca i64, align 8
  %v.var = alloca i64, align 8

  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %early_return, label %check_start

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_return, label %allocs

early_return:
  store i64 0, i64* %out_count_ptr, align 8
  ret void

allocs:
  %size_visit_bytes = shl i64 %n, 2
  %malloc_visit_raw = call i8* @malloc(i64 %size_visit_bytes)
  %malloc_visit = bitcast i8* %malloc_visit_raw to i32*
  store i32* %malloc_visit, i32** %visited.ptr, align 8

  %size_next_bytes = shl i64 %n, 3
  %malloc_next_raw = call i8* @malloc(i64 %size_next_bytes)
  %malloc_next = bitcast i8* %malloc_next_raw to i64*
  store i64* %malloc_next, i64** %nextidx.ptr, align 8

  %malloc_stack_raw = call i8* @malloc(i64 %size_next_bytes)
  %malloc_stack = bitcast i8* %malloc_stack_raw to i64*
  store i64* %malloc_stack, i64** %stack.ptr, align 8

  %vis_is_null = icmp eq i32* %malloc_visit, null
  %next_is_null = icmp eq i64* %malloc_next, null
  %stack_is_null = icmp eq i64* %malloc_stack, null
  %any_null_tmp = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %any_null_tmp, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  %vis_free_i8 = bitcast i32* %malloc_visit to i8*
  call void @free(i8* %vis_free_i8)
  %next_free_i8 = bitcast i64* %malloc_next to i8*
  call void @free(i8* %next_free_i8)
  %stack_free_i8 = bitcast i64* %malloc_stack to i8*
  call void @free(i8* %stack_free_i8)
  store i64 0, i64* %out_count_ptr, align 8
  ret void

init:
  store i64 0, i64* %i.var, align 8
  br label %init.loop

init.loop:
  %i.cur = load i64, i64* %i.var, align 8
  %i.lt.n = icmp ult i64 %i.cur, %n
  br i1 %i.lt.n, label %init.body, label %after.init

init.body:
  %visited.base = load i32*, i32** %visited.ptr, align 8
  %vis.gep = getelementptr inbounds i32, i32* %visited.base, i64 %i.cur
  store i32 0, i32* %vis.gep, align 4

  %next.base = load i64*, i64** %nextidx.ptr, align 8
  %next.gep = getelementptr inbounds i64, i64* %next.base, i64 %i.cur
  store i64 0, i64* %next.gep, align 8

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.var, align 8
  br label %init.loop

after.init:
  store i64 0, i64* %stack.size, align 8
  store i64 0, i64* %out_count_ptr, align 8

  %stack.base0 = load i64*, i64** %stack.ptr, align 8
  %ssz.old0 = load i64, i64* %stack.size, align 8
  %stack.slot0 = getelementptr inbounds i64, i64* %stack.base0, i64 %ssz.old0
  store i64 %start, i64* %stack.slot0, align 8
  %ssz.new0 = add i64 %ssz.old0, 1
  store i64 %ssz.new0, i64* %stack.size, align 8

  %visited.base0 = load i32*, i32** %visited.ptr, align 8
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited.base0, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4

  %outcnt.old0 = load i64, i64* %out_count_ptr, align 8
  %out.slot0 = getelementptr inbounds i64, i64* %out, i64 %outcnt.old0
  store i64 %start, i64* %out.slot0, align 8
  %outcnt.new0 = add i64 %outcnt.old0, 1
  store i64 %outcnt.new0, i64* %out_count_ptr, align 8

  br label %main.loop

main.loop:
  %ssz.cur = load i64, i64* %stack.size, align 8
  %ssz.nonzero = icmp ne i64 %ssz.cur, 0
  br i1 %ssz.nonzero, label %process.frame, label %cleanup

process.frame:
  %ssz.minus1 = add i64 %ssz.cur, -1
  %stack.base1 = load i64*, i64** %stack.ptr, align 8
  %top.ptr = getelementptr inbounds i64, i64* %stack.base1, i64 %ssz.minus1
  %u.val = load i64, i64* %top.ptr, align 8
  store i64 %u.val, i64* %u.var, align 8

  %next.base1 = load i64*, i64** %nextidx.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %next.base1, i64 %u.val
  %v.start = load i64, i64* %next.u.ptr, align 8
  store i64 %v.start, i64* %v.var, align 8

  br label %neighbor.loop

neighbor.loop:
  %v.cur = load i64, i64* %v.var, align 8
  %v.lt.n = icmp ult i64 %v.cur, %n
  br i1 %v.lt.n, label %check.edge, label %no.more.neighbors

check.edge:
  %u.cur = load i64, i64* %u.var, align 8
  %mul.un = mul i64 %u.cur, %n
  %adj.idx = add i64 %mul.un, %v.cur
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %adj.idx
  %edge.val = load i32, i32* %adj.ptr, align 4
  %edge.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.zero, label %inc.v, label %check.visited

check.visited:
  %visited.base2 = load i32*, i32** %visited.ptr, align 8
  %vis.v.ptr = getelementptr inbounds i32, i32* %visited.base2, i64 %v.cur
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.nonzero = icmp ne i32 %vis.v, 0
  br i1 %vis.nonzero, label %inc.v, label %found.neighbor

inc.v:
  %v.cur2 = load i64, i64* %v.var, align 8
  %v.next = add i64 %v.cur2, 1
  store i64 %v.next, i64* %v.var, align 8
  br label %neighbor.loop

found.neighbor:
  %v.plus1 = add i64 %v.cur, 1
  %next.base2 = load i64*, i64** %nextidx.ptr, align 8
  %next.u.ptr2 = getelementptr inbounds i64, i64* %next.base2, i64 %u.cur
  store i64 %v.plus1, i64* %next.u.ptr2, align 8

  %visited.base3 = load i32*, i32** %visited.ptr, align 8
  %vis.v.ptr2 = getelementptr inbounds i32, i32* %visited.base3, i64 %v.cur
  store i32 1, i32* %vis.v.ptr2, align 4

  %outcnt.old1 = load i64, i64* %out_count_ptr, align 8
  %out.slot1 = getelementptr inbounds i64, i64* %out, i64 %outcnt.old1
  store i64 %v.cur, i64* %out.slot1, align 8
  %outcnt.new1 = add i64 %outcnt.old1, 1
  store i64 %outcnt.new1, i64* %out_count_ptr, align 8

  %stack.base2 = load i64*, i64** %stack.ptr, align 8
  %ssz.old1 = load i64, i64* %stack.size, align 8
  %stack.slot1 = getelementptr inbounds i64, i64* %stack.base2, i64 %ssz.old1
  store i64 %v.cur, i64* %stack.slot1, align 8
  %ssz.new1 = add i64 %ssz.old1, 1
  store i64 %ssz.new1, i64* %stack.size, align 8

  br label %main.loop

no.more.neighbors:
  %ssz.cur2 = load i64, i64* %stack.size, align 8
  %ssz.dec = add i64 %ssz.cur2, -1
  store i64 %ssz.dec, i64* %stack.size, align 8
  br label %main.loop

cleanup:
  %visited.base4 = load i32*, i32** %visited.ptr, align 8
  %visited.free = bitcast i32* %visited.base4 to i8*
  call void @free(i8* %visited.free)

  %next.base4 = load i64*, i64** %nextidx.ptr, align 8
  %next.free = bitcast i64* %next.base4 to i8*
  call void @free(i8* %next.free)

  %stack.base4 = load i64*, i64** %stack.ptr, align 8
  %stack.free = bitcast i64* %stack.base4 to i8*
  call void @free(i8* %stack.free)

  ret void
}