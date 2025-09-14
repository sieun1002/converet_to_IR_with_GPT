; ModuleID = 'print_distances'
source_filename = "print_distances.ll"
target triple = "x86_64-unknown-linux-gnu"

@format_inf = private unnamed_addr constant [18 x i8] c"dist[%d] = INF\0A\00", align 1
@format_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  %dist.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %dist, i32** %dist.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %cmp = icmp slt i32 %i.val, %n.val
  br i1 %cmp, label %body, label %exit

body:
  %dist.ptr = load i32*, i32** %dist.addr, align 8
  %idx.sext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %idx.sext
  %elem = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %elem, 2147483647
  br i1 %isinf, label %then.inf, label %else.val

then.inf:
  %fmt1 = getelementptr inbounds [18 x i8], [18 x i8]* @format_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i.val)
  br label %inc

else.val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @format_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i.val, i32 %elem)
  br label %inc

inc:
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

exit:
  ret void
}