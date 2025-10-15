; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define dso_local i32 @main() {
entry:
  %adj = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %count = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var30 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var20 = alloca i64, align 8

  store i64 7, i64* %var28, align 8

  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %adj.i8, i8 0, i64 192, i1 false)

  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  store i32 0, i32* %adj.base, align 4

  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1.ptr, align 4
  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  %n = load i64, i64* %var28, align 8

  %i0 = add i64 %n, 0
  %p0 = getelementptr inbounds i32, i32* %adj.base, i64 %i0
  store i32 1, i32* %p0, align 4

  %i1 = shl i64 %n, 1
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 %i1
  store i32 1, i32* %p1, align 4

  %i2 = add i64 %n, 3
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 %i2
  store i32 1, i32* %p2, align 4

  %t3 = add i64 %i1, %n           ; 3*n
  %i3 = add i64 %t3, 1            ; 3*n + 1
  %p3 = getelementptr inbounds i32, i32* %adj.base, i64 %i3
  store i32 1, i32* %p3, align 4

  %i4 = add i64 %n, 4
  %p4 = getelementptr inbounds i32, i32* %adj.base, i64 %i4
  store i32 1, i32* %p4, align 4

  %t5 = shl i64 %n, 2              ; 4*n
  %i5 = add i64 %t5, 1             ; 4*n + 1
  %p5 = getelementptr inbounds i32, i32* %adj.base, i64 %i5
  store i32 1, i32* %p5, align 4

  %i6 = add i64 %i1, 5             ; 2*n + 5
  %p6 = getelementptr inbounds i32, i32* %adj.base, i64 %i6
  store i32 1, i32* %p6, align 4

  %t7 = add i64 %t5, %n            ; 5*n
  %i7 = add i64 %t7, 2             ; 5*n + 2
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 %i7
  store i32 1, i32* %p7, align 4

  %i8 = add i64 %t5, 5             ; 4*n + 5
  %p8 = getelementptr inbounds i32, i32* %adj.base, i64 %i8
  store i32 1, i32* %p8, align 4

  %i9 = add i64 %t7, 4             ; 5*n + 4
  %p9 = getelementptr inbounds i32, i32* %adj.base, i64 %i9
  store i32 1, i32* %p9, align 4

  %i10 = add i64 %t7, 6            ; 5*n + 6
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 %i10
  store i32 1, i32* %p10, align 4

  %t11a = add i64 %i1, %n          ; 3*n
  %t11b = shl i64 %t11a, 1         ; 6*n
  %i11 = add i64 %t11b, 5          ; 6*n + 5
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 %i11
  store i32 1, i32* %p11, align 4

  store i64 0, i64* %var30, align 8
  store i64 0, i64* %count, align 8

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0

  %src0 = load i64, i64* %var30, align 8
  call void @bfs(i32* noundef %adj.base, i64 noundef %n, i64 noundef %src0, i32* noundef %dist.base, i64* noundef %count, i64* noundef %order.base)

  %src1 = load i64, i64* %var30, align 8
  %fmt.bfs = bitcast [21 x i8]* @.str.bfs to i8*
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* noundef %fmt.bfs, i64 noundef %src1)

  store i64 0, i64* %var18, align 8
  br label %loop.print

loop.print:
  %i = load i64, i64* %var18, align 8
  %cnt = load i64, i64* %count, align 8
  %i.next = add i64 %i, 1
  %cmp.more = icmp ult i64 %i.next, %cnt
  %sep.ptr = select i1 %cmp.more, i8* bitcast ([2 x i8]* @.str.sep to i8*), i8* bitcast ([1 x i8]* @.str.empty to i8*)
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt.zus = bitcast [6 x i8]* @.str.zus to i8*
  %call.printf.seq = call i32 (i8*, ...) @printf(i8* noundef %fmt.zus, i64 noundef %ord.val, i8* noundef %sep.ptr)
  %i.inc = add i64 %i, 1
  store i64 %i.inc, i64* %var18, align 8
  %cnt2 = load i64, i64* %count, align 8
  %cont = icmp ult i64 %i.inc, %cnt2
  br i1 %cont, label %loop.print, label %after.seq

after.seq:
  %call.putchar = call i32 @putchar(i32 noundef 10)

  store i64 0, i64* %var20, align 8
  br label %loop.dist

loop.dist:
  %j = load i64, i64* %var20, align 8
  %cond = icmp ult i64 %j, %n
  br i1 %cond, label %body.dist, label %ret

body.dist:
  %dptr = getelementptr inbounds i32, i32* %dist.base, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %src2 = load i64, i64* %var30, align 8
  %fmt.dist = bitcast [23 x i8]* @.str.dist to i8*
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* noundef %fmt.dist, i64 noundef %src2, i64 noundef %j, i32 noundef %dval)
  %j.inc = add i64 %j, 1
  store i64 %j.inc, i64* %var20, align 8
  br label %loop.dist

ret:
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)