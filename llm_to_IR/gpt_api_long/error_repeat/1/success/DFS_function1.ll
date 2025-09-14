; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x14AE
; Intent: Build a small adjacency bitmap and run dfs to produce a preorder from 0, then print it (confidence=0.62). Evidence: sets specific indices of an i32 array to 1; calls dfs with (graph ptr, n=7, start=0, out buf, out count); prints "DFS preorder from %zu:" and a sequence.
; Preconditions: dfs interprets the i32 array as a graph description for n=7 and appends preorder nodes to out, updating out_len.
; Postconditions: Prints the preorder as size_t values separated by spaces and a trailing newline.

@.str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

; Only the needed extern declarations:
declare void @dfs(i32* noundef, i64 noundef, i64 noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %a = alloca [49 x i32], align 16
  %out = alloca [64 x i64], align 16
  %out_len = alloca i64, align 8

  store [49 x i32] zeroinitializer, [49 x i32]* %a, align 16
  store [64 x i64] zeroinitializer, [64 x i64]* %out, align 16
  store i64 0, i64* %out_len, align 8

  %a.base = getelementptr inbounds [49 x i32], [49 x i32]* %a, i64 0, i64 0
  ; a[1] = 1
  %p1 = getelementptr inbounds i32, i32* %a.base, i64 1
  store i32 1, i32* %p1, align 4
  ; a[2] = 1
  %p2 = getelementptr inbounds i32, i32* %a.base, i64 2
  store i32 1, i32* %p2, align 4

  ; n = 7
  %n = add i64 0, 7

  ; a[n] = 1
  %pn = getelementptr inbounds i32, i32* %a.base, i64 %n
  store i32 1, i32* %pn, align 4
  ; a[2n] = 1
  %mul2 = shl i64 %n, 1
  %p2n = getelementptr inbounds i32, i32* %a.base, i64 %mul2
  store i32 1, i32* %p2n, align 4
  ; a[n+3] = 1
  %n_plus_3 = add i64 %n, 3
  %pn3 = getelementptr inbounds i32, i32* %a.base, i64 %n_plus_3
  store i32 1, i32* %pn3, align 4
  ; a[3n+1] = 1
  %mul3 = mul i64 %n, 3
  %m3p1 = add i64 %mul3, 1
  %p3n1 = getelementptr inbounds i32, i32* %a.base, i64 %m3p1
  store i32 1, i32* %p3n1, align 4
  ; a[n+4] = 1
  %n_plus_4 = add i64 %n, 4
  %pn4 = getelementptr inbounds i32, i32* %a.base, i64 %n_plus_4
  store i32 1, i32* %pn4, align 4
  ; a[4n+1] = 1
  %mul4 = shl i64 %n, 2
  %m4p1 = add i64 %mul4, 1
  %p4n1 = getelementptr inbounds i32, i32* %a.base, i64 %m4p1
  store i32 1, i32* %p4n1, align 4
  ; a[2n+5] = 1
  %m2p5 = add i64 %mul2, 5
  %p2n5 = getelementptr inbounds i32, i32* %a.base, i64 %m2p5
  store i32 1, i32* %p2n5, align 4
  ; a[5n+2] = 1
  %m5 = add i64 %mul4, %n
  %m5p2 = add i64 %m5, 2
  %p5n2 = getelementptr inbounds i32, i32* %a.base, i64 %m5p2
  store i32 1, i32* %p5n2, align 4
  ; a[4n+5] = 1
  %m4p5 = add i64 %mul4, 5
  %p4n5 = getelementptr inbounds i32, i32* %a.base, i64 %m4p5
  store i32 1, i32* %p4n5, align 4
  ; a[5n+4] = 1
  %m5p4 = add i64 %m5, 4
  %p5n4 = getelementptr inbounds i32, i32* %a.base, i64 %m5p4
  store i32 1, i32* %p5n4, align 4
  ; a[5n+6] = 1
  %m5p6 = add i64 %m5, 6
  %p5n6 = getelementptr inbounds i32, i32* %a.base, i64 %m5p6
  store i32 1, i32* %p5n6, align 4
  ; a[6n+5] = 1
  %mul6 = mul i64 %n, 6
  %m6p5 = add i64 %mul6, 5
  %p6n5 = getelementptr inbounds i32, i32* %a.base, i64 %m6p5
  store i32 1, i32* %p6n5, align 4

  ; call dfs(graph=&a[0], n=7, start=0, out=&out[0], out_len=&out_len)
  %out.base = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* noundef %a.base, i64 noundef %n, i64 noundef 0, i64* noundef %out.base, i64* noundef %out_len)

  ; printf("DFS preorder from %zu: ", 0)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* noundef %hdr.ptr, i64 noundef 0)

  ; loop to print out sequence
  %len0 = load i64, i64* %out_len, align 8
  br label %loop

loop:                                             ; preds = %entry, %loop.body
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.phi = phi i64 [ %len0, %entry ], [ %len.phi, %loop.body ]
  %cmp = icmp ult i64 %i, %len.phi
  br i1 %cmp, label %loop.body, label %done

loop.body:                                        ; preds = %loop
  %i.plus1 = add i64 %i, 1
  %is_last = icmp uge i64 %i.plus1, %len.phi
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %is_last, i8* %empty.ptr, i8* %space.ptr

  %val.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call_item = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i64 noundef %val, i8* noundef %sep)

  %i.next = add i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}