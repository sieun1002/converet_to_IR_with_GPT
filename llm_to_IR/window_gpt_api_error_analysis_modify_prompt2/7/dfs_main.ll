; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00"
@unk_14000401A = private unnamed_addr constant [1 x i8] c"\00"

declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %outLen = alloca i64, align 8
  %outArr = alloca [7 x i64], align 16
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %adj.bc = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.bc, i8 0, i64 196, i1 false)

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0

  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1.ptr, align 4

  %n.val0 = load i64, i64* %n, align 8
  %idxn.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %n.val0
  store i32 1, i32* %idxn.ptr, align 4

  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2.ptr, align 4

  %n.val1 = load i64, i64* %n, align 8
  %mul2 = shl i64 %n.val1, 1
  %idx2n.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %mul2
  store i32 1, i32* %idx2n.ptr, align 4

  %n.val2 = load i64, i64* %n, align 8
  %addn3 = add i64 %n.val2, 3
  %idxn3.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %addn3
  store i32 1, i32* %idxn3.ptr, align 4

  %n.val3 = load i64, i64* %n, align 8
  %t1 = add i64 %n.val3, %n.val3
  %t2 = add i64 %t1, %n.val3
  %t3 = add i64 %t2, 1
  %idx3n1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %t3
  store i32 1, i32* %idx3n1.ptr, align 4

  %n.val4 = load i64, i64* %n, align 8
  %addn4 = add i64 %n.val4, 4
  %idxn4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %addn4
  store i32 1, i32* %idxn4.ptr, align 4

  %n.val5 = load i64, i64* %n, align 8
  %mul4 = shl i64 %n.val5, 2
  %add4n1 = add i64 %mul4, 1
  %idx4n1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add4n1
  store i32 1, i32* %idx4n1.ptr, align 4

  %n.val6 = load i64, i64* %n, align 8
  %twon = add i64 %n.val6, %n.val6
  %add2n5 = add i64 %twon, 5
  %idx2n5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add2n5
  store i32 1, i32* %idx2n5.ptr, align 4

  %n.val7 = load i64, i64* %n, align 8
  %mul4b = shl i64 %n.val7, 2
  %add5n2a = add i64 %mul4b, %n.val7
  %add5n2 = add i64 %add5n2a, 2
  %idx5n2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add5n2
  store i32 1, i32* %idx5n2.ptr, align 4

  %n.val8 = load i64, i64* %n, align 8
  %mul4c = shl i64 %n.val8, 2
  %add4n5 = add i64 %mul4c, 5
  %idx4n5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add4n5
  store i32 1, i32* %idx4n5.ptr, align 4

  %n.val9 = load i64, i64* %n, align 8
  %mul4d = shl i64 %n.val9, 2
  %add5n4a = add i64 %mul4d, %n.val9
  %add5n4 = add i64 %add5n4a, 4
  %idx5n4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add5n4
  store i32 1, i32* %idx5n4.ptr, align 4

  %n.val10 = load i64, i64* %n, align 8
  %mul4e = shl i64 %n.val10, 2
  %add5n6a = add i64 %mul4e, %n.val10
  %add5n6 = add i64 %add5n6a, 6
  %idx5n6.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %add5n6
  store i32 1, i32* %idx5n6.ptr, align 4

  %n.val11 = load i64, i64* %n, align 8
  %d1 = add i64 %n.val11, %n.val11
  %d2 = add i64 %d1, %n.val11
  %d3 = add i64 %d2, %d2
  %d4 = add i64 %d3, 5
  %idx6n5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %d4
  store i32 1, i32* %idx6n5.ptr, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %outLen, align 8

  %n.load = load i64, i64* %n, align 8
  %start.load = load i64, i64* %start, align 8
  %outArr.base = getelementptr inbounds [7 x i64], [7 x i64]* %outArr, i64 0, i64 0
  call void @dfs(i32* %adj.base, i64 %n.load, i64 %start.load, i64* %outArr.base, i64* %outLen)

  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %ph0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.print)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %outLen, align 8
  %cmp.loop = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.loop, label %loop.body, label %loop.end

loop.body:
  %i.nextc = add i64 %i.cur, 1
  %len.c2 = load i64, i64* %outLen, align 8
  %has.more = icmp ult i64 %i.nextc, %len.c2
  br i1 %has.more, label %sep.space, label %sep.empty

sep.space:
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  br label %sep.join

sep.empty:
  %em.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  br label %sep.join

sep.join:
  %sep.sel = phi i8* [ %sp.ptr, %sep.space ], [ %em.ptr, %sep.empty ]
  %out.base2 = getelementptr inbounds [7 x i64], [7 x i64]* %outArr, i64 0, i64 0
  %elt.ptr = getelementptr inbounds i64, i64* %out.base2, i64 %i.cur
  %elt.val = load i64, i64* %elt.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %ph1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %elt.val, i8* %sep.sel)
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}