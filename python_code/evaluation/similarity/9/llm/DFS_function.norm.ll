; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/DFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/DFS_function.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind
declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture) #0

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #0

; Function Attrs: nounwind
declare i32 @putchar(i32) #0

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  store i64 0, i64* %len, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %idx1.ptr, align 4
  %idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %idx2.ptr, align 8
  %idx3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %idx3.ptr, align 8
  %idx4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %idx4.ptr, align 8
  %idx5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %idx5.ptr, align 4
  %idx6.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %idx6.ptr, align 4
  %idx7.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %idx7.ptr, align 4
  %idx8.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %idx8.ptr, align 4
  %idx9.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %idx9.ptr, align 4
  %idx10.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %idx10.ptr, align 4
  %idx11.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %idx11.ptr, align 4
  %idx12.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %idx12.ptr, align 4
  call void @dfs(i32* nonnull %adj.base, i64 7, i64 0, i64* nonnull %order.base, i64* nonnull %len)
  %_p0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.header, i64 0, i64 0), i64 0)
  %len.cur.pre = load i64, i64* %len, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.plus1, %body ]
  %cmp = icmp ult i64 %i, %len.cur.pre
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %i.plus1 = add i64 %i, 1
  %has_next = icmp ult i64 %i.plus1, %len.cur.pre
  %. = select i1 %has_next, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %_p1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0), i64 %elem, i8* %.)
  br label %loop

done:                                             ; preds = %loop
  %_pc = call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
