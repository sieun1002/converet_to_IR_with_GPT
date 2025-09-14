; ModuleID = 'recovered_main'
source_filename = "recovered_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

@__stack_chk_guard = external global i64

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; locals
  %stack_guard.slot = alloca i64, align 8
  %adj = alloca [48 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8
  %tmp_CC = alloca i32, align 4
  %tmp_C8 = alloca i32, align 4

  ; stack protector prologue
  %guardv = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guardv, i64* %stack_guard.slot, align 8

  ; n = 7
  store i64 7, i64* %n, align 8

  ; zero adj[48] (192 bytes)
  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  ; dead locals written in original
  store i32 1, i32* %tmp_CC, align 4

  ; set specific adj entries to 1
  %nval = load i64, i64* %n, align 8

  ; idx = n
  %p0 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %nval
  store i32 1, i32* %p0, align 4

  ; idx = 2*n
  %mul2 = add i64 %nval, %nval
  %p1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul2
  store i32 1, i32* %p1, align 4

  ; idx = n + 3
  %add3 = add i64 %nval, 3
  %p2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %add3
  store i32 1, i32* %p2, align 4

  ; idx = 3*n + 1
  %t3 = add i64 %mul2, %nval        ; 2n + n = 3n
  %t3p1 = add i64 %t3, 1
  %p3 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %t3p1
  store i32 1, i32* %p3, align 4

  ; idx = n + 4
  %add4 = add i64 %nval, 4
  %p4 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %add4
  store i32 1, i32* %p4, align 4

  ; idx = 4*n + 1
  %mul4 = shl i64 %nval, 2
  %mul4p1 = add i64 %mul4, 1
  %p5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul4p1
  store i32 1, i32* %p5, align 4

  ; idx = 2*n + 5
  %t2p5 = add i64 %mul2, 5
  %p6 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %t2p5
  store i32 1, i32* %p6, align 4

  ; idx = 5*n + 2
  %mul5 = add i64 %mul4, %nval      ; 4n + n = 5n
  %mul5p2 = add i64 %mul5, 2
  %p7 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul5p2
  store i32 1, i32* %p7, align 4

  ; idx = 4*n + 5
  %mul4p5 = add i64 %mul4, 5
  %p8 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul4p5
  store i32 1, i32* %p8, align 4

  ; idx = 5*n + 4
  %mul5p4 = add i64 %mul5, 4
  %p9 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul5p4
  store i32 1, i32* %p9, align 4

  ; idx = 5*n + 6
  %mul5p6 = add i64 %mul5, 6
  %p10 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul5p6
  store i32 1, i32* %p10, align 4

  ; idx = 6*n + 5
  %mul6 = add i64 %mul5, %nval      ; 5n + n = 6n
  %mul6p5 = add i64 %mul6, 5
  %p11 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 %mul6p5
  store i32 1, i32* %p11, align 4

  ; dead local written in original
  store i32 1, i32* %tmp_C8, align 4

  ; start = 0; out_len = 0
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; call dfs(adj, n, start, out, &out_len)
  %adj.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %out.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  %startval = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.ptr, i64 %nval, i64 %startval, i64* %out.ptr, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_pre, i64 0, i64 0
  %call_pre = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %startval)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], (i+1<out_len)?" ":"")
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %olen = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %olen
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; value = out[i]
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8

  ; choose separator
  %i.plus1 = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.plus1, %olen
  %space.p = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.p = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space.p, i8* %empty.p

  ; printf("%zu%s", val, sep)
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_pair = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %val, i8* %sep)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  call i32 @putchar(i32 10)

  ; stack protector epilogue
  %guard.end = load i64, i64* %stack_guard.slot, align 8
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %chk = icmp ne i64 %guard.end, %guard.cur
  br i1 %chk, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}