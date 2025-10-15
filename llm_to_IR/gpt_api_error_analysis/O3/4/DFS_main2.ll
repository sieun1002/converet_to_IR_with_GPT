; ModuleID = 'dfs_preorder.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

@adj = private unnamed_addr constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 1, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 1, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]
], align 4

declare i8* @calloc(i64, i64) nounwind
declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %out = alloca [7 x i64], align 16
  %visited_raw = call i8* @calloc(i64 28, i64 1)
  %visited = bitcast i8* %visited_raw to i32*
  %next_raw = call i8* @calloc(i64 56, i64 1)
  %next = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 56)
  %stack = bitcast i8* %stack_raw to i64*
  %vnull = icmp eq i8* %visited_raw, null
  %nnull = icmp eq i8* %next_raw, null
  %snull = icmp eq i8* %stack_raw, null
  %tmp.and1 = or i1 %vnull, %nnull
  %anynull = or i1 %tmp.and1, %snull
  br i1 %anynull, label %fail, label %init

init:
  %stack0ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 0, i64* %stack0ptr, align 8
  %visit0ptr = getelementptr inbounds i32, i32* %visited, i64 0
  store i32 1, i32* %visit0ptr, align 4
  %out0ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  store i64 0, i64* %out0ptr, align 8
  br label %loop

loop:
  %d = phi i64 [ 1, %init ], [ %d_dec, %pop ], [ %d, %inc_ni ], [ %d_inc, %push ]
  %c = phi i64 [ 1, %init ], [ %c, %pop ], [ %c, %inc_ni ], [ %c_inc, %push ]
  %iszero = icmp eq i64 %d, 0
  br i1 %iszero, label %end, label %top

top:
  %d_minus = add nsw i64 %d, -1
  %stkptr = getelementptr inbounds i64, i64* %stack, i64 %d_minus
  %cur = load i64, i64* %stkptr, align 8
  %nptr = getelementptr inbounds i64, i64* %next, i64 %cur
  %ni = load i64, i64* %nptr, align 8
  %cmp_ni = icmp ugt i64 %ni, 6
  br i1 %cmp_ni, label %pop, label %check_adj

check_adj:
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %cur
  %cellptr = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %ni
  %aval = load i32, i32* %cellptr, align 4
  %hasEdge = icmp ne i32 %aval, 0
  br i1 %hasEdge, label %check_visit, label %inc_ni

check_visit:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %ni
  %vval = load i32, i32* %vptr, align 4
  %isVisited = icmp ne i32 %vval, 0
  br i1 %isVisited, label %inc_ni, label %push

inc_ni:
  %ni_inc = add nuw nsw i64 %ni, 1
  store i64 %ni_inc, i64* %nptr, align 8
  br label %loop

push:
  %outptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %c
  store i64 %ni, i64* %outptr, align 8
  %c_inc = add nuw nsw i64 %c, 1
  %stkpushptr = getelementptr inbounds i64, i64* %stack, i64 %d
  store i64 %ni, i64* %stkpushptr, align 8
  %d_inc = add nuw nsw i64 %d, 1
  %ni_inc2 = add nuw nsw i64 %ni, 1
  store i64 %ni_inc2, i64* %nptr, align 8
  store i32 1, i32* %vptr, align 4
  br label %loop

pop:
  %d_dec = add nsw i64 %d, -1
  br label %loop

end:
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %callhdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1, i64 0)
  %c_is_zero = icmp eq i64 %c, 0
  br i1 %c_is_zero, label %print_nl, label %print_first

print_first:
  %val0ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %val0 = load i64, i64* %val0ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %val0, i8* %empty)
  %c_eq1 = icmp eq i64 %c, 1
  br i1 %c_eq1, label %print_nl, label %print_loop

print_loop:
  br label %pl_head

pl_head:
  %i = phi i64 [ 1, %print_loop ], [ %i_next, %pl_body ]
  %cond = icmp ult i64 %i, %c
  br i1 %cond, label %pl_body, label %print_nl

pl_body:
  %valiptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %i
  %vali = load i64, i64* %valiptr, align 8
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %calli = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %vali, i8* %space)
  %i_next = add nuw nsw i64 %i, 1
  br label %pl_head

print_nl:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  ret i32 0

fail:
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  %fmt1_f = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %callhdr_f = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1_f, i64 0)
  br label %print_nl
}