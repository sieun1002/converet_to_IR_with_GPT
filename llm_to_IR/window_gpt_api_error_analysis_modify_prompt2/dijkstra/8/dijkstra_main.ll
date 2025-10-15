; ModuleID = 'reconstructed'
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
declare void @dijkstra(i32*, i64, i64, i8*, i32*)

define i32 @main() {
entry:
  %n = alloca i64, align 8
  %adj = alloca [36 x i32], align 16
  %dist = alloca [36 x i32], align 16
  %prev = alloca [36 x i32], align 16
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %loopi = alloca i64, align 8
  %dest = alloca i64, align 8
  %pathLen = alloca i64, align 8
  %curr = alloca i32, align 4
  %pathStack = alloca [36 x i64], align 16
  %k = alloca i64, align 8
  %tmpv = alloca i64, align 8
  store i64 6, i64* %n, align 8
  store i64 0, i64* %i, align 8
  br label %fill

fill:                                             ; preds = %fill.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val1 = load i64, i64* %n, align 8
  %mul = mul i64 %n.val1, %n.val1
  %cmp = icmp ult i64 %i.val, %mul
  br i1 %cmp, label %fill.body, label %fill.end

fill.body:                                        ; preds = %fill
  %adj.base = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %i.val
  store i32 -1, i32* %adj.base, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %fill

fill.end:                                         ; preds = %fill
  store i64 0, i64* %j, align 8
  br label %diag.loop

diag.loop:                                        ; preds = %diag.body, %fill.end
  %j.val = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmpj = icmp ult i64 %j.val, %n.val2
  br i1 %cmpj, label %diag.body, label %edges

diag.body:                                        ; preds = %diag.loop
  %nplus1 = add i64 %n.val2, 1
  %idx = mul i64 %nplus1, %j.val
  %gep = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %idx
  store i32 0, i32* %gep, align 4
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %diag.loop

edges:                                            ; preds = %diag.loop
  %n3 = load i64, i64* %n, align 8
  %gep_n = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %n3
  store i32 7, i32* %gep_n, align 4
  %n_times2 = shl i64 %n3, 1
  %gep_2n = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %n_times2
  store i32 9, i32* %gep_2n, align 4
  %n_times3 = add i64 %n_times2, %n3
  %gep_3n = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %n_times3
  store i32 10, i32* %gep_3n, align 4
  %n_plus3 = add i64 %n3, 3
  %gep_n_plus3 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %n_plus3
  store i32 15, i32* %gep_n_plus3, align 4
  %three_n_plus1 = add i64 %n_times3, 1
  %gep_3n_plus1 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %three_n_plus1
  store i32 15, i32* %gep_3n_plus1, align 4
  %two_n_plus3 = add i64 %n_times2, 3
  %gep_2n_plus3 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %two_n_plus3
  store i32 11, i32* %gep_2n_plus3, align 4
  %three_n_plus2 = add i64 %n_times3, 2
  %gep_3n_plus2 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %three_n_plus2
  store i32 11, i32* %gep_3n_plus2, align 4
  %three_n_plus4 = add i64 %n_times3, 4
  %gep_3n_plus4 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %three_n_plus4
  store i32 6, i32* %gep_3n_plus4, align 4
  %n_times4 = shl i64 %n3, 2
  %four_n_plus3 = add i64 %n_times4, 3
  %gep_4n_plus3 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %four_n_plus3
  store i32 6, i32* %gep_4n_plus3, align 4
  %four_n_plus5 = add i64 %n_times4, 5
  %gep_4n_plus5 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %four_n_plus5
  store i32 9, i32* %gep_4n_plus5, align 4
  %n_times5 = add i64 %n_times4, %n3
  %five_n_plus4 = add i64 %n_times5, 4
  %gep_5n_plus4 = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 %five_n_plus4
  store i32 9, i32* %gep_5n_plus4, align 4
  store i64 0, i64* %src, align 8
  %adj.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 0
  %prev.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %prev, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [36 x i32], [36 x i32]* %dist, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %src.call = load i64, i64* %src, align 8
  %arg4.ptr = bitcast i32* %dist.ptr to i8*
  call void @dijkstra(i32* %adj.ptr, i64 %n.call, i64 %src.call, i8* %arg4.ptr, i32* %prev.ptr)
  store i64 0, i64* %loopi, align 8
  br label %print.loop

print.loop:                                       ; preds = %print.inc, %edges
  %li = load i64, i64* %loopi, align 8
  %n.val3 = load i64, i64* %n, align 8
  %cond = icmp ult i64 %li, %n.val3
  br i1 %cond, label %print.body, label %after.first.print

print.body:                                       ; preds = %print.loop
  %di.gep = getelementptr inbounds [36 x i32], [36 x i32]* %dist, i64 0, i64 %li
  %di.val = load i32, i32* %di.gep, align 4
  %thresh.cmp = icmp sle i32 %di.val, 1061109566
  br i1 %thresh.cmp, label %print.value, label %print.inf

print.inf:                                        ; preds = %print.body
  %src6 = load i64, i64* %src, align 8
  %dest.idx = load i64, i64* %loopi, align 8
  %fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i64 %src6, i64 %dest.idx)
  br label %print.inc

print.value:                                      ; preds = %print.body
  %src7 = load i64, i64* %src, align 8
  %dest.idx2 = load i64, i64* %loopi, align 8
  %fmt.val.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %call.val = call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i64 %src7, i64 %dest.idx2, i32 %di.val)
  br label %print.inc

print.inc:                                        ; preds = %print.value, %print.inf
  %li2 = add i64 %li, 1
  store i64 %li2, i64* %loopi, align 8
  br label %print.loop

after.first.print:                                ; preds = %print.loop
  store i64 5, i64* %dest, align 8
  %dest.idx3 = load i64, i64* %dest, align 8
  %dist.dest.gep = getelementptr inbounds [36 x i32], [36 x i32]* %dist, i64 0, i64 %dest.idx3
  %dist.dest.val = load i32, i32* %dist.dest.gep, align 4
  %cmpDest = icmp sle i32 %dist.dest.val, 1061109566
  br i1 %cmpDest, label %has.path, label %no.path

no.path:                                          ; preds = %after.first.print
  %src8 = load i64, i64* %src, align 8
  %dest8 = load i64, i64* %dest, align 8
  %fmt.nopath = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %call.nopath = call i32 (i8*, ...) @printf(i8* %fmt.nopath, i64 %src8, i64 %dest8)
  br label %ret.label

has.path:                                         ; preds = %after.first.print
  store i64 0, i64* %pathLen, align 8
  %dest9 = load i64, i64* %dest, align 8
  %dest.tr = trunc i64 %dest9 to i32
  store i32 %dest.tr, i32* %curr, align 4
  br label %build.path

build.path:                                       ; preds = %push.step, %has.path
  %curr.val = load i32, i32* %curr, align 4
  %curr.notneg1 = icmp ne i32 %curr.val, -1
  br i1 %curr.notneg1, label %push.step, label %path.built

push.step:                                        ; preds = %build.path
  %pl = load i64, i64* %pathLen, align 8
  %nextLen = add i64 %pl, 1
  store i64 %nextLen, i64* %pathLen, align 8
  %curr.sext = sext i32 %curr.val to i64
  %stack.slot = getelementptr inbounds [36 x i64], [36 x i64]* %pathStack, i64 0, i64 %pl
  store i64 %curr.sext, i64* %stack.slot, align 8
  %curr64 = sext i32 %curr.val to i64
  %prev.gep = getelementptr inbounds [36 x i32], [36 x i32]* %prev, i64 0, i64 %curr64
  %prev.val = load i32, i32* %prev.gep, align 4
  store i32 %prev.val, i32* %curr, align 4
  br label %build.path

path.built:                                       ; preds = %build.path
  %src10 = load i64, i64* %src, align 8
  %dest10 = load i64, i64* %dest, align 8
  %fmt.path = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %call.header = call i32 (i8*, ...) @printf(i8* %fmt.path, i64 %src10, i64 %dest10)
  store i64 0, i64* %k, align 8
  br label %print.path.loop

print.path.loop:                                  ; preds = %print.node, %path.built
  %kval = load i64, i64* %k, align 8
  %pl2 = load i64, i64* %pathLen, align 8
  %cond2 = icmp ult i64 %kval, %pl2
  br i1 %cond2, label %path.body, label %after.path

path.body:                                        ; preds = %print.path.loop
  %tmp1 = sub i64 %pl2, %kval
  %tmp2 = sub i64 %tmp1, 1
  %val.gep = getelementptr inbounds [36 x i64], [36 x i64]* %pathStack, i64 0, i64 %tmp2
  %node.val64 = load i64, i64* %val.gep, align 8
  store i64 %node.val64, i64* %tmpv, align 8
  %kplus1 = add i64 %kval, 1
  %cmp3 = icmp ult i64 %kplus1, %pl2
  br i1 %cmp3, label %choose.arrow, label %choose.empty

choose.arrow:                                     ; preds = %path.body
  %arrow.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %print.node

choose.empty:                                     ; preds = %path.body
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %print.node

print.node:                                       ; preds = %choose.empty, %choose.arrow
  %suffix = phi i8* [ %arrow.ptr, %choose.arrow ], [ %empty.ptr, %choose.empty ]
  %fmt.node = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node.load = load i64, i64* %tmpv, align 8
  %call.node = call i32 (i8*, ...) @printf(i8* %fmt.node, i64 %node.load, i8* %suffix)
  %knew = add i64 %kval, 1
  store i64 %knew, i64* %k, align 8
  br label %print.path.loop

after.path:                                       ; preds = %print.path.loop
  %put = call i32 @putchar(i32 10)
  br label %ret.label

ret.label:                                        ; preds = %after.path, %no.path
  ret i32 0
}