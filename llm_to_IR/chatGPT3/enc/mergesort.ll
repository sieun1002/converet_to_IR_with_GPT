; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10e0
; Intent: entry point (confidence=1.00). Evidence: references to argc/argv, common printf pattern
; Preconditions: allocates memory with malloc
; Postconditions: prints values and frees memory

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @free(i8*)
declare i8* @malloc(i64)
declare void @llvm.stackprotector(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %call = call i8* @malloc(i64 40)
  %1 = icmp eq i8* %call, null
  br i1 %1, label %return_zero, label %malloc_success

malloc_success:                               ; preds = %entry
  %array = bitcast i8* %call to i32*
  store i64 1, i32* %array, align 4
  br label %loop

loop:                                         ; preds = %merge, %malloc_success
  %i = phi i64 [ 1, %malloc_success ], [ %inc, %merge ]
  %mul = mul i64 %i, 2
  %cmp = icmp ult i64 %mul, 10
  br i1 %cmp, label %merge, label %loop_end

merge:                                        ; preds = %loop
  %inc = add i64 %i, 1
  br label %loop

loop_end:                                     ; preds = %loop
  %2 = getelementptr inbounds i32, i32* %array, i64 0
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i64 0, i64 0), i32 %i)
  call void @free(i8* %call)
  ret i32 0

return_zero:                                  ; preds = %entry
  ret i32 0
}

@fmt = internal constant [4 x i8] c"%d \00"