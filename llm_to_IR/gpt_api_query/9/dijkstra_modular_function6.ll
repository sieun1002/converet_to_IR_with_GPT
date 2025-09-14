; target triple optional; LLVM 14 compatible IR

@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00"
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00"

declare i32 @printf(i8*, ...)

define dso_local void @print_distances(i32* %dist, i32 %n) {
entry:
  %dist.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %dist, i32** %dist.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %nval = load i32, i32* %n.addr, align 4
  %cond = icmp slt i32 %iv, %nval
  br i1 %cond, label %body, label %exit

body:
  %distptr = load i32*, i32** %dist.addr, align 8
  %idxext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds i32, i32* %distptr, i64 %idxext
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %if.inf, label %if.val

if.inf:
  %fmt.inf = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %iv2 = load i32, i32* %i, align 4
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf, i32 %iv2)
  br label %inc

if.val:
  %fmt.val = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %iv3 = load i32, i32* %i, align 4
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val, i32 %iv3, i32 %val)
  br label %inc

inc:
  %iv4 = load i32, i32* %i, align 4
  %inc1 = add nsw i32 %iv4, 1
  store i32 %inc1, i32* %i, align 4
  br label %loop

exit:
  ret void
}