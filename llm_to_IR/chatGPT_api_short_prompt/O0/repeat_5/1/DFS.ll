; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 grid with marked cells, call dfs to produce a preorder from start=0, and print it. (confidence=0.78). Evidence: dfs(out,out_len) pattern and printing "%zu%s" with conditional space and header "DFS preorder from %zu: ".
; Preconditions: None
; Postconditions: Prints DFS preorder and a trailing newline; returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %grid = alloca [49 x i32], align 16
  %out = alloca [33 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 7, i64* %n, align 8

  ; zero grid (49 * 4 = 196 bytes)
  %grid.base = getelementptr inbounds [49 x i32], [49 x i32]* %grid, i64 0, i64 0
  %grid.i8 = bitcast i32* %grid.base to i8*
  call void @llvm.memset.p0i8.i64(i8* %grid.i8, i8 0, i64 196, i1 false)

  ; set marked cells to 1
  %p1 = getelementptr inbounds i32, i32* %grid.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %grid.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %grid.base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %grid.base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %grid.base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %grid.base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %grid.base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %grid.base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %grid.base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %grid.base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %grid.base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %grid.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %grid.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %grid.base, i64 47
  store i32 1, i32* %p47, align 4

  ; init start and out_len
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; call dfs(grid, n, start, out, &out_len)
  %out.base = getelementptr inbounds [33 x i64], [33 x i64]* %out, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %grid.base, i64 %n.val, i64 %start.val, i64* %out.base, i64* %out_len)

  ; printf("DFS preorder from %zu: ", start)
  %fmt.pre = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.pre = call i32 (i8*, ...) @printf(i8* %fmt.pre, i64 %start.print)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", out[i], i+1 < out_len ? " " : "")
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %sep_join, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %out_len, align 8
  %cont = icmp ult i64 %i.cur, %len.cur
  br i1 %cont, label %body, label %done

body:                                             ; preds = %loop
  %i.next = add i64 %i.cur, 1
  %len2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %i.next, %len2
  br i1 %has_space, label %sep_space, label %sep_empty

sep_space:                                        ; preds = %body
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %sep_join

sep_empty:                                        ; preds = %body
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %sep_join

sep_join:                                         ; preds = %sep_empty, %sep_space
  %sep = phi i8* [ %space.ptr, %sep_space ], [ %empty.ptr, %sep_empty ]
  %val.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8
  %fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call.print = call i32 (i8*, ...) @printf(i8* %fmt, i64 %val, i8* %sep)
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}