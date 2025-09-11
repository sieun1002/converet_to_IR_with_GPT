; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1240
; Intent: in-place quicksort on i32 array (confidence=0.95). Evidence: pivot from middle; two-pointer partition with swap; recurse smaller side.
; Preconditions: %a points to a valid array of at least (%hi+1) i32 elements; 0-based indices; compare signed i32; requires %lo and %hi within array bounds.
; Postconditions: elements in [%lo, %hi] sorted ascending (signed).

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
%cmp_init = icmp sge i64 %lo, %hi
br i1 %cmp_init, label %ret, label %loop

loop: ; outer iterative loop over the current [L,H] range
%L = phi i64 [ %lo, %entry ], [ %L.next, %decide_after ]
%H = phi i64 [ %hi, %entry ], [ %H.next, %decide_after ]
; while (L < H)
%cont = icmp slt i64 %L, %H
br i1 %cont, label %partition_prep, label %ret

partition_prep:
; pivot = a[L + ((H-L)>>1)]
%diff = sub i64 %H, %L
%half = ashr i64 %diff, 1
%mid = add i64 %L, %half
%pivot.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
%pivot = load i32, i32* %pivot.ptr, align 4
br label %part.loop.header

part.loop.header:
; i := L, j := H
%i.init = phi i64 [ %L, %partition_prep ], [ %i.next, %swap_done ], [ %i.stay, %after_j ]
%j.init = phi i64 [ %H, %partition_prep ], [ %j.next, %swap_done ], [ %j.stay, %after_j ]
br label %loop_i

loop_i: ; while (a[i] < pivot) i++
%ai.ptr = getelementptr inbounds i32, i32* %a, i64 %i.init
%ai = load i32, i32* %ai.ptr, align 4
%cmp_i = icmp slt i32 %ai, %pivot
br i1 %cmp_i, label %inc_i, label %after_i

inc_i:
%i.inc = add i64 %i.init, 1
br label %loop_i

after_i:
; keep i where a[i] >= pivot (signed)
%i.stay = phi i64 [ %i.init, %loop_i ]
br label %loop_j

loop_j: ; while (pivot < a[j]) j--
%aj.ptr = getelementptr inbounds i32, i32* %a, i64 %j.init
%aj = load i32, i32* %aj.ptr, align 4
%cmp_j = icmp slt i32 %pivot, %aj
br i1 %cmp_j, label %dec_j, label %after_j

dec_j:
%j.dec = add i64 %j.init, -1
br label %loop_j

after_j:
; keep j where pivot >= a[j] (signed)
%j.stay = phi i64 [ %j.init, %loop_j ]
; if (i > j) break
%brk = icmp sgt i64 %i.stay, %j.stay
br i1 %brk, label %decide, label %do_swap

do_swap: ; swap a[i], a[j]; i++, j--
%ai.ptr2 = getelementptr inbounds i32, i32* %a, i64 %i.stay
%aj.ptr2 = getelementptr inbounds i32, i32* %a, i64 %j.stay
%ai2 = load i32, i32* %ai.ptr2, align 4
%aj2 = load i32, i32* %aj.ptr2, align 4
store i32 %aj2, i32* %ai.ptr2, align 4
store i32 %ai2, i32* %aj.ptr2, align 4
%i.next = add i64 %i.stay, 1
%j.next = add i64 %j.stay, -1
br label %swap_done

swap_done:
br label %part.loop.header

decide: ; choose smaller side to recurse; iterate on the other
%leftLen = sub i64 %j.stay, %L
%rightLen = sub i64 %H, %i.stay
%left_ge_right = icmp sge i64 %leftLen, %rightLen
br i1 %left_ge_right, label %right_first, label %left_first

right_first: ; recurse right if needed; then H = j
%need_right = icmp slt i64 %i.stay, %H
br i1 %need_right, label %call_right, label %skip_right

call_right:
call void @quick_sort(i32* %a, i64 %i.stay, i64 %H)
br label %skip_right

skip_right:
; iterate on left: [L, j]
%L.next.rf = %L
%H.next.rf = %j.stay
br label %decide_after

left_first: ; recurse left if needed; then L = i
%need_left = icmp slt i64 %L, %j.stay
br i1 %need_left, label %call_left, label %skip_left

call_left:
call void @quick_sort(i32* %a, i64 %L, i64 %j.stay)
br label %skip_left

skip_left:
; iterate on right: [i, H]
%L.next.lf = %i.stay
%H.next.lf = %H
br label %decide_after

decide_after:
%L.next = phi i64 [ %L.next.rf, %skip_right ], [ %L.next.lf, %skip_left ]
%H.next = phi i64 [ %H.next.rf, %skip_right ], [ %H.next.lf, %skip_left ]
br label %loop

ret:
ret void
}