; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @__main()
declare void @dfs(i8*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [48 x i32], align 16
  %var20 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %outLen = alloca i64, align 8
  %outArr = alloca [8 x i64], align 16
  %var18 = alloca i64, align 8
  call void @__main()
  store i64 7, i64* %var20, align 8
  %arr.gep0 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  store i32 0, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 1
  store i32 0, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 3
  store i32 0, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 4
  store i32 0, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 5
  store i32 0, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 6
  store i32 0, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 7
  store i32 0, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 8
  store i32 0, i32* %arr.gep8, align 4
  %arr.gep9 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.gep9, align 4
  %arr.gep10 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 10
  store i32 0, i32* %arr.gep10, align 4
  %arr.gep11 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 11
  store i32 0, i32* %arr.gep11, align 4
  %arr.gep12 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 12
  store i32 0, i32* %arr.gep12, align 4
  %arr.gep13 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 13
  store i32 0, i32* %arr.gep13, align 4
  %arr.gep14 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 14
  store i32 0, i32* %arr.gep14, align 4
  %arr.gep15 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 15
  store i32 0, i32* %arr.gep15, align 4
  %arr.gep16 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 16
  store i32 0, i32* %arr.gep16, align 4
  %arr.gep17 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 17
  store i32 0, i32* %arr.gep17, align 4
  %arr.gep18 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 18
  store i32 0, i32* %arr.gep18, align 4
  %arr.gep19 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 19
  store i32 0, i32* %arr.gep19, align 4
  %arr.gep20 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 20
  store i32 0, i32* %arr.gep20, align 4
  %arr.gep21 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 21
  store i32 0, i32* %arr.gep21, align 4
  %arr.gep22 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 22
  store i32 0, i32* %arr.gep22, align 4
  %arr.gep23 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 23
  store i32 0, i32* %arr.gep23, align 4
  %arr.gep24 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 24
  store i32 0, i32* %arr.gep24, align 4
  %arr.gep25 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 25
  store i32 0, i32* %arr.gep25, align 4
  %arr.gep26 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 26
  store i32 0, i32* %arr.gep26, align 4
  %arr.gep27 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 27
  store i32 0, i32* %arr.gep27, align 4
  %arr.gep28 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 28
  store i32 0, i32* %arr.gep28, align 4
  %arr.gep29 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 29
  store i32 0, i32* %arr.gep29, align 4
  %arr.gep30 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 30
  store i32 0, i32* %arr.gep30, align 4
  %arr.gep31 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 31
  store i32 0, i32* %arr.gep31, align 4
  %arr.gep32 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 32
  store i32 0, i32* %arr.gep32, align 4
  %arr.gep33 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 33
  store i32 0, i32* %arr.gep33, align 4
  %arr.gep34 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 34
  store i32 0, i32* %arr.gep34, align 4
  %arr.gep35 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 35
  store i32 0, i32* %arr.gep35, align 4
  %arr.gep36 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 36
  store i32 0, i32* %arr.gep36, align 4
  %arr.gep37 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 37
  store i32 0, i32* %arr.gep37, align 4
  %arr.gep38 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 38
  store i32 0, i32* %arr.gep38, align 4
  %arr.gep39 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 39
  store i32 0, i32* %arr.gep39, align 4
  %arr.gep40 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 40
  store i32 0, i32* %arr.gep40, align 4
  %arr.gep41 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 41
  store i32 0, i32* %arr.gep41, align 4
  %arr.gep42 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 42
  store i32 0, i32* %arr.gep42, align 4
  %arr.gep43 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 43
  store i32 0, i32* %arr.gep43, align 4
  %arr.gep44 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 44
  store i32 0, i32* %arr.gep44, align 4
  %arr.gep45 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 45
  store i32 0, i32* %arr.gep45, align 4
  %arr.gep46 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 46
  store i32 0, i32* %arr.gep46, align 4
  %arr.gep47 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 47
  store i32 0, i32* %arr.gep47, align 4
  store i32 1, i32* %arr.gep1, align 4
  %N.ld0 = load i64, i64* %var20, align 8
  %arr.idxN0 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %N.ld0
  store i32 1, i32* %arr.idxN0, align 4
  store i32 1, i32* %arr.gep2, align 4
  %N.ld1 = load i64, i64* %var20, align 8
  %mul2 = shl i64 %N.ld1, 1
  %arr.idx2N = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %mul2
  store i32 1, i32* %arr.idx2N, align 4
  %N.ld2 = load i64, i64* %var20, align 8
  %addN3 = add i64 %N.ld2, 3
  %arr.idxNplus3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %addN3
  store i32 1, i32* %arr.idxNplus3, align 4
  %N.ld3 = load i64, i64* %var20, align 8
  %twiceN3 = shl i64 %N.ld3, 1
  %threeN = add i64 %twiceN3, %N.ld3
  %threeNplus1 = add i64 %threeN, 1
  %arr.idx3Nplus1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %threeNplus1
  store i32 1, i32* %arr.idx3Nplus1, align 4
  %N.ld4 = load i64, i64* %var20, align 8
  %addN4 = add i64 %N.ld4, 4
  %arr.idxNplus4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %addN4
  store i32 1, i32* %arr.idxNplus4, align 4
  %N.ld5 = load i64, i64* %var20, align 8
  %fourN = shl i64 %N.ld5, 2
  %fourNplus1 = add i64 %fourN, 1
  %arr.idx4Nplus1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %fourNplus1
  store i32 1, i32* %arr.idx4Nplus1, align 4
  %N.ld6 = load i64, i64* %var20, align 8
  %twoN6 = shl i64 %N.ld6, 1
  %twoNplus5 = add i64 %twoN6, 5
  %arr.idx2Nplus5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %twoNplus5
  store i32 1, i32* %arr.idx2Nplus5, align 4
  %N.ld7 = load i64, i64* %var20, align 8
  %fourN7 = shl i64 %N.ld7, 2
  %fiveN = add i64 %fourN7, %N.ld7
  %fiveNplus2 = add i64 %fiveN, 2
  %arr.idx5Nplus2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %fiveNplus2
  store i32 1, i32* %arr.idx5Nplus2, align 4
  %N.ld8 = load i64, i64* %var20, align 8
  %fourN8 = shl i64 %N.ld8, 2
  %fourNplus5 = add i64 %fourN8, 5
  %arr.idx4Nplus5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %fourNplus5
  store i32 1, i32* %arr.idx4Nplus5, align 4
  %N.ld9 = load i64, i64* %var20, align 8
  %fourN9 = shl i64 %N.ld9, 2
  %fiveN9 = add i64 %fourN9, %N.ld9
  %fiveNplus4 = add i64 %fiveN9, 4
  %arr.idx5Nplus4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %fiveNplus4
  store i32 1, i32* %arr.idx5Nplus4, align 4
  %N.ld10 = load i64, i64* %var20, align 8
  %fourN10 = shl i64 %N.ld10, 2
  %fiveN10 = add i64 %fourN10, %N.ld10
  %fiveNplus6 = add i64 %fiveN10, 6
  %arr.idx5Nplus6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %fiveNplus6
  store i32 1, i32* %arr.idx5Nplus6, align 4
  %N.ld11 = load i64, i64* %var20, align 8
  %twiceN11 = shl i64 %N.ld11, 1
  %threeN11 = add i64 %twiceN11, %N.ld11
  %sixN = shl i64 %threeN11, 1
  %sixNplus5 = add i64 %sixN, 5
  %arr.idx6Nplus5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %sixNplus5
  store i32 1, i32* %arr.idx6Nplus5, align 4
  store i64 0, i64* %var28, align 8
  store i64 0, i64* %outLen, align 8
  %arr.bc = bitcast [48 x i32]* %arr to i8*
  %N.arg = load i64, i64* %var20, align 8
  %start.ld = load i64, i64* %var28, align 8
  %outArr.base = getelementptr inbounds [8 x i64], [8 x i64]* %outArr, i64 0, i64 0
  call void @dfs(i8* %arr.bc, i64 %N.arg, i64 %start.ld, i64* %outArr.base, i64* %outLen)
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %start.print = load i64, i64* %var28, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.print)
  store i64 0, i64* %var18, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %var18, align 8
  %len.cur = load i64, i64* %outLen, align 8
  %cmp.lt = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.lt, label %loop.body, label %loop.end

loop.body:
  %i.for = load i64, i64* %var18, align 8
  %i.plus1 = add i64 %i.for, 1
  %len2 = load i64, i64* %outLen, align 8
  %ge.last = icmp uge i64 %i.plus1, %len2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  %suffix.sel = select i1 %ge.last, i8* %empty.ptr, i8* %space.ptr
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %outArr, i64 0, i64 %i.for
  %val.ld = load i64, i64* %val.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %val.ld, i8* %suffix.sel)
  %i.next = add i64 %i.for, 1
  store i64 %i.next, i64* %var18, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}