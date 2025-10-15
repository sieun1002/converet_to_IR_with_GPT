; ModuleID = 'main'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] c"\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) nounwind

define dso_local i32 @main() {
entry:
  %adj = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %order_len, align 8

  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i32 0, i32 0
  %idx1ptr = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1ptr, align 4
  %idx2ptr = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2ptr, align 4

  %nv = load i64, i64* %n, align 8

  ; arr[n] = 1
  %p_n = getelementptr inbounds i32, i32* %adj.base, i64 %nv
  store i32 1, i32* %p_n, align 4

  ; arr[2n] = 1
  %mul2 = shl i64 %nv, 1
  %p_2n = getelementptr inbounds i32, i32* %adj.base, i64 %mul2
  store i32 1, i32* %p_2n, align 4

  ; arr[n+3] = 1
  %n_plus_3 = add i64 %nv, 3
  %p_n_plus_3 = getelementptr inbounds i32, i32* %adj.base, i64 %n_plus_3
  store i32 1, i32* %p_n_plus_3, align 4

  ; arr[3n+1] = 1
  %mul3 = add i64 %mul2, %nv
  %three_n_plus_1 = add i64 %mul3, 1
  %p_3n_plus_1 = getelementptr inbounds i32, i32* %adj.base, i64 %three_n_plus_1
  store i32 1, i32* %p_3n_plus_1, align 4

  ; arr[n+4] = 1
  %n_plus_4 = add i64 %nv, 4
  %p_n_plus_4 = getelementptr inbounds i32, i32* %adj.base, i64 %n_plus_4
  store i32 1, i32* %p_n_plus_4, align 4

  ; arr[4n+1] = 1
  %mul4 = shl i64 %nv, 2
  %four_n_plus_1 = add i64 %mul4, 1
  %p_4n_plus_1 = getelementptr inbounds i32, i32* %adj.base, i64 %four_n_plus_1
  store i32 1, i32* %p_4n_plus_1, align 4

  ; arr[2n+5] = 1
  %two_n_plus_5 = add i64 %mul2, 5
  %p_2n_plus_5 = getelementptr inbounds i32, i32* %adj.base, i64 %two_n_plus_5
  store i32 1, i32* %p_2n_plus_5, align 4

  ; arr[5n+2] = 1
  %mul5 = add i64 %mul4, %nv
  %five_n_plus_2 = add i64 %mul5, 2
  %p_5n_plus_2 = getelementptr inbounds i32, i32* %adj.base, i64 %five_n_plus_2
  store i32 1, i32* %p_5n_plus_2, align 4

  ; arr[4n+5] = 1
  %four_n_plus_5 = add i64 %mul4, 5
  %p_4n_plus_5 = getelementptr inbounds i32, i32* %adj.base, i64 %four_n_plus_5
  store i32 1, i32* %p_4n_plus_5, align 4

  ; arr[5n+4] = 1
  %five_n_plus_4 = add i64 %mul5, 4
  %p_5n_plus_4 = getelementptr inbounds i32, i32* %adj.base, i64 %five_n_plus_4
  store i32 1, i32* %p_5n_plus_4, align 4

  ; arr[5n+6] = 1
  %five_n_plus_6 = add i64 %mul5, 6
  %p_5n_plus_6 = getelementptr inbounds i32, i32* %adj.base, i64 %five_n_plus_6
  store i32 1, i32* %p_5n_plus_6, align 4

  ; arr[6n+5] = 1
  %mul6 = shl i64 %mul3, 1
  %six_n_plus_5 = add i64 %mul6, 5
  %p_6n_plus_5 = getelementptr inbounds i32, i32* %adj.base, i64 %six_n_plus_5
  store i32 1, i32* %p_6n_plus_5, align 4

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i32 0, i32 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i32 0, i32 0
  %startv = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.base, i64 %nv, i64 %startv, i32* %dist.base, i64* %order.base, i64* %order_len)

  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i32 0, i32 0
  %fmt1p = bitcast i8* %fmt1 to i8*
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt1p, i64 %startv)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lenv = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %iv, %lenv
  br i1 %cmp, label %body, label %after_loop

body:
  %iv1 = add i64 %iv, 1
  %cond = icmp ult i64 %iv1, %lenv
  %sptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i32 0, i32 0
  %eptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i32 0, i32 0
  %delim = select i1 %cond, i8* %sptr, i8* %eptr
  %elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %iv
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i32 0, i32 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %elem, i8* %delim)
  %iv.next = add i64 %iv, 1
  store i64 %iv.next, i64* %i, align 8
  br label %loop

after_loop:
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %jv = load i64, i64* %j, align 8
  %nv2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %jv, %nv2
  br i1 %cmp2, label %body2, label %done2

body2:
  %dptr = getelementptr inbounds i32, i32* %dist.base, i64 %jv
  %dval = load i32, i32* %dptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i32 0, i32 0
  %startv2 = load i64, i64* %start, align 8
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %startv2, i64 %jv, i32 %dval)
  %j.next = add i64 %jv, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2

done2:
  ret i32 0
}