; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/selectionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/selectionsort_main.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.num = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @selection_sort(i32*, i32)

declare i32 @printf(i8*, ...)

; Function Attrs: noreturn
declare void @__stack_chk_fail() #0

define i32 @main() {
entry:
  %array = alloca [5 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %arr.base, align 16
  %a1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %a1.ptr, align 4
  %a2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %a2.ptr, align 8
  %a3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %a3.ptr, align 4
  %a4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %a4.ptr, align 16
  call void @selection_sort(i32* nonnull %arr.base, i32 5)
  %call.print.sorted = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0))
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %for.body ]
  %cmp = icmp ult i32 %i.phi, 5
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idx.ext = zext i32 %i.phi to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx.ext
  %elem.val = load i32, i32* %elem.ptr, align 4
  %call.print.num = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.num, i64 0, i64 0), i32 %elem.val)
  %i.next = add nuw nsw i32 %i.phi, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %guard.current = load i64, i64* @__stack_chk_guard, align 8
  %cmp.canary.not = icmp eq i64 %guard.load, %guard.current
  br i1 %cmp.canary.not, label %ret, label %stackfail

stackfail:                                        ; preds = %for.end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %for.end
  ret i32 0
}

attributes #0 = { noreturn }
