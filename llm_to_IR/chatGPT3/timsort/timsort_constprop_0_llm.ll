; ModuleID = 'timsort_constprop_0'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: timsort_constprop_0 ; Address: 0x1300
; Intent: Sort 16 i32s in-place at %a (ascending, stable insertion-sort stand-in for timsort) (confidence=0.88). Evidence: fixed 16-element window (0..15), comparisons/moves, malloc(60) temp buffer typical of timsort scratch usage.
; Preconditions: %a points to at least 16 contiguous i32 elements.
; Postconditions: %a[0..15] is nondecreasing.

; Only the needed extern declarations:

declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @timsort_constprop_0(i32* %a) local_unnamed_addr {
entry:
%buf = call i8* @malloc(i64 60)
%isnull = icmp eq i8* %buf, null
br i1 %isnull, label %ret, label %outer

outer: ; preds = entry, %nexti
%i = phi i64 [ 1, entry ], [ %i.next, %nexti ]
%ai = getelementptr inbounds i32, i32* %a, i64 %i
%key = load i32, i32* %ai, align 4
%j0 = add i64 %i, -1
br label %inner

inner: ; preds = %shift, %outer
%j = phi i64 [ %j0, %outer ], [ %j.next, %shift ]
%jneg = icmp slt i64 %j, 0
br i1 %jneg, label %insert, label %check

check: ; preds = %inner
%ajptr = getelementptr inbounds i32, i32* %a, i64 %j
%aj = load i32, i32* %ajptr, align 4
%cmp = icmp sgt i32 %aj, %key
br i1 %cmp, label %shift, label %insert

shift: ; preds = %check
%jp1 = add i64 %j, 1
%dst = getelementptr inbounds i32, i32* %a, i64 %jp1
store i32 %aj, i32* %dst, align 4
%j.next = add i64 %j, -1
br label %inner

insert: ; preds = %check, %inner
%jp1b = add i64 %j, 1
%dst2 = getelementptr inbounds i32, i32* %a, i64 %jp1b
store i32 %key, i32* %dst2, align 4
%i.lt.15 = icmp ult i64 %i, 15
br i1 %i.lt.15, label %nexti, label %after_outer

nexti: ; preds = %insert
%i.next = add i64 %i, 1
br label %outer

after_outer: ; preds = %insert
call void @free(i8* %buf)
br label %ret

ret: ; preds = %after_outer, %entry
ret void
}