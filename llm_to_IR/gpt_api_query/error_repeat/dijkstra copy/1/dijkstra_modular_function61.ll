; ModuleID = 'print_distances'
target triple = "x86_64-pc-linux-gnu"

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

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
  %cond = icmp slt i32 %i.val, %n.val
  br i1 %cond, label %body, label %end

body:
  %dist.ptr = load i32*, i32** %dist.addr, align 8
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist.ptr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %elem, 2147483647
  br i1 %isinf, label %if.inf, label %if.val

if.inf:
  %i.for.print1 = load i32, i32* %i, align 4
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i.for.print1)
  br label %inc

if.val:
  %i.for.print2 = load i32, i32* %i, align 4
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i.for.print2, i32 %elem)
  br label %inc

inc:
  %i.old = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

end:
  ret void
}