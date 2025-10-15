; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out0 = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0

  ; zero initialize adjacency matrix: 7*7 = 49 ints
  %total = mul i64 7, 7
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcmp = icmp ult i64 %zi, %total
  br i1 %zcmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %zptr = getelementptr inbounds i32, i32* %adj0, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  ; precompute multiples of n (n = 7)
  %twoN = add i64 7, 7
  %threeN = add i64 %twoN, 7
  %fourN = shl i64 7, 2
  %fiveN = add i64 %fourN, 7
  %sixN = add i64 %threeN, %threeN

  ; set edges (store 1s) at computed indices
  %idx1 = mul i64 7, 1
  %p1 = getelementptr inbounds i32, i32* %adj0, i64 %idx1
  store i32 1, i32* %p1, align 4

  %p2 = getelementptr inbounds i32, i32* %adj0, i64 %twoN
  store i32 1, i32* %p2, align 4

  %idx3 = add i64 7, 3
  %p3 = getelementptr inbounds i32, i32* %adj0, i64 %idx3
  store i32 1, i32* %p3, align 4

  %idx4 = add i64 %threeN, 1
  %p4 = getelementptr inbounds i32, i32* %adj0, i64 %idx4
  store i32 1, i32* %p4, align 4

  %idx5 = add i64 7, 4
  %p5 = getelementptr inbounds i32, i32* %adj0, i64 %idx5
  store i32 1, i32* %p5, align 4

  %idx6 = add i64 %fourN, 1
  %p6 = getelementptr inbounds i32, i32* %adj0, i64 %idx6
  store i32 1, i32* %p6, align 4

  %idx7 = add i64 %twoN, 5
  %p7 = getelementptr inbounds i32, i32* %adj0, i64 %idx7
  store i32 1, i32* %p7, align 4

  %idx8 = add i64 %fiveN, 2
  %p8 = getelementptr inbounds i32, i32* %adj0, i64 %idx8
  store i32 1, i32* %p8, align 4

  %idx9 = add i64 %fourN, 5
  %p9 = getelementptr inbounds i32, i32* %adj0, i64 %idx9
  store i32 1, i32* %p9, align 4

  %idx10 = add i64 %fiveN, 4
  %p10 = getelementptr inbounds i32, i32* %adj0, i64 %idx10
  store i32 1, i32* %p10, align 4

  %idx11 = add i64 %fiveN, 6
  %p11 = getelementptr inbounds i32, i32* %adj0, i64 %idx11
  store i32 1, i32* %p11, align 4

  %idx12 = add i64 %sixN, 5
  %p12 = getelementptr inbounds i32, i32* %adj0, i64 %idx12
  store i32 1, i32* %p12, align 4

  ; out_len = 0
  store i64 0, i64* %out_len, align 8

  ; call dfs(&adj[0], n=7, start=0, out, &out_len)
  call void @dfs(i32* %adj0, i64 7, i64 0, i64* %out0, i64* %out_len)

  ; printf("DFS preorder from %zu: ", 0)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %ph1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)

  br label %print.cond

print.cond:                                       ; preds = %print.body, %zero.end
  %i = phi i64 [ 0, %zero.end ], [ %i.next, %print.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %loop.cont = icmp ult i64 %i, %len.cur
  br i1 %loop.cont, label %print.body, label %print.end

print.body:                                       ; preds = %print.cond
  %i.plus1 = add i64 %i, 1
  %len.cur2 = load i64, i64* %out_len, align 8
  %has_more = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr

  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8

  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %ph2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %delim)

  %i.next = add i64 %i, 1
  br label %print.cond

print.end:                                        ; preds = %print.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}