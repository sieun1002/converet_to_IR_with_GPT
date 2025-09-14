; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x14AE
; Intent: Build a 7x7 adjacency matrix, run dfs preorder from 0, and print the order (confidence=0.89). Evidence: call to dfs with (graph,n,start,out,olen), printing "DFS preorder from %zu: " and iterating out array with "%zu%s".
; Preconditions: dfs expects a row-major n x n int (i32) adjacency matrix; out buffer large enough.
; Postconditions: Prints the DFS preorder starting at 0, space-separated on one line.

@.fmt_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.fmt_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.spc = private unnamed_addr constant [2 x i8] c" \00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dfs(i32*, i64, i64, i64*, i64*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %g = alloca [49 x i32], align 16
  %outbuf = alloca [32 x i64], align 16
  %outlen = alloca i64, align 8
  %i = alloca i64, align 8

  ; zero-init graph
  store [49 x i32] zeroinitializer, [49 x i32]* %g
  ; zero-init outlen
  store i64 0, i64* %outlen, align 8

  ; set undirected edges (1 at both (u,v) and (v,u)) in 7x7 adjacency matrix (row-major)
  ; indices: 1, 7, 2, 14, 10, 22, 11, 29, 19, 37, 33, 39, 41, 47
  %gptr0 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 1
  store i32 1, i32* %gptr0, align 4
  %gptr1 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 7
  store i32 1, i32* %gptr1, align 4
  %gptr2 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 2
  store i32 1, i32* %gptr2, align 4
  %gptr3 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 14
  store i32 1, i32* %gptr3, align 4
  %gptr4 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 10
  store i32 1, i32* %gptr4, align 4
  %gptr5 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 22
  store i32 1, i32* %gptr5, align 4
  %gptr6 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 11
  store i32 1, i32* %gptr6, align 4
  %gptr7 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 29
  store i32 1, i32* %gptr7, align 4
  %gptr8 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 19
  store i32 1, i32* %gptr8, align 4
  %gptr9 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 37
  store i32 1, i32* %gptr9, align 4
  %gptr10 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 33
  store i32 1, i32* %gptr10, align 4
  %gptr11 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 39
  store i32 1, i32* %gptr11, align 4
  %gptr12 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 41
  store i32 1, i32* %gptr12, align 4
  %gptr13 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 47
  store i32 1, i32* %gptr13, align 4

  ; call dfs(graph, n=7, start=0, outbuf, &outlen)
  %gbase = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 0
  %outbase = getelementptr inbounds [32 x i64], [32 x i64]* %outbuf, i64 0, i64 0
  call void @dfs(i32* %gbase, i64 7, i64 0, i64* %outbase, i64* %outlen)

  ; printf("DFS preorder from %zu: ", 0)
  %hdrptr = getelementptr inbounds [24 x i8], [24 x i8]* @.fmt_hdr, i64 0, i64 0
  %printf_hdr = call i32 (i8*, ...) @printf(i8* %hdrptr, i64 0)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %len = load i64, i64* %outlen, align 8
  %cmp = icmp ult i64 %i.val, %len
  br i1 %cmp, label %body, label %done

body:
  ; choose separator: " " if i+1 < len else ""
  %ip1 = add i64 %i.val, 1
  %hasnext = icmp ult i64 %ip1, %len
  %spcptr = getelementptr inbounds [2 x i8], [2 x i8]* @.spc, i64 0, i64 0
  %emptyptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sep = select i1 %hasnext, i8* %spcptr, i8* %emptyptr

  ; load outbuf[i]
  %outeltptr = getelementptr inbounds [32 x i64], [32 x i64]* %outbuf, i64 0, i64 %i.val
  %val = load i64, i64* %outeltptr, align 8

  ; printf("%zu%s", val, sep)
  %fmtptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_item, i64 0, i64 0
  %printf_item = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %val, i8* %sep)

  ; i++
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  ; newline
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}