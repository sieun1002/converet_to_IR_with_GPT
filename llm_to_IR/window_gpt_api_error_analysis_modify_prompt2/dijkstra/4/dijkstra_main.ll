; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] c"\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @dijkstra(i32*, i64, i64, i32*, i32*)

define dso_local i32 @main() {
entry:
  %adj = alloca [36 x i32], align 16
  %prev = alloca [6 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %path = alloca [6 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %p = alloca i64, align 8
  %dest = alloca i64, align 8
  %count = alloca i64, align 8
  %v = alloca i32, align 4
  %k = alloca i64, align 8
  %node = alloca i64, align 8
  store i64 6, i64* %n, align 8

  ; fill adj with -1 for n*n entries
  %n.ld = load i64, i64* %n, align 8
  %nsq = mul i64 %n.ld, %n.ld
  store i64 0, i64* %i, align 8
  br label %fill.cond

fill.cond:                                           ; preds = %fill.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %cmp.fill = icmp ult i64 %i.cur, %nsq
  br i1 %cmp.fill, label %fill.body, label %diag.init

fill.body:                                           ; preds = %fill.cond
  %adj.el.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %i.cur
  store i32 -1, i32* %adj.el.ptr, align 4
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %fill.cond

; zero out diagonal: adj[(n+1)*j] = 0 for j in [0, n)
diag.init:                                           ; preds = %fill.cond
  store i64 0, i64* %j, align 8
  br label %diag.cond

diag.cond:                                           ; preds = %diag.body, %diag.init
  %j.cur = load i64, i64* %j, align 8
  %n.ld2 = load i64, i64* %n, align 8
  %cmp.diag = icmp ult i64 %j.cur, %n.ld2
  br i1 %cmp.diag, label %diag.body, label %edges

diag.body:                                           ; preds = %diag.cond
  %n.plus1 = add i64 %n.ld2, 1
  %diag.idx = mul i64 %n.plus1, %j.cur
  %diag.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %diag.idx
  store i32 0, i32* %diag.ptr, align 4
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %diag.cond

; set specific edges (indices computed with n=var_38)
edges:                                               ; preds = %diag.cond
  %n.ld3 = load i64, i64* %n, align 8
  %idx1 = mul i64 %n.ld3, 1
  %ptr1 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx1
  store i32 7, i32* %ptr1, align 4

  %idx2 = mul i64 %n.ld3, 2
  %ptr2 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx2
  store i32 9, i32* %ptr2, align 4

  %idx3 = mul i64 %n.ld3, 3
  %ptr3 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx3
  store i32 10, i32* %ptr3, align 4

  %idx4a = add i64 %n.ld3, 3
  %ptr4a = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx4a
  store i32 15, i32* %ptr4a, align 4

  %idx4b.t = mul i64 %n.ld3, 3
  %idx4b = add i64 %idx4b.t, 1
  %ptr4b = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx4b
  store i32 15, i32* %ptr4b, align 4

  %idx5a.t = mul i64 %n.ld3, 2
  %idx5a = add i64 %idx5a.t, 3
  %ptr5a = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx5a
  store i32 11, i32* %ptr5a, align 4

  %idx5b.t = mul i64 %n.ld3, 3
  %idx5b = add i64 %idx5b.t, 2
  %ptr5b = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx5b
  store i32 11, i32* %ptr5b, align 4

  %idx6a.t = mul i64 %n.ld3, 3
  %idx6a = add i64 %idx6a.t, 4
  %ptr6a = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx6a
  store i32 6, i32* %ptr6a, align 4

  %idx6b.t = mul i64 %n.ld3, 4
  %idx6b = add i64 %idx6b.t, 3
  %ptr6b = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx6b
  store i32 6, i32* %ptr6b, align 4

  %idx7a.t = mul i64 %n.ld3, 4
  %idx7a = add i64 %idx7a.t, 5
  %ptr7a = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx7a
  store i32 9, i32* %ptr7a, align 4

  %idx7b.t = mul i64 %n.ld3, 5
  %idx7b = add i64 %idx7b.t, 4
  %ptr7b = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx7b
  store i32 9, i32* %ptr7b, align 4

  store i64 0, i64* %src, align 8

  %adj.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %prev.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %src.ld = load i64, i64* %src, align 8
  call void @dijkstra(i32* %adj.ptr, i64 %n.call, i64 %src.ld, i32* %dist.ptr, i32* %prev.ptr)

  ; print distances
  store i64 0, i64* %p, align 8
  br label %print.cond

print.cond:                                         ; preds = %print.body, %edges
  %p.cur = load i64, i64* %p, align 8
  %n.ld4 = load i64, i64* %n, align 8
  %cmp.print = icmp ult i64 %p.cur, %n.ld4
  br i1 %cmp.print, label %print.body, label %after.print

print.body:                                         ; preds = %print.cond
  %dist.el.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %p.cur
  %dist.val = load i32, i32* %dist.el.ptr, align 4
  %cmp.inf = icmp sle i32 %dist.val, 1061109566
  br i1 %cmp.inf, label %print.numeric, label %print.inf

print.inf:                                          ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %src.ld2 = load i64, i64* %src, align 8
  %p.cur2 = load i64, i64* %p, align 8
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i64 %src.ld2, i64 %p.cur2)
  br label %print.inc

print.numeric:                                      ; preds = %print.body
  %fmt.num.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %src.ld3 = load i64, i64* %src, align 8
  %p.cur3 = load i64, i64* %p, align 8
  %call.num = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i64 %src.ld3, i64 %p.cur3, i32 %dist.val)
  br label %print.inc

print.inc:                                          ; preds = %print.numeric, %print.inf
  %p.next = add i64 %p.cur, 1
  store i64 %p.next, i64* %p, align 8
  br label %print.cond

after.print:                                        ; preds = %print.cond
  store i64 5, i64* %dest, align 8
  %dest.ld = load i64, i64* %dest, align 8
  %dist.dest.ptr = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 %dest.ld
  %dist.dest = load i32, i32* %dist.dest.ptr, align 4
  %cmp.inf2 = icmp sle i32 %dist.dest, 1061109566
  br i1 %cmp.inf2, label %path.build, label %no.path

no.path:                                            ; preds = %after.print
  %fmt.nopath.ptr = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %src.ld4 = load i64, i64* %src, align 8
  %dest.ld2 = load i64, i64* %dest, align 8
  %call.nopath = call i32 (i8*, ...) @printf(i8* %fmt.nopath.ptr, i64 %src.ld4, i64 %dest.ld2)
  br label %ret

path.build:                                         ; preds = %after.print
  store i64 0, i64* %count, align 8
  %dest.ld3 = load i64, i64* %dest, align 8
  %dest.tr = trunc i64 %dest.ld3 to i32
  store i32 %dest.tr, i32* %v, align 4
  br label %path.cond

path.cond:                                          ; preds = %path.body, %path.build
  %v.cur = load i32, i32* %v, align 4
  %cmp.v = icmp ne i32 %v.cur, -1
  br i1 %cmp.v, label %path.body, label %path.done

path.body:                                          ; preds = %path.cond
  %cnt.cur = load i64, i64* %count, align 8
  %path.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %cnt.cur
  %v.sext = sext i32 %v.cur to i64
  store i64 %v.sext, i64* %path.ptr, align 8
  %cnt.next = add i64 %cnt.cur, 1
  store i64 %cnt.next, i64* %count, align 8
  %v.idx = sext i32 %v.cur to i64
  %prev.ptr.el = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 %v.idx
  %prev.val = load i32, i32* %prev.ptr.el, align 4
  store i32 %prev.val, i32* %v, align 4
  br label %path.cond

path.done:                                          ; preds = %path.cond
  %fmt.path.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %src.ld5 = load i64, i64* %src, align 8
  %dest.ld4 = load i64, i64* %dest, align 8
  %call.pathhead = call i32 (i8*, ...) @printf(i8* %fmt.path.ptr, i64 %src.ld5, i64 %dest.ld4)
  store i64 0, i64* %k, align 8
  br label %printpath.cond

printpath.cond:                                     ; preds = %printpath.body, %path.done
  %k.cur = load i64, i64* %k, align 8
  %cnt.total = load i64, i64* %count, align 8
  %cmp.k = icmp ult i64 %k.cur, %cnt.total
  br i1 %cmp.k, label %printpath.body, label %printpath.done

printpath.body:                                     ; preds = %printpath.cond
  %cnt.total2 = load i64, i64* %count, align 8
  %idx.rev.t = sub i64 %cnt.total2, %k.cur
  %idx.rev = add i64 %idx.rev.t, -1
  %path.rev.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %idx.rev
  %node.val = load i64, i64* %path.rev.ptr, align 8
  store i64 %node.val, i64* %node, align 8
  %k.plus1 = add i64 %k.cur, 1
  %has.more = icmp ult i64 %k.plus1, %cnt.total2
  %arrow.sel = select i1 %has.more, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0)
  %fmt.step.ptr = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node.ld = load i64, i64* %node, align 8
  %call.step = call i32 (i8*, ...) @printf(i8* %fmt.step.ptr, i64 %node.ld, i8* %arrow.sel)
  store i64 %k.plus1, i64* %k, align 8
  br label %printpath.cond

printpath.done:                                     ; preds = %printpath.cond
  %putchar.call = call i32 @putchar(i32 10)
  br label %ret

ret:                                                ; preds = %printpath.done, %no.path
  ret i32 0
}