; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/heapsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.after = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)

declare dso_local i32 @putchar(i32)

declare dso_local void @heap_sort(i32*, i64)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %a0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %a0.ptr, align 16
  %a1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %a1.ptr, align 4
  %a2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %a2.ptr, align 8
  %a3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %a3.ptr, align 4
  %a4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %a4.ptr, align 16
  %a5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %a5.ptr, align 4
  %a6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %a6.ptr, align 8
  %a7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7.ptr, align 4
  %a8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %a8.ptr, align 16
  %call.before = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str.before, i64 0, i64 0))
  br label %print.loop.header

print.loop.header:                                ; preds = %print.loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.loop.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %print.loop.body, label %print.loop.end

print.loop.body:                                  ; preds = %print.loop.header
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0), i32 %elem)
  %i.next = add nuw nsw i64 %i, 1
  br label %print.loop.header

print.loop.end:                                   ; preds = %print.loop.header
  %call.nl1 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %a0.ptr, i64 9)
  %call.after = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([8 x i8], [8 x i8]* @.str.after, i64 0, i64 0))
  br label %print2.loop.header

print2.loop.header:                               ; preds = %print2.loop.body, %print.loop.end
  %j = phi i64 [ 0, %print.loop.end ], [ %j.next, %print2.loop.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %print2.loop.body, label %print2.loop.end

print2.loop.body:                                 ; preds = %print2.loop.header
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0), i32 %elem2)
  %j.next = add nuw nsw i64 %j, 1
  br label %print2.loop.header

print2.loop.end:                                  ; preds = %print2.loop.header
  %call.nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
