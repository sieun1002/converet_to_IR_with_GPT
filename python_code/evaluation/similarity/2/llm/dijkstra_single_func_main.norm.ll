; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_single_func_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/dijkstra_single_func_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %t.0 = phi i32 [ 0, %entry ], [ %tinc, %loop.body ]
  %mval = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %t.0, %mval
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* nonnull %i, i32* nonnull %j, i32* nonnull %w)
  %iv = load i32, i32* %i, align 4
  %jv = load i32, i32* %j, align 4
  %wv = load i32, i32* %w, align 4
  %iv64 = sext i32 %iv to i64
  %jv64 = sext i32 %jv to i64
  %elemPtr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %iv64, i64 %jv64
  store i32 %wv, i32* %elemPtr, align 4
  %elemPtr_t = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %jv64, i64 %iv64
  store i32 %wv, i32* %elemPtr_t, align 4
  %tinc = add nuw nsw i32 %t.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* nonnull %src)
  %s_i32 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  call void @dijkstra(i32* nonnull %s_i32, i32 %nval, i32 %srcval)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
