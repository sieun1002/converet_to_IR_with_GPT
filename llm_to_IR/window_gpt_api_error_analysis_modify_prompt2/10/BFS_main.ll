; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %adj.base.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj.base.i8 = bitcast i32* %adj.base.i32 to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.base.i8, i8 0, i64 196, i1 false)

  %n.val = load i64, i64* %n, align 8

  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 1
  store i32 1, i32* %idx1.ptr, align 4

  %idxn.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %n.val
  store i32 1, i32* %idxn.ptr, align 4

  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  %mul2n = mul i64 %n.val, 2
  %idx2n.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %mul2n
  store i32 1, i32* %idx2n.ptr, align 4

  %addn3 = add i64 %n.val, 3
  %idxn3.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %addn3
  store i32 1, i32* %idxn3.ptr, align 4

  %mul3n = mul i64 %n.val, 3
  %add3n1 = add i64 %mul3n, 1
  %idx3n1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add3n1
  store i32 1, i32* %idx3n1.ptr, align 4

  %addn4 = add i64 %n.val, 4
  %idxn4.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %addn4
  store i32 1, i32* %idxn4.ptr, align 4

  %mul4n = mul i64 %n.val, 4
  %add4n1 = add i64 %mul4n, 1
  %idx4n1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add4n1
  store i32 1, i32* %idx4n1.ptr, align 4

  %mul2n.b = mul i64 %n.val, 2
  %add2n5 = add i64 %mul2n.b, 5
  %idx2n5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add2n5
  store i32 1, i32* %idx2n5.ptr, align 4

  %mul5n = mul i64 %n.val, 5
  %add5n2 = add i64 %mul5n, 2
  %idx5n2.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add5n2
  store i32 1, i32* %idx5n2.ptr, align 4

  %add4n5 = add i64 %mul4n, 5
  %idx4n5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add4n5
  store i32 1, i32* %idx4n5.ptr, align 4

  %add5n4 = add i64 %mul5n, 4
  %idx5n4.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add5n4
  store i32 1, i32* %idx5n4.ptr, align 4

  %add5n6 = add i64 %mul5n, 6
  %idx5n6.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add5n6
  store i32 1, i32* %idx5n6.ptr, align 4

  %mul6n = mul i64 %n.val, 6
  %add6n5 = add i64 %mul6n, 5
  %idx6n5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %add6n5
  store i32 1, i32* %idx6n5.ptr, align 4

  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %src.call = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.base.i32, i64 %n.call, i64 %src.call, i32* %dist.base, i64* %order.base, i64* %order_len)

  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %src.print = load i64, i64* %src, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %src.print)

  store i64 0, i64* %i, align 8
  br label %loop_order

loop_order:                                       ; preds = %body_order, %entry
  %i.cur = phi i64 [ 0, %entry ], [ %i.next, %body_order ]
  %len.cur = load i64, i64* %order_len, align 8
  %cmp.i = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.i, label %body_order, label %after_order

body_order:                                       ; preds = %loop_order
  %i.plus1 = add i64 %i.cur, 1
  %len.again = load i64, i64* %order_len, align 8
  %cmp.sep = icmp ult i64 %i.plus1, %len.again
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.sel = select i1 %cmp.sep, i8* %space.ptr, i8* %empty.ptr
  %val.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %val.load = load i64, i64* %val.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val.load, i8* %sep.sel)
  %i.next = add i64 %i.cur, 1
  br label %loop_order

after_order:                                      ; preds = %loop_order
  %putc = call i32 @putchar(i32 10)

  store i64 0, i64* %j, align 8
  br label %loop_dist

loop_dist:                                        ; preds = %body_dist, %after_order
  %j.cur = phi i64 [ 0, %after_order ], [ %j.next, %body_dist ]
  %n.cur = load i64, i64* %n, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp.j, label %body_dist, label %ret

body_dist:                                        ; preds = %loop_dist
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %src.again = load i64, i64* %src, align 8
  %call.printf3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %src.again, i64 %j.cur, i32 %d.val)
  %j.next = add i64 %j.cur, 1
  br label %loop_dist

ret:                                              ; preds = %loop_dist
  ret i32 0
}