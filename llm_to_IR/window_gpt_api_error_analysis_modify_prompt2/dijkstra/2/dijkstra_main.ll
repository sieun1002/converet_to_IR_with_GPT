; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = dso_local constant [24 x i8] c"dist(%zu -> %zu) = INF\0A\00", align 1
@aDistZuZuD = dso_local constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@aNoPathFromZuTo = dso_local constant [25 x i8] c"no path from %zu to %zu\0A\00", align 1
@aPathZuZu = dso_local constant [17 x i8] c"path %zu -> %zu:\00", align 1
@asc_140004059 = dso_local constant [4 x i8] c" ->\00", align 1
@unk_14000405D = dso_local constant [1 x i8] zeroinitializer, align 1
@aZuS = dso_local constant [7 x i8] c" %zu%s\00", align 1

declare dso_local void @dijkstra(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i32* noundef)
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local i32 @main() {
entry:
  %adj = alloca [56 x i32], align 16
  %dist = alloca [64 x i32], align 16
  %pred = alloca [64 x i32], align 16
  %path = alloca [64 x i64], align 16
  %n.addr = alloca i64, align 8
  store i64 6, i64* %n.addr, align 8
  %adj.base = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 0
  %n.load0 = load i64, i64* %n.addr, align 8
  %n2 = mul i64 %n.load0, %n.load0
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp ult i64 %i.phi, %n2
  br i1 %cmp.init, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %init.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %i.phi
  store i32 -1, i32* %init.ptr, align 4
  %i.next = add i64 %i.phi, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  br label %diag.loop

diag.loop:                                        ; preds = %diag.body, %init.end
  %j.phi = phi i64 [ 0, %init.end ], [ %j.next, %diag.body ]
  %n.load1 = load i64, i64* %n.addr, align 8
  %cmp.diag = icmp ult i64 %j.phi, %n.load1
  br i1 %cmp.diag, label %diag.body, label %after.diag

diag.body:                                        ; preds = %diag.loop
  %n.plus1 = add i64 %n.load1, 1
  %diag.idx = mul i64 %n.plus1, %j.phi
  %diag.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %diag.idx
  store i32 0, i32* %diag.ptr, align 4
  %j.next = add i64 %j.phi, 1
  br label %diag.loop

after.diag:                                       ; preds = %diag.loop
  %n.load2 = load i64, i64* %n.addr, align 8
  %idx.n = getelementptr inbounds i32, i32* %adj.base, i64 %n.load2
  store i32 7, i32* %idx.n, align 4
  %two.n = shl i64 %n.load2, 1
  %idx.2n = getelementptr inbounds i32, i32* %adj.base, i64 %two.n
  store i32 9, i32* %idx.2n, align 4
  %three.n = add i64 %two.n, %n.load2
  %idx.3n = getelementptr inbounds i32, i32* %adj.base, i64 %three.n
  store i32 10, i32* %idx.3n, align 4
  %n.plus3 = add i64 %n.load2, 3
  %idx.n.plus3 = getelementptr inbounds i32, i32* %adj.base, i64 %n.plus3
  store i32 15, i32* %idx.n.plus3, align 4
  %three.n.plus1 = add i64 %three.n, 1
  %idx.3n.plus1 = getelementptr inbounds i32, i32* %adj.base, i64 %three.n.plus1
  store i32 15, i32* %idx.3n.plus1, align 4
  %two.n.plus3 = add i64 %two.n, 3
  %idx.2n.plus3 = getelementptr inbounds i32, i32* %adj.base, i64 %two.n.plus3
  store i32 11, i32* %idx.2n.plus3, align 4
  %three.n.plus2 = add i64 %three.n, 2
  %idx.3n.plus2 = getelementptr inbounds i32, i32* %adj.base, i64 %three.n.plus2
  store i32 11, i32* %idx.3n.plus2, align 4
  %three.n.plus4 = add i64 %three.n, 4
  %idx.3n.plus4 = getelementptr inbounds i32, i32* %adj.base, i64 %three.n.plus4
  store i32 6, i32* %idx.3n.plus4, align 4
  %four.n = shl i64 %n.load2, 2
  %four.n.plus3 = add i64 %four.n, 3
  %idx.4n.plus3 = getelementptr inbounds i32, i32* %adj.base, i64 %four.n.plus3
  store i32 6, i32* %idx.4n.plus3, align 4
  %four.n.plus5 = add i64 %four.n, 5
  %idx.4n.plus5 = getelementptr inbounds i32, i32* %adj.base, i64 %four.n.plus5
  store i32 9, i32* %idx.4n.plus5, align 4
  %five.n.temp = add i64 %four.n, %n.load2
  %five.n.plus4 = add i64 %five.n.temp, 4
  %idx.5n.plus4 = getelementptr inbounds i32, i32* %adj.base, i64 %five.n.plus4
  store i32 9, i32* %idx.5n.plus4, align 4
  %dist.base = getelementptr inbounds [64 x i32], [64 x i32]* %dist, i64 0, i64 0
  %pred.base = getelementptr inbounds [64 x i32], [64 x i32]* %pred, i64 0, i64 0
  call void @dijkstra(i32* noundef %adj.base, i64 noundef %n.load2, i64 noundef 0, i32* noundef %dist.base, i32* noundef %pred.base)
  br label %print.loop

print.loop:                                       ; preds = %print.body.cont, %after.diag
  %i2.phi = phi i64 [ 0, %after.diag ], [ %i2.next, %print.body.cont ]
  %n.load3 = load i64, i64* %n.addr, align 8
  %cmp.print = icmp ult i64 %i2.phi, %n.load3
  br i1 %cmp.print, label %print.body, label %after.print

print.body:                                       ; preds = %print.loop
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %i2.phi
  %d.val = load i32, i32* %d.ptr, align 4
  %cmp.inf = icmp sgt i32 %d.val, 1061109566
  br i1 %cmp.inf, label %print.inf, label %print.norm

print.inf:                                        ; preds = %print.body
  %fmt.inf.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @_Format, i64 0, i64 0
  %call.inf = call i32 (i8*, ...) @printf(i8* noundef %fmt.inf.ptr, i64 noundef 0, i64 noundef %i2.phi)
  br label %print.body.cont

print.norm:                                       ; preds = %print.body
  %fmt.norm.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %call.norm = call i32 (i8*, ...) @printf(i8* noundef %fmt.norm.ptr, i64 noundef 0, i64 noundef %i2.phi, i32 noundef %d.val)
  br label %print.body.cont

print.body.cont:                                  ; preds = %print.norm, %print.inf
  %i2.next = add i64 %i2.phi, 1
  br label %print.loop

after.print:                                      ; preds = %print.loop
  %dest.idx = getelementptr inbounds i32, i32* %dist.base, i64 5
  %dest.val = load i32, i32* %dest.idx, align 4
  %cmp.no.path = icmp sgt i32 %dest.val, 1061109566
  br i1 %cmp.no.path, label %no.path, label %has.path

no.path:                                          ; preds = %after.print
  %fmt.nopath.ptr = getelementptr inbounds [25 x i8], [25 x i8]* @aNoPathFromZuTo, i64 0, i64 0
  %call.nopath = call i32 (i8*, ...) @printf(i8* noundef %fmt.nopath.ptr, i64 noundef 0, i64 noundef 5)
  br label %ret.blk

has.path:                                         ; preds = %after.print
  br label %collect.path

collect.path:                                     ; preds = %path.loop, %has.path
  %plen.phi = phi i64 [ 0, %has.path ], [ %plen.next, %path.loop ]
  %cur.phi = phi i32 [ 5, %has.path ], [ %cur.next, %path.loop ]
  %cmp.cur = icmp ne i32 %cur.phi, -1
  br i1 %cmp.cur, label %path.loop, label %after.collect

path.loop:                                        ; preds = %collect.path
  %cur64 = sext i32 %cur.phi to i64
  %p.slot = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 %plen.phi
  store i64 %cur64, i64* %p.slot, align 8
  %plen.next = add i64 %plen.phi, 1
  %pred.ptr = getelementptr inbounds i32, i32* %pred.base, i64 %cur64
  %cur.next = load i32, i32* %pred.ptr, align 4
  br label %collect.path

after.collect:                                    ; preds = %collect.path
  %fmt.path.ptr = getelementptr inbounds [17 x i8], [17 x i8]* @aPathZuZu, i64 0, i64 0
  %call.path.hdr = call i32 (i8*, ...) @printf(i8* noundef %fmt.path.ptr, i64 noundef 0, i64 noundef 5)
  br label %print.path.loop

print.path.loop:                                  ; preds = %print.path.cont, %after.collect
  %k.phi = phi i64 [ 0, %after.collect ], [ %k.next, %print.path.cont ]
  %cmp.k = icmp ult i64 %k.phi, %plen.phi
  br i1 %cmp.k, label %print.path.body, label %after.path.print

print.path.body:                                  ; preds = %print.path.loop
  %tmp.sub = sub i64 %plen.phi, %k.phi
  %idx.rev = add i64 %tmp.sub, -1
  %path.elem.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %path, i64 0, i64 %idx.rev
  %node = load i64, i64* %path.elem.ptr, align 8
  %k.plus1 = add i64 %k.phi, 1
  %more = icmp ult i64 %k.plus1, %plen.phi
  %arrow.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @asc_140004059, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_14000405D, i64 0, i64 0
  %suffix.sel = select i1 %more, i8* %arrow.ptr, i8* %empty.ptr
  %fmt.step.ptr = getelementptr inbounds [7 x i8], [7 x i8]* @aZuS, i64 0, i64 0
  %call.step = call i32 (i8*, ...) @printf(i8* noundef %fmt.step.ptr, i64 noundef %node, i8* noundef %suffix.sel)
  br label %print.path.cont

print.path.cont:                                  ; preds = %print.path.body
  %k.next = add i64 %k.phi, 1
  br label %print.path.loop

after.path.print:                                 ; preds = %print.path.loop
  %putc = call i32 @putchar(i32 noundef 10)
  br label %ret.blk

ret.blk:                                          ; preds = %after.path.print, %no.path
  ret i32 0
}