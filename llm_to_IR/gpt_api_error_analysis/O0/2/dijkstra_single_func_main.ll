; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare i8* @memset(i8*, i32, i64)
declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %t = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 0, i32* %var4, align 4
  %fmt2_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str2, i64 0, i64 0
  %n_ptr = bitcast i32* %n to i8*
  %m_ptr = bitcast i32* %m to i8*
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2_ptr, i8* %n_ptr, i8* %m_ptr)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  %memset_call = call i8* @memset(i8* %s_i8, i32 0, i64 40000)
  store i32 0, i32* %t, align 4
  br label %loop.cond

loop.cond:
  %tval = load i32, i32* %t, align 4
  %mval = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %tval, %mval
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %fmt3_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str3, i64 0, i64 0
  %i_ptr_i8 = bitcast i32* %i to i8*
  %j_ptr_i8 = bitcast i32* %j to i8*
  %w_ptr_i8 = bitcast i32* %w to i8*
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3_ptr, i8* %i_ptr_i8, i8* %j_ptr_i8, i8* %w_ptr_i8)
  %iv = load i32, i32* %i, align 4
  %jv = load i32, i32* %j, align 4
  %wv = load i32, i32* %w, align 4
  %iv64 = sext i32 %iv to i64
  %jv64 = sext i32 %jv to i64
  %rowptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %iv64
  %elemPtr = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr, i64 0, i64 %jv64
  store i32 %wv, i32* %elemPtr, align 4
  %rowptr_t = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %jv64
  %elemPtr_t = getelementptr inbounds [100 x i32], [100 x i32]* %rowptr_t, i64 0, i64 %iv64
  store i32 %wv, i32* %elemPtr_t, align 4
  %tprev = load i32, i32* %t, align 4
  %tinc = add nsw i32 %tprev, 1
  store i32 %tinc, i32* %t, align 4
  br label %loop.cond

after.loop:
  %fmt1_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str1, i64 0, i64 0
  %src_ptr_i8 = bitcast i32* %src to i8*
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1_ptr, i8* %src_ptr_i8)
  %s_i32 = bitcast [100 x [100 x i32]]* %s to i32*
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  call void @dijkstra(i32* %s_i32, i32 %nval, i32 %srcval)
  ret i32 0
}