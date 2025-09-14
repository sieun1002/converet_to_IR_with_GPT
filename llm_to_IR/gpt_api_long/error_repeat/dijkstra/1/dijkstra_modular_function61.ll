; ModuleID = 'print_distances'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: print_distances  ; Address: 0x401640
; Intent: Print distances array, showing INF for 0x7FFFFFFF (confidence=0.95). Evidence: format strings "dist[%d] = INF\n" and "dist[%d] = %d\n"
; Preconditions: %dist points to at least %n 32-bit integers; %n >= 0

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00"
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00"

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* %dist, i32 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp sgt i32 %n, 0
  br i1 %cmp0, label %loop, label %exit

loop:
  %i = phi i32 [ 0, %entry ], [ %next, %latch ]
  %idx = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx
  %val = load i32, i32* %elem.ptr, align 4
  %is.inf = icmp eq i32 %val, 2147483647
  br i1 %is.inf, label %then.inf, label %else.val

then.inf:
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %i)
  br label %latch

else.val:
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %i, i32 %val)
  br label %latch

latch:
  %next = add i32 %i, 1
  %cont = icmp slt i32 %next, %n
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}