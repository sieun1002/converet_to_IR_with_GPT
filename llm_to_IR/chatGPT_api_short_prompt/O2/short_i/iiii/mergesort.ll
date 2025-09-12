; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: bottom-up mergesort of 10 ints then print them (confidence=0.93). Evidence: iterative merge with ping-pong buffers; prints "%d " loop and newline
; Preconditions: none
; Postconditions: prints 10 space-separated integers followed by newline

; Only the necessary external declarations:
; declare i32 @__printf_chk(i32, i8*, ...)
; declare noalias i8* @malloc(i64)
; declare void @free(i8*)

@.str = private constant [4 x i8] c"%d \00"
@.nl = private constant [2 x i8] c"\0A\00"

declare i32 @__printf_chk(i32, i8*, ...)
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %stack.begin = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  %p0 = getelementptr inbounds i32, i32* %stack.begin, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds i32, i32* %stack.begin, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %stack.begin, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds i32, i32* %stack.begin, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %stack.begin, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds i32, i32* %stack.begin, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %stack.begin, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds i32, i32* %stack.begin, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %stack.begin, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds i32, i32* %stack.begin, i64 9
  store i32 0, i32* %p9, align 4

  %tmp.buf.raw = call noalias i8* @malloc(i64 40)
  %tmp.ok = icmp ne i8* %tmp.buf.raw, null
  br i1 %tmp.ok, label %sort, label %print

sort:
  %tmp.buf = bitcast i8* %tmp.buf.raw to i32*
  br label %pass.loop

pass.loop:                                        ; passes_left in [1..4], len starts at 1 doubles each pass
  %src.phi = phi i32* [ %stack.begin, %sort ], [ %src.next, %after.pass ]
  %dest.phi = phi i32* [ %tmp.buf, %sort ], [ %dest.next, %after.pass ]
  %len.phi = phi i32 [ 1, %sort ], [ %len.next, %after.pass ]
  %passes.phi = phi i32 [ 4, %sort ], [ %passes.next, %after.pass ]
  br label %i.loop

i.loop:
  %i = phi i32 [ 0, %pass.loop ], [ %i.next, %after.merge.range ]
  %cond.i = icmp ult i32 %i, 10
  br i1 %cond.i, label %merge.range, label %after.pass

merge.range:
  %i.plus.len = add i32 %i, %len.phi
  %mid = call i32 @llvm.umin.i32(i32 %i.plus.len, i32 10)
  %len.twice = shl i32 %len.phi, 1
  %i.plus.2len = add i32 %i, %len.twice
  %right = call i32 @llvm.umin.i32(i32 %i.plus.2len, i32 10)
  ; set up merge indices
  br label %merge.loop

merge.loop:
  %a = phi i32 [ %i, %merge.range ], [ %a.next, %choose.cont ]
  %b = phi i32 [ %mid, %merge.range ], [ %b.next, %choose.cont ]
  %out = phi i32 [ %i, %merge.range ], [ %out.next, %choose.cont ]
  %more = icmp ult i32 %out, %right
  br i1 %more, label %choose, label %after.merge.range

choose:
  %a.valid = icmp ult i32 %a, %mid
  br i1 %a.valid, label %a.valid.block, label %choose.b

a.valid.block:
  %b.valid = icmp ult i32 %b, %right
  br i1 %b.valid, label %both.valid, label %choose.a.only

both.valid:
  ; load both and compare
  %a.idx64 = zext i32 %a to i64
  %b.idx64 = zext i32 %b to i64
  %a.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %a.idx64
  %b.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %b.idx64
  %a.val = load i32, i32* %a.ptr, align 4
  %b.val = load i32, i32* %b.ptr, align 4
  %take.a = icmp sle i32 %a.val, %b.val
  br i1 %take.a, label %choose.a.with.a, label %choose.b.with.b

choose.a.with.a:
  %out.idx64.a = zext i32 %out to i64
  %out.ptr.a = getelementptr inbounds i32, i32* %dest.phi, i64 %out.idx64.a
  store i32 %a.val, i32* %out.ptr.a, align 4
  %a.next.a = add i32 %a, 1
  %out.next.a = add i32 %out, 1
  br label %choose.cont

choose.b.with.b:
  %out.idx64.b = zext i32 %out to i64
  %out.ptr.b = getelementptr inbounds i32, i32* %dest.phi, i64 %out.idx64.b
  store i32 %b.val, i32* %out.ptr.b, align 4
  %b.next.b = add i32 %b, 1
  %out.next.b = add i32 %out, 1
  br label %choose.cont

choose.a.only:
  ; only a is valid
  %a.idx64.only = zext i32 %a to i64
  %a.ptr.only = getelementptr inbounds i32, i32* %src.phi, i64 %a.idx64.only
  %a.val.only = load i32, i32* %a.ptr.only, align 4
  %out.idx64.only = zext i32 %out to i64
  %out.ptr.only = getelementptr inbounds i32, i32* %dest.phi, i64 %out.idx64.only
  store i32 %a.val.only, i32* %out.ptr.only, align 4
  %a.next.only = add i32 %a, 1
  %out.next.only = add i32 %out, 1
  br label %choose.cont

choose.b:
  ; a not valid => must take b
  %b.idx64.only = zext i32 %b to i64
  %b.ptr.only = getelementptr inbounds i32, i32* %src.phi, i64 %b.idx64.only
  %b.val.only = load i32, i32* %b.ptr.only, align 4
  %out.idx64.onlyb = zext i32 %out to i64
  %out.ptr.onlyb = getelementptr inbounds i32, i32* %dest.phi, i64 %out.idx64.onlyb
  store i32 %b.val.only, i32* %out.ptr.onlyb, align 4
  %b.next.only = add i32 %b, 1
  %out.next.onlyb = add i32 %out, 1
  br label %choose.cont

choose.cont:
  %a.next = phi i32 [ %a.next.a, %choose.a.with.a ], [ %a, %choose.b.with.b ], [ %a.next.only, %choose.a.only ], [ %a, %choose.b ]
  %b.next = phi i32 [ %b, %choose.a.with.a ], [ %b.next.b, %choose.b.with.b ], [ %b, %choose.a.only ], [ %b.next.only, %choose.b ]
  %out.next = phi i32 [ %out.next.a, %choose.a.with.a ], [ %out.next.b, %choose.b.with.b ], [ %out.next.only, %choose.a.only ], [ %out.next.onlyb, %choose.b ]
  br label %merge.loop

after.merge.range:
  %i.next = add i32 %i, %len.twice
  br label %i.loop

after.pass:
  %passes.next = add i32 %passes.phi, -1
  %done = icmp eq i32 %passes.next, 0
  br i1 %done, label %after.sort, label %swap.and.cont

swap.and.cont:
  %src.next = phi i32* [ %dest.phi, %after.pass ]
  %dest.next = phi i32* [ %src.phi, %after.pass ]
  %len.next = shl i32 %len.phi, 1
  br label %pass.loop

after.sort:
  ; dest.phi holds the destination of the final pass
  %need.copy = icmp ne i32* %dest.phi, %stack.begin
  br i1 %need.copy, label %copy.back, label %after.copy

copy.back:
  br label %copy.loop

copy.loop:
  %ci = phi i32 [ 0, %copy.back ], [ %ci.next, %copy.loop ]
  %c.cond = icmp ult i32 %ci, 10
  br i1 %c.cond, label %copy.body, label %copy.done

copy.body:
  %ci64 = zext i32 %ci to i64
  %src.ptr.c = getelementptr inbounds i32, i32* %dest.phi, i64 %ci64
  %val.c = load i32, i32* %src.ptr.c, align 4
  %dst.ptr.c = getelementptr inbounds i32, i32* %stack.begin, i64 %ci64
  store i32 %val.c, i32* %dst.ptr.c, align 4
  %ci.next = add i32 %ci, 1
  br label %copy.loop

copy.done:
  br label %after.copy

after.copy:
  call void @free(i8* %tmp.buf.raw)
  br label %print

print:
  ; print 10 ints from stack
  br label %pl.loop

pl.loop:
  %pi = phi i32 [ 0, %print ], [ %pi.next, %pl.loop ]
  %pl.cond = icmp ult i32 %pi, 10
  br i1 %pl.cond, label %pl.body, label %pl.done

pl.body:
  %pi64 = zext i32 %pi to i64
  %p.ptr = getelementptr inbounds i32, i32* %stack.begin, i64 %pi64
  %p.val = load i32, i32* %p.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %p.val)
  %pi.next = add i32 %pi, 1
  br label %pl.loop

pl.done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}

declare i32 @llvm.umin.i32(i32, i32) nounwind readnone willreturn intrinsic