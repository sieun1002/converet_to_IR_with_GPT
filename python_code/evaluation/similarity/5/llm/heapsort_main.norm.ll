; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/heapsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str_num = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %.fca.0.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %.fca.0.gep, align 16
  %.fca.1.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %.fca.1.gep, align 4
  %.fca.2.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %.fca.2.gep, align 8
  %.fca.3.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %.fca.3.gep, align 4
  %.fca.4.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %.fca.4.gep, align 16
  %.fca.5.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %.fca.5.gep, align 4
  %.fca.6.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %.fca.6.gep, align 8
  %.fca.7.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %.fca.7.gep, align 4
  %.fca.8.gep = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %.fca.8.gep, align 16
  %0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str_before, i64 0, i64 0))
  br label %for.check

for.check:                                        ; preds = %for.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.body ]
  %1 = icmp ult i64 %i, 9
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.check
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %3 = load i32, i32* %2, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str_num, i64 0, i64 0), i32 %3)
  %i.next = add i64 %i, 1
  br label %for.check

for.end:                                          ; preds = %for.check
  %5 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %.fca.0.gep, i64 9)
  %6 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([8 x i8], [8 x i8]* @.str_after, i64 0, i64 0))
  br label %for2.check

for2.check:                                       ; preds = %for2.body, %for.end
  %j = phi i64 [ 0, %for.end ], [ %j.next, %for2.body ]
  %7 = icmp ult i64 %j, 9
  br i1 %7, label %for2.body, label %for2.end

for2.body:                                        ; preds = %for2.check
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %9 = load i32, i32* %8, align 4
  %10 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str_num, i64 0, i64 0), i32 %9)
  %j.next = add i64 %j, 1
  br label %for2.check

for2.end:                                         ; preds = %for2.check
  %11 = call i32 @putchar(i32 10)
  ret i32 0
}
