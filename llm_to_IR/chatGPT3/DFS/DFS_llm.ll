; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10E0
; Intent: Print DFS preorder of a fixed 7-node graph starting from 0 (confidence=0.90). Evidence: printf strings and adjacency/visited/stack loops.
; Preconditions: None
; Postconditions: Writes traversal to stdout and returns 0

@G = private unnamed_addr constant [7 x [7 x i32]] [
[7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
[7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
[7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
[7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
[7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
[7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
[7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
], align 16

@.str0 = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.sp = private unnamed_addr constant [2 x i8] c" \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Only the needed extern declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare noalias i8* @calloc(i64, i64)
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
%res = alloca [7 x i64], align 8
%nres = alloca i64, align 8
store i64 0, i64* %nres, align 8

%vraw = call noalias i8* @calloc(i64 28, i64 1)
%nxtraw = call noalias i8* @calloc(i64 56, i64 1)
%stkraw = call noalias i8* @malloc(i64 56)

%vnull = icmp eq i8* %vraw, null
%nnull = icmp eq i8* %nxtraw, null
%snull = icmp eq i8* %stkraw, null
%tmp.or = or i1 %vnull, %nnull
%anynull = or i1 %tmp.or, %snull
br i1 %anynull, label %fail, label %init_ok

init_ok:
%visited = bitcast i8* %vraw to i32*
%next = bitcast i8* %nxtraw to i64*
%stack = bitcast i8* %stkraw to i64*

; visited[0] = 1
%v0ptr = getelementptr inbounds i32, i32* %visited, i64 0
store i32 1, i32* %v0ptr, align 4

; initial state: curr=0, t=1
br label %outer

outer: ; preds = %init_ok, %after_pop, %back_from_push, %scan_inc, %parent_no_pop
%curr = phi i64 [ 0, %init_ok ], [ %curr.pop, %after_pop ], [ %curr.push, %back_from_push ], [ %curr.keep, %scan_inc ], [ %curr.par, %parent_no_pop ]
%t = phi i64 [ 1, %init_ok ], [ %t.dec, %after_pop ], [ %t.inc, %back_from_push ], [ %t, %scan_inc ], [ %t, %parent_no_pop ]
%nptr.curr = getelementptr inbounds i64, i64* %next, i64 %curr
%a = load i64, i64* %nptr.curr, align 8
%a_gt6 = icmp ugt i64 %a, 6
br i1 %a_gt6, label %gt6, label %scan

scan: ; preds = %outer, %scan_inc
%curr.keep = phi i64 [ %curr, %outer ], [ %curr.keep, %scan_inc ]
%nptr.scan = phi i64* [ %nptr.curr, %outer ], [ %nptr.scan, %scan_inc ]
%a.scan = phi i64 [ %a, %outer ], [ %a.next, %scan_inc ]

%rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @G, i64 0, i64 %curr.keep
%cellptr = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %a.scan
%edge = load i32, i32* %cellptr, align 4
%has_edge = icmp ne i32 %edge, 0
br i1 %has_edge, label %check_visit, label %scan_inc

check_visit: ; preds = %scan
%v.aptr = getelementptr inbounds i32, i32* %visited, i64 %a.scan
%vaval = load i32, i32* %v.aptr, align 4
%not_visited = icmp eq i32 %vaval, 0
br i1 %not_visited, label %push_neighbor, label %scan_inc

scan_inc: ; preds = %check_visit, %scan
%a.plus = phi i64 [ %a.scan, %scan ], [ %a.scan, %check_visit ]
%a.next = add i64 %a.plus, 1
store i64 %a.next, i64* %nptr.scan, align 8
br label %scan

push_neighbor: ; preds = %check_visit
; stack[t] = a
%st.ptr = getelementptr inbounds i64, i64* %stack, i64 %t
store i64 %a.scan, i64* %st.ptr, align 8
%t.inc = add i64 %t, 1

; res[nres] = a ; nres++
%nold = load i64, i64* %nres, align 8
%resp = getelementptr inbounds [7 x i64], [7 x i64]* %res, i64 0, i64 %nold
store i64 %a.scan, i64* %resp, align 8
%nnew = add i64 %nold, 1
store i64 %nnew, i64* %nres, align 8

; next[curr] = a+1
%a.p1 = add i64 %a.scan, 1
store i64 %a.p1, i64* %nptr.curr, align 8

; visited[a] = 1
store i32 1, i32* %v.aptr, align 4

; curr = a
%curr.push = %a.scan
br label %back_from_push

back_from_push: ; preds = %push_neighbor
br label %outer

gt6: ; preds = %outer
%a.eq7 = icmp eq i64 %a, 7
br i1 %a.eq7, label %pop, label %parent_no_pop

pop: ; preds = %gt6
%t.dec = sub i64 %t, 1
%t.zero = icmp eq i64 %t.dec, 0
br i1 %t.zero, label %done, label %load_parent

load_parent: ; preds = %pop
%idx.par = sub i64 %t.dec, 1
%par.ptr = getelementptr inbounds i64, i64* %stack, i64 %idx.par
%curr.pop = load i64, i64* %par.ptr, align 8
br label %after_pop

after_pop: ; preds = %load_parent
br label %outer

parent_no_pop: ; preds = %gt6
%idx.par2 = sub i64 %t, 1
%par.ptr2 = getelementptr inbounds i64, i64* %stack, i64 %idx.par2
%curr.par = load i64, i64* %par.ptr2, align 8
br label %outer

done: ; preds = %pop
; free in success path
call void @free(i8* %vraw)
call void @free(i8* %nxtraw)
call void @free(i8* %stkraw)
br label %print

fail: ; preds = %entry
; free even if NULL (no-op), then print header + newline
call void @free(i8* %vraw)
call void @free(i8* %nxtraw)
call void @free(i8* %stkraw)
store i64 0, i64* %nres, align 8
br label %print

print: ; preds = %done, %fail
%fmt0.p = getelementptr inbounds [24 x i8], [24 x i8]* @.str0, i64 0, i64 0
%call0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt0.p, i64 0)

%nval = load i64, i64* %nres, align 8
%hasnone = icmp eq i64 %nval, 0
br i1 %hasnone, label %print_nl, label %loop_init

loop_init:
%last = add i64 %nval, -1
br label %loop_hdr

loop_hdr: ; preds = %loop_body, %loop_init
%i = phi i64 [ 0, %loop_init ], [ %i.next, %loop_body ]
%cont = icmp ult i64 %i, %nval
br i1 %cont, label %loop_body, label %print_nl

loop_body: ; preds = %loop_hdr
%elem.p = getelementptr inbounds [7 x i64], [7 x i64]* @res, i64 0, i64 %i
%elem = load i64, i64* %elem.p, align 8
%islast = icmp eq i64 %i, %last
%space.p = getelementptr inbounds [2 x i8], [2 x i8]* @.sp, i64 0, i64 0
%empty.p = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
%sep = select i1 %islast, i8* %empty.p, i8* %space.p
%fmt1.p = getelementptr inbounds [6 x i8], [6 x i8]* @.str1, i64 0, i64 0
%call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt1.p, i64 %elem, i8* %sep)
%i.next = add i64 %i, 1
br label %loop_hdr

print_nl: ; preds = %loop_hdr, %print, %loop_init
%nl.p = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
%call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.p)
ret i32 0
}