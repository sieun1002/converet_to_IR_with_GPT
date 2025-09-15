; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/heapsort_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 16
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 8
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 16
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 8
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 16
  %call.before = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str.before, i64 0, i64 0))
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp1 = icmp ult i64 %i.0, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %call.print1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.int, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i.0, 1
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %nl1 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %p0, i64 9)
  %call.after = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([8 x i8], [8 x i8]* @.str.after, i64 0, i64 0))
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %j.0 = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j.0, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.0
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call.print2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.int, i64 0, i64 0), i32 %elem2)
  %j.next = add i64 %j.0, 1
  br label %loop2.cond

loop2.end:                                        ; preds = %loop2.cond
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
