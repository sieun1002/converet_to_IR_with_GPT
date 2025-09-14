; ModuleID = 'dfs_module'
source_filename = "dfs_module"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %outCount) {
entry:
  %nIsZero = icmp eq i64 %n, 0
  br i1 %nIsZero, label %invalid, label %checkStart

checkStart:                                         ; preds = %entry
  %startLt = icmp ult i64 %start, %n
  br i1 %startLt, label %alloc, label %invalid

invalid:                                            ; preds = %entry, %checkStart, %alloc_fail
  store i64 0, i64* %outCount, align 8
  ret void

alloc:                                              ; preds = %checkStart
  %sizeVisited = shl i64 %n, 2
  %p1 = call i8* @malloc(i64 %sizeVisited)
  %visited = bitcast i8* %p1 to i32*
  %sizeNext = shl i64 %n, 3
  %p2 = call i8* @malloc(i64 %sizeNext)
  %nextIdx = bitcast i8* %p2 to i64*
  %p3 = call i8* @malloc(i64 %sizeNext)
  %stack = bitcast i8* %p3 to i64*
  %vnull = icmp eq i32* %visited, null
  %nnull = icmp eq i64* %nextIdx, null
  %tmp_or = or i1 %vnull, %nnull
  %snull = icmp eq i64* %stack, null
  %anynull = or i1 %tmp_or, %snull
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:                                         ; preds = %alloc
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  br label %invalid

init:                                               ; preds = %alloc
  br label %init_loop

init_loop:                                          ; preds = %init_loop_body_end, %init
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body_end ]
  %condInit = icmp ult i64 %i, %n
  br i1 %condInit, label %init_loop_body, label %start_dfs

init_loop_body:                                     ; preds = %init_loop
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %nptr, align 8
  br label %init_loop_body_end

init_loop_body_end:                                 ; preds = %init_loop_body
  %i.next = add i64 %i, 1
  br label %init_loop

start_dfs:                                          ; preds = %init_loop
  store i64 0, i64* %outCount, align 8
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8
  %vptr_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vptr_start, align 4
  %cnt0 = load i64, i64* %outCount, align 8
  %outidx0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %outidx0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %outCount, align 8
  br label %loop

loop:                                               ; preds = %loop_iter, %start_dfs
  %depth.phi = phi i64 [ 1, %start_dfs ], [ %depth.next, %loop_iter ]
  %nonzero = icmp ne i64 %depth.phi, 0
  br i1 %nonzero, label %iter, label %cleanup

iter:                                               ; preds = %loop
  %topIndex = sub i64 %depth.phi, 1
  %topPtr = getelementptr inbounds i64, i64* %stack, i64 %topIndex
  %curr = load i64, i64* %topPtr, align 8
  %idxptr = getelementptr inbounds i64, i64* %nextIdx, i64 %curr
  %idx = load i64, i64* %idxptr, align 8
  br label %for

for:                                                ; preds = %for_body_end, %iter
  %j = phi i64 [ %idx, %iter ], [ %j.next, %for_body_end ]
  %cond = icmp ult i64 %j, %n
  br i1 %cond, label %for_body, label %no_more_neighbors

for_body:                                           ; preds = %for
  %rowMul = mul i64 %curr, %n
  %flat = add i64 %rowMul, %j
  %cellPtr = getelementptr inbounds i32, i32* %adj, i64 %flat
  %cell = load i32, i32* %cellPtr, align 4
  %hasEdge = icmp ne i32 %cell, 0
  br i1 %hasEdge, label %check_unvisited, label %for_body_skip

check_unvisited:                                    ; preds = %for_body
  %vptr_j = getelementptr inbounds i32, i32* %visited, i64 %j
  %v_j = load i32, i32* %vptr_j, align 4
  %unvis = icmp eq i32 %v_j, 0
  br i1 %unvis, label %take_edge, label %for_body_skip

take_edge:                                          ; preds = %check_unvisited
  %jplus = add i64 %j, 1
  store i64 %jplus, i64* %idxptr, align 8
  store i32 1, i32* %vptr_j, align 4
  %cntA = load i64, i64* %outCount, align 8
  %cntA1 = add i64 %cntA, 1
  store i64 %cntA1, i64* %outCount, align 8
  %outPtrA = getelementptr inbounds i64, i64* %out, i64 %cntA
  store i64 %j, i64* %outPtrA, align 8
  %pushIndex = getelementptr inbounds i64, i64* %stack, i64 %depth.phi
  store i64 %j, i64* %pushIndex, align 8
  %depth.inc = add i64 %depth.phi, 1
  br label %loop_iter

for_body_skip:                                      ; preds = %check_unvisited, %for_body
  %j.next = add i64 %j, 1
  br label %for_body_end

for_body_end:                                       ; preds = %for_body_skip
  br label %for

no_more_neighbors:                                  ; preds = %for
  %depth.dec = sub i64 %depth.phi, 1
  br label %loop_iter

loop_iter:                                          ; preds = %no_more_neighbors, %take_edge
  %depth.next = phi i64 [ %depth.inc, %take_edge ], [ %depth.dec, %no_more_neighbors ]
  br label %loop

cleanup:                                            ; preds = %loop
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  ret void
}