; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i8*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %var20 = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %var20, align 8

  %adj.base.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj.base.i8 = bitcast i32* %adj.base.i32 to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.base.i8, i8 0, i64 192, i1 false)

  store i32 0, i32* %adj.base.i32, align 4

  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 1
  store i32 1, i32* %idx1.ptr, align 4

  %n.load.0 = load i64, i64* %var20, align 8
  %idx.n.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %n.load.0
  store i32 1, i32* %idx.n.ptr, align 4

  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  %n.load.1 = load i64, i64* %var20, align 8
  %two.n = shl i64 %n.load.1, 1
  %idx.2n.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %two.n
  store i32 1, i32* %idx.2n.ptr, align 4

  %n.load.2 = load i64, i64* %var20, align 8
  %n.plus3 = add i64 %n.load.2, 3
  %idx.n.plus3.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %n.plus3
  store i32 1, i32* %idx.n.plus3.ptr, align 4

  %n.load.3 = load i64, i64* %var20, align 8
  %t.2n.0 = add i64 %n.load.3, %n.load.3
  %t.3n.0 = add i64 %t.2n.0, %n.load.3
  %t.3n.plus1 = add i64 %t.3n.0, 1
  %idx.3n.plus1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.3n.plus1
  store i32 1, i32* %idx.3n.plus1.ptr, align 4

  %n.load.4 = load i64, i64* %var20, align 8
  %n.plus4 = add i64 %n.load.4, 4
  %idx.n.plus4.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %n.plus4
  store i32 1, i32* %idx.n.plus4.ptr, align 4

  %n.load.5 = load i64, i64* %var20, align 8
  %t.4n.0 = shl i64 %n.load.5, 2
  %t.4n.plus1 = add i64 %t.4n.0, 1
  %idx.4n.plus1.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.4n.plus1
  store i32 1, i32* %idx.4n.plus1.ptr, align 4

  %n.load.6 = load i64, i64* %var20, align 8
  %t.2n.1 = add i64 %n.load.6, %n.load.6
  %t.2n.plus5 = add i64 %t.2n.1, 5
  %idx.2n.plus5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.2n.plus5
  store i32 1, i32* %idx.2n.plus5.ptr, align 4

  %n.load.7 = load i64, i64* %var20, align 8
  %t.4n.1 = shl i64 %n.load.7, 2
  %t.5n.0 = add i64 %t.4n.1, %n.load.7
  %t.5n.plus2 = add i64 %t.5n.0, 2
  %idx.5n.plus2.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.5n.plus2
  store i32 1, i32* %idx.5n.plus2.ptr, align 4

  %n.load.8 = load i64, i64* %var20, align 8
  %t.4n.2 = shl i64 %n.load.8, 2
  %t.4n.plus5 = add i64 %t.4n.2, 5
  %idx.4n.plus5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.4n.plus5
  store i32 1, i32* %idx.4n.plus5.ptr, align 4

  %n.load.9 = load i64, i64* %var20, align 8
  %t.4n.3 = shl i64 %n.load.9, 2
  %t.5n.1 = add i64 %t.4n.3, %n.load.9
  %t.5n.plus4 = add i64 %t.5n.1, 4
  %idx.5n.plus4.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.5n.plus4
  store i32 1, i32* %idx.5n.plus4.ptr, align 4

  %n.load.10 = load i64, i64* %var20, align 8
  %t.4n.4 = shl i64 %n.load.10, 2
  %t.5n.2 = add i64 %t.4n.4, %n.load.10
  %t.5n.plus6 = add i64 %t.5n.2, 6
  %idx.5n.plus6.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.5n.plus6
  store i32 1, i32* %idx.5n.plus6.ptr, align 4

  %n.load.11 = load i64, i64* %var20, align 8
  %t.2n.2 = add i64 %n.load.11, %n.load.11
  %t.3n.1 = add i64 %t.2n.2, %n.load.11
  %t.6n.0 = add i64 %t.3n.1, %t.3n.1
  %t.6n.plus5 = add i64 %t.6n.0, 5
  %idx.6n.plus5.ptr = getelementptr inbounds i32, i32* %adj.base.i32, i64 %t.6n.plus5
  store i32 1, i32* %idx.6n.plus5.ptr, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %adj.bytes = bitcast i32* %adj.base.i32 to i8*
  %n.call = load i64, i64* %var20, align 8
  %start.call = load i64, i64* %start, align 8
  %out.base = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i8* %adj.bytes, i64 %n.call, i64 %start.call, i64* %out.base, i64* %out_len)

  %fmt.hdr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.printf.hdr = call i32 (i8*, ...) @printf(i8* %fmt.hdr, i64 %start.print)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %len.cur = load i64, i64* %out_len, align 8
  %i.cur = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %body, label %after

body:
  %i.cur.2 = load i64, i64* %i, align 8
  %i.plus1 = add i64 %i.cur.2, 1
  %len.cur.2 = load i64, i64* %out_len, align 8
  %has.space = icmp ult i64 %i.plus1, %len.cur.2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  %suffix.sel = select i1 %has.space, i8* %space.ptr, i8* %empty.ptr

  %i.load.for.out = load i64, i64* %i, align 8
  %out.elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.load.for.out
  %out.val = load i64, i64* %out.elem.ptr, align 8

  %fmt.loop = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf.loop = call i32 (i8*, ...) @printf(i8* %fmt.loop, i64 %out.val, i8* %suffix.sel)

  %i.next = load i64, i64* %i, align 8
  %i.inc = add i64 %i.next, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop

after:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}