; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)

@.str.bfs_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist_fmt = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  br label %zero.loop

zero.loop:
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %z.cmp = icmp ult i64 %zi, 49
  br i1 %z.cmp, label %zero.body, label %zero.done

zero.body:
  %z.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %zi
  store i32 0, i32* %z.ptr, align 4
  %zi.next = add nuw nsw i64 %zi, 1
  br label %zero.loop

zero.done:
  store i64 0, i64* %order_len, align 8
  %idx1 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx9, align 4
  %idx10 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx10, align 4
  %idx11 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx11, align 4
  %idx12 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx12, align 4
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs_hdr, i64 0, i64 0
  %hdr.call = call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)
  br label %order.loop

order.loop:
  %i = phi i64 [ 0, %zero.done ], [ %i.next, %order.inc ]
  %len.cur = load i64, i64* %order_len, align 8
  %cmp.i = icmp ult i64 %i, %len.cur
  br i1 %cmp.i, label %order.body, label %order.done

order.body:
  %i.plus1 = add nuw nsw i64 %i, 1
  %len.cur2 = load i64, i64* %order_len, align 8
  %has.more = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.more, i8* %space.ptr, i8* %empty.ptr
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.sep_fmt, i64 0, i64 0
  %print.sep = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %ord.val, i8* %sep.ptr)
  br label %order.inc

order.inc:
  %i.next = add nuw nsw i64 %i, 1
  br label %order.loop

order.done:
  %nl = call i32 @putchar(i32 10)
  br label %dist.loop

dist.loop:
  %v = phi i64 [ 0, %order.done ], [ %v.next, %dist.inc ]
  %cmp.v = icmp ult i64 %v, 7
  br i1 %cmp.v, label %dist.body, label %done

dist.body:
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist_fmt, i64 0, i64 0
  %print.dist = call i32 (i8*, ...) @printf(i8* %fmt3, i64 0, i64 %v, i32 %d.val)
  br label %dist.inc

dist.inc:
  %v.next = add nuw nsw i64 %v, 1
  br label %dist.loop

done:
  ret i32 0
}