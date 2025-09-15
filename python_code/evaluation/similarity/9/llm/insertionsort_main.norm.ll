; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/insertionsort_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/insertionsort_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n = icmp ult i64 %n, 2
  br i1 %cmp_n, label %ret, label %for.header

for.header:                                       ; preds = %while.end, %entry
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %i.cmp = icmp ult i64 %i.ph, %n
  br i1 %i.cmp, label %for.body, label %ret

for.body:                                         ; preds = %for.header
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key = load i32, i32* %i.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j.ph.in = phi i64 [ %i.ph, %for.body ], [ %j.ph, %while.body ]
  %j.ph = add i64 %j.ph.in, -1
  %j.ge0 = icmp sgt i64 %j.ph, -1
  br i1 %j.ge0, label %check, label %while.end

check:                                            ; preds = %while.cond
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp = icmp sgt i32 %j.val, %key
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %check
  %dst.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ph.in
  store i32 %j.val, i32* %dst.ptr, align 4
  br label %while.cond

while.end:                                        ; preds = %check, %while.cond
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ph.in
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add i64 %i.ph, 1
  br label %for.header

ret:                                              ; preds = %for.header, %entry
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* nonnull %base, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}
