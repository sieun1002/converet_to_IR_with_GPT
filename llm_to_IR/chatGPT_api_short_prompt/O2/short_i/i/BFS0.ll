; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: BFS traversal from node 0; print visit order and distances (confidence=0.88). Evidence: uses "BFS order from %zu: " and "dist(%zu -> %zu) = %d\n"; queue via malloc and neighbor scan 0..6.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@adj = private constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
], align 16

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  ; constants
  %N = add i32 0, 7
  %N64 = zext i32 %N to i64

  ; allocas
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %front = alloca i64, align 8
  %back = alloca i64, align 8
  %count = alloca i64, align 8
  %qptr = alloca i8*, align 8

  ; init dist[i] = -1
  br label %dist.init

dist.init:
  %i0 = phi i64 [ 0, %entry ], [ %i0.next, %dist.init.body ]
  %cmp0 = icmp ult i64 %i0, %N64
  br i1 %cmp0, label %dist.init.body, label %dist.init.end

dist.init.body:
  %dist.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i0
  store i32 -1, i32* %dist.gep, align 4
  %i0.next = add i64 %i0, 1
  br label %dist.init

dist.init.end:
  ; allocate queue of 7 qwords (56 bytes)
  %qmem = call noalias i8* @malloc(i64 56)
  store i8* %qmem, i8** %qptr, align 8
  %qnull = icmp eq i8* %qmem, null
  br i1 %qnull, label %noqueue, label %havequeue

havequeue:
  ; q[0] = 0; front=0; back=1; count=0
  %q64 = bitcast i8* %qmem to i64*
  %q0 = getelementptr inbounds i64, i64* %q64, i64 0
  store i64 0, i64* %q0, align 8
  store i64 0, i64* %front, align 8
  store i64 1, i64* %back, align 8
  store i64 0, i64* %count, align 8
  br label %bfs.loop.check

bfs.loop.check:
  %f = load i64, i64* %front, align 8
  %b = load i64, i64* %back, align 8
  %more = icmp ult i64 %f, %b
  br i1 %more, label %bfs.loop.body, label %bfs.done

bfs.loop.body:
  ; a = q[front++]
  %qa.ptr = getelementptr inbounds i64, i64* %q64, i64 %f
  %a = load i64, i64* %qa.ptr, align 8
  %f.next = add i64 %f, 1
  store i64 %f.next, i64* %front, align 8
  ; order[count++] = a
  %cnt = load i64, i64* %count, align 8
  %ord.slot = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %cnt
  store i64 %a, i64* %ord.slot, align 8
  %cnt.next = add i64 %cnt, 1
  store i64 %cnt.next, i64* %count, align 8

  ; inner neighbors loop: for b=0..6
  br label %nbr.loop

nbr.loop:
  %bi = phi i64 [ 0, %bfs.loop.body ], [ %bi.next, %nbr.loop.end ]
  %cond = icmp ult i64 %bi, %N64
  br i1 %cond, label %nbr.loop.body, label %bfs.loop.check

nbr.loop.body:
  ; if (adj[a][b] && dist[b] == -1)
  %row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %a
  %cell.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row.ptr, i64 0, i64 %bi
  %adjval = load i32, i32* %cell.ptr, align 4
  %adj.nz = icmp ne i32 %adjval, 0
  br i1 %adj.nz, label %check.dist, label %nbr.loop.end

check.dist:
  %db.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %bi
  %db = load i32, i32* %db.ptr, align 4
  %is.neg1 = icmp eq i32 %db, -1
  br i1 %is.neg1, label %enqueue, label %nbr.loop.end

enqueue:
  ; q[back++] = b
  %bidx = load i64, i64* %back, align 8
  %qb.ptr = getelementptr inbounds i64, i64* %q64, i64 %bidx
  store i64 %bi, i64* %qb.ptr, align 8
  %bidx.next = add i64 %bidx, 1
  store i64 %bidx.next, i64* %back, align 8
  ; dist[b] = dist[a] + 1
  %da.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %a
  %da = load i32, i32* %da.ptr, align 4
  %da.plus1 = add i32 %da, 1
  store i32 %da.plus1, i32* %db.ptr, align 4
  br label %nbr.loop.end

nbr.loop.end:
  %bi.next = add i64 %bi, 1
  br label %nbr.loop

bfs.done:
  ; free queue
  %qmem2 = load i8*, i8** %qptr, align 8
  call void @free(i8* %qmem2)
  br label %print.header

noqueue:
  ; count = 0 (no BFS), print header then newline, then distances (all -1)
  store i64 0, i64* %count, align 8
  br label %print.header

print.header:
  ; __printf_chk(1, "BFS order from %zu: ", (size_t)0)
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_header, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr.ptr, i64 0)
  ; print BFS order list
  %cnt.final = load i64, i64* %count, align 8
  br label %order.loop

order.loop:
  %oi = phi i64 [ 0, %print.header ], [ %oi.next, %order.loop.cont ]
  %more.ord = icmp ult i64 %oi, %cnt.final
  br i1 %more.ord, label %order.loop.body, label %order.done

order.loop.body:
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oi
  %elem = load i64, i64* %elem.ptr, align 8
  ; choose suffix: space for non-last, "" for last
  %is.last = icmp eq i64 %oi, sub i64 %cnt.final, 1
  %sp.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %emp.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %is.last, i8* %emp.ptr, i8* %sp.ptr
  %fmt.pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call.pair = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.pair, i64 %elem, i8* %suffix)
  br label %order.loop.cont

order.loop.cont:
  %oi.next = add i64 %oi, 1
  br label %order.loop

order.done:
  ; newline after order
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)

  ; print distances
  br label %dist.print

dist.print:
  %di = phi i64 [ 0, %order.done ], [ %di.next, %dist.print.body ]
  %cond.dp = icmp ult i64 %di, %N64
  br i1 %cond.dp, label %dist.print.body, label %ret

dist.print.body:
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di
  %dval = load i32, i32* %dptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.dist, i64 0, i64 %di, i32 %dval)
  %di.next = add i64 %di, 1
  br label %dist.print

ret:
  ret i32 0
}