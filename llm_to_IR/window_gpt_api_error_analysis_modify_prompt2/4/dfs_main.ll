; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = dso_local constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = dso_local constant [6 x i8] c"%zu%s\00", align 1
@asc_140004018 = dso_local constant [2 x i8] c" \00", align 1
@unk_14000401A = dso_local constant [1 x i8] c"\00", align 1

declare void @dfs(i8*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %arr = alloca [48 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %outlen = alloca i64, align 8
  %outvec = alloca [8 x i64], align 16
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  %arr.i8 = bitcast [48 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.i8, i8 0, i64 192, i1 false)

  %arr0ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  store i32 0, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 2
  store i32 1, i32* %arr2ptr, align 4

  %nval = load i64, i64* %n, align 8

  %idx1 = add i64 %nval, 0
  %p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx1
  store i32 1, i32* %p1, align 4

  %mul2 = shl i64 %nval, 1
  %p2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %mul2
  store i32 1, i32* %p2, align 4

  %idx3 = add i64 %nval, 3
  %p3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx3
  store i32 1, i32* %p3, align 4

  %t31 = add i64 %mul2, %nval
  %idx4 = add i64 %t31, 1
  %p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx4
  store i32 1, i32* %p4, align 4

  %idx5 = add i64 %nval, 4
  %p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx5
  store i32 1, i32* %p5, align 4

  %mul4 = shl i64 %nval, 2
  %idx6 = add i64 %mul4, 1
  %p6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx6
  store i32 1, i32* %p6, align 4

  %idx7 = add i64 %mul2, 5
  %p7 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx7
  store i32 1, i32* %p7, align 4

  %mul5 = add i64 %mul4, %nval
  %idx8 = add i64 %mul5, 2
  %p8 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx8
  store i32 1, i32* %p8, align 4

  %idx9 = add i64 %mul4, 5
  %p9 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx9
  store i32 1, i32* %p9, align 4

  %idx10 = add i64 %mul5, 4
  %p10 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx10
  store i32 1, i32* %p10, align 4

  %idx11 = add i64 %mul5, 6
  %p11 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx11
  store i32 1, i32* %p11, align 4

  %mul3 = add i64 %mul2, %nval
  %mul6 = add i64 %mul3, %mul3
  %idx12 = add i64 %mul6, 5
  %p12 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %idx12
  store i32 1, i32* %p12, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %outlen, align 8

  %base = bitcast [48 x i32]* %arr to i8*
  %startval = load i64, i64* %start, align 8
  %outvec.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %outvec, i64 0, i64 0
  call void @dfs(i8* %base, i64 %nval, i64 %startval, i64* %outvec.ptr, i64* %outlen)

  %fmtptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %startval2 = load i64, i64* %start, align 8
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %startval2)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %outlen, align 8
  %lt = icmp ult i64 %i.cur, %len.cur
  br i1 %lt, label %loop.body, label %loop.end

loop.body:
  %ip1 = add i64 %i.cur, 1
  %len.cur2 = load i64, i64* %outlen, align 8
  %ge = icmp uge i64 %ip1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  %sep = select i1 %ge, i8* %empty.ptr, i8* %space.ptr

  %elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %outvec, i64 0, i64 %i.cur
  %elem = load i64, i64* %elem.ptr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elem, i8* %sep)

  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}