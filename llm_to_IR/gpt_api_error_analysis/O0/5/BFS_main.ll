; ModuleID = 'bfs_main'
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.item   = private unnamed_addr constant [5 x i8]  c"%zu%s\00", align 1
@.str.dist   = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str.space  = private unnamed_addr constant [2 x i8]  c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8]  c"\00", align 1

declare void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %outCount)
declare i32 @printf(i8* %fmt, ...)
declare i32 @putchar(i32 %c)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %outCount = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %outCount, align 8

  %adj.bytes = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bytes, i8 0, i64 196, i1 false)

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8

  call void @bfs(i32* %adj.base, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %order.base, i64* %outCount)

  %fmt.header = getelementptr inbounds [21 x i8], [21 x i8]* @.str.header, i64 0, i64 0
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.header, i64 %start.val)

  br label %order.loop

order.loop:                                           ; i in [0, outCount)
  %i = phi i64 [ 0, %entry ], [ %i.next, %order.body.end ]
  %len0 = load i64, i64* %outCount, align 8
  %cmp.i = icmp ult i64 %i, %len0
  br i1 %cmp.i, label %order.body, label %order.done

order.body:
  %i.plus1 = add i64 %i, 1
  %len1 = load i64, i64* %outCount, align 8
  %has.next = icmp ult i64 %i.plus1, %len1
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %has.next, i8* %space.ptr, i8* %empty.ptr
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt.item = getelementptr inbounds [5 x i8], [5 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item, i64 %ord.val, i8* %sep.ptr)
  %i.next = add i64 %i, 1
  br label %order.body.end

order.body.end:
  br label %order.loop

order.done:
  %call.putchar = call i32 @putchar(i32 10)

  br label %dist.loop

dist.loop:                                            ; j in [0, n)
  %j = phi i64 [ 0, %order.done ], [ %j.next, %dist.body.end ]
  %n.cur = load i64, i64* %n, align 8
  %cmp.j = icmp ult i64 %j, %n.cur
  br i1 %cmp.j, label %dist.body, label %ret.block

dist.body:
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %start.val, i64 %j, i32 %d.val)
  %j.next = add i64 %j, 1
  br label %dist.body.end

dist.body.end:
  br label %dist.loop

ret.block:
  ret i32 0
}