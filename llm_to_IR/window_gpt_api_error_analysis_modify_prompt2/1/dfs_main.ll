; ModuleID = 'recovered_main'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %arr = alloca [48 x i32], align 16
  %var20 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var138 = alloca i64, align 8
  %var130 = alloca [8 x i64], align 16
  %var18 = alloca i64, align 8

  %arr.i8 = bitcast [48 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.i8, i8 0, i64 192, i1 false)

  store i64 7, i64* %var20, align 8

  %arr0ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  store i32 0, i32* %arr0ptr, align 4

  %arr1ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1ptr, align 4

  %v20.0 = load i64, i64* %var20, align 8
  %gep.v20.0 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.0
  store i32 1, i32* %gep.v20.0, align 4

  %arr2ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 2
  store i32 1, i32* %arr2ptr, align 4

  %v20.2 = add i64 %v20.0, %v20.0
  %gep.2v20 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.2
  store i32 1, i32* %gep.2v20, align 4

  %v20.p3 = add i64 %v20.0, 3
  %gep.v20.p3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.p3
  store i32 1, i32* %gep.v20.p3, align 4

  %v20.3 = add i64 %v20.2, %v20.0
  %v20.3.p1 = add i64 %v20.3, 1
  %gep.3v20.p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.3.p1
  store i32 1, i32* %gep.3v20.p1, align 4

  %v20.p4 = add i64 %v20.0, 4
  %gep.v20.p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.p4
  store i32 1, i32* %gep.v20.p4, align 4

  %v20.4 = shl i64 %v20.0, 2
  %v20.4.p1 = add i64 %v20.4, 1
  %gep.4v20.p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.4.p1
  store i32 1, i32* %gep.4v20.p1, align 4

  %v20.2.p5 = add i64 %v20.2, 5
  %gep.2v20.p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.2.p5
  store i32 1, i32* %gep.2v20.p5, align 4

  %v20.5 = add i64 %v20.4, %v20.0
  %v20.5.p2 = add i64 %v20.5, 2
  %gep.5v20.p2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.5.p2
  store i32 1, i32* %gep.5v20.p2, align 4

  %v20.4.p5 = add i64 %v20.4, 5
  %gep.4v20.p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.4.p5
  store i32 1, i32* %gep.4v20.p5, align 4

  %v20.5.p4 = add i64 %v20.5, 4
  %gep.5v20.p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.5.p4
  store i32 1, i32* %gep.5v20.p4, align 4

  %v20.5.p6 = add i64 %v20.5, 6
  %gep.5v20.p6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.5.p6
  store i32 1, i32* %gep.5v20.p6, align 4

  %v20.6 = add i64 %v20.3, %v20.3
  %v20.6.p5 = add i64 %v20.6, 5
  %gep.6v20.p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v20.6.p5
  store i32 1, i32* %gep.6v20.p5, align 4

  store i64 0, i64* %var28, align 8
  store i64 0, i64* %var138, align 8

  %var130.base = getelementptr inbounds [8 x i64], [8 x i64]* %var130, i64 0, i64 0
  %arr.base = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  %v28.0 = load i64, i64* %var28, align 8
  %v20.call = load i64, i64* %var20, align 8
  call void @dfs(i32* %arr.base, i64 %v20.call, i64 %v28.0, i64* %var130.base, i64* %var138)

  %start.val = load i64, i64* %var28, align 8
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.val)

  store i64 0, i64* %var18, align 8
  br label %loop.cond

loop.cond:
  %len = load i64, i64* %var138, align 8
  %i.val = load i64, i64* %var18, align 8
  %cmp = icmp ult i64 %i.val, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.val, 1
  %len2 = load i64, i64* %var138, align 8
  %cond = icmp uge i64 %i.plus1, %len2
  br i1 %cond, label %select.empty, label %select.space

select.space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  br label %select.merge

select.empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  br label %select.merge

select.merge:
  %suffix.ptr = phi i8* [ %space.ptr, %select.space ], [ %empty.ptr, %select.empty ]
  %out.val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %var130, i64 0, i64 %i.val
  %out.val = load i64, i64* %out.val.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %out.val, i8* %suffix.ptr)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %var18, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}