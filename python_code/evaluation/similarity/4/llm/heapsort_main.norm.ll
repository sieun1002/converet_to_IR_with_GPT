; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/heapsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting:\0A\00", align 1
@.str.after = private unnamed_addr constant [16 x i8] c"After sorting:\0A\00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@str = private unnamed_addr constant [16 x i8] c"Before sorting:\00", align 1
@str.1 = private unnamed_addr constant [15 x i8] c"After sorting:\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 16
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 8
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 16
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 8
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 16
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @str, i64 0, i64 0))
  br label %loop1.header

loop1.header:                                     ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.header
  %9 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %10 = load i32, i32* %9, align 4
  %11 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %10)
  %i.next = add i64 %i, 1
  br label %loop1.header

loop1.end:                                        ; preds = %loop1.header
  %12 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %0, i64 9)
  %puts1 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @str.1, i64 0, i64 0))
  br label %loop2.header

loop2.header:                                     ; preds = %loop2.body, %loop1.end
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.header
  %13 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %14 = load i32, i32* %13, align 4
  %15 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %14)
  %j.next = add i64 %j, 1
  br label %loop2.header

loop2.end:                                        ; preds = %loop2.header
  %16 = call i32 @putchar(i32 10)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) #0

attributes #0 = { nofree nounwind }
