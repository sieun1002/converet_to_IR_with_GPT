; ModuleID = 'merge_sort_module'
source_filename = "merge_sort"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* nocapture noundef %dest, i64 noundef %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:
  %sizeBytes = shl i64 %n, 2
  %tmp_i8 = call noalias i8* @malloc(i64 %sizeBytes)
  %tmp = bitcast i8* %tmp_i8 to i32*
  %isnull = icmp eq i32* %tmp, null
  br i1 %isnull, label %ret, label %outer

outer:
  %run = phi i64 [ 1, %alloc ], [ %runNext, %afterInner ]
  %src = phi i32* [ %dest, %alloc ], [ %outAfter, %afterInner ]
  %out = phi i32* [ %tmp, %alloc ], [ %srcAfter, %afterInner ]
  %condOuter = icmp ult i64 %run, %n
  br i1 %condOuter, label %inner.pre, label %afterOuter

inner.pre:
  %stride = shl i64 %run, 1
  br label %inner

inner:
  %base = phi i64 [ 0, %inner.pre ], [ %baseNext, %afterMerge ]
  %cmpBase = icmp ult i64 %base, %n
  br i1 %cmpBase, label %merge.pre, label %afterInner

merge.pre:
  %start = add i64 %base, 0
  %mid_tmp = add i64 %base, %run
  %mid_cmp = icmp ult i64 %mid_tmp, %n
  %mid = select i1 %mid_cmp, i64 %mid_tmp, i64 %n
  %end_tmp = add i64 %base, %stride
  %end_cmp = icmp ult i64 %end_tmp, %n
  %end = select i1 %end_cmp, i64 %end_tmp, i64 %n
  br label %merge

merge:
  %i = phi i64 [ %start, %merge.pre ], [ %iNextM, %mergeBodyDone ]
  %j = phi i64 [ %mid, %merge.pre ], [ %jNextM, %mergeBodyDone ]
  %k = phi i64 [ %start, %merge.pre ], [ %kNext, %mergeBodyDone ]
  %condK = icmp ult i64 %k, %end
  br i1 %condK, label %merge.select, label %afterMerge

merge.select:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %checkRight, label %takeRight

checkRight:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %cmpValues, label %takeLeft

cmpValues:
  %ptr_i = getelementptr inbounds i32, i32* %src, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %ptr_j = getelementptr inbounds i32, i32* %src, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_le = icmp sle i32 %val_i, %val_j
  br i1 %cmp_le, label %takeLeft, label %takeRight

takeLeft:
  %src_i_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %v_i = load i32, i32* %src_i_ptr, align 4
  %out_k_ptr = getelementptr inbounds i32, i32* %out, i64 %k
  store i32 %v_i, i32* %out_k_ptr, align 4
  %iNext = add i64 %i, 1
  br label %mergeBodyDone

takeRight:
  %src_j_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %v_j = load i32, i32* %src_j_ptr, align 4
  %out_k_ptr2 = getelementptr inbounds i32, i32* %out, i64 %k
  store i32 %v_j, i32* %out_k_ptr2, align 4
  %jNext2 = add i64 %j, 1
  br label %mergeBodyDone

mergeBodyDone:
  %iNextM = phi i64 [ %iNext, %takeLeft ], [ %i, %takeRight ]
  %jNextM = phi i64 [ %j, %takeLeft ], [ %jNext2, %takeRight ]
  %kNext = add i64 %k, 1
  br label %merge

afterMerge:
  %baseNext = add i64 %base, %stride
  br label %inner

afterInner:
  ; swap src and out; double run
  %srcAfter = phi i32* [ %src, %inner ], [ %src, %inner ] ; placeholder to keep SSA valid
  %outAfter = phi i32* [ %out, %inner ], [ %out, %inner ]
  ; Perform swap explicitly
  %srcNext = %out
  %outNext = %src
  %runNext = shl i64 %run, 1
  br label %outer

afterOuter:
  %srcFinal = phi i32* [ %src, %outer ]
  %needCopy = icmp eq i32* %srcFinal, %dest
  br i1 %needCopy, label %freeBlock, label %doCopy

doCopy:
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %srcFinal to i8*
  %unused = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %sizeBytes)
  br label %freeBlock

freeBlock:
  call void @free(i8* %tmp_i8)
  br label %ret

ret:
  ret void
}