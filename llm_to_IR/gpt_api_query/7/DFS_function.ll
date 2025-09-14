; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.dfs = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8* nocapture readonly, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; locals
  %arr = alloca [48 x i32], align 16
  %out = alloca [64 x i64], align 16
  %out_len = alloca i64, align 8
  %start = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  ; n = 7
  store i64 7, i64* %n, align 8
  ; start = 0
  store i64 0, i64* %start, align 8
  ; out_len = 0
  store i64 0, i64* %out_len, align 8

  ; memset arr to 0 (48 * 4 bytes)
  %arr.i8 = bitcast [48 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %arr.i8, i8 0, i64 192, i1 false)

  ; arr[1] = 1
  %arr.base = getelementptr inbounds [48 x i32], [48 x i32]* %arr, i64 0, i64 0
  %p.idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %p.idx1, align 4

  ; arr[2] = 1
  %p.idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 1, i32* %p.idx2, align 4

  ; compute common multiples of n
  %n.val = load i64, i64* %n, align 8
  %n2 = shl i64 %n.val, 1                                  ; 2n
  %n3 = add i64 %n2, %n.val                                ; 3n
  %n4 = shl i64 %n.val, 2                                  ; 4n
  %n5 = add i64 %n4, %n.val                                ; 5n
  %n6 = shl i64 %n3, 1                                     ; 6n

  ; arr[n] = 1
  %p.n = getelementptr inbounds i32, i32* %arr.base, i64 %n.val
  store i32 1, i32* %p.n, align 4

  ; arr[2n] = 1
  %p.2n = getelementptr inbounds i32, i32* %arr.base, i64 %n2
  store i32 1, i32* %p.2n, align 4

  ; arr[n + 3] = 1
  %n_plus_3 = add i64 %n.val, 3
  %p.np3 = getelementptr inbounds i32, i32* %arr.base, i64 %n_plus_3
  store i32 1, i32* %p.np3, align 4

  ; arr[3n + 1] = 1
  %n3_plus_1 = add i64 %n3, 1
  %p.3n1 = getelementptr inbounds i32, i32* %arr.base, i64 %n3_plus_1
  store i32 1, i32* %p.3n1, align 4

  ; arr[n + 4] = 1
  %n_plus_4 = add i64 %n.val, 4
  %p.np4 = getelementptr inbounds i32, i32* %arr.base, i64 %n_plus_4
  store i32 1, i32* %p.np4, align 4

  ; arr[4n + 1] = 1
  %n4_plus_1 = add i64 %n4, 1
  %p.4n1 = getelementptr inbounds i32, i32* %arr.base, i64 %n4_plus_1
  store i32 1, i32* %p.4n1, align 4

  ; arr[2n + 5] = 1
  %n2_plus_5 = add i64 %n2, 5
  %p.2n5 = getelementptr inbounds i32, i32* %arr.base, i64 %n2_plus_5
  store i32 1, i32* %p.2n5, align 4

  ; arr[5n + 2] = 1
  %n5_plus_2 = add i64 %n5, 2
  %p.5n2 = getelementptr inbounds i32, i32* %arr.base, i64 %n5_plus_2
  store i32 1, i32* %p.5n2, align 4

  ; arr[4n + 5] = 1
  %n4_plus_5 = add i64 %n4, 5
  %p.4n5 = getelementptr inbounds i32, i32* %arr.base, i64 %n4_plus_5
  store i32 1, i32* %p.4n5, align 4

  ; arr[5n + 4] = 1
  %n5_plus_4 = add i64 %n5, 4
  %p.5n4 = getelementptr inbounds i32, i32* %arr.base, i64 %n5_plus_4
  store i32 1, i32* %p.5n4, align 4

  ; arr[5n + 6] = 1
  %n5_plus_6 = add i64 %n5, 6
  %p.5n6 = getelementptr inbounds i32, i32* %arr.base, i64 %n5_plus_6
  store i32 1, i32* %p.5n6, align 4

  ; arr[6n + 5] = 1
  %n6_plus_5 = add i64 %n6, 5
  %p.6n5 = getelementptr inbounds i32, i32* %arr.base, i64 %n6_plus_5
  store i32 1, i32* %p.6n5, align 4

  ; call dfs(&arr[0], n, start, out, &out_len)
  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %arr.base, i64 %n.val, i64 0, i64* %out.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.dfs, i64 0, i64 0
  %start.val = load i64, i64* %start, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.val)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], (i+1<out_len) ? " " : "");
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  ; choose separator based on (i+1 < out_len)
  %i.plus1 = add i64 %i.cur, 1
  %is_not_last = icmp ult i64 %i.plus1, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.sel = select i1 %is_not_last, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; load out[i]
  %out.elem.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.cur
  %out.elem = load i64, i64* %out.elem.ptr, align 8

  ; printf("%zu%s", out[i], sep)
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %out.elem, i8* %sep.sel)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ; putchar('\n')
  %call.putc = call i32 @putchar(i32 10)
  ret i32 0
}