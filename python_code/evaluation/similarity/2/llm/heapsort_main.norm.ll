; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/2/heapsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting: \00", align 1
@.str.after = private unnamed_addr constant [16 x i8] c"After sorting: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 16
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 8
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 16
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 8
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 16
  %call0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str.before, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ult i64 %i.0, 9
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elem)
  %inc = add i64 %i.0, 1
  br label %loop

loop.end:                                         ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %arr0ptr, i64 9)
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.after, i64 0, i64 0))
  br label %loop2

loop2:                                            ; preds = %loop2.body, %loop.end
  %j.0 = phi i64 [ 0, %loop.end ], [ %inc2, %loop2.body ]
  %cmp2 = icmp ult i64 %j.0, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.0
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %call3 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elem2)
  %inc2 = add i64 %j.0, 1
  br label %loop2

loop2.end:                                        ; preds = %loop2
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
