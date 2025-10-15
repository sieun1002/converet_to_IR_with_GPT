; ModuleID = 'dijkstra_mod'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dijkstra(i32* %arg0, i64 %n, i64 %start, i32* %dist, i32* %prev) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %ret, label %check_start

check_start:
  %cmp_start_ge_n = icmp uge i64 %start, %n
  br i1 %cmp_start_ge_n, label %ret, label %alloc

alloc:
  %size_bytes = mul i64 %n, 4
  %memptr = call i8* @malloc(i64 %size_bytes)
  %alloc_null = icmp eq i8* %memptr, null
  br i1 %alloc_null, label %ret, label %init

init:
  %block = bitcast i8* %memptr to i32*
  br label %init.loop

init.loop:
  %i.init = phi i64 [ 0, %init ], [ %i.next, %init.latch ]
  %init.cond = icmp ult i64 %i.init, %n
  br i1 %init.cond, label %init.body, label %post_init

init.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.init
  store i32 1061109567, i32* %dist.ptr, align 4
  %prev.ptr = getelementptr inbounds i32, i32* %prev, i64 %i.init
  store i32 -1, i32* %prev.ptr, align 4
  %block.ptr = getelementptr inbounds i32, i32* %block, i64 %i.init
  store i32 0, i32* %block.ptr, align 4
  br label %init.latch

init.latch:
  %i.next = add i64 %i.init, 1
  br label %init.loop

post_init:
  %start.dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  br label %outer.loop

outer.loop:
  %t = phi i64 [ 0, %post_init ], [ %t.next, %outer.latch ]
  %outer.cond = icmp ult i64 %t, %n
  br i1 %outer.cond, label %find.init, label %done_free

find.init:
  br label %find.loop

find.loop:
  %i.find = phi i64 [ 0, %find.init ], [ %i.find.next, %find.latch ]
  %best = phi i32 [ 1061109567, %find.init ], [ %best.next, %find.latch ]
  %u = phi i64 [ %n, %find.init ], [ %u.next, %find.latch ]
  %find.cond = icmp ult i64 %i.find, %n
  br i1 %find.cond, label %find.body, label %find.done

find.body:
  %blk.ptr.i = getelementptr inbounds i32, i32* %block, i64 %i.find
  %blk.val.i = load i32, i32* %blk.ptr.i, align 4
  %blk.is.zero = icmp eq i32 %blk.val.i, 0
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i.find
  %dist.val.i = load i32, i32* %dist.ptr.i, align 4
  %di_lt_best = icmp slt i32 %dist.val.i, %best
  %do.update = and i1 %blk.is.zero, %di_lt_best
  %best.sel = select i1 %do.update, i32 %dist.val.i, i32 %best
  %u.sel = select i1 %do.update, i64 %i.find, i64 %u
  br label %find.latch

find.latch:
  %best.next = phi i32 [ %best.sel, %find.body ]
  %u.next = phi i64 [ %u.sel, %find.body ]
  %i.find.next = add i64 %i.find, 1
  br label %find.loop

find.done:
  %u.final = phi i64 [ %u, %find.loop ]
  %u_is_n = icmp eq i64 %u.final, %n
  br i1 %u_is_n, label %done_free, label %mark_visited

mark_visited:
  %blk.ptr.u = getelementptr inbounds i32, i32* %block, i64 %u.final
  store i32 1, i32* %blk.ptr.u, align 4
  br label %nbr.loop

nbr.loop:
  %j = phi i64 [ 0, %mark_visited ], [ %j.next, %nbr.latch ]
  %nbr.cond = icmp ult i64 %j, %n
  br i1 %nbr.cond, label %nbr.body, label %outer.latch

nbr.body:
  %mul = mul i64 %u.final, %n
  %idx = add i64 %mul, %j
  %w.ptr = getelementptr inbounds i32, i32* %arg0, i64 %idx
  %w = load i32, i32* %w.ptr, align 4
  %w.neg = icmp slt i32 %w, 0
  br i1 %w.neg, label %nbr.latch, label %check_blk_j

check_blk_j:
  %blk.ptr.j = getelementptr inbounds i32, i32* %block, i64 %j
  %blk.val.j = load i32, i32* %blk.ptr.j, align 4
  %blk.j.notzero = icmp ne i32 %blk.val.j, 0
  br i1 %blk.j.notzero, label %nbr.latch, label %check_du_inf

check_du_inf:
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.final
  %du = load i32, i32* %du.ptr, align 4
  %du.is.inf = icmp eq i32 %du, 1061109567
  br i1 %du.is.inf, label %nbr.latch, label %relax.check

relax.check:
  %newd = add i32 %du, %w
  %dj.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %dj.ptr, align 4
  %ge = icmp sge i32 %newd, %dj
  br i1 %ge, label %nbr.latch, label %relax.update

relax.update:
  store i32 %newd, i32* %dj.ptr, align 4
  %u.trunc = trunc i64 %u.final to i32
  %prev.ptr.j = getelementptr inbounds i32, i32* %prev, i64 %j
  store i32 %u.trunc, i32* %prev.ptr.j, align 4
  br label %nbr.latch

nbr.latch:
  %j.next = add i64 %j, 1
  br label %nbr.loop

outer.latch:
  %t.next = add i64 %t, 1
  br label %outer.loop

done_free:
  %memptr.free = phi i8* [ %memptr, %outer.loop ], [ %memptr, %find.done ]
  call void @free(i8* %memptr.free)
  br label %ret

ret:
  ret void
}