; ModuleID = 'main_module'
target triple = "x86_64-unknown-linux-gnu"

@.fmt_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.fmt_item   = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.space      = private unnamed_addr constant [2 x i8] c" \00"
@.empty      = private unnamed_addr constant [1 x i8] zeroinitializer

@__stack_chk_guard = external global i64

declare void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %n           = alloca i64, align 8
  %start       = alloca i64, align 8
  %out_len     = alloca i64, align 8
  %i           = alloca i64, align 8
  %adj.arr     = alloca [49 x i32], align 16
  %out.arr     = alloca [8 x i64], align 16

  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canary.slot, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj.arr, i64 0, i64 0
  %adj.i8   = bitcast i32* %adj.base to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %nv = load i64, i64* %n, align 8

  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4

  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4

  %pn = getelementptr inbounds i32, i32* %adj.base, i64 %nv
  store i32 1, i32* %pn, align 4

  %two.n = mul i64 %nv, 2
  %p2n = getelementptr inbounds i32, i32* %adj.base, i64 %two.n
  store i32 1, i32* %p2n, align 4

  %n.plus3 = add i64 %nv, 3
  %pn3 = getelementptr inbounds i32, i32* %adj.base, i64 %n.plus3
  store i32 1, i32* %pn3, align 4

  %three.n = mul i64 %nv, 3
  %three.n.plus1 = add i64 %three.n, 1
  %p3n1 = getelementptr inbounds i32, i32* %adj.base, i64 %three.n.plus1
  store i32 1, i32* %p3n1, align 4

  %n.plus4 = add i64 %nv, 4
  %pn4 = getelementptr inbounds i32, i32* %adj.base, i64 %n.plus4
  store i32 1, i32* %pn4, align 4

  %four.n = mul i64 %nv, 4
  %four.n.plus1 = add i64 %four.n, 1
  %p4n1 = getelementptr inbounds i32, i32* %adj.base, i64 %four.n.plus1
  store i32 1, i32* %p4n1, align 4

  %two.n.plus5 = add i64 %two.n, 5
  %p2n5 = getelementptr inbounds i32, i32* %adj.base, i64 %two.n.plus5
  store i32 1, i32* %p2n5, align 4

  %five.n = mul i64 %nv, 5
  %five.n.plus2 = add i64 %five.n, 2
  %p5n2 = getelementptr inbounds i32, i32* %adj.base, i64 %five.n.plus2
  store i32 1, i32* %p5n2, align 4

  %four.n.plus5 = add i64 %four.n, 5
  %p4n5 = getelementptr inbounds i32, i32* %adj.base, i64 %four.n.plus5
  store i32 1, i32* %p4n5, align 4

  %five.n.plus4 = add i64 %five.n, 4
  %p5n4 = getelementptr inbounds i32, i32* %adj.base, i64 %five.n.plus4
  store i32 1, i32* %p5n4, align 4

  %five.n.plus6 = add i64 %five.n, 6
  %p5n6 = getelementptr inbounds i32, i32* %adj.base, i64 %five.n.plus6
  store i32 1, i32* %p5n6, align 4

  %six.n = mul i64 %nv, 6
  %six.n.plus5 = add i64 %six.n, 5
  %p6n5 = getelementptr inbounds i32, i32* %adj.base, i64 %six.n.plus5
  store i32 1, i32* %p6n5, align 4

  %out.base = getelementptr inbounds [8 x i64], [8 x i64]* %out.arr, i64 0, i64 0
  %start.v = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %nv, i64 %start.v, i64* %out.base, i64* %out_len)

  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt_header, i64 0, i64 0
  %start.v2 = load i64, i64* %start, align 8
  %call.printf.hdr = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.v2)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cmp.lt = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.lt, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.cur, 1
  %has.more = icmp ult i64 %i.plus1, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.more, i8* %sep.space.ptr, i8* %sep.empty.ptr

  %out.elem.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.cur
  %out.elem = load i64, i64* %out.elem.ptr, align 8

  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %out.elem, i8* %sep.ptr)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %_nl = call i32 @putchar(i32 10)

  %guard.end = load i64, i64* %canary.slot, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard
  %guard.ok = icmp eq i64 %guard.end, %guard.cur
  br i1 %guard.ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}