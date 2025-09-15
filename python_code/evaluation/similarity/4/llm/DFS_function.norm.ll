; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/DFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/DFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out0 = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcmp = icmp ult i64 %zi, 49
  br i1 %zcmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %zptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p2, align 8
  %p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p3, align 8
  %p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p4, align 8
  %p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p5, align 4
  %p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p7, align 4
  %p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p8, align 4
  %p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p9, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p11, align 4
  %p12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p12, align 4
  store i64 0, i64* %out_len, align 8
  call void @dfs(i32* nonnull %adj0, i64 7, i64 0, i64* nonnull %out0, i64* nonnull %out_len)
  %ph1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0), i64 0)
  %len.cur.pre = load i64, i64* %out_len, align 8
  br label %print.cond

print.cond:                                       ; preds = %print.body, %zero.end
  %i = phi i64 [ 0, %zero.end ], [ %i.plus1, %print.body ]
  %loop.cont = icmp ult i64 %i, %len.cur.pre
  br i1 %loop.cont, label %print.body, label %print.end

print.body:                                       ; preds = %print.cond
  %i.plus1 = add i64 %i, 1
  %has_more = icmp ult i64 %i.plus1, %len.cur.pre
  %delim = select i1 %has_more, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %ph2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0), i64 %val, i8* %delim)
  br label %print.cond

print.end:                                        ; preds = %print.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}
