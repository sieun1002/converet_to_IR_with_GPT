; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/quicksort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/quicksort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  %cmp = icmp slt i64 %low, %high
  br i1 %cmp, label %part, label %ret

part:                                             ; preds = %entry
  %p = call i64 @partition(i32* %arr, i64 %low, i64 %high)
  %condL = icmp sgt i64 %p, %low
  br i1 %condL, label %left, label %after_left

left:                                             ; preds = %part
  %pm1 = add nsw i64 %p, -1
  call void @quick_sort(i32* %arr, i64 %low, i64 %pm1)
  br label %after_left

after_left:                                       ; preds = %left, %part
  %condR = icmp slt i64 %p, %high
  br i1 %condR, label %right, label %ret

right:                                            ; preds = %after_left
  %pp1 = add nsw i64 %p, 1
  call void @quick_sort(i32* %arr, i64 %pp1, i64 %high)
  br label %ret

ret:                                              ; preds = %right, %after_left, %entry
  ret void
}

define i64 @partition(i32* %arr, i64 %low, i64 %high) {
entry:
  %hptr = getelementptr inbounds i32, i32* %arr, i64 %high
  %pivot = load i32, i32* %hptr, align 4
  %i_init = add nsw i64 %low, -1
  br label %loop_head

loop_head:                                        ; preds = %j_inc, %entry
  %j = phi i64 [ %low, %entry ], [ %j_next, %j_inc ]
  %i_cur = phi i64 [ %i_init, %entry ], [ %i_updated, %j_inc ]
  %cmp.not.not = icmp slt i64 %j, %high
  br i1 %cmp.not.not, label %body, label %after_loop

body:                                             ; preds = %loop_head
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %aj = load i32, i32* %jptr, align 4
  %le.not = icmp sgt i32 %aj, %pivot
  br i1 %le.not, label %j_inc, label %iftrue

iftrue:                                           ; preds = %body
  %i1 = add nsw i64 %i_cur, 1
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i1
  %ai = load i32, i32* %iptr, align 4
  store i32 %aj, i32* %iptr, align 4
  store i32 %ai, i32* %jptr, align 4
  br label %j_inc

j_inc:                                            ; preds = %body, %iftrue
  %i_updated = phi i64 [ %i1, %iftrue ], [ %i_cur, %body ]
  %j_next = add nsw i64 %j, 1
  br label %loop_head

after_loop:                                       ; preds = %loop_head
  %ip1 = add nsw i64 %i_cur, 1
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %ip1
  %aip1 = load i32, i32* %iptr2, align 4
  store i32 %pivot, i32* %iptr2, align 4
  store i32 %aip1, i32* %hptr, align 4
  ret i64 %ip1
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  call void @quick_sort(i32* nonnull %arr0, i64 0, i64 9)
  br label %loop

loop:                                             ; preds = %print, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %print ]
  %cond = icmp ult i64 %i.0, 10
  br i1 %cond, label %print, label %done

print:                                            ; preds = %loop
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem_ptr, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %inc = add i64 %i.0, 1
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}
