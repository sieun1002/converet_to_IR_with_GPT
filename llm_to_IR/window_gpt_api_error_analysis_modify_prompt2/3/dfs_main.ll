; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@asc_140004018 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_14000401A = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @dfs(i32* %base, i64 %n, i64 %start, i64* %out_arr, i64* %out_len)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() {
entry:
  %graph = alloca [49 x i32], align 16
  %outArr = alloca [48 x i64], align 16
  %var20 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var138 = alloca i64, align 8

  store i64 7, i64* %var20, align 8

  %graph_i8 = bitcast [49 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph_i8, i8 0, i64 196, i1 false)

  ; set graph[1] = 1
  %gep_g1 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 1
  store i32 1, i32* %gep_g1, align 4
  ; set graph[2] = 1
  %gep_g2 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 2
  store i32 1, i32* %gep_g2, align 4

  ; load n = var20
  %n0 = load i64, i64* %var20, align 8

  ; graph[n] = 1
  %gep_gn = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %n0
  store i32 1, i32* %gep_gn, align 4

  ; graph[2*n] = 1
  %mul2 = shl i64 %n0, 1
  %gep_g2n = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %mul2
  store i32 1, i32* %gep_g2n, align 4

  ; graph[n+3] = 1
  %n_plus_3 = add i64 %n0, 3
  %gep_gn3 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %n_plus_3
  store i32 1, i32* %gep_gn3, align 4

  ; graph[3*n + 1] = 1
  %twon = shl i64 %n0, 1
  %threen = add i64 %twon, %n0
  %threen_plus_1 = add i64 %threen, 1
  %gep_g3n1 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %threen_plus_1
  store i32 1, i32* %gep_g3n1, align 4

  ; graph[n + 4] = 1
  %n_plus_4 = add i64 %n0, 4
  %gep_gn4 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %n_plus_4
  store i32 1, i32* %gep_gn4, align 4

  ; graph[4*n + 1] = 1
  %fourn = shl i64 %n0, 2
  %fourn_plus_1 = add i64 %fourn, 1
  %gep_g4n1 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %fourn_plus_1
  store i32 1, i32* %gep_g4n1, align 4

  ; graph[2*n + 5] = 1
  %twon_plus_5 = add i64 %mul2, 5
  %gep_g2n5 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %twon_plus_5
  store i32 1, i32* %gep_g2n5, align 4

  ; graph[5*n + 2] = 1   (4*n + n + 2)
  %five_n = add i64 %fourn, %n0
  %five_n_plus_2 = add i64 %five_n, 2
  %gep_g5n2 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %five_n_plus_2
  store i32 1, i32* %gep_g5n2, align 4

  ; graph[4*n + 5] = 1
  %fourn_plus_5 = add i64 %fourn, 5
  %gep_g4n5 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %fourn_plus_5
  store i32 1, i32* %gep_g4n5, align 4

  ; graph[5*n + 4] = 1
  %five_n_plus_4 = add i64 %five_n, 4
  %gep_g5n4 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %five_n_plus_4
  store i32 1, i32* %gep_g5n4, align 4

  ; graph[5*n + 6] = 1
  %five_n_plus_6 = add i64 %five_n, 6
  %gep_g5n6 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %five_n_plus_6
  store i32 1, i32* %gep_g5n6, align 4

  ; graph[6*n + 5] = 1   (n -> 2n -> +n = 3n -> *2 = 6n -> +5)
  %sixn = shl i64 %threen, 1
  %sixn_plus_5 = add i64 %sixn, 5
  %gep_g6n5 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 %sixn_plus_5
  store i32 1, i32* %gep_g6n5, align 4

  ; var_28 = 0
  store i64 0, i64* %var28, align 8
  ; var_138 = 0
  store i64 0, i64* %var138, align 8

  ; call dfs(base=&graph[0], n=var20, start=var28, out=&outArr[0], out_len=&var138)
  %graph_base = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0
  %outArr_base = getelementptr inbounds [48 x i64], [48 x i64]* %outArr, i64 0, i64 0
  %n_for_call = load i64, i64* %var20, align 8
  %start_for_call = load i64, i64* %var28, align 8
  call void @dfs(i32* %graph_base, i64 %n_for_call, i64 %start_for_call, i64* %outArr_base, i64* %var138)

  ; printf("DFS preorder from %zu: ", start)
  %start_print = load i64, i64* %var28, align 8
  %fmt_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i64 %start_print)

  ; i = 0
  store i64 0, i64* %var18, align 8
  br label %loop_check

loop_check:
  %len_now = load i64, i64* %var138, align 8
  %i_now = load i64, i64* %var18, align 8
  %cmp = icmp ult i64 %i_now, %len_now
  br i1 %cmp, label %loop_body, label %loop_end

loop_body:
  ; select delimiter: " " if (i+1 < len) else ""
  %i_plus_1 = add i64 %i_now, 1
  %cmp_last = icmp ult i64 %i_plus_1, %len_now
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004018, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000401A, i64 0, i64 0
  %delim = select i1 %cmp_last, i8* %space_ptr, i8* %empty_ptr

  ; load outArr[i]
  %elem_ptr = getelementptr inbounds [48 x i64], [48 x i64]* %outArr, i64 0, i64 %i_now
  %elem_val = load i64, i64* %elem_ptr, align 8

  ; printf("%zu%s", elem_val, delim)
  %fmt2_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %call_printf_item = call i32 (i8*, ...) @printf(i8* %fmt2_ptr, i64 %elem_val, i8* %delim)

  ; i++
  %i_next = add i64 %i_now, 1
  store i64 %i_next, i64* %var18, align 8
  br label %loop_check

loop_end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}