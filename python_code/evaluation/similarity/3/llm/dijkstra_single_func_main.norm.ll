; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_single_func_main.ll'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8* nocapture, i32, i64)

declare i32 @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %s = alloca [100 x [100 x i32]], align 16
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %w = alloca i32, align 4
  %last = alloca i32, align 4
  %call.scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i32* nonnull %var8, i32* nonnull %varC)
  %s.i8 = bitcast [100 x [100 x i32]]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s.i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %cnt.0 = phi i32 [ 0, %entry ], [ %i.inc, %loop.body ]
  %nedges = load i32, i32* %varC, align 4
  %cmp = icmp slt i32 %cnt.0, %nedges
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call.scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* nonnull %a, i32* nonnull %b, i32* nonnull %w)
  %w.val = load i32, i32* %w, align 4
  %a.val = load i32, i32* %a, align 4
  %b.val = load i32, i32* %b, align 4
  %a.idx = sext i32 %a.val to i64
  %b.idx = sext i32 %b.val to i64
  %elem.ab.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %a.idx, i64 %b.idx
  store i32 %w.val, i32* %elem.ab.ptr, align 4
  %elem.ba.ptr = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 %b.idx, i64 %a.idx
  store i32 %w.val, i32* %elem.ba.ptr, align 4
  %i.inc = add nuw nsw i32 %cnt.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call.scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* nonnull %last)
  %s.flat = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* %s, i64 0, i64 0, i64 0
  %n.param = load i32, i32* %var8, align 4
  %src.param = load i32, i32* %last, align 4
  %call.dijkstra = call i32 @dijkstra(i32* nonnull %s.flat, i32 %n.param, i32 %src.param)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
