; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/dijkstra_single_func_main.ll'
source_filename = "recovered"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %v_i = alloca i32, align 4
  %v_j = alloca i32, align 4
  %v_w = alloca i32, align 4
  %last = alloca i32, align 4
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0), i32* nonnull %var8, i32* nonnull %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s.i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %counter.0 = phi i32 [ 0, %entry ], [ %tinc, %loop.body ]
  %e = load i32, i32* %varC, align 4
  %cmp.not = icmp slt i32 %counter.0, %e
  br i1 %cmp.not, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0), i32* nonnull %v_i, i32* nonnull %v_j, i32* nonnull %v_w)
  %i = load i32, i32* %v_i, align 4
  %j = load i32, i32* %v_j, align 4
  %w = load i32, i32* %v_w, align 4
  %i64_i = sext i32 %i to i64
  %i64_j = sext i32 %j to i64
  %eltptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %i64_i, i64 %i64_j
  store i32 %w, i32* %eltptr, align 4
  %eltptr2 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %i64_j, i64 %i64_i
  store i32 %w, i32* %eltptr2, align 4
  %tinc = add nuw nsw i32 %counter.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* nonnull %last)
  %sflat = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n = load i32, i32* %var8, align 4
  %src = load i32, i32* %last, align 4
  call void @dijkstra(i32* nonnull %sflat, i32 %n, i32 %src)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
