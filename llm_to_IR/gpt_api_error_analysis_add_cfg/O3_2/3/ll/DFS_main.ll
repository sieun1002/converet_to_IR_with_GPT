; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.nl     = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.fmt    = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

@qword_2028 = external global i8*

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() local_unnamed_addr {
bb10e0:
  %canary.init = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.slot = alloca i64, align 8
  store i64 %canary.init, i64* %canary.slot, align 8

  %matrix = alloca [49 x i32], align 16
  %order  = alloca [7 x i64], align 16
  %curNode.slot = alloca i64, align 8
  %sp.slot   = alloca i64, align 8
  %cnt.slot  = alloca i64, align 8

  %mbytes = bitcast [49 x i32]* %matrix to i8*
  call void @llvm.memset.p0i8.i64(i8* %mbytes, i8 0, i64 196, i1 false)

  %m48.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 48
  store i32 0, i32* %m48.ptr, align 4

  %qptr = load i8*, i8** @qword_2028
  %qval = ptrtoint i8* %qptr to i64
  %m1.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 1
  %m1.i64 = bitcast i32* %m1.i32 to i64*
  store i64 %qval, i64* %m1.i64, align 4
  %m10.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 10
  %m10.i64 = bitcast i32* %m10.i32 to i64*
  store i64 %qval, i64* %m10.i64, align 4

  %m7   = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 7
  %m14  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 14
  %m19  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 19
  %m22  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 22
  %m29  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 29
  %m33  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 33
  %m37  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 37
  %m39  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 39
  %m41  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 41
  %m47  = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 47
  store i32 1, i32* %m7,  align 4
  store i32 1, i32* %m14, align 4
  store i32 1, i32* %m22, align 4
  store i32 1, i32* %m29, align 4
  store i32 1, i32* %m19, align 4
  store i32 1, i32* %m37, align 4
  store i32 1, i32* %m33, align 4
  store i32 1, i32* %m39, align 4
  store i32 1, i32* %m41, align 4
  store i32 1, i32* %m47, align 4

  %visited.raw = call i8* @calloc(i64 28, i64 1)
  %next.raw    = call i8* @calloc(i64 56, i64 1)
  %stack.raw   = call i8* @malloc(i64 56)

  %visited = bitcast i8* %visited.raw to i32*
  %nextArr = bitcast i8* %next.raw    to i64*
  %stack   = bitcast i8* %stack.raw   to i64*

  %v.null = icmp eq i8* %visited.raw, null
  %n.null = icmp eq i8* %next.raw,    null
  %s.null = icmp eq i8* %stack.raw,   null
  %any.null0 = or i1 %v.null, %n.null
  %any.null  = or i1 %any.null0, %s.null
  br i1 %any.null, label %bb1455, label %bb11e0

bb11e0:
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 0, i64* %stack0, align 8
  store i64 1, i64* %cnt.slot, align 8
  store i64 1, i64* %sp.slot,  align 8
  %v0 = getelementptr inbounds i32, i32* %visited, i64 0
  store i32 1, i32* %v0, align 4
  %o0 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  store i64 0, i64* %o0, align 8
  store i64 0, i64* %curNode.slot, align 8
  br label %bb120d

bb1208:
  %sp1208 = load i64, i64* %sp.slot, align 8
  %spm1   = add i64 %sp1208, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %spm1
  %node = load i64, i64* %top.ptr, align 8
  store i64 %node, i64* %curNode.slot, align 8
  br label %bb120d

bb120d:
  %node120d = load i64, i64* %curNode.slot, align 8
  %r8.ptr = getelementptr inbounds i64, i64* %nextArr, i64 %node120d
  %nextIdx = load i64, i64* %r8.ptr, align 8
  %gt6 = icmp ugt i64 %nextIdx, 6
  br i1 %gt6, label %bb1412, label %bb1227

bb1227:
  %mul7 = mul i64 %node120d, 7
  %idx0 = add i64 %nextIdx, %mul7
  %m.idx0 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx0
  %adj0 = load i32, i32* %m.idx0, align 4
  %adj0nz = icmp ne i32 %adj0, 0
  br i1 %adj0nz, label %bb1238, label %bb1248

bb1238:
  %v.nextIdx.ptr = getelementptr inbounds i32, i32* %visited, i64 %nextIdx
  %v.nextIdx = load i32, i32* %v.nextIdx.ptr, align 4
  %vis0 = icmp ne i32 %v.nextIdx, 0
  br i1 %vis0, label %bb1248, label %bb13ea

bb1248:
  %cand1 = add i64 %nextIdx, 1
  %eq6 = icmp eq i64 %nextIdx, 6
  br i1 %eq6, label %bb133d, label %bb1256

bb1256:
  %idx1 = add i64 %cand1, %mul7
  %m.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx1
  %adj1 = load i32, i32* %m.idx1, align 4
  %adj1nz = icmp ne i32 %adj1, 0
  br i1 %adj1nz, label %bb1264, label %bb1274

bb1264:
  %v.cand1.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand1
  %v.cand1 = load i32, i32* %v.cand1.ptr, align 4
  %vis1 = icmp ne i32 %v.cand1, 0
  br i1 %vis1, label %bb1274, label %bb13f0_from1

bb1274:
  %cand2 = add i64 %nextIdx, 2
  %eq5 = icmp eq i64 %nextIdx, 5
  br i1 %eq5, label %bb133d, label %bb1282

bb1282:
  %idx2 = add i64 %cand2, %mul7
  %m.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx2
  %adj2 = load i32, i32* %m.idx2, align 4
  %adj2nz = icmp ne i32 %adj2, 0
  br i1 %adj2nz, label %bb1290, label %bb12a0

bb1290:
  %v.cand2.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand2
  %v.cand2 = load i32, i32* %v.cand2.ptr, align 4
  %vis2 = icmp ne i32 %v.cand2, 0
  br i1 %vis2, label %bb12a0, label %bb13f0_from2

bb12a0:
  %cand3 = add i64 %nextIdx, 3
  %eq4 = icmp eq i64 %nextIdx, 4
  br i1 %eq4, label %bb133d, label %bb12ae

bb12ae:
  %idx3 = add i64 %cand3, %mul7
  %m.idx3 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx3
  %adj3 = load i32, i32* %m.idx3, align 4
  %adj3nz = icmp ne i32 %adj3, 0
  br i1 %adj3nz, label %bb12bc, label %bb12cc

bb12bc:
  %v.cand3.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand3
  %v.cand3 = load i32, i32* %v.cand3.ptr, align 4
  %vis3 = icmp ne i32 %v.cand3, 0
  br i1 %vis3, label %bb12cc, label %bb13f0_from3

bb12cc:
  %cand4 = add i64 %nextIdx, 4
  %eq3 = icmp eq i64 %nextIdx, 3
  br i1 %eq3, label %bb133d, label %bb12d6

bb12d6:
  %idx4 = add i64 %cand4, %mul7
  %m.idx4 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx4
  %adj4 = load i32, i32* %m.idx4, align 4
  %adj4nz = icmp ne i32 %adj4, 0
  br i1 %adj4nz, label %bb12e4, label %bb12f4

bb12e4:
  %v.cand4.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand4
  %v.cand4 = load i32, i32* %v.cand4.ptr, align 4
  %vis4 = icmp ne i32 %v.cand4, 0
  br i1 %vis4, label %bb12f4, label %bb13f0_from4

bb12f4:
  %cand5 = add i64 %nextIdx, 5
  %eq2 = icmp eq i64 %nextIdx, 2
  br i1 %eq2, label %bb133d, label %bb12fe

bb12fe:
  %idx5 = add i64 %cand5, %mul7
  %m.idx5 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx5
  %adj5 = load i32, i32* %m.idx5, align 4
  %adj5nz = icmp ne i32 %adj5, 0
  br i1 %adj5nz, label %bb130c, label %bb131c

bb130c:
  %v.cand5.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand5
  %v.cand5 = load i32, i32* %v.cand5.ptr, align 4
  %vis5 = icmp ne i32 %v.cand5, 0
  br i1 %vis5, label %bb131c, label %bb13f0_from5

bb131c:
  %nz.next = icmp ne i64 %nextIdx, 0
  br i1 %nz.next, label %bb133d, label %bb1321

bb1321:
  %idx6 = add i64 %mul7, 6
  %m.idx6 = getelementptr inbounds [49 x i32], [49 x i32]* %matrix, i64 0, i64 %idx6
  %adj6 = load i32, i32* %m.idx6, align 4
  %adj6nz = icmp ne i32 %adj6, 0
  br i1 %adj6nz, label %bb1329, label %bb133d

bb1329:
  %v6.ptr = getelementptr inbounds i32, i32* %visited, i64 6
  %v6 = load i32, i32* %v6.ptr, align 4
  %vis6 = icmp ne i32 %v6, 0
  br i1 %vis6, label %bb133d, label %bb13f0_from6

bb133d:
  %sp.before = load i64, i64* %sp.slot, align 8
  %sp.dec = add i64 %sp.before, -1
  store i64 %sp.dec, i64* %sp.slot, align 8
  %sp.isnz = icmp ne i64 %sp.dec, 0
  br i1 %sp.isnz, label %bb1208, label %bb134a

bb1341:
  %sp.now = load i64, i64* %sp.slot, align 8
  %sp.nonzero = icmp ne i64 %sp.now, 0
  br i1 %sp.nonzero, label %bb1208, label %bb134a

bb134a:
  call void @free(i8* %visited.raw)
  call void @free(i8* %next.raw)
  call void @free(i8* %stack.raw)
  br label %bb1362

bb1362:
  %fmt.header.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %zero64 = add i64 0, 0
  %call.header = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.header.ptr, i64 %zero64)
  br label %bb1377

bb1377:
  %cnt = load i64, i64* %cnt.slot, align 8
  %have = icmp ne i64 %cnt, 0
  br i1 %have, label %bb1380, label %bb13ae

bb1380:
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %rdx.init = load i64, i64* %order.base, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt, i64 0, i64 0
  %single = icmp ne i64 %cnt, 1
  br i1 %single, label %bb1421, label %bb1398

bb1398:
  %rdx.sel = phi i64 [ %rdx.init, %bb1380 ], [ %rdx.for.last, %bb1450 ]
  %empty.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 1
  %call.last = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %rdx.sel, i8* %empty.ptr)
  br label %bb13ae

bb13ae:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  br label %bb13c1

bb13c1:
  %canary.saved = load i64, i64* %canary.slot, align 8
  %canary.cur = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.eq = icmp eq i64 %canary.saved, %canary.cur
  br i1 %canary.eq, label %bb13d8, label %bb1487

bb13d8:
  ret i32 0

bb1412:
  %is7 = icmp eq i64 %nextIdx, 7
  br i1 %is7, label %bb133d, label %bb1208

bb1421:
  %rbx.start = add i64 0, 1
  %space.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 22
  %order.base2 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  br label %bb1430

bb1430:
  %rbx.phi = phi i64 [ %rbx.start, %bb1421 ], [ %rbx.inc, %bb1430.latch ]
  %idx.print = add i64 %rbx.phi, -1
  %elem.ptr = getelementptr inbounds i64, i64* %order.base2, i64 %idx.print
  %rdx.loop = load i64, i64* %elem.ptr, align 8
  %call.each = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %rdx.loop, i8* %space.ptr)
  %rbx.inc = add i64 %rbx.phi, 1
  %idx.next = add i64 %rbx.inc, -1
  %elem.next.ptr = getelementptr inbounds i64, i64* %order.base2, i64 %idx.next
  %rdx.next = load i64, i64* %elem.next.ptr, align 8
  %cont = icmp ne i64 %rbx.inc, %cnt
  br i1 %cont, label %bb1430.latch, label %bb1450

bb1430.latch:
  br label %bb1430

bb1450:
  %rdx.for.last = phi i64 [ %rdx.next, %bb1430 ]
  br label %bb1398

bb13ea:
  br label %bb13f0_from0

bb13f0_from0:
  %cand0 = phi i64 [ %nextIdx, %bb13ea ]
  br label %bb13f0

bb13f0_from1:
  br label %bb13f0

bb13f0_from2:
  br label %bb13f0

bb13f0_from3:
  br label %bb13f0

bb13f0_from4:
  br label %bb13f0

bb13f0_from5:
  br label %bb13f0

bb13f0_from6:
  br label %bb13f0

bb13f0:
  %cand.sel = phi i64 [ %cand0, %bb13f0_from0 ],
                     [ %cand1, %bb13f0_from1 ],
                     [ %cand2, %bb13f0_from2 ],
                     [ %cand3, %bb13f0_from3 ],
                     [ %cand4, %bb13f0_from4 ],
                     [ %cand5, %bb13f0_from5 ],
                     [ 6,       %bb13f0_from6 ]
  %cnt.cur = load i64, i64* %cnt.slot, align 8
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %cnt.cur
  store i64 %cand.sel, i64* %ord.ptr, align 8
  %cnt.inc = add i64 %cnt.cur, 1
  store i64 %cnt.inc, i64* %cnt.slot, align 8
  %sp.cur = load i64, i64* %sp.slot, align 8
  %stk.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %sp.cur
  store i64 %cand.sel, i64* %stk.push.ptr, align 8
  %sp.new = add i64 %sp.cur, 1
  store i64 %sp.new, i64* %sp.slot, align 8
  %node13f0 = load i64, i64* %curNode.slot, align 8
  %r8.ptr.13f0 = getelementptr inbounds i64, i64* %nextArr, i64 %node13f0
  %cand.plus1 = add i64 %cand.sel, 1
  store i64 %cand.plus1, i64* %r8.ptr.13f0, align 8
  %v.cand.ptr = getelementptr inbounds i32, i32* %visited, i64 %cand.sel
  store i32 1, i32* %v.cand.ptr, align 4
  br label %bb1341

bb1455:
  call void @free(i8* %visited.raw)
  call void @free(i8* %next.raw)
  call void @free(i8* %stack.raw)
  %fmt.header.ptr2 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %call.header2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.header.ptr2, i64 0)
  br label %bb13ae

bb1487:
  call void @__stack_chk_fail()
  unreachable
}