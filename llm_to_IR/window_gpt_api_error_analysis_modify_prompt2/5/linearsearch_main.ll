target triple = "x86_64-pc-windows-msvc"

@_Format = internal unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@Buffer  = internal unnamed_addr constant [18 x i8] c"Element not found\00", align 1

declare i32 @linear_search(i32* noundef, i32 noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %target = alloca i32, align 4
  %res = alloca i32, align 4

  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %p4, align 4

  store i32 4, i32* %len, align 4
  store i32 5, i32* %target, align 4

  %lenv = load i32, i32* %len, align 4
  %tgtv = load i32, i32* %target, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linear_search(i32* %arrptr, i32 %tgtv, i32 %lenv)
  store i32 %call, i32* %res, align 4

  %r0 = load i32, i32* %res, align 4
  %cmp = icmp eq i32 %r0, -1
  br i1 %cmp, label %loc_140001512, label %cont

cont:
  %r1 = load i32, i32* %res, align 4
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @_Format, i64 0, i64 0
  %callprintf = call i32 @printf(i8* %fmt, i32 %r1)
  br label %loc_140001521

loc_140001512:
  %buf = getelementptr inbounds [18 x i8], [18 x i8]* @Buffer, i64 0, i64 0
  %callputs = call i32 @puts(i8* %buf)
  br label %loc_140001521

loc_140001521:
  ret i32 0
}