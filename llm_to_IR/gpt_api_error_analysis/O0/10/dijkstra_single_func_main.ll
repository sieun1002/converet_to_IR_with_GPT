; target
target triple = "x86_64-pc-linux-gnu"

; format strings
@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_double = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; externs
declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() local_unnamed_addr {
entry:
  %N = alloca i32, align 4
  %M = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %i = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %start = alloca i32, align 4
  %fmt_dbl_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_double, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dbl_ptr, i32* %N, i32* %M)
  %s_i8 = bitcast [10000 x i32]* %s to i8*
  %call_memset = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_val = load i32, i32* %i, align 4
  %M_val = load i32, i32* %M, align 4
  %cmp = icmp sge i32 %i_val, %M_val
  br i1 %cmp, label %after_loop, label %read_edge

read_edge:
  %fmt_triple_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_triple_ptr, i32* %a, i32* %b, i32* %w)
  %a_val = load i32, i32* %a, align 4
  %b_val = load i32, i32* %b, align 4
  %w_val = load i32, i32* %w, align 4
  %a_ext = sext i32 %a_val to i64
  %b_ext = sext i32 %b_val to i64
  %row_mul = mul nsw i64 %a_ext, 100
  %idx_ab = add nsw i64 %row_mul, %b_ext
  %s_base = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %elem_ab = getelementptr inbounds i32, i32* %s_base, i64 %idx_ab
  store i32 %w_val, i32* %elem_ab, align 4
  %row2_mul = mul nsw i64 %b_ext, 100
  %idx_ba = add nsw i64 %row2_mul, %a_ext
  %elem_ba = getelementptr inbounds i32, i32* %s_base, i64 %idx_ba
  store i32 %w_val, i32* %elem_ba, align 4
  %inc = add nsw i32 %i_val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after_loop:
  %fmt_single_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_single, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_single_ptr, i32* %start)
  %s_first = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %N_val2 = load i32, i32* %N, align 4
  %start_val2 = load i32, i32* %start, align 4
  call void @dijkstra(i32* %s_first, i32 %N_val2, i32 %start_val2)
  ret i32 0
}