; ModuleID = 'main.ll'
source_filename = "main"
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str.space = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty = private unnamed_addr constant [1 x i8] c"\00"
@.str.fmt2 = private unnamed_addr constant [6 x i8] c"%zu%s\00"

declare void @dfs(i32* %edges, i64 %a, i64 %start, i64* %out, i64* %out_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [48 x i32], align 16
  %out = alloca [48 x i64], align 16
  %a = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %a, align 8

  %arr.i8 = bitcast [48 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.i8, i8 0, i64 192, i1 false)

  %a.val = load i64, i64* %a, align 8
  ; idx = a
  %gep1 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %a.val
  store i32 1, i32* %gep1, align 4
  ; idx = 2a
  %mul2 = add i64 %a.val, %a.val
  %gep2 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %mul2
  store i32 1, i32* %gep2, align 4
  ; idx = a + 3
  %add_a_3 = add i64 %a.val, 3
  %gep3 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_a_3
  store i32 1, i32* %gep3, align 4
  ; idx = 3a + 1
  %three_a = add i64 %mul2, %a.val
  %add_3a_1 = add i64 %three_a, 1
  %gep4 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_3a_1
  store i32 1, i32* %gep4, align 4
  ; idx = a + 4
  %add_a_4 = add i64 %a.val, 4
  %gep5 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_a_4
  store i32 1, i32* %gep5, align 4
  ; idx = 4a + 1
  %mul4 = add i64 %mul2, %mul2
  %add_4a_1 = add i64 %mul4, 1
  %gep6 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_4a_1
  store i32 1, i32* %gep6, align 4
  ; idx = 2a + 5
  %add_2a_5 = add i64 %mul2, 5
  %gep7 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_2a_5
  store i32 1, i32* %gep7, align 4
  ; idx = 5a + 2
  %mul5 = add i64 %mul4, %a.val
  %add_5a_2 = add i64 %mul5, 2
  %gep8 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_5a_2
  store i32 1, i32* %gep8, align 4
  ; idx = 4a + 5
  %add_4a_5 = add i64 %mul4, 5
  %gep9 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_4a_5
  store i32 1, i32* %gep9, align 4
  ; idx = 5a + 4
  %add_5a_4 = add i64 %mul5, 4
  %gep10 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_5a_4
  store i32 1, i32* %gep10, align 4
  ; idx = 5a + 6
  %add_5a_6 = add i64 %mul5, 6
  %gep11 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_5a_6
  store i32 1, i32* %gep11, align 4
  ; idx = 6a + 5
  %mul6 = add i64 %mul4, %mul2
  %add_6a_5 = add i64 %mul6, 5
  %gep12 = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 %add_6a_5
  store i32 1, i32* %gep12, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  %arr.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  %out.ptr = getelementptr inbounds [48 x i64], [48 x i64]* %out, i64 0, i64 0
  %start.val0 = load i64, i64* %start, align 8
  call void @dfs(i32* %arr.ptr, i64 %a.val, i64 %start.val0, i64* %out.ptr, i64* %out_len)

  %fmt.pre.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %start.val1 = load i64, i64* %start, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt.pre.ptr, i64 %start.val1)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.val, %len
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %iplus1 = add i64 %i.val, 1
  %is_last = icmp uge i64 %iplus1, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim.ptr = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr

  %out.elem.ptr = getelementptr inbounds [48 x i64], [48 x i64]* %out, i64 0, i64 %i.val
  %out.elem = load i64, i64* %out.elem.ptr, align 8

  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt2, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %out.elem, i8* %delim.ptr)

  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}