; ModuleID = 'dfs_preorder_main'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt    = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space  = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty  = private unnamed_addr constant [1 x i8] c"\00", align 1

declare void @dfs(i32* nocapture, i64, i64, i64* nocapture, i64* nocapture) nounwind
declare i32 @printf(i8* nocapture readonly, ...) nounwind
declare i32 @putchar(i32) nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) nounwind

define i32 @main() {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %start = alloca i64, align 8

  ; start = 0, len = 0
  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  ; zero adjacency matrix: 49 * 4 = 196 bytes
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; base pointers
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0

  ; n = 7
  %n = add i64 0, 7

  ; set edges (column-major indices = row + col * n)
  ; idx1 = n
  %idx1.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %n
  store i32 1, i32* %idx1.ptr, align 4

  ; idx2 = 2*n
  %idx2 = shl i64 %n, 1
  %idx2.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx2
  store i32 1, i32* %idx2.ptr, align 4

  ; idx3 = n + 3
  %idx3 = add i64 %n, 3
  %idx3.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx3
  store i32 1, i32* %idx3.ptr, align 4

  ; idx4 = 3*n + 1
  %idx4.t1 = shl i64 %n, 1
  %idx4.t2 = add i64 %idx4.t1, %n
  %idx4 = add i64 %idx4.t2, 1
  %idx4.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx4
  store i32 1, i32* %idx4.ptr, align 4

  ; idx5 = n + 4
  %idx5 = add i64 %n, 4
  %idx5.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx5
  store i32 1, i32* %idx5.ptr, align 4

  ; idx6 = 4*n + 1
  %idx6.t1 = shl i64 %n, 2
  %idx6 = add i64 %idx6.t1, 1
  %idx6.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx6
  store i32 1, i32* %idx6.ptr, align 4

  ; idx7 = 2*n + 5
  %idx7.t1 = shl i64 %n, 1
  %idx7 = add i64 %idx7.t1, 5
  %idx7.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx7
  store i32 1, i32* %idx7.ptr, align 4

  ; idx8 = 5*n + 2
  %idx8.t1 = shl i64 %n, 2
  %idx8.t2 = add i64 %idx8.t1, %n
  %idx8 = add i64 %idx8.t2, 2
  %idx8.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx8
  store i32 1, i32* %idx8.ptr, align 4

  ; idx9 = 4*n + 5
  %idx9.t1 = shl i64 %n, 2
  %idx9 = add i64 %idx9.t1, 5
  %idx9.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx9
  store i32 1, i32* %idx9.ptr, align 4

  ; idx10 = 5*n + 4
  %idx10.t1 = shl i64 %n, 2
  %idx10.t2 = add i64 %idx10.t1, %n
  %idx10 = add i64 %idx10.t2, 4
  %idx10.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx10
  store i32 1, i32* %idx10.ptr, align 4

  ; idx11 = 5*n + 6
  %idx11.t1 = shl i64 %n, 2
  %idx11.t2 = add i64 %idx11.t1, %n
  %idx11 = add i64 %idx11.t2, 6
  %idx11.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx11
  store i32 1, i32* %idx11.ptr, align 4

  ; idx12 = 6*n + 5
  %idx12.t1 = add i64 %n, %n          ; 2n
  %idx12.t2 = add i64 %idx12.t1, %n    ; 3n
  %idx12.t3 = shl i64 %idx12.t2, 1     ; 6n
  %idx12 = add i64 %idx12.t3, 5
  %idx12.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx12
  store i32 1, i32* %idx12.ptr, align 4

  ; call dfs(adj, n, start, order, &len)
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj.base, i64 %n, i64 %start.val, i64* %order.base, i64* %len)

  ; printf("DFS preorder from %zu: ", start)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %_p0 = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 %start.val)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.cur
  br i1 %cmp, label %body, label %done

body:
  %i.plus1 = add i64 %i, 1
  %len.sep = load i64, i64* %len, align 8
  %has_next = icmp ult i64 %i.plus1, %len.sep
  br i1 %has_next, label %use_space, label %use_empty

use_space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %after_sep

use_empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %after_sep

after_sep:
  %sep = phi i8* [ %space.ptr, %use_space ], [ %empty.ptr, %use_empty ]
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %_p1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %elem, i8* %sep)
  %i.next = add i64 %i, 1
  br label %after_print

after_print:
  br label %loop

done:
  %_pc = call i32 @putchar(i32 10)
  ret i32 0
}