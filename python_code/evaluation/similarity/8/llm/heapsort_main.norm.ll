; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/heapsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/heapsort_main.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %arr.idx0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.idx0, align 16
  %arr.idx1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.idx2, align 8
  %arr.idx3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.idx4, align 16
  %arr.idx5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.idx6, align 8
  %arr.idx7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.idx8, align 16
  %call.print.before = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str.before, i64 0, i64 0))
  br label %loop1

loop1:                                            ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp.i = icmp ult i64 %i, 9
  br i1 %cmp.i, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1
  %elem.ptr.i = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem.i = load i32, i32* %elem.ptr.i, align 4
  %call.print.elem.i = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0), i32 %elem.i)
  %i.next = add i64 %i, 1
  br label %loop1

loop1.end:                                        ; preds = %loop1
  %call.nl1 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %arr.idx0, i64 9)
  %call.print.after = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([8 x i8], [8 x i8]* @.str.after, i64 0, i64 0))
  br label %loop2

loop2:                                            ; preds = %loop2.body, %loop1.end
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp.j = icmp ult i64 %j, 9
  br i1 %cmp.j, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2
  %elem.ptr.j = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem.j = load i32, i32* %elem.ptr.j, align 4
  %call.print.elem.j = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0), i32 %elem.j)
  %j.next = add i64 %j, 1
  br label %loop2

loop2.end:                                        ; preds = %loop2
  %call.nl2 = call i32 @putchar(i32 10)
  ret i32 0
}
