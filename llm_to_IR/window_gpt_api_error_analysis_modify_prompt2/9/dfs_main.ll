; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@_Format = private constant [24 x i8] c"DFS preorder from %zu: \00"
@aZuS = private constant [6 x i8] c"%zu%s\00"
@asc_140004018 = private constant [2 x i8] c" \00"
@unk_14000401A = private constant [1 x i8] c"\00"

declare dso_local void @dfs(i8* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main() {
entry:
  %arr = alloca [48 x i32], align 16
  %var20 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %outCount = alloca i64, align 8
  %outArr = alloca [64 x i64], align 16

  store i64 7, i64* %var20, align 8

  %arr.i8 = bitcast [48 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.i8, i8 0, i64 192, i1 false)

  %arr.idx1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 2
  store i32 1, i32* %arr.idx2, align 4

  %v0 = load i64, i64* %var20, align 8
  %p.v0 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v0
  store i32 1, i32* %p.v0, align 4

  %v2 = add i64 %v0, %v0
  %p.v2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v2
  store i32 1, i32* %p.v2, align 4

  %v0p3 = add i64 %v0, 3
  %p.v0p3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v0p3
  store i32 1, i32* %p.v0p3, align 4

  %v3 = add i64 %v2, %v0
  %v3p1 = add i64 %v3, 1
  %p.v3p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v3p1
  store i32 1, i32* %p.v3p1, align 4

  %v0p4 = add i64 %v0, 4
  %p.v0p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v0p4
  store i32 1, i32* %p.v0p4, align 4

  %vshl2 = shl i64 %v0, 2
  %vshl2p1 = add i64 %vshl2, 1
  %p.vshl2p1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %vshl2p1
  store i32 1, i32* %p.vshl2p1, align 4

  %v2p5 = add i64 %v2, 5
  %p.v2p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v2p5
  store i32 1, i32* %p.v2p5, align 4

  %v4p0 = add i64 %vshl2, %v0
  %v4p2 = add i64 %v4p0, 2
  %p.v4p2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v4p2
  store i32 1, i32* %p.v4p2, align 4

  %v4p5 = add i64 %vshl2, 5
  %p.v4p5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v4p5
  store i32 1, i32* %p.v4p5, align 4

  %v4p4 = add i64 %v4p0, 4
  %p.v4p4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v4p4
  store i32 1, i32* %p.v4p4, align 4

  %v4p6 = add i64 %v4p0, 6
  %p.v4p6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v4p6
  store i32 1, i32* %p.v4p6, align 4

  %v3dbl = shl i64 %v3, 1
  %v3dblp5 = add i64 %v3dbl, 5
  %p.v3dblp5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %v3dblp5
  store i32 1, i32* %p.v3dblp5, align 4

  store i64 0, i64* %var28, align 8
  store i64 0, i64* %outCount, align 8

  %outArr.base = getelementptr inbounds [64 x i64], [64 x i64]* %outArr, i64 0, i64 0
  call void @dfs(i8* %arr.i8, i64 %v0, i64 0, i64* %outArr.base, i64* %outCount)

  %startv = load i64, i64* %var28, align 8
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %fmt0.i8 = bitcast i8* %fmt0 to i8*
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt0.i8, i64 %startv)

  store i64 0, i64* %var18, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %var18, align 8
  %cnt.cur = load i64, i64* %outCount, align 8
  %cmp.lt = icmp ult i64 %i.cur, %cnt.cur
  br i1 %cmp.lt, label %loop.body, label %loop.end

loop.body:
  %i.nextidx = add i64 %i.cur, 1
  %cnt.forcmp = load i64, i64* %outCount, align 8
  %has.space = icmp ult i64 %i.nextidx, %cnt.forcmp
  br i1 %has.space, label %choose.space, label %choose.empty

choose.space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  br label %suffix.join

choose.empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  br label %suffix.join

suffix.join:
  %suffix.sel = phi i8* [ %space.ptr, %choose.space ], [ %empty.ptr, %choose.empty ]
  %outArr.loadbase = getelementptr inbounds [64 x i64], [64 x i64]* %outArr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i64, i64* %outArr.loadbase, i64 %i.cur
  %elem.val = load i64, i64* %elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %fmt1.i8 = bitcast i8* %fmt1 to i8*
  %call.print = call i32 (i8*, ...) @printf(i8* %fmt1.i8, i64 %elem.val, i8* %suffix.sel)
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %var18, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}