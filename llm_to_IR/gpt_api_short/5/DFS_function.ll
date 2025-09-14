; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run DFS preorder from 0, and print the order (confidence=0.89). Evidence: call to dfs with matrix pointer and n=7; string "DFS preorder from %zu: "
; Preconditions: dfs(graph, n, start, out, out_len) must write a preorder sequence of size_t to out and set *out_len accordingly (0 <= *out_len <= n).
; Postconditions: Prints the preorder sequence separated by spaces and a trailing newline.

; Only the necessary external declarations:
declare void @dfs(i32*, i64, i64, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_sep_sp = private unnamed_addr constant [2 x i8] c" \00"
@.str_sep_nil = private unnamed_addr constant [1 x i8] c"\00"
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %graph = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8

  ; initialize n=7, start=0, out_len=0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8

  ; zero-initialize graph (49 ints)
  store [49 x i32] zeroinitializer, [49 x i32]* %graph, align 16

  ; set adjacency matrix entries to 1
  %g0 = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0
  ; indices: 1, 2, 7, 10, 11, 14, 19, 22, 29, 33, 37, 39, 41, 47
  %p1 = getelementptr inbounds i32, i32* %g0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %g0, i64 2
  store i32 1, i32* %p2, align 8
  %p7 = getelementptr inbounds i32, i32* %g0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %g0, i64 10
  store i32 1, i32* %p10, align 8
  %p11 = getelementptr inbounds i32, i32* %g0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %g0, i64 14
  store i32 1, i32* %p14, align 8
  %p19 = getelementptr inbounds i32, i32* %g0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %g0, i64 22
  store i32 1, i32* %p22, align 8
  %p29 = getelementptr inbounds i32, i32* %g0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %g0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %g0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %g0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %g0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %g0, i64 47
  store i32 1, i32* %p47, align 4

  ; call dfs(graph, n, start, out, &out_len)
  %nval = load i64, i64* %n, align 8
  %startval = load i64, i64* %start, align 8
  %out_ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %g0, i64 %nval, i64 %startval, i64* %out_ptr, i64* %out_len)

  ; printf header
  %hdrptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %startval2 = load i64, i64* %start, align 8
  %callhdr = call i32 (i8*, ...) @printf(i8* %hdrptr, i64 %startval2)

  ; loop: for (i=0; i<out_len; ++i) printf("%zu%s", out[i], (i+1<out_len)?" ":"");
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i_cur, %len
  br i1 %cmp, label %body, label %after

body:
  %i_next = add i64 %i_cur, 1
  %has_more = icmp ult i64 %i_next, %len
  %sep_sp_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_sep_sp, i64 0, i64 0
  %sep_nil_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_sep_nil, i64 0, i64 0
  %sep = select i1 %has_more, i8* %sep_sp_ptr, i8* %sep_nil_ptr
  %out_elem_ptr = getelementptr inbounds i64, i64* %out_ptr, i64 %i_cur
  %out_elem = load i64, i64* %out_elem_ptr, align 8
  %fmt_item = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %callitem = call i32 (i8*, ...) @printf(i8* %fmt_item, i64 %out_elem, i8* %sep)
  %i_inc = add i64 %i_cur, 1
  store i64 %i_inc, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}