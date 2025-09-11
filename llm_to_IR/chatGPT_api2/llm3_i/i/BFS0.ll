; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print BFS order and per-node distances from node 0 on a fixed 7-node graph (confidence=0.86). Evidence: malloc(56) queue (7 x 8), __printf_chk patterns for BFS order and dist

@.str_order = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; undirected tree: 0-1,0-2,1-3,1-4,2-5,2-6
@adj = internal constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 1],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0]
], align 16

; Only the needed extern declarations:
declare i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue = alloca [7 x i64], align 16

  ; initialize dist[] = -1
  br label %init.loop

init.loop:                                           ; preds = %init.loop, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.loop ]
  %cmp.init = icmp slt i32 %i.ph, 7
  br i1 %cmp.init, label %init.body, label %init.done

init.body:                                           ; preds = %init.loop
  %i64 = sext i32 %i.ph to i64
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i64
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add nsw i32 %i.ph, 1
  br label %init.loop

init.done:                                           ; preds = %init.loop
  ; dist[0] = 0
  %dist0.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0.ptr, align 4

  ; queue[0] = 0; head=0; tail=1; count=0
  %q0.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 0
  store i64 0, i64* %q0.ptr, align 8
  %head.init = add i32 0, 0
  %tail.init = add i32 0, 1
  %cnt.init = add i32 0, 0

  ; also allocate heap queue as in original
  %qmem = call i8* @malloc(i64 56)

  br label %outer.cond

outer.cond:                                          ; preds = %inner.end, %init.done
  %head.ph = phi i32 [ %head.init, %init.done ], [ %head.next, %inner.end ]
  %tail.ph = phi i32 [ %tail.init, %init.done ], [ %tail.out, %inner.end ]
  %cnt.ph  = phi i32 [ %cnt.init,  %init.done ], [ %cnt.next, %inner.end ]
  %cmp.ht = icmp slt i32 %head.ph, %tail.ph
  br i1 %cmp.ht, label %outer.body, label %bfs.done

outer.body:                                          ; preds = %outer.cond
  %head.i64 = sext i32 %head.ph to i64
  %q.head.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %head.i64
  %cur = load i64, i64* %q.head.ptr, align 8
  %head.next = add nsw i32 %head.ph, 1
  %cnt.i64 = sext i32 %cnt.ph to i64
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %cnt.i64
  store i64 %cur, i64* %order.ptr, align 8
  %cnt.next = add nsw i32 %cnt.ph, 1
  br label %inner.cond

inner.cond:                                          ; preds = %inc, %outer.body
  %nb.ph = phi i32 [ 0, %outer.body ], [ %nb.next, %inc ]
  %tail.in = phi i32 [ %tail.ph, %outer.body ], [ %tail.sel, %inc ]
  %cur.ph = phi i64 [ %cur, %outer.body ], [ %cur, %inc ]
  %nb.cmp = icmp slt i32 %nb.ph, 7
  br i1 %nb.cmp, label %inner.body, label %inner.end

inner.body:                                          ; preds = %inner.cond
  %cur.i64 = sext i32 (trunc i64 %cur.ph to i32) to i64
  %nb.i64 = sext i32 %nb.ph to i64
  %row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %cur.i64
  %adj.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row.ptr, i64 0, i64 %nb.i64
  %edge = load i32, i32* %adj.elem.ptr, align 4
  %edge.nz = icmp ne i32 %edge, 0
  br i1 %edge.nz, label %check.unvisited, label %skip

check.unvisited:                                     ; preds = %inner.body
  %dist.nb.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %nb.i64
  %dnb = load i32, i32* %dist.nb.ptr, align 4
  %unvis = icmp eq i32 %dnb, -1
  br i1 %unvis, label %visit, label %skip

visit:                                               ; preds = %check.unvisited
  %dist.cur.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %cur.i64
  %dcur = load i32, i32* %dist.cur.ptr, align 4
  %dplus = add nsw i32 %dcur, 1
  store i32 %dplus, i32* %dist.nb.ptr, align 4
  %tail.i64 = sext i32 %tail.in to i64
  %q.tail.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %tail.i64
  %nb.as64 = sext i32 %nb.ph to i64
  store i64 %nb.as64, i64* %q.tail.ptr, align 8
  %tail.enq = add nsw i32 %tail.in, 1
  br label %inc

skip:                                                ; preds = %check.unvisited, %inner.body
  %tail.enq.skip = add i32 %tail.in, 0
  br label %inc

inc:                                                 ; preds = %skip, %visit
  %tail.sel = phi i32 [ %tail.enq, %visit ], [ %tail.enq.skip, %skip ]
  %nb.next = add nsw i32 %nb.ph, 1
  br label %inner.cond

inner.end:                                           ; preds = %inner.cond
  %tail.out = add i32 %tail.in, 0
  br label %outer.cond

bfs.done:                                            ; preds = %outer.cond
  ; free heap queue if allocated
  %qmem.nn = icmp ne i8* %qmem, null
  br i1 %qmem.nn, label %do.free, label %after.free

do.free:                                             ; preds = %bfs.done
  call void @free(i8* %qmem)
  br label %after.free

after.free:                                          ; preds = %do.free, %bfs.done
  ; print header: BFS order from 0:
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_order, i64 0, i64 0
  %hdr.call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)

  ; if malloc succeeded, print order list; else skip
  br i1 %qmem.nn, label %print.list, label %after.list

print.list:                                          ; preds = %after.free
  %i2.init = add i32 0, 0
  br label %plist.cond

plist.cond:                                          ; preds = %plist.inc, %print.list
  %i2.ph = phi i32 [ %i2.init, %print.list ], [ %i2.next, %plist.inc ]
  %cmp.i2 = icmp slt i32 %i2.ph, %cnt.ph
  br i1 %cmp.i2, label %plist.body, label %after.list

plist.body:                                          ; preds = %plist.cond
  %i2.i64 = sext i32 %i2.ph to i64
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i2.i64
  %ord.val = load i64, i64* %ord.ptr, align 8
  %next.idx = add nsw i32 %i2.ph, 1
  %is.last = icmp eq i32 %next.idx, %cnt.ph
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suf = select i1 %is.last, i8* %emp.ptr, i8* %sp.ptr
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call.list = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i64 %ord.val, i8* %suf)
  br label %plist.inc

plist.inc:                                           ; preds = %plist.body
  %i2.next = add nsw i32 %i2.ph, 1
  br label %plist.cond

after.list:                                          ; preds = %plist.cond, %after.free
  ; newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %nl.call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)

  ; print distances
  br label %dist.cond

dist.cond:                                           ; preds = %dist.inc, %after.list
  %di.ph = phi i32 [ 0, %after.list ], [ %di.next, %dist.inc ]
  %cmp.di = icmp slt i32 %di.ph, 7
  br i1 %cmp.di, label %dist.body, label %ret

dist.body:                                           ; preds = %dist.cond
  %di.i64 = sext i32 %di.ph to i64
  %d.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di.i64
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.dist, i64 0, i64 %di.i64, i32 %d.val)
  br label %dist.inc

dist.inc:                                            ; preds = %dist.body
  %di.next = add nsw i32 %di.ph, 1
  br label %dist.cond

ret:                                                 ; preds = %dist.cond
  ret i32 0
}