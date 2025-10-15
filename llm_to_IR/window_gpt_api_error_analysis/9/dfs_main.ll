; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str.format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.fmt_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %outCount) local_unnamed_addr {
entry:
  %visited = alloca i8, i64 %n, align 1
  %stack = alloca i64, i64 %n, align 8
  %top = alloca i64, align 8
  %visited.cast = bitcast i8* %visited to i8*
  call void @llvm.memset.p0i8.i64(i8* %visited.cast, i8 0, i64 %n, i1 false)
  store i64 0, i64* %top, align 8
  %t0 = load i64, i64* %top, align 8
  %sptr0 = getelementptr inbounds i64, i64* %stack, i64 %t0
  store i64 %start, i64* %sptr0, align 8
  %t1 = add i64 %t0, 1
  store i64 %t1, i64* %top, align 8
  br label %loop

loop:                                             ; preds = %for, %entry
  %top_cur = load i64, i64* %top, align 8
  %cond_empty = icmp eq i64 %top_cur, 0
  br i1 %cond_empty, label %done, label %pop

pop:                                              ; preds = %loop
  %top_dec = add i64 %top_cur, -1
  store i64 %top_dec, i64* %top, align 8
  %sptr1 = getelementptr inbounds i64, i64* %stack, i64 %top_dec
  %u = load i64, i64* %sptr1, align 8
  %vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %u
  %vis_val = load i8, i8* %vis_ptr, align 1
  %was_visited = icmp ne i8 %vis_val, 0
  br i1 %was_visited, label %loop, label %visit

visit:                                            ; preds = %pop
  store i8 1, i8* %vis_ptr, align 1
  %idx0 = load i64, i64* %outCount, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %idx0
  store i64 %u, i64* %out_slot, align 8
  %idx1 = add i64 %idx0, 1
  store i64 %idx1, i64* %outCount, align 8
  %iv = alloca i64, align 8
  store i64 %n, i64* %iv, align 8
  br label %for

for:                                              ; preds = %for_next, %visit
  %iv_cur = load i64, i64* %iv, align 8
  %is_zero = icmp eq i64 %iv_cur, 0
  br i1 %is_zero, label %loop, label %for_body

for_body:                                         ; preds = %for
  %v = add i64 %iv_cur, -1
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_ptr, align 4
  %has_edge = icmp ne i32 %edge, 0
  br i1 %has_edge, label %check_unvisited, label %for_next

check_unvisited:                                  ; preds = %for_body
  %vis_v_ptr = getelementptr inbounds i8, i8* %visited, i64 %v
  %vis_v_val = load i8, i8* %vis_v_ptr, align 1
  %v_unvis = icmp eq i8 %vis_v_val, 0
  br i1 %v_unvis, label %push_v, label %for_next

push_v:                                           ; preds = %check_unvisited
  %top_now = load i64, i64* %top, align 8
  %dst = getelementptr inbounds i64, i64* %stack, i64 %top_now
  store i64 %v, i64* %dst, align 8
  %top_inc = add i64 %top_now, 1
  store i64 %top_inc, i64* %top, align 8
  br label %for_next

for_next:                                         ; preds = %push_v, %check_unvisited, %for_body
  %iv_next = add i64 %iv_cur, -1
  store i64 %iv_next, i64* %iv, align 8
  br label %for

done:                                             ; preds = %loop
  ret void
}

define dso_local i32 @main() local_unnamed_addr {
entry:
  call void @__main()
  %adj = alloca i32, i64 49, align 4
  %out = alloca i64, i64 7, align 8
  %outCount = alloca i64, align 8
  %start = alloca i64, align 8
  %adj.i8 = bitcast i32* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %p1 = getelementptr inbounds i32, i32* %adj, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj, i64 2
  store i32 1, i32* %p2, align 4
  %p10 = getelementptr inbounds i32, i32* %adj, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj, i64 11
  store i32 1, i32* %p11, align 4
  %p19 = getelementptr inbounds i32, i32* %adj, i64 19
  store i32 1, i32* %p19, align 4
  %p33 = getelementptr inbounds i32, i32* %adj, i64 33
  store i32 1, i32* %p33, align 4
  %p41 = getelementptr inbounds i32, i32* %adj, i64 41
  store i32 1, i32* %p41, align 4
  store i64 0, i64* %outCount, align 8
  store i64 0, i64* %start, align 8
  %start.val = load i64, i64* %start, align 8
  call void @dfs(i32* %adj, i64 7, i64 %start.val, i64* %out, i64* %outCount)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.format, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %start.val2)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop_print

loop_print:                                       ; preds = %do_print, %entry
  %i.cur = load i64, i64* %i, align 8
  %cnt = load i64, i64* %outCount, align 8
  %cmp = icmp ult i64 %i.cur, %cnt
  br i1 %cmp, label %body_print, label %after_print

body_print:                                       ; preds = %loop_print
  %nexti = add i64 %i.cur, 1
  %lt = icmp ult i64 %nexti, %cnt
  br i1 %lt, label %sep_space, label %sep_empty

sep_space:                                        ; preds = %body_print
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %do_print

sep_empty:                                        ; preds = %body_print
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %do_print

do_print:                                         ; preds = %sep_empty, %sep_space
  %sep.phi = phi i8* [ %sep.space, %sep_space ], [ %sep.empty, %sep_empty ]
  %out.ptr.i = getelementptr inbounds i64, i64* %out, i64 %i.cur
  %out.val = load i64, i64* %out.ptr.i, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt_item, i64 0, i64 0
  %call.printf.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %out.val, i8* %sep.phi)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_print

after_print:                                      ; preds = %loop_print
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}