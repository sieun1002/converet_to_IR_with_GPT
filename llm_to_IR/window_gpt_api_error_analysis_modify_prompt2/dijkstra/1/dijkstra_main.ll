; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @dijkstra(i32*, i64, i64, i32*, i32*)

define dso_local i32 @main() {
entry:
  %adj = alloca [36 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %parent = alloca [6 x i32], align 16
  %path = alloca [6 x i64], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %src = alloca i64, align 8
  %idx = alloca i64, align 8
  %dest = alloca i64, align 8
  %cnt = alloca i64, align 8
  %cur = alloca i32, align 4
  %k = alloca i64, align 8
  %node64 = alloca i64, align 8
  store i64 6, i64* %n, align 8
  store i64 0, i64* %src, align 8

  %adj.base = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 0
  %dist.base = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %parent.base = getelementptr inbounds [6 x i32], [6 x i32]* %parent, i64 0, i64 0

  %n.val = load i64, i64* %n, align 8
  %n2 = mul i64 %n.val, %n.val
  store i64 0, i64* %i, align 8
  br label %fill_loop

fill_loop:
  %i.cur = load i64, i64* %i, align 8
  %cmp.fill = icmp ult i64 %i.cur, %n2
  br i1 %cmp.fill, label %fill_body, label %fill_done

fill_body:
  %elem.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %i.cur
  store i32 -1, i32* %elem.ptr, align 4
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %fill_loop

fill_done:
  store i64 0, i64* %j, align 8
  br label %diag_loop

diag_loop:
  %j.cur = load i64, i64* %j, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.val
  br i1 %cmp.j, label %diag_body, label %diag_done

diag_body:
  %n.plus1 = add i64 %n.val, 1
  %idx.diag = mul i64 %n.plus1, %j.cur
  %ptr.diag = getelementptr inbounds i32, i32* %adj.base, i64 %idx.diag
  store i32 0, i32* %ptr.diag, align 4
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %diag_loop

diag_done:
  %idx_n = load i64, i64* %n, align 8
  %p_n = getelementptr inbounds i32, i32* %adj.base, i64 %idx_n
  store i32 7, i32* %p_n, align 4

  %two_n = shl i64 %n.val, 1
  %p_2n = getelementptr inbounds i32, i32* %adj.base, i64 %two_n
  store i32 9, i32* %p_2n, align 4

  %three_n = mul i64 %n.val, 3
  %p_3n = getelementptr inbounds i32, i32* %adj.base, i64 %three_n
  store i32 10, i32* %p_3n, align 4

  %n_plus_3 = add i64 %n.val, 3
  %p_n_plus_3 = getelementptr inbounds i32, i32* %adj.base, i64 %n_plus_3
  store i32 15, i32* %p_n_plus_3, align 4

  %three_n_plus_1 = add i64 %three_n, 1
  %p_3n_plus_1 = getelementptr inbounds i32, i32* %adj.base, i64 %three_n_plus_1
  store i32 15, i32* %p_3n_plus_1, align 4

  %two_n_plus_3 = add i64 %two_n, 3
  %p_2n_plus_3 = getelementptr inbounds i32, i32* %adj.base, i64 %two_n_plus_3
  store i32 11, i32* %p_2n_plus_3, align 4

  %three_n_plus_2 = add i64 %three_n, 2
  %p_3n_plus_2 = getelementptr inbounds i32, i32* %adj.base, i64 %three_n_plus_2
  store i32 11, i32* %p_3n_plus_2, align 4

  %three_n_plus_4 = add i64 %three_n, 4
  %p_3n_plus_4 = getelementptr inbounds i32, i32* %adj.base, i64 %three_n_plus_4
  store i32 6, i32* %p_3n_plus_4, align 4

  %four_n = shl i64 %n.val, 2
  %four_n_plus_3 = add i64 %four_n, 3
  %p_4n_plus_3 = getelementptr inbounds i32, i32* %adj.base, i64 %four_n_plus_3
  store i32 6, i32* %p_4n_plus_3, align 4

  %four_n_plus_5 = add i64 %four_n, 5
  %p_4n_plus_5 = getelementptr inbounds i32, i32* %adj.base, i64 %four_n_plus_5
  store i32 9, i32* %p_4n_plus_5, align 4

  %five_n = add i64 %four_n, %n.val
  %five_n_plus_4 = add i64 %five_n, 4
  %p_5n_plus_4 = getelementptr inbounds i32, i32* %adj.base, i64 %five_n_plus_4
  store i32 9, i32* %p_5n_plus_4, align 4

  %src.val = load i64, i64* %src, align 8
  call void @dijkstra(i32* %adj.base, i64 %n.val, i64 %src.val, i32* %dist.base, i32* %parent.base)

  store i64 0, i64* %i, align 8
  br label %print_dist_loop

print_dist_loop:
  %i.cur2 = load i64, i64* %i, align 8
  %cmp.i2 = icmp ult i64 %i.cur2, %n.val
  br i1 %cmp.i2, label %print_dist_body, label %after_print_dist

print_dist_body:
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %i.cur2
  %d.val = load i32, i32* %d.ptr, align 4
  %th = icmp sgt i32 %d.val, 1061109566
  br i1 %th, label %print_inf, label %print_num

print_inf:
  %fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %src.forprint = load i64, i64* %src, align 8
  %i.sz = load i64, i64* %i, align 8
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i64 %src.forprint, i64 %i.sz)
  br label %print_step_done

print_num:
  %fmt.num.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src.forprint2 = load i64, i64* %src, align 8
  %i.sz2 = load i64, i64* %i, align 8
  %call.num = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i64 %src.forprint2, i64 %i.sz2, i32 %d.val)
  br label %print_step_done

print_step_done:
  %i.next2 = add i64 %i.cur2, 1
  store i64 %i.next2, i64* %i, align 8
  br label %print_dist_loop

after_print_dist:
  store i64 5, i64* %dest, align 8
  %dest.val = load i64, i64* %dest, align 8
  %dptr.dest = getelementptr inbounds i32, i32* %dist.base, i64 %dest.val
  %dval.dest = load i32, i32* %dptr.dest, align 4
  %is.inf.dest = icmp sgt i32 %dval.dest, 1061109566
  br i1 %is.inf.dest, label %no_path, label %has_path

no_path:
  %fmt.nopath.ptr = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %src.np = load i64, i64* %src, align 8
  %dest.np = load i64, i64* %dest, align 8
  %call.nopath = call i32 (i8*, ...) @printf(i8* %fmt.nopath.ptr, i64 %src.np, i64 %dest.np)
  br label %ret_block

has_path:
  store i64 0, i64* %cnt, align 8
  %dest.i32 = trunc i64 %dest.val to i32
  store i32 %dest.i32, i32* %cur, align 4
  br label %path_build_loop

path_build_loop:
  %cur.val = load i32, i32* %cur, align 4
  %cmp.cur = icmp ne i32 %cur.val, -1
  br i1 %cmp.cur, label %path_push, label %path_built

path_push:
  %cnt.val = load i64, i64* %cnt, align 8
  %cur.sext = sext i32 %cur.val to i64
  %path.slot = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %cnt.val
  store i64 %cur.sext, i64* %path.slot, align 8
  %cnt.inc = add i64 %cnt.val, 1
  store i64 %cnt.inc, i64* %cnt, align 8
  %cur.idx64 = sext i32 %cur.val to i64
  %parent.next.ptr = getelementptr inbounds i32, i32* %parent.base, i64 %cur.idx64
  %parent.next = load i32, i32* %parent.next.ptr, align 4
  store i32 %parent.next, i32* %cur, align 4
  br label %path_build_loop

path_built:
  %fmt.path.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %src.hp = load i64, i64* %src, align 8
  %dest.hp = load i64, i64* %dest, align 8
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt.path.ptr, i64 %src.hp, i64 %dest.hp)
  store i64 0, i64* %k, align 8
  br label %print_path_loop

print_path_loop:
  %k.val = load i64, i64* %k, align 8
  %cnt.total = load i64, i64* %cnt, align 8
  %cmp.k = icmp ult i64 %k.val, %cnt.total
  br i1 %cmp.k, label %print_path_body, label %after_print_path

print_path_body:
  %idx.rev.tmp = sub i64 %cnt.total, %k.val
  %idx.rev = add i64 %idx.rev.tmp, -1
  %node.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %idx.rev
  %node.val = load i64, i64* %node.ptr, align 8
  store i64 %node.val, i64* %node64, align 8

  %k.plus1 = add i64 %k.val, 1
  %need.arrow = icmp ult i64 %k.plus1, %cnt.total
  br i1 %need.arrow, label %arrow_yes, label %arrow_no

arrow_yes:
  %suf1 = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %after_arrow

arrow_no:
  %suf2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %after_arrow

after_arrow:
  %suffix = phi i8* [ %suf1, %arrow_yes ], [ %suf2, %arrow_no ]
  %fmt.node.ptr = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node.to.print = load i64, i64* %node64, align 8
  %call.node = call i32 (i8*, ...) @printf(i8* %fmt.node.ptr, i64 %node.to.print, i8* %suffix)
  %k.next = add i64 %k.val, 1
  store i64 %k.next, i64* %k, align 8
  br label %print_path_loop

after_print_path:
  %nl = call i32 @putchar(i32 10)
  br label %ret_block

ret_block:
  ret i32 0
}