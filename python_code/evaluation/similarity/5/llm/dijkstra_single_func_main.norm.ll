; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_single_func_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_single_func_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare i8* @memset(i8*, i32, i64)

declare void @dijkstra(i32*, i32, i32)

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %s = alloca [10000 x i32], align 16
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %src = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.two, i64 0, i64 0), i32* nonnull %n, i32* nonnull %m)
  %s_as_i8 = bitcast [10000 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40000) %s_as_i8, i8 0, i64 40000, i1 false)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %m.val = load i32, i32* %m, align 4
  %cmp = icmp slt i32 %i.0, %m.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.three, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %w.val = load i32, i32* %w, align 4
  %u.val = load i32, i32* %u, align 4
  %u.ext = sext i32 %u.val to i64
  %mul.row = mul nsw i64 %u.ext, 100
  %v.val = load i32, i32* %v, align 4
  %v.ext = sext i32 %v.val to i64
  %idx.uv = add nsw i64 %mul.row, %v.ext
  %elem.uv.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.uv
  store i32 %w.val, i32* %elem.uv.ptr, align 4
  %mul.row.v = mul nsw i64 %v.ext, 100
  %idx.vu = add nsw i64 %mul.row.v, %u.ext
  %elem.vu.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 %idx.vu
  store i32 %w.val, i32* %elem.vu.ptr, align 4
  %i.next = add nuw nsw i32 %i.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.one, i64 0, i64 0), i32* nonnull %src)
  %s.base = getelementptr inbounds [10000 x i32], [10000 x i32]* %s, i64 0, i64 0
  %n.load = load i32, i32* %n, align 4
  %src.load = load i32, i32* %src, align 4
  call void @dijkstra(i32* nonnull %s.base, i32 %n.load, i32 %src.load)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
