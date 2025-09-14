; ModuleID = 'print_distances'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: print_distances ; Address: 0x401640
; Intent: Print distances, using "INF" for INT_MAX sentinel (confidence=0.98). Evidence: compare to 0x7FFFFFFF; format strings "dist[%d] = INF\n"/"dist[%d] = %d\n"
; Preconditions: arr points to at least n 32-bit elements
; Postconditions: Prints n lines to stdout

@format = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@aDistDD = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %after, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %after ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %is_inf = icmp eq i32 %val, 2147483647
  br i1 %is_inf, label %then, label %else

then:                                             ; preds = %body
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i)
  br label %after

else:                                             ; preds = %body
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @aDistDD, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i, i32 %val)
  br label %after

after:                                            ; preds = %then, %else
  %inc = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}