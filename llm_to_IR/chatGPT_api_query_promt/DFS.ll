; ModuleID = 'dfs_preorder.ll'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_hdr = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.sp = private unnamed_addr constant [2 x i8] c" \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %A = alloca [7 x [7 x i32]], align 16
  %out = alloca [8 x i64], align 16
  %sTop = alloca i64, align 8
  %outCnt = alloca i64, align 8
  %cur = alloca i64, align 8

  %Acast = bitcast [7 x [7 x i32]]* %A to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %Acast, i8 0, i64 196, i1 false)

  ; Edges (undirected) for 7-node graph
  ; 0-1, 0-2
  %A0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 0
  %A01 = getelementptr inbounds [7 x i32], [7 x i32]* %A0, i64 0, i64 1
  store i32 1, i32* %A01, align 4
  %A02 = getelementptr inbounds [7 x i32], [7 x i32]* %A0, i64 0, i64 2
  store i32 1, i32* %A02, align 4

  ; 1-0, 1-3, 1-4
  %A1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 1
  %A10 = getelementptr inbounds [7 x i32], [7 x i32]* %A1, i64 0, i64 0
  store i32 1, i32* %A10, align 4
  %A13 = getelementptr inbounds [7 x i32], [7 x i32]* %A1, i64 0, i64 3
  store i32 1, i32* %A13, align 4
  %A14 = getelementptr inbounds [7 x i32], [7 x i32]* %A1, i64 0, i64 4
  store i32 1, i32* %A14, align 4

  ; 2-0, 2-5
  %A2 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 2
  %A20 = getelementptr inbounds [7 x i32], [7 x i32]* %A2, i64 0, i64 0
  store i32 1, i32* %A20, align 4
  %A25 = getelementptr inbounds [7 x i32], [7 x i32]* %A2, i64 0, i64 5
  store i32 1, i32* %A25, align 4

  ; 3-1
  %A3 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 3
  %A31 = getelementptr inbounds [7 x i32], [7 x i32]* %A3, i64 0, i64 1
  store i32 1, i32* %A31, align 4

  ; 4-1, 4-5
  %A4 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 4
  %A41 = getelementptr inbounds [7 x i32], [7 x i32]* %A4, i64 0, i64 1
  store i32 1, i32* %A41, align 4
  %A45 = getelementptr inbounds [7 x i32], [7 x i32]* %A4, i64 0, i64 5
  store i32 1, i32* %A45, align 4

  ; 5-2, 5-4, 5-6
  %A5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 5
  %A52 = getelementptr inbounds [7 x i32], [7 x i32]* %A5, i64 0, i64 2
  store i32 1, i32* %A52, align 4
  %A54 = getelementptr inbounds [7 x i32], [7 x i32]* %A5, i64 0, i64 4
  store i32 1, i32* %A54, align 4
  %A56 = getelementptr inbounds [7 x i32], [7 x i32]* %A5, i64 0, i64 6
  store i32 1, i32* %A56, align 4

  ; 6-5
  %A6 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 6
  %A65 = getelementptr inbounds [7 x i32], [7 x i32]* %A6, i64 0, i64 5
  store i32 1, i32* %A65, align 4

  ; Allocate arrays
  %vraw = call i8* @calloc(i64 7, i64 4)
  %visited = bitcast i8* %vraw to i32*
  %ci_raw = call i8* @calloc(i64 7, i64 8)
  %curIdx = bitcast i8* %ci_raw to i64*
  %stk_raw = call i8* @malloc(i64 56)
  %stack = bitcast i8* %stk_raw to i64*

  ; Null checks
  %vnull = icmp eq i8* %vraw, null
  %cinull = icmp eq i8* %ci_raw, null
  %snull = icmp eq i8* %stk_raw, null
  %t1 = or i1 %vnull, %cinull
  %anynull = or i1 %t1, %snull
  br i1 %anynull, label %alloc_fail, label %ok

alloc_fail:
  call void @free(i8* %vraw)
  call void @free(i8* %ci_raw)
  call void @free(i8* %stk_raw)
  %hdrp0 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %_p0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdrp0, i64 0)
  br label %print_nl

ok:
  ; Initialize traversal
  store i32 1, i32* %visited, align 4              ; visited[0] = 1
  %out0 = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  store i64 0, i64* %out0, align 8                 ; out[0] = 0
  store i64 1, i64* %sTop, align 8
  store i64 1, i64* %outCnt, align 8
  %s0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 0, i64* %s0, align 8
  store i64 0, i64* %cur, align 8
  br label %loop

loop:
  %c = load i64, i64* %cur, align 8
  %kinit_ptr = getelementptr inbounds i64, i64* %curIdx, i64 %c
  %kinit = load i64, i64* %kinit_ptr, align 8
  br label %scan_hdr

scan_hdr:
  %kphi = phi i64 [ %kinit, %loop ], [ %kinc, %scan_next ]
  %klt = icmp ult i64 %kphi, 7
  br i1 %klt, label %scan_body, label %pop

scan_body:
  %Arow = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %A, i64 0, i64 %c
  %Aelem = getelementptr inbounds [7 x i32], [7 x i32]* %Arow, i64 0, i64 %kphi
  %aval = load i32, i32* %Aelem, align 4
  %anonz = icmp ne i32 %aval, 0
  br i1 %anonz, label %check_vis, label %scan_next

check_vis:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %kphi
  %vval = load i32, i32* %vptr, align 4
  %vis0 = icmp eq i32 %vval, 0
  br i1 %vis0, label %discover, label %scan_next

scan_next:
  %kinc = add i64 %kphi, 1
  br label %scan_hdr

discover:
  ; push kphi onto stack
  %sTopVal = load i64, i64* %sTop, align 8
  %dst = getelementptr inbounds i64, i64* %stack, i64 %sTopVal
  store i64 %kphi, i64* %dst, align 8
  %sTopNew = add i64 %sTopVal, 1
  store i64 %sTopNew, i64* %sTop, align 8

  ; record in out
  %outIdx = load i64, i64* %outCnt, align 8
  %outSlot = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %outIdx
  store i64 %kphi, i64* %outSlot, align 8
  %outNew = add i64 %outIdx, 1
  store i64 %outNew, i64* %outCnt, align 8

  ; curIdx[c] = kphi + 1
  %kplus = add i64 %kphi, 1
  store i64 %kplus, i64* %kinit_ptr, align 8

  ; visited[kphi] = 1
  store i32 1, i32* %vptr, align 4

  ; current = kphi
  store i64 %kphi, i64* %cur, align 8
  br label %loop

pop:
  ; sTop--
  %sTopNow = load i64, i64* %sTop, align 8
  %sTopDec = add i64 %sTopNow, -1
  store i64 %sTopDec, i64* %sTop, align 8
  %isEmpty = icmp eq i64 %sTopDec, 0
  br i1 %isEmpty, label %done_traversal, label %resume

resume:
  ; current = stack[sTop-1]
  %idx = add i64 %sTopDec, -1
  %src = getelementptr inbounds i64, i64* %stack, i64 %idx
  %prev = load i64, i64* %src, align 8
  store i64 %prev, i64* %cur, align 8
  br label %loop

done_traversal:
  ; free resources before printing
  call void @free(i8* %vraw)
  call void @free(i8* %ci_raw)
  call void @free(i8* %stk_raw)

  ; print header with start node 0
  %hdrp = getelementptr inbounds [24 x i8], [24 x i8]* @.str_hdr, i64 0, i64 0
  %_p1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdrp, i64 0)

  ; if outCnt == 0, just newline
  %count = load i64, i64* %outCnt, align 8
  %isZero = icmp eq i64 %count, 0
  br i1 %isZero, label %print_nl, label %print_loop_init

print_loop_init:
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %print_loop

print_loop:
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, %count
  br i1 %cmp, label %print_body, label %print_nl

print_body:
  %next = add i64 %iv, 1
  %isLast = icmp eq i64 %next, %count
  %delim = select i1 %isLast, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.sp, i64 0, i64 0)
  %ovalptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %iv
  %oval = load i64, i64* %ovalptr, align 8
  %pairp = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %_p2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %pairp, i64 %oval, i8* %delim)
  store i64 %next, i64* %i, align 8
  br label %print_loop

print_nl:
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %_p3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlp)
  ret i32 0
}