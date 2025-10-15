; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.num = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

@adj = private constant [49 x i32] [
  i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
  i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,
  i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0,
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0,
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0,
  i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1,
  i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0
], align 4

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %pre = alloca [7 x i64], align 16
  %call.calloc.vis = call i8* @calloc(i64 28, i64 1)
  %call.calloc.nxt = call i8* @calloc(i64 56, i64 1)
  %call.malloc.stk = call i8* @malloc(i64 56)
  %vis.null = icmp eq i8* %call.calloc.vis, null
  %nxt.null = icmp eq i8* %call.calloc.nxt, null
  %stk.null = icmp eq i8* %call.malloc.stk, null
  %tmp.or1 = or i1 %vis.null, %nxt.null
  %tmp.or2 = or i1 %tmp.or1, %stk.null
  br i1 %tmp.or2, label %alloc_fail, label %alloc_ok

alloc_ok:
  %visited = bitcast i8* %call.calloc.vis to i32*
  %nextidx = bitcast i8* %call.calloc.nxt to i64*
  %stack = bitcast i8* %call.malloc.stk to i64*
  store i32 1, i32* %visited, align 4
  %stack0.ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 0, i64* %stack0.ptr, align 8
  %pre0.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %pre, i64 0, i64 0
  store i64 0, i64* %pre0.ptr, align 8
  br label %dfs.cond

dfs.cond:
  %depth.phi = phi i64 [ 1, %alloc_ok ], [ %depth.push, %dfs.push ], [ %depth.cont, %dfs.cont.set ], [ %depth.pop, %dfs.pop ]
  %count.phi = phi i64 [ 1, %alloc_ok ], [ %count.push, %dfs.push ], [ %count.cont, %dfs.cont.set ], [ %count.pop, %dfs.pop ]
  %cond.nz = icmp ne i64 %depth.phi, 0
  br i1 %cond.nz, label %dfs.body, label %dfs.end

dfs.body:
  %depth.m1 = add i64 %depth.phi, -1
  %stk.cur.ptr = getelementptr inbounds i64, i64* %stack, i64 %depth.m1
  %node = load i64, i64* %stk.cur.ptr, align 8
  %nxt.ptr = getelementptr inbounds i64, i64* %nextidx, i64 %node
  %i.cur = load i64, i64* %nxt.ptr, align 8
  %i.ge7 = icmp uge i64 %i.cur, 7
  br i1 %i.ge7, label %dfs.pop, label %dfs.check

dfs.pop:
  %depth.pop = add i64 %depth.phi, -1
  %count.pop = add i64 %count.phi, 0
  br label %dfs.cond

dfs.check:
  %node.mul = mul i64 %node, 7
  %adj.idx = add i64 %node.mul, %i.cur
  %adj.gep = getelementptr inbounds [49 x i32], [49 x i32]* @adj, i64 0, i64 %adj.idx
  %adj.val = load i32, i32* %adj.gep, align 4
  %adj.nz = icmp ne i32 %adj.val, 0
  br i1 %adj.nz, label %dfs.check.vis, label %dfs.cont.set

dfs.check.vis:
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i.cur
  %vis.val = load i32, i32* %vis.ptr, align 4
  %vis.nz = icmp ne i32 %vis.val, 0
  br i1 %vis.nz, label %dfs.cont.set, label %dfs.push

dfs.cont.set:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %nxt.ptr, align 8
  %depth.cont = add i64 %depth.phi, 0
  %count.cont = add i64 %count.phi, 0
  br label %dfs.cond

dfs.push:
  %i.next.push = add i64 %i.cur, 1
  store i64 %i.next.push, i64* %nxt.ptr, align 8
  %vis.one = add i32 0, 1
  %vis.ptr2 = getelementptr inbounds i32, i32* %visited, i64 %i.cur
  store i32 %vis.one, i32* %vis.ptr2, align 4
  %stk.put.ptr = getelementptr inbounds i64, i64* %stack, i64 %depth.phi
  store i64 %i.cur, i64* %stk.put.ptr, align 8
  %pre.put.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %pre, i64 0, i64 %count.phi
  store i64 %i.cur, i64* %pre.put.ptr, align 8
  %depth.push = add i64 %depth.phi, 1
  %count.push = add i64 %count.phi, 1
  br label %dfs.cond

dfs.end:
  %count.end = phi i64 [ %count.phi, %dfs.cond ]
  call void @free(i8* %call.calloc.vis)
  call void @free(i8* %call.calloc.nxt)
  call void @free(i8* %call.malloc.stk)
  %pre.fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %pre.fmt.ptr, i64 0)
  %cnt.eq1 = icmp eq i64 %count.end, 1
  br i1 %cnt.eq1, label %print.single, label %print.multi.check

print.single:
  %val0.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %pre, i64 0, i64 0
  %val0 = load i64, i64* %val0.ptr, align 8
  %fmt.num.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.num, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %call.single = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num.ptr, i64 %val0, i8* %empty.ptr)
  br label %print.nl

print.multi.check:
  %cnt.gt1 = icmp ugt i64 %count.end, 1
  br i1 %cnt.gt1, label %print.loop.init, label %print.nl

print.loop.init:
  %i.init = add i64 0, 0
  br label %print.loop

print.loop:
  %i.phi = phi i64 [ %i.init, %print.loop.init ], [ %i.next2, %print.loop.body ]
  %lim = add i64 %count.end, -1
  %cond.loop = icmp ult i64 %i.phi, %lim
  br i1 %cond.loop, label %print.loop.body, label %print.tail

print.loop.body:
  %pre.idx.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %pre, i64 0, i64 %i.phi
  %pre.val = load i64, i64* %pre.idx.ptr, align 8
  %fmt.num2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.num, i64 0, i64 0
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %call.loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num2.ptr, i64 %pre.val, i8* %space.ptr)
  %i.next2 = add i64 %i.phi, 1
  br label %print.loop

print.tail:
  %last.idx = add i64 %count.end, -1
  %pre.last.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %pre, i64 0, i64 %last.idx
  %pre.last = load i64, i64* %pre.last.ptr, align 8
  %fmt.num3.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.num, i64 0, i64 0
  %empty2.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %call.tail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.num3.ptr, i64 %pre.last, i8* %empty2.ptr)
  br label %print.nl

print.nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0

alloc_fail:
  call void @free(i8* %call.calloc.vis)
  call void @free(i8* %call.calloc.nxt)
  call void @free(i8* %call.malloc.stk)
  %pre.fmt.ptr.af = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %call.hdr.af = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %pre.fmt.ptr.af, i64 0)
  %nl.ptr.af = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl.af = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr.af)
  ret i32 0
}