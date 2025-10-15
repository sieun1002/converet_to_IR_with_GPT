; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

@Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @sub_1400019C0()
declare void @sub_140001450(i32*, i64, i64, i8*, i64*, i64*)
declare i32 @sub_140002A40(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @sub_14000165D() {
entry:
  %adj = alloca [48 x i32], align 16
  %var28 = alloca i64, align 8
  %start = alloca i64, align 8
  %count = alloca i64, align 8
  %order = alloca [64 x i64], align 16
  %dist = alloca [8 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @sub_1400019C0()
  store i64 7, i64* %var28, align 8
  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %adj.i8, i8 0, i64 192, i1 false)
  %adj1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i32 1
  store i32 1, i32* %adj1, align 4
  %n0 = load i64, i64* %var28, align 8
  %adjn = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %n0
  store i32 1, i32* %adjn, align 4
  %adj2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i32 2
  store i32 1, i32* %adj2, align 4
  %mul2 = shl i64 %n0, 1
  %adj2n = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %mul2
  store i32 1, i32* %adj2n, align 4
  %addn3 = add i64 %n0, 3
  %adjn3 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %addn3
  store i32 1, i32* %adjn3, align 4
  %mul3 = mul i64 %n0, 3
  %add3n1 = add i64 %mul3, 1
  %adj3n1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add3n1
  store i32 1, i32* %adj3n1, align 4
  %addn4 = add i64 %n0, 4
  %adjn4 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %addn4
  store i32 1, i32* %adjn4, align 4
  %mul4 = shl i64 %n0, 2
  %add4n1 = add i64 %mul4, 1
  %adj4n1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add4n1
  store i32 1, i32* %adj4n1, align 4
  %add2n5 = add i64 %mul2, 5
  %adj2n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add2n5
  store i32 1, i32* %adj2n5, align 4
  %add5n2 = add i64 %mul4, %n0
  %add5n2b = add i64 %add5n2, 2
  %adj5n2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add5n2b
  store i32 1, i32* %adj5n2, align 4
  %add4n5 = add i64 %mul4, 5
  %adj4n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add4n5
  store i32 1, i32* %adj4n5, align 4
  %add5n4 = add i64 %mul4, %n0
  %add5n4b = add i64 %add5n4, 4
  %adj5n4 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add5n4b
  store i32 1, i32* %adj5n4, align 4
  %add5n6 = add i64 %mul4, %n0
  %add5n6b = add i64 %add5n6, 6
  %adj5n6 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add5n6b
  store i32 1, i32* %adj5n6, align 4
  %mul6 = mul i64 %n0, 6
  %add6n5 = add i64 %mul6, 5
  %adj6n5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i64 %add6n5
  store i32 1, i32* %adj6n5, align 4
  store i64 0, i64* %start, align 8
  store i64 0, i64* %count, align 8
  %adjptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i32 0
  %orderptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i32 0, i32 0
  %startv0 = load i64, i64* %start, align 8
  call void @sub_140001450(i32* nonnull %adjptr, i64 %n0, i64 %startv0, i8* null, i64* nonnull %count, i64* nonnull %orderptr)
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @Format, i32 0, i32 0
  %startv1 = load i64, i64* %start, align 8
  %call0 = call i32 (i8*, ...) @sub_140002A40(i8* nonnull %fmt0, i64 %startv1)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %cnt.cur = load i64, i64* %count, align 8
  %cmp1 = icmp ult i64 %i.cur, %cnt.cur
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                      ; preds = %loop1.cond
  %next = add i64 %i.cur, 1
  %space.cond = icmp ult i64 %next, %cnt.cur
  %sp.if = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i32 0, i32 0
  %sp.else = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i32 0, i32 0
  %sp.sel = select i1 %space.cond, i8* %sp.if, i8* %sp.else
  %node.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i32 0, i64 %i.cur
  %node.val = load i64, i64* %node.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i32 0, i32 0
  %call1 = call i32 (i8*, ...) @sub_140002A40(i8* nonnull %fmt1, i64 %node.val, i8* %sp.sel)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                       ; preds = %loop1.cond
  %nlcall = call i32 @putchar(i32 10)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %loop1.end
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %var28, align 8
  %cmp2 = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp2, label %loop2.body, label %exit

loop2.body:                                      ; preds = %loop2.cond
  %dist.ptr = getelementptr inbounds [8 x i32], [8 x i32]* %dist, i32 0, i64 %j.cur
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i32 0, i32 0
  %startv2 = load i64, i64* %start, align 8
  %call2 = call i32 (i8*, ...) @sub_140002A40(i8* nonnull %fmt2, i64 %startv2, i64 %j.cur, i32 %dist.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

exit:                                             ; preds = %loop2.cond
  ret i32 0
}