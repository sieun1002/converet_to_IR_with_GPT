; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dijkstra(i32*, i64, i64, i32*, i32*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %dest = alloca i64, align 8
  %matrix = alloca [36 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %pred = alloca [6 x i32], align 16
  %path = alloca [6 x i64], align 16
  %i.var = alloca i64, align 8
  %j.var = alloca i64, align 8
  %count = alloca i64, align 8
  %cur = alloca i32, align 4
  %idx = alloca i64, align 8
  %node = alloca i64, align 8
  store i64 6, i64* %n, align 8
  store i64 0, i64* %src, align 8
  br label %fill.cond

fill.cond:
  %i.ph = phi i64 [ 0, %entry ], [ %i.next, %fill.body ]
  %n.load = load i64, i64* %n, align 8
  %n.mul = mul i64 %n.load, %n.load
  %fill.cmp = icmp ult i64 %i.ph, %n.mul
  br i1 %fill.cmp, label %fill.body, label %fill.end

fill.body:
  %mat.elem.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %i.ph
  store i32 -1, i32* %mat.elem.ptr, align 4
  %i.next = add i64 %i.ph, 1
  br label %fill.cond

fill.end:
  br label %diag.cond

diag.cond:
  %j.ph = phi i64 [ 0, %fill.end ], [ %j.next, %diag.body ]
  %n.load2 = load i64, i64* %n, align 8
  %diag.cmp = icmp ult i64 %j.ph, %n.load2
  br i1 %diag.cmp, label %diag.body, label %after.diag

diag.body:
  %n.plus1 = add i64 %n.load2, 1
  %diag.idx = mul i64 %n.plus1, %j.ph
  %diag.elem.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %diag.idx
  store i32 0, i32* %diag.elem.ptr, align 4
  %j.next = add i64 %j.ph, 1
  br label %diag.cond

after.diag:
  %n.load3 = load i64, i64* %n, align 8
  %idx.n = add i64 %n.load3, 0
  %ptr.n = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.n
  store i32 7, i32* %ptr.n, align 4
  %idx.2n = shl i64 %n.load3, 1
  %ptr.2n = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.2n
  store i32 9, i32* %ptr.2n, align 4
  %idx.3n.tmp = add i64 %n.load3, %n.load3
  %idx.3n = add i64 %idx.3n.tmp, %n.load3
  %ptr.3n = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.3n
  store i32 10, i32* %ptr.3n, align 4
  %idx.np3 = add i64 %n.load3, 3
  %ptr.np3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.np3
  store i32 15, i32* %ptr.np3, align 4
  %idx.3n1 = add i64 %idx.3n, 1
  %ptr.3n1 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.3n1
  store i32 15, i32* %ptr.3n1, align 4
  %idx.2n3 = add i64 %idx.2n, 3
  %ptr.2n3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.2n3
  store i32 11, i32* %ptr.2n3, align 4
  %idx.3n2 = add i64 %idx.3n, 2
  %ptr.3n2 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.3n2
  store i32 11, i32* %ptr.3n2, align 4
  %idx.3n4 = add i64 %idx.3n, 4
  %ptr.3n4 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.3n4
  store i32 6, i32* %ptr.3n4, align 4
  %idx.4n = shl i64 %n.load3, 2
  %idx.4n3 = add i64 %idx.4n, 3
  %ptr.4n3 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.4n3
  store i32 6, i32* %ptr.4n3, align 4
  %idx.4n5 = add i64 %idx.4n, 5
  %ptr.4n5 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.4n5
  store i32 9, i32* %ptr.4n5, align 4
  %idx.5n.tmp = add i64 %idx.4n, %n.load3
  %idx.5n4 = add i64 %idx.5n.tmp, 4
  %ptr.5n4 = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 %idx.5n4
  store i32 9, i32* %ptr.5n4, align 4
  store i64 0, i64* %src, align 8
  %mat.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %matrix, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %pred.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %pred, i64 0, i64 0
  %n.load4 = load i64, i64* %n, align 8
  %src.load = load i64, i64* %src, align 8
  call void @dijkstra(i32* %mat.ptr, i64 %n.load4, i64 %src.load, i32* %dist.ptr, i32* %pred.ptr)
  br label %print.cond

print.cond:
  %t.ph = phi i64 [ 0, %after.diag ], [ %t.next, %print.end ]
  %n.load5 = load i64, i64* %n, align 8
  %print.cmp = icmp ult i64 %t.ph, %n.load5
  br i1 %print.cmp, label %print.body, label %after.print

print.body:
  %dist.elem.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %t.ph
  %dist.val = load i32, i32* %dist.elem.ptr, align 4
  %inf.cmp = icmp sle i32 %dist.val, 1061109566
  br i1 %inf.cmp, label %print.finite, label %print.inf

print.inf:
  %fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %src.load6 = load i64, i64* %src, align 8
  %t.ext = add i64 %t.ph, 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i64 %src.load6, i64 %t.ext)
  br label %print.end

print.finite:
  %fmt.fin.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src.load7 = load i64, i64* %src, align 8
  %t.ext2 = add i64 %t.ph, 0
  %call.fin = call i32 (i8*, ...) @printf(i8* %fmt.fin.ptr, i64 %src.load7, i64 %t.ext2, i32 %dist.val)
  br label %print.end

print.end:
  %t.next = add i64 %t.ph, 1
  br label %print.cond

after.print:
  store i64 5, i64* %dest, align 8
  %dest.load = load i64, i64* %dest, align 8
  %dist.dest.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dest.load
  %dist.dest.val = load i32, i32* %dist.dest.ptr, align 4
  %dest.fin.cmp = icmp sle i32 %dist.dest.val, 1061109566
  br i1 %dest.fin.cmp, label %have.path, label %no.path

no.path:
  %fmt.nopath.ptr = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %src.load8 = load i64, i64* %src, align 8
  %dest.load2 = load i64, i64* %dest, align 8
  %call.nopath = call i32 (i8*, ...) @printf(i8* %fmt.nopath.ptr, i64 %src.load8, i64 %dest.load2)
  br label %ret

have.path:
  store i64 0, i64* %count, align 8
  %dest.load3 = load i64, i64* %dest, align 8
  %dest.trunc = trunc i64 %dest.load3 to i32
  store i32 %dest.trunc, i32* %cur, align 4
  br label %build.cond

build.cond:
  %count.load = load i64, i64* %count, align 8
  %cur.load = load i32, i32* %cur, align 4
  %cur.cmp = icmp ne i32 %cur.load, -1
  br i1 %cur.cmp, label %build.body, label %build.end

build.body:
  %count.next = add i64 %count.load, 1
  store i64 %count.next, i64* %count, align 8
  %cur.sext = sext i32 %cur.load to i64
  %path.slot = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %count.load
  store i64 %cur.sext, i64* %path.slot, align 8
  %cur.idx = sext i32 %cur.load to i64
  %pred.elem.ptr2 = getelementptr inbounds [6 x i32], [6 x i32]* %pred, i64 0, i64 %cur.idx
  %pred.val = load i32, i32* %pred.elem.ptr2, align 4
  store i32 %pred.val, i32* %cur, align 4
  br label %build.cond

build.end:
  %fmt.path.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %src.load9 = load i64, i64* %src, align 8
  %dest.load4 = load i64, i64* %dest, align 8
  %call.pathhdr = call i32 (i8*, ...) @printf(i8* %fmt.path.ptr, i64 %src.load9, i64 %dest.load4)
  store i64 0, i64* %idx, align 8
  br label %printpath.cond

printpath.cond:
  %idx.load = load i64, i64* %idx, align 8
  %count.load2 = load i64, i64* %count, align 8
  %pp.cmp = icmp ult i64 %idx.load, %count.load2
  br i1 %pp.cmp, label %printpath.body, label %printpath.end

printpath.body:
  %tmp1 = sub i64 %count.load2, %idx.load
  %pos = add i64 %tmp1, -1
  %node.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %pos
  %node.val = load i64, i64* %node.ptr, align 8
  store i64 %node.val, i64* %node, align 8
  %idx.plus1 = add i64 %idx.load, 1
  %cmp.more = icmp ult i64 %idx.plus1, %count.load2
  br i1 %cmp.more, label %suffix.arrow, label %suffix.empty

suffix.arrow:
  %arrow.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %suffix.join

suffix.empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %suffix.join

suffix.join:
  %suffix.phi = phi i8* [ %arrow.ptr, %suffix.arrow ], [ %empty.ptr, %suffix.empty ]
  %fmt.node.ptr = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node.load = load i64, i64* %node, align 8
  %call.node = call i32 (i8*, ...) @printf(i8* %fmt.node.ptr, i64 %node.load, i8* %suffix.phi)
  %idx.next = add i64 %idx.load, 1
  store i64 %idx.next, i64* %idx, align 8
  br label %printpath.cond

printpath.end:
  %nl = call i32 @putchar(i32 10)
  br label %ret

ret:
  ret i32 0
}