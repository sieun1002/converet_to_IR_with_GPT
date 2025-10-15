; ModuleID = 'recovered_main'
target triple = "x86_64-pc-windows-msvc"

declare void @dijkstra(i32* %adj, i64 %n, i64 %src, i8* %frame, i32* %prev)
declare i32 @printf(i8* %fmt, ...)
declare i32 @putchar(i32 %ch)

@_Format = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = private unnamed_addr constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = private unnamed_addr constant [17 x i8] c"path %zu -> %zu:\00", align 1
@aZuS = private unnamed_addr constant [7 x i8] c" %zu%s\00", align 1
@asc_140004059 = private unnamed_addr constant [4 x i8] c" ->\00", align 1
@unk_14000405D = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define i32 @main() {
entry:
  %adj = alloca [36 x i32], align 16
  %dist = alloca [6 x i32], align 16
  %prev = alloca [6 x i32], align 16
  %path = alloca [6 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %dest = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %pathLen = alloca i64, align 8
  %cur = alloca i32, align 4
  %k = alloca i64, align 8
  %node64 = alloca i64, align 8
  %i2 = alloca i64, align 8
  store i64 6, i64* %n, align 8
  store i64 0, i64* %i, align 8
  %adj.base = getelementptr inbounds [36 x i32], [36 x i32]* %adj, i64 0, i64 0
  br label %for.cond

for.cond:                                        ; preds = %for.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %n2 = mul i64 %n.val, %n.val
  %cmp = icmp ult i64 %i.val, %n2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                        ; preds = %for.cond
  %idxptr = getelementptr inbounds i32, i32* %adj.base, i64 %i.val
  store i32 -1, i32* %idxptr, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %for.cond

for.end:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %diag.cond

diag.cond:                                       ; preds = %diag.body, %for.end
  %j.val = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.val, %n.val2
  br i1 %cmp2, label %diag.body, label %diag.end

diag.body:                                       ; preds = %diag.cond
  %n.plus1 = add i64 %n.val2, 1
  %pos = mul i64 %n.plus1, %j.val
  %posptr = getelementptr inbounds i32, i32* %adj.base, i64 %pos
  store i32 0, i32* %posptr, align 4
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %diag.cond

diag.end:                                        ; preds = %diag.cond
  %n3 = load i64, i64* %n, align 8
  %idx1 = getelementptr inbounds i32, i32* %adj.base, i64 %n3
  store i32 7, i32* %idx1, align 4
  %two = mul i64 %n3, 2
  %idx2p = getelementptr inbounds i32, i32* %adj.base, i64 %two
  store i32 9, i32* %idx2p, align 4
  %three = mul i64 %n3, 3
  %idx3p = getelementptr inbounds i32, i32* %adj.base, i64 %three
  store i32 10, i32* %idx3p, align 4
  %nplus3 = add i64 %n3, 3
  %idx4p = getelementptr inbounds i32, i32* %adj.base, i64 %nplus3
  store i32 15, i32* %idx4p, align 4
  %three.plus1 = add i64 %three, 1
  %idx5p = getelementptr inbounds i32, i32* %adj.base, i64 %three.plus1
  store i32 15, i32* %idx5p, align 4
  %two.plus3 = add i64 %two, 3
  %idx6p = getelementptr inbounds i32, i32* %adj.base, i64 %two.plus3
  store i32 11, i32* %idx6p, align 4
  %three.plus2 = add i64 %three, 2
  %idx7p = getelementptr inbounds i32, i32* %adj.base, i64 %three.plus2
  store i32 11, i32* %idx7p, align 4
  %three.plus4 = add i64 %three, 4
  %idx8p = getelementptr inbounds i32, i32* %adj.base, i64 %three.plus4
  store i32 6, i32* %idx8p, align 4
  %four = mul i64 %n3, 4
  %four.plus3 = add i64 %four, 3
  %idx9p = getelementptr inbounds i32, i32* %adj.base, i64 %four.plus3
  store i32 6, i32* %idx9p, align 4
  %four.plus5 = add i64 %four, 5
  %idx10p = getelementptr inbounds i32, i32* %adj.base, i64 %four.plus5
  store i32 9, i32* %idx10p, align 4
  %five = mul i64 %n3, 5
  %five.plus4 = add i64 %five, 4
  %idx11p = getelementptr inbounds i32, i32* %adj.base, i64 %five.plus4
  store i32 9, i32* %idx11p, align 4
  store i64 0, i64* %src, align 8
  %dist.base = getelementptr inbounds [6 x i32], [6 x i32]* %dist, i64 0, i64 0
  %prev.base = getelementptr inbounds [6 x i32], [6 x i32]* %prev, i64 0, i64 0
  %src.val = load i64, i64* %src, align 8
  %frame.ptr = bitcast i32* %dist.base to i8*
  call void @dijkstra(i32* %adj.base, i64 %n3, i64 %src.val, i8* %frame.ptr, i32* %prev.base)
  store i64 0, i64* %i2, align 8
  br label %dist.loop.cond

dist.loop.cond:                                  ; preds = %dist.after, %diag.end
  %i2v = load i64, i64* %i2, align 8
  %n4 = load i64, i64* %n, align 8
  %cmpd = icmp ult i64 %i2v, %n4
  br i1 %cmpd, label %dist.loop.body, label %dist.loop.end

dist.loop.body:                                  ; preds = %dist.loop.cond
  %dptr = getelementptr inbounds i32, i32* %dist.base, i64 %i2v
  %dval = load i32, i32* %dptr, align 4
  %th = icmp sgt i32 %dval, 1061109566
  br i1 %th, label %dist.inf, label %dist.finite

dist.inf:                                        ; preds = %dist.loop.body
  %srcv = load i64, i64* %src, align 8
  %fmt1.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %srcv, i64 %i2v)
  br label %dist.after

dist.finite:                                     ; preds = %dist.loop.body
  %fmt2.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %srcv2 = load i64, i64* %src, align 8
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i64 %srcv2, i64 %i2v, i32 %dval)
  br label %dist.after

dist.after:                                      ; preds = %dist.finite, %dist.inf
  %i2next = add i64 %i2v, 1
  store i64 %i2next, i64* %i2, align 8
  br label %dist.loop.cond

dist.loop.end:                                   ; preds = %dist.loop.cond
  store i64 5, i64* %dest, align 8
  %destv = load i64, i64* %dest, align 8
  %dptr2 = getelementptr inbounds i32, i32* %dist.base, i64 %destv
  %dval2 = load i32, i32* %dptr2, align 4
  %isinf2 = icmp sgt i32 %dval2, 1061109566
  br i1 %isinf2, label %no.path, label %has.path

no.path:                                         ; preds = %dist.loop.end
  %srcv3 = load i64, i64* %src, align 8
  %fmt3 = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %srcv3, i64 %destv)
  br label %ret

has.path:                                        ; preds = %dist.loop.end
  store i64 0, i64* %pathLen, align 8
  %desti32 = trunc i64 %destv to i32
  store i32 %desti32, i32* %cur, align 4
  br label %path.build.cond

path.build.cond:                                 ; preds = %path.build.body, %has.path
  %curv = load i32, i32* %cur, align 4
  %cmpcur = icmp ne i32 %curv, -1
  br i1 %cmpcur, label %path.build.body, label %path.build.end

path.build.body:                                 ; preds = %path.build.cond
  %lenv = load i64, i64* %pathLen, align 8
  %node64sext = sext i32 %curv to i64
  %path.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %lenv
  store i64 %node64sext, i64* %path.ptr, align 8
  %len.next = add i64 %lenv, 1
  store i64 %len.next, i64* %pathLen, align 8
  %curidx = sext i32 %curv to i64
  %prev.ptr = getelementptr inbounds i32, i32* %prev.base, i64 %curidx
  %prev.val = load i32, i32* %prev.ptr, align 4
  store i32 %prev.val, i32* %cur, align 4
  br label %path.build.cond

path.build.end:                                  ; preds = %path.build.cond
  %fmt4 = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %srcv4 = load i64, i64* %src, align 8
  %call4 = call i32 (i8*, ...) @printf(i8* %fmt4, i64 %srcv4, i64 %destv)
  store i64 0, i64* %k, align 8
  br label %print.loop.cond

print.loop.cond:                                 ; preds = %suffix.merge, %path.build.end
  %kv = load i64, i64* %k, align 8
  %lenv2 = load i64, i64* %pathLen, align 8
  %cmpk = icmp ult i64 %kv, %lenv2
  br i1 %cmpk, label %print.loop.body, label %print.loop.end

print.loop.body:                                 ; preds = %print.loop.cond
  %lenv3 = load i64, i64* %pathLen, align 8
  %t1 = sub i64 %lenv3, %kv
  %t2 = sub i64 %t1, 1
  %node.ptr = getelementptr inbounds [6 x i64], [6 x i64]* %path, i64 0, i64 %t2
  %node.val = load i64, i64* %node.ptr, align 8
  store i64 %node.val, i64* %node64, align 8
  %kv1 = load i64, i64* %k, align 8
  %kplus1 = add i64 %kv1, 1
  %cmpmore = icmp ult i64 %kplus1, %lenv3
  br i1 %cmpmore, label %suffix.arrow, label %suffix.empty

suffix.arrow:                                    ; preds = %print.loop.body
  %s1 = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  br label %suffix.merge

suffix.empty:                                    ; preds = %print.loop.body
  %s2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  br label %suffix.merge

suffix.merge:                                    ; preds = %suffix.empty, %suffix.arrow
  %suffix = phi i8* [ %s1, %suffix.arrow ], [ %s2, %suffix.empty ]
  %fmt5 = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %node.to.pass = load i64, i64* %node64, align 8
  %call5 = call i32 (i8*, ...) @printf(i8* %fmt5, i64 %node.to.pass, i8* %suffix)
  %k.next = add i64 %kv1, 1
  store i64 %k.next, i64* %k, align 8
  br label %print.loop.cond

print.loop.end:                                  ; preds = %print.loop.cond
  %nl = call i32 @putchar(i32 10)
  br label %ret

ret:                                             ; preds = %print.loop.end, %no.path
  ret i32 0
}