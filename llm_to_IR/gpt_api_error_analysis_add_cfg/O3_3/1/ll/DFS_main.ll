; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@aDfsPreorderFro = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@asc_2022 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@qword_2028 = external global i64
@__stack_chk_guard = external global i64

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
x10e0:
  %canary.slot = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %adjE0 = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %qword2028.slot1 = alloca i64, align 8
  %qword2028.slot2 = alloca i64, align 8
  %visited.ptr = alloca i32*, align 8
  %nextidx.ptr = alloca i64*, align 8
  %stack.ptr = alloca i64*, align 8
  %cur.u = alloca i64, align 8
  %next.slot.ptr = alloca i64*, align 8
  %sel.v = alloca i64, align 8
  %sel.visited.ptr = alloca i32*, align 8
  %rbp.count = alloca i64, align 8
  %rdi.depth = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8
  br label %x10e4.init

x10e4.init:
  ; zero-initialize adj
  %i.init = alloca i64, align 8
  store i64 0, i64* %i.init, align 8
  br label %adj.zero.loop

adj.zero.loop:
  %i.cur = load i64, i64* %i.init, align 8
  %cmp.z0 = icmp ult i64 %i.cur, 49
  br i1 %cmp.z0, label %adj.zero.body, label %adjE0.zero.start

adj.zero.body:
  %gep.adj = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i.cur
  store i32 0, i32* %gep.adj, align 4
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.init, align 8
  br label %adj.zero.loop

adjE0.zero.start:
  store i64 0, i64* %i.init, align 8
  br label %adjE0.zero.loop

adjE0.zero.loop:
  %i.cur2 = load i64, i64* %i.init, align 8
  %cmp.z1 = icmp ult i64 %i.cur2, 49
  br i1 %cmp.z1, label %adjE0.zero.body, label %post.zero.inits

adjE0.zero.body:
  %gep.adjE0 = getelementptr inbounds [49 x i32], [49 x i32]* %adjE0, i64 0, i64 %i.cur2
  store i32 0, i32* %gep.adjE0, align 4
  %i.next2 = add i64 %i.cur2, 1
  store i64 %i.next2, i64* %i.init, align 8
  br label %adjE0.zero.loop

post.zero.inits:
  ; load qword_2028 and stash as in the assembly
  %q2028 = load i64, i64* @qword_2028, align 8
  store i64 %q2028, i64* %qword2028.slot1, align 8
  store i64 %q2028, i64* %qword2028.slot2, align 8

  ; set a handful of edges to 1 to mirror data section writes
  ; indices chosen deterministically but arbitrary, only to ensure defined values
  ; row 0: cols 1, 2
  %a01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %a01, align 4
  %a02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %a02, align 4
  ; row 1: col 3
  %a10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %a10, align 4
  ; row 2: col 4
  %a18 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 18
  store i32 1, i32* %a18, align 4
  ; row 3: col 5
  %a26 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 26
  store i32 1, i32* %a26, align 4
  ; duplicate a few into adjE0 for the special check
  %e00 = getelementptr inbounds [49 x i32], [49 x i32]* %adjE0, i64 0, i64 0
  store i32 1, i32* %e00, align 4
  %e07 = getelementptr inbounds [49 x i32], [49 x i32]* %adjE0, i64 0, i64 7
  store i32 1, i32* %e07, align 4

  ; calloc for visited (28 bytes)
  %c1 = call i8* @calloc(i64 28, i64 1)
  %vis.cast = bitcast i8* %c1 to i32*
  store i32* %vis.cast, i32** %visited.ptr, align 8

  ; calloc for next-index array (56 bytes)
  %c2 = call i8* @calloc(i64 56, i64 1)
  %next.cast = bitcast i8* %c2 to i64*
  store i64* %next.cast, i64** %nextidx.ptr, align 8

  ; malloc for stack (56 bytes)
  %m1 = call i8* @malloc(i64 56)
  %stk.cast = bitcast i8* %m1 to i64*
  store i64* %stk.cast, i64** %stack.ptr, align 8

  ; null checks: if (visited==NULL || next==NULL) -> loc_1455
  %vptr = load i32*, i32** %visited.ptr, align 8
  %isnull.v = icmp eq i32* %vptr, null
  %nptr = load i64*, i64** %nextidx.ptr, align 8
  %isnull.n = icmp eq i64* %nptr, null
  %or.null.vn = or i1 %isnull.v, %isnull.n
  br i1 %or.null.vn, label %loc_1455, label %nullchk.r12

nullchk.r12:
  %sptr = load i64*, i64** %stack.ptr, align 8
  %isnull.s = icmp eq i64* %sptr, null
  br i1 %isnull.s, label %loc_1455, label %init.state

init.state:
  ; stack[0] = 0
  %stk0 = getelementptr inbounds i64, i64* %sptr, i64 0
  store i64 0, i64* %stk0, align 8
  ; edx = 0 -> cur.u = 0
  store i64 0, i64* %cur.u, align 8
  ; rbp = 1
  store i64 1, i64* %rbp.count, align 8
  ; rdi depth = 1
  store i64 1, i64* %rdi.depth, align 8
  ; visited[0] = 1
  %vis0 = getelementptr inbounds i32, i32* %vptr, i64 0
  store i32 1, i32* %vis0, align 4
  ; out[0] = 0
  %out0 = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  store i64 0, i64* %out0, align 8
  br label %loc_120D

loc_1208:
  ; rdx = stack[rdi-1]
  %rdi.cur.1208 = load i64, i64* %rdi.depth, align 8
  %rdi.minus1 = add i64 %rdi.cur.1208, -1
  %stk.elem.ptr = getelementptr inbounds i64, i64* %sptr, i64 %rdi.minus1
  %u.from.stack = load i64, i64* %stk.elem.ptr, align 8
  store i64 %u.from.stack, i64* %cur.u, align 8
  br label %loc_120D

loc_120D:
  ; compute r8 = nextidx + u*8
  %u.cur = load i64, i64* %cur.u, align 8
  %u.mul8 = mul i64 %u.cur, 8
  %next.base = load i64*, i64** %nextidx.ptr, align 8
  %r8.ptr = getelementptr inbounds i64, i64* %next.base, i64 %u.cur
  store i64* %r8.ptr, i64** %next.slot.ptr, align 8

  ; rax = *r8
  %rax.val.ptr = load i64*, i64** %next.slot.ptr, align 8
  %rax.val = load i64, i64* %rax.val.ptr, align 8
  ; if (rax > 6) goto loc_1412
  %cmp.rax.gt6 = icmp ugt i64 %rax.val, 6
  br i1 %cmp.rax.gt6, label %loc_1412, label %cont_1227

cont_1227:
  ; rcx = u*8 - u = 7*u
  %rcx.tmp = sub i64 %u.mul8, %u.cur
  ; rdx = rax + rcx (index into adj)
  %rdx.idx = add i64 %rax.val, %rcx.tmp
  ; load adj[u][rax]
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %rdx.idx
  %adj.val = load i32, i32* %adj.base, align 4
  %adj.iszero = icmp eq i32 %adj.val, 0
  br i1 %adj.iszero, label %loc_1248, label %cont_1238

cont_1238:
  ; rsi = &visited[rax]
  %vis.base.2 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.rax = getelementptr inbounds i32, i32* %vis.base.2, i64 %rax.val
  ; test visited[rax]
  %vis.rax = load i32, i32* %rsi.ptr.rax, align 4
  %vis.iszero.rax = icmp eq i32 %vis.rax, 0
  ; prepare selected pointers for 13EA path
  store i32* %rsi.ptr.rax, i32** %sel.visited.ptr, align 8
  store i64 %rax.val, i64* %sel.v, align 8
  br i1 %vis.iszero.rax, label %loc_13EA, label %loc_1248

loc_1248:
  ; rdx = rax + 1
  %rdx.axp1 = add i64 %rax.val, 1
  ; if (rax == 6) goto loc_133D
  %cmp.ax.eq6 = icmp eq i64 %rax.val, 6
  br i1 %cmp.ax.eq6, label %loc_133D, label %cont_1256

cont_1256:
  ; test adj[u][rax+1]
  %idx.a1 = add i64 %rcx.tmp, %rdx.axp1
  %adj.a1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx.a1
  %adj.a1 = load i32, i32* %adj.a1.ptr, align 4
  %adj.a1.zero = icmp eq i32 %adj.a1, 0
  br i1 %adj.a1.zero, label %loc_1274, label %cont_1264

cont_1264:
  ; rsi = &visited[rax+1]
  %vis.base.3 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.ax1 = getelementptr inbounds i32, i32* %vis.base.3, i64 %rdx.axp1
  %vis.ax1 = load i32, i32* %rsi.ptr.ax1, align 4
  %vis.ax1.zero = icmp eq i32 %vis.ax1, 0
  ; prepare selected v, rsi for 13F0
  store i32* %rsi.ptr.ax1, i32** %sel.visited.ptr, align 8
  store i64 %rdx.axp1, i64* %sel.v, align 8
  br i1 %vis.ax1.zero, label %loc_13F0, label %loc_1274

loc_1274:
  ; rdx = rax + 2
  %rdx.axp2 = add i64 %rax.val, 2
  ; if (rax == 5) goto loc_133D
  %cmp.ax.eq5 = icmp eq i64 %rax.val, 5
  br i1 %cmp.ax.eq5, label %loc_133D, label %cont_1282

cont_1282:
  ; test adj[u][rax+2]
  %idx.a2 = add i64 %rcx.tmp, %rdx.axp2
  %adj.a2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx.a2
  %adj.a2 = load i32, i32* %adj.a2.ptr, align 4
  %adj.a2.zero = icmp eq i32 %adj.a2, 0
  br i1 %adj.a2.zero, label %loc_12A0, label %cont_1290

cont_1290:
  ; rsi = &visited[rax+2]
  %vis.base.4 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.ax2 = getelementptr inbounds i32, i32* %vis.base.4, i64 %rdx.axp2
  %vis.ax2 = load i32, i32* %rsi.ptr.ax2, align 4
  %vis.ax2.zero = icmp eq i32 %vis.ax2, 0
  store i32* %rsi.ptr.ax2, i32** %sel.visited.ptr, align 8
  store i64 %rdx.axp2, i64* %sel.v, align 8
  br i1 %vis.ax2.zero, label %loc_13F0, label %loc_12A0

loc_12A0:
  ; rdx = rax + 3
  %rdx.axp3 = add i64 %rax.val, 3
  ; if (rax == 4) goto loc_133D
  %cmp.ax.eq4 = icmp eq i64 %rax.val, 4
  br i1 %cmp.ax.eq4, label %loc_133D, label %cont_12AE

cont_12AE:
  ; test adj[u][rax+3]
  %idx.a3 = add i64 %rcx.tmp, %rdx.axp3
  %adj.a3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx.a3
  %adj.a3 = load i32, i32* %adj.a3.ptr, align 4
  %adj.a3.zero = icmp eq i32 %adj.a3, 0
  br i1 %adj.a3.zero, label %loc_12CC, label %cont_12BC

cont_12BC:
  ; rsi = &visited[rax+3]
  %vis.base.5 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.ax3 = getelementptr inbounds i32, i32* %vis.base.5, i64 %rdx.axp3
  %vis.ax3 = load i32, i32* %rsi.ptr.ax3, align 4
  %vis.ax3.zero = icmp eq i32 %vis.ax3, 0
  store i32* %rsi.ptr.ax3, i32** %sel.visited.ptr, align 8
  store i64 %rdx.axp3, i64* %sel.v, align 8
  br i1 %vis.ax3.zero, label %loc_13F0, label %loc_12CC

loc_12CC:
  ; rdx = rax + 4
  %rdx.axp4 = add i64 %rax.val, 4
  ; if (rax == 3) goto loc_133D
  %cmp.ax.eq3 = icmp eq i64 %rax.val, 3
  br i1 %cmp.ax.eq3, label %loc_133D, label %cont_12D6

cont_12D6:
  ; test adj[u][rax+4]
  %idx.a4 = add i64 %rcx.tmp, %rdx.axp4
  %adj.a4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx.a4
  %adj.a4 = load i32, i32* %adj.a4.ptr, align 4
  %adj.a4.zero = icmp eq i32 %adj.a4, 0
  br i1 %adj.a4.zero, label %loc_12F4, label %cont_12E4

cont_12E4:
  ; rsi = &visited[rax+4]
  %vis.base.6 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.ax4 = getelementptr inbounds i32, i32* %vis.base.6, i64 %rdx.axp4
  %vis.ax4 = load i32, i32* %rsi.ptr.ax4, align 4
  %vis.ax4.zero = icmp eq i32 %vis.ax4, 0
  store i32* %rsi.ptr.ax4, i32** %sel.visited.ptr, align 8
  store i64 %rdx.axp4, i64* %sel.v, align 8
  br i1 %vis.ax4.zero, label %loc_13F0, label %loc_12F4

loc_12F4:
  ; rdx = rax + 5
  %rdx.axp5 = add i64 %rax.val, 5
  ; if (rax == 2) goto loc_133D
  %cmp.ax.eq2 = icmp eq i64 %rax.val, 2
  br i1 %cmp.ax.eq2, label %loc_133D, label %cont_12FE

cont_12FE:
  ; test adj[u][rax+5]
  %idx.a5 = add i64 %rcx.tmp, %rdx.axp5
  %adj.a5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx.a5
  %adj.a5 = load i32, i32* %adj.a5.ptr, align 4
  %adj.a5.zero = icmp eq i32 %adj.a5, 0
  br i1 %adj.a5.zero, label %loc_131C, label %cont_130C

cont_130C:
  ; rsi = &visited[rax+5]
  %vis.base.7 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.ax5 = getelementptr inbounds i32, i32* %vis.base.7, i64 %rdx.axp5
  %vis.ax5 = load i32, i32* %rsi.ptr.ax5, align 4
  %vis.ax5.zero = icmp eq i32 %vis.ax5, 0
  store i32* %rsi.ptr.ax5, i32** %sel.visited.ptr, align 8
  store i64 %rdx.axp5, i64* %sel.v, align 8
  br i1 %vis.ax5.zero, label %loc_13F0, label %loc_131C

loc_131C:
  ; if (rax != 0) goto loc_133D
  %cmp.ax.ne0 = icmp ne i64 %rax.val, 0
  br i1 %cmp.ax.ne0, label %loc_133D, label %cont_1321

cont_1321:
  ; edx = adjE0[u*7 + 0]
  %idx.e0 = mul i64 %u.cur, 7
  %adjE0.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adjE0, i64 0, i64 %idx.e0
  %adjE0.val = load i32, i32* %adjE0.ptr, align 4
  %adjE0.zero = icmp eq i32 %adjE0.val, 0
  br i1 %adjE0.zero, label %loc_133D, label %cont_1329

cont_1329:
  ; eax = visited[6], rsi = &visited[6], edx = 6
  %vis.base.8 = load i32*, i32** %visited.ptr, align 8
  %rsi.ptr.6 = getelementptr inbounds i32, i32* %vis.base.8, i64 6
  %vis.6 = load i32, i32* %rsi.ptr.6, align 4
  ; set selected v=6 and rsi=&visited[6]
  store i64 6, i64* %sel.v, align 8
  store i32* %rsi.ptr.6, i32** %sel.visited.ptr, align 8
  %vis6.zero = icmp eq i32 %vis.6, 0
  br i1 %vis6.zero, label %loc_13F0, label %loc_133D

loc_133D:
  ; sub rdi, 1
  %rdi.cur.133d = load i64, i64* %rdi.depth, align 8
  %rdi.sub1 = add i64 %rdi.cur.133d, -1
  store i64 %rdi.sub1, i64* %rdi.depth, align 8
  br label %loc_1341

loc_1341:
  ; test rdi, rdi
  %rdi.cur.1341 = load i64, i64* %rdi.depth, align 8
  %cond.nz.rdi = icmp ne i64 %rdi.cur.1341, 0
  br i1 %cond.nz.rdi, label %loc_1208, label %cont_134a

cont_134a:
  ; free visited
  %vis.tofree = load i32*, i32** %visited.ptr, align 8
  %vis.tofree.cast = bitcast i32* %vis.tofree to i8*
  call void @free(i8* %vis.tofree.cast)
  ; free nextidx
  %next.tofree = load i64*, i64** %nextidx.ptr, align 8
  %next.tofree.cast = bitcast i64* %next.tofree to i8*
  call void @free(i8* %next.tofree.cast)
  ; free stack
  %stack.tofree = load i64*, i64** %stack.ptr, align 8
  %stack.tofree.cast = bitcast i64* %stack.tofree to i8*
  call void @free(i8* %stack.tofree.cast)

  ; printf header: ___printf_chk(2, "DFS preorder from %zu: ", 0)
  %hdr.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr)
  ; if (rbp == 0) skip? Assembly tests rbp, jz -> newline
  %rbp.cur.136 = load i64, i64* %rbp.count, align 8
  %rbp.iszero = icmp eq i64 %rbp.cur.136, 0
  br i1 %rbp.iszero, label %loc_13AE, label %cont_137c

cont_137c:
  ; rdx = out[0]; r12 = "%zu%s"
  %out.first.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0
  %val.first = load i64, i64* %out.first.ptr, align 8
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  ; if (rbp != 1) goto loc_1421
  %cmp.rbp.ne1 = icmp ne i64 %rbp.cur.136, 1
  br i1 %cmp.rbp.ne1, label %loc_1421, label %loc_1398

loc_1398:
  ; rcx = asc_2022+1 (""), print: ___printf_chk(2, "%zu%s", out[last_loaded], "")
  %empty.ptr.base = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  %empty.ptr = getelementptr inbounds i8, i8* %empty.ptr.base, i64 1
  %call.print.single = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %val.first, i8* %empty.ptr)
  br label %loc_13AE

loc_13AE:
  ; print newline
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ; stack canary check
  %canary.saved = load i64, i64* %canary.slot, align 8
  %canary.now = load i64, i64* @__stack_chk_guard, align 8
  %cmp.canary.ne = icmp ne i64 %canary.saved, %canary.now
  br i1 %cmp.canary.ne, label %loc_1487, label %epilogue

epilogue:
  ret i32 0

loc_13EA:
  ; rdx = rax (store selected v from rax), rsi already prepared
  store i64 %rax.val, i64* %sel.v, align 8
  br label %loc_13F0

loc_13F0:
  ; rax = sel.v + 1
  %v.sel = load i64, i64* %sel.v, align 8
  %v.plus1 = add i64 %v.sel, 1
  ; out[rbp] = v.sel
  %rbp.cur = load i64, i64* %rbp.count, align 8
  %out.dst.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %rbp.cur
  store i64 %v.sel, i64* %out.dst.ptr, align 8
  ; rbp++
  %rbp.plus1 = add i64 %rbp.cur, 1
  store i64 %rbp.plus1, i64* %rbp.count, align 8
  ; stack[rdi] = v.sel ; rdi++
  %rdi.cur = load i64, i64* %rdi.depth, align 8
  %stk.push.ptr = getelementptr inbounds i64, i64* %sptr, i64 %rdi.cur
  store i64 %v.sel, i64* %stk.push.ptr, align 8
  %rdi.plus1 = add i64 %rdi.cur, 1
  store i64 %rdi.plus1, i64* %rdi.depth, align 8
  ; *r8 = v.sel + 1
  %r8.slot = load i64*, i64** %next.slot.ptr, align 8
  store i64 %v.plus1, i64* %r8.slot, align 8
  ; *visited[v.sel] = 1
  %rsi.sel = load i32*, i32** %sel.visited.ptr, align 8
  store i32 1, i32* %rsi.sel, align 4
  br label %loc_1341

loc_1412:
  ; if (rax != 7) goto loc_1208 else goto loc_133D
  %cmp.rax.ne7 = icmp ne i64 %rax.val, 7
  br i1 %cmp.rax.ne7, label %loc_1208, label %loc_133D

loc_1421:
  ; ebx = 1 ; r14 = &" " ; r13 = &out base
  %loop.idx.init = add i64 0, 1
  br label %loc_1430

loc_1430:
  ; print each preceding element with " " separator
  %phi.idx = phi i64 [ %loop.idx.init, %loc_1421 ], [ %idx.next, %loc_1430 ]
  %space.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 22
  %elem.load.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 %phi.idx
  %elem.ptr.prev = getelementptr inbounds i64, i64* %elem.load.ptr, i64 -1
  %elem.prev = load i64, i64* %elem.ptr.prev, align 8
  %call.loop.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %elem.prev, i8* %space.ptr)
  ; idx++
  %idx.next = add i64 %phi.idx, 1
  ; rdx = out[idx*8 - 8] prepared by next iteration; compare idx with rbp
  %rbp.cur.loop = load i64, i64* %rbp.count, align 8
  %cmp.loop = icmp ne i64 %idx.next, %rbp.cur.loop
  br i1 %cmp.loop, label %loc_1430, label %loc_1450

loc_1450:
  br label %loc_1398

loc_1455:
  ; free visited
  %vis.free2 = load i32*, i32** %visited.ptr, align 8
  %vis.free2.cast = bitcast i32* %vis.free2 to i8*
  call void @free(i8* %vis.free2.cast)
  ; free nextidx
  %next.free2 = load i64*, i64** %nextidx.ptr, align 8
  %next.free2.cast = bitcast i64* %next.free2 to i8*
  call void @free(i8* %next.free2.cast)
  ; free stack
  %stack.free2 = load i64*, i64** %stack.ptr, align 8
  %stack.free2.cast = bitcast i64* %stack.free2 to i8*
  call void @free(i8* %stack.free2.cast)
  ; print header and then jump to newline
  %hdr.ptr2 = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call.hdr2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr.ptr2)
  br label %loc_13AE

loc_1487:
  call void @__stack_chk_fail()
  unreachable
}