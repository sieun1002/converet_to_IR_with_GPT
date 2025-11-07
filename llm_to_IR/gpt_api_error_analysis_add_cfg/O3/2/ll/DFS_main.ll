; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

@__stack_chk_guard = external global i64
@qword_2028 = external global i64

@.str.header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.nl     = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.fmt_zs = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1

define i32 @main() {
b10e0:
  %arr      = alloca [64 x i32], align 16
  %path     = alloca [16 x i64], align 16
  %rbx      = alloca i8*, align 8
  %r13      = alloca i64*, align 8
  %r12      = alloca i8*, align 8
  %rdi      = alloca i64, align 8
  %rbp      = alloca i64, align 8
  %rax      = alloca i64, align 8
  %rdx      = alloca i64, align 8
  %rcx      = alloca i64, align 8
  %r8p      = alloca i64*, align 8
  %rsip     = alloca i32*, align 8
  %ebx      = alloca i64, align 8
  %r14sp    = alloca i8*, align 8
  %canary   = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary, align 8
  %zptr = bitcast [64 x i32]* %arr to i8*
  call void @llvm.memset.p0i8.i64(i8* %zptr, i8 0, i64 256, i1 false)
  store i64 0, i64* %rax, align 8
  store i64 0, i64* %rdx, align 8
  store i64 0, i64* %rcx, align 8
  %g2028 = load i64, i64* @qword_2028
  ; ensure arr[0] = 0 (matches dword ptr [rdi] = 0)
  %arr0 = getelementptr inbounds [64 x i32], [64 x i32]* %arr, i64 0, i64 0
  store i32 0, i32* %arr0, align 4
  ; calls to allocate
  %c1 = call i8* @calloc(i64 28, i64 1)
  store i8* %c1, i8** %rbx, align 8
  %c2 = call i8* @calloc(i64 56, i64 1)
  %c2i64 = bitcast i8* %c2 to i64*
  store i64* %c2i64, i64** %r13, align 8
  %m3 = call i8* @malloc(i64 56)
  store i8* %m3, i8** %r12, align 8
  %t1 = icmp eq i8* %c1, null
  %t2 = icmp eq i8* %c2, null
  %t12 = or i1 %t1, %t2
  br i1 %t12, label %b1455, label %b11d7

b11d7:
  %m3l = load i8*, i8** %r12, align 8
  %t3 = icmp eq i8* %m3l, null
  br i1 %t3, label %b1455, label %b11e0

b11e0:
  %r12b = load i8*, i8** %r12, align 8
  %r12b64 = bitcast i8* %r12b to i64*
  store i64 0, i64* %r12b64, align 8
  store i64 0, i64* %rdx, align 8
  store i64 1, i64* %rbp, align 8
  store i64 1, i64* %rdi, align 8
  %rbx0 = load i8*, i8** %rbx, align 8
  %rbx0i32 = bitcast i8* %rbx0 to i32*
  store i32 1, i32* %rbx0i32, align 4
  %path0 = getelementptr inbounds [16 x i64], [16 x i64]* %path, i64 0, i64 0
  store i64 0, i64* %path0, align 8
  br label %b120d

b1208:
  %r12base = load i8*, i8** %r12, align 8
  %rdi_v3 = load i64, i64* %rdi, align 8
  %idxm1 = sub i64 %rdi_v3, 1
  %r12as64 = bitcast i8* %r12base to i64*
  %prevp = getelementptr inbounds i64, i64* %r12as64, i64 %idxm1
  %rdxnew = load i64, i64* %prevp, align 8
  store i64 %rdxnew, i64* %rdx, align 8
  br label %b120d

b120d:
  %rdxv = load i64, i64* %rdx, align 8
  %cx1 = mul i64 %rdxv, 8
  %cx2 = sub i64 %cx1, %rdxv
  store i64 %cx2, i64* %rcx, align 8
  %r13b = load i64*, i64** %r13, align 8
  %r8calc = getelementptr inbounds i64, i64* %r13b, i64 %cx2
  store i64* %r8calc, i64** %r8p, align 8
  %r8d = load i64*, i64** %r8p, align 8
  %raxv = load i64, i64* %r8d, align 8
  store i64 %raxv, i64* %rax, align 8
  %gt6 = icmp ugt i64 %raxv, 6
  br i1 %gt6, label %b1412, label %b1227

b1227:
  %rcxv = load i64, i64* %rcx, align 8
  %rdxv2 = load i64, i64* %rdx, align 8
  %rcxsub = sub i64 %rcxv, %rdxv2
  store i64 %rcxsub, i64* %rcx, align 8
  %rax2 = load i64, i64* %rax, align 8
  %rdx2 = add i64 %rax2, %rcxsub
  store i64 %rdx2, i64* %rdx, align 8
  %arrbase = bitcast [64 x i32]* %arr to i32*
  %a0p = getelementptr inbounds i32, i32* %arrbase, i64 %rdx2
  %r14d = load i32, i32* %a0p, align 4
  %r14z = icmp eq i32 %r14d, 0
  br i1 %r14z, label %b1248, label %b1238

b1238:
  %rbx1 = load i8*, i8** %rbx, align 8
  %rbx1i = bitcast i8* %rbx1 to i32*
  %rax3 = load i64, i64* %rax, align 8
  %rs1 = getelementptr inbounds i32, i32* %rbx1i, i64 %rax3
  store i32* %rs1, i32** %rsip, align 8
  %r11d = load i32, i32* %rs1, align 4
  %r11z = icmp eq i32 %r11d, 0
  br i1 %r11z, label %b13EA, label %b1248

b1248:
  %rax4 = load i64, i64* %rax, align 8
  %rdx3 = add i64 %rax4, 1
  store i64 %rdx3, i64* %rdx, align 8
  %eq6 = icmp eq i64 %rax4, 6
  br i1 %eq6, label %b133D, label %b1256

b1256:
  %rcx2 = load i64, i64* %rcx, align 8
  %rdx4 = load i64, i64* %rdx, align 8
  %idx1 = add i64 %rcx2, %rdx4
  %a1p = getelementptr inbounds i32, i32* %arrbase, i64 %idx1
  %r10d = load i32, i32* %a1p, align 4
  %r10z = icmp eq i32 %r10d, 0
  br i1 %r10z, label %b1274, label %b1264

b1264:
  %rbx2 = load i8*, i8** %rbx, align 8
  %rbx2i = bitcast i8* %rbx2 to i32*
  %rdx5 = load i64, i64* %rdx, align 8
  %rs2 = getelementptr inbounds i32, i32* %rbx2i, i64 %rdx5
  store i32* %rs2, i32** %rsip, align 8
  %r9d = load i32, i32* %rs2, align 4
  %r9z = icmp eq i32 %r9d, 0
  br i1 %r9z, label %b13F0, label %b1274

b1274:
  %rax5 = load i64, i64* %rax, align 8
  %rdx6 = add i64 %rax5, 2
  store i64 %rdx6, i64* %rdx, align 8
  %eq5 = icmp eq i64 %rax5, 5
  br i1 %eq5, label %b133D, label %b1282

b1282:
  %rcx3 = load i64, i64* %rcx, align 8
  %rdx7 = load i64, i64* %rdx, align 8
  %idx2 = add i64 %rcx3, %rdx7
  %a2p = getelementptr inbounds i32, i32* %arrbase, i64 %idx2
  %r14d2 = load i32, i32* %a2p, align 4
  %r14z2 = icmp eq i32 %r14d2, 0
  br i1 %r14z2, label %b12A0, label %b1290

b1290:
  %rbx3 = load i8*, i8** %rbx, align 8
  %rbx3i = bitcast i8* %rbx3 to i32*
  %rdx8 = load i64, i64* %rdx, align 8
  %rs3 = getelementptr inbounds i32, i32* %rbx3i, i64 %rdx8
  store i32* %rs3, i32** %rsip, align 8
  %r11d2 = load i32, i32* %rs3, align 4
  %r11z2 = icmp eq i32 %r11d2, 0
  br i1 %r11z2, label %b13F0, label %b12A0

b12A0:
  %rax6 = load i64, i64* %rax, align 8
  %rdx9 = add i64 %rax6, 3
  store i64 %rdx9, i64* %rdx, align 8
  %eq4 = icmp eq i64 %rax6, 4
  br i1 %eq4, label %b133D, label %b12AE

b12AE:
  %rcx4 = load i64, i64* %rcx, align 8
  %rdx10 = load i64, i64* %rdx, align 8
  %idx3 = add i64 %rcx4, %rdx10
  %a3p = getelementptr inbounds i32, i32* %arrbase, i64 %idx3
  %r10d3 = load i32, i32* %a3p, align 4
  %r10z3 = icmp eq i32 %r10d3, 0
  br i1 %r10z3, label %b12CC, label %b12BC

b12BC:
  %rbx4 = load i8*, i8** %rbx, align 8
  %rbx4i = bitcast i8* %rbx4 to i32*
  %rdx11 = load i64, i64* %rdx, align 8
  %rs4 = getelementptr inbounds i32, i32* %rbx4i, i64 %rdx11
  store i32* %rs4, i32** %rsip, align 8
  %r9d3 = load i32, i32* %rs4, align 4
  %r9z3 = icmp eq i32 %r9d3, 0
  br i1 %r9z3, label %b13F0, label %b12CC

b12CC:
  %rax7 = load i64, i64* %rax, align 8
  %rdx12 = add i64 %rax7, 4
  store i64 %rdx12, i64* %rdx, align 8
  %eq3 = icmp eq i64 %rax7, 3
  br i1 %eq3, label %b133D, label %b12D6

b12D6:
  %rcx5 = load i64, i64* %rcx, align 8
  %rdx13 = load i64, i64* %rdx, align 8
  %idx4 = add i64 %rcx5, %rdx13
  %a4p = getelementptr inbounds i32, i32* %arrbase, i64 %idx4
  %r14d4 = load i32, i32* %a4p, align 4
  %r14z4 = icmp eq i32 %r14d4, 0
  br i1 %r14z4, label %b12F4, label %b12E4

b12E4:
  %rbx5 = load i8*, i8** %rbx, align 8
  %rbx5i = bitcast i8* %rbx5 to i32*
  %rdx14 = load i64, i64* %rdx, align 8
  %rs5 = getelementptr inbounds i32, i32* %rbx5i, i64 %rdx14
  store i32* %rs5, i32** %rsip, align 8
  %r11d4 = load i32, i32* %rs5, align 4
  %r11z4 = icmp eq i32 %r11d4, 0
  br i1 %r11z4, label %b13F0, label %b12F4

b12F4:
  %rax8 = load i64, i64* %rax, align 8
  %rdx15 = add i64 %rax8, 5
  store i64 %rdx15, i64* %rdx, align 8
  %eq2 = icmp eq i64 %rax8, 2
  br i1 %eq2, label %b133D, label %b12FE

b12FE:
  %rcx6 = load i64, i64* %rcx, align 8
  %rdx16 = load i64, i64* %rdx, align 8
  %idx5 = add i64 %rcx6, %rdx16
  %a5p = getelementptr inbounds i32, i32* %arrbase, i64 %idx5
  %r10d5 = load i32, i32* %a5p, align 4
  %r10z5 = icmp eq i32 %r10d5, 0
  br i1 %r10z5, label %b131C, label %b130C

b130C:
  %rbx6 = load i8*, i8** %rbx, align 8
  %rbx6i = bitcast i8* %rbx6 to i32*
  %rdx17 = load i64, i64* %rdx, align 8
  %rs6 = getelementptr inbounds i32, i32* %rbx6i, i64 %rdx17
  store i32* %rs6, i32** %rsip, align 8
  %r9d5 = load i32, i32* %rs6, align 4
  %r9z5 = icmp eq i32 %r9d5, 0
  br i1 %r9z5, label %b13F0, label %b131C

b131C:
  %rax9 = load i64, i64* %rax, align 8
  %rax_nz = icmp ne i64 %rax9, 0
  br i1 %rax_nz, label %b133D, label %b1321

b1321:
  %rcx7 = load i64, i64* %rcx, align 8
  %arrbase2 = bitcast [64 x i32]* %arr to i32*
  %a6p = getelementptr inbounds i32, i32* %arrbase2, i64 %rcx7
  %edxv = load i32, i32* %a6p, align 4
  %edxz = icmp eq i32 %edxv, 0
  br i1 %edxz, label %b133D, label %b1329

b1329:
  %rbx7 = load i8*, i8** %rbx, align 8
  %rbx7i = bitcast i8* %rbx7 to i32*
  %idx6 = getelementptr inbounds i32, i32* %rbx7i, i64 6
  %eax6 = load i32, i32* %idx6, align 4
  store i32* %idx6, i32** %rsip, align 8
  %eaxz = icmp eq i32 %eax6, 0
  br i1 %eaxz, label %b13F0, label %b133D

b133D:
  %rdi_c = load i64, i64* %rdi, align 8
  %rdi_d = sub i64 %rdi_c, 1
  store i64 %rdi_d, i64* %rdi, align 8
  br label %b1341

b1341:
  %rdi_v = load i64, i64* %rdi, align 8
  %rdi_nz = icmp ne i64 %rdi_v, 0
  br i1 %rdi_nz, label %b1208, label %b134a

b134a:
  %rbxf = load i8*, i8** %rbx, align 8
  call void @free(i8* %rbxf)
  %r13f = load i64*, i64** %r13, align 8
  %r13f8 = bitcast i64* %r13f to i8*
  call void @free(i8* %r13f8)
  %r12f = load i8*, i8** %r12, align 8
  call void @free(i8* %r12f)
  %hdr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %pc1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr, i64 0)
  %rbp_v = load i64, i64* %rbp, align 8
  %rbp_z = icmp eq i64 %rbp_v, 0
  br i1 %rbp_z, label %b13AE, label %b137c

b137c:
  %p0 = load i64, i64* %path0, align 8
  %rbp_ne1 = icmp ne i64 %rbp_v, 1
  br i1 %rbp_ne1, label %b1421, label %b1398

b1398:
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 1
  %fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt_zs, i64 0, i64 0
  %pc2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i64 %p0, i8* %empty)
  br label %b13AE

b13AE:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %pc3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  %g1 = load i64, i64* @__stack_chk_guard
  %gs = load i64, i64* %canary, align 8
  %gcmp = icmp ne i64 %g1, %gs
  br i1 %gcmp, label %b1487, label %b13d8

b13d8:
  ret i32 0

b13EA:
  %rax_now = load i64, i64* %rax, align 8
  store i64 %rax_now, i64* %rdx, align 8
  br label %b13F0

b13F0:
  %rdx_now = load i64, i64* %rdx, align 8
  %rax_next = add i64 %rdx_now, 1
  store i64 %rax_next, i64* %rax, align 8
  %rbp_now = load i64, i64* %rbp, align 8
  %pp = getelementptr inbounds [16 x i64], [16 x i64]* %path, i64 0, i64 %rbp_now
  store i64 %rdx_now, i64* %pp, align 8
  %rbp_inc = add i64 %rbp_now, 1
  store i64 %rbp_inc, i64* %rbp, align 8
  %r12b2 = load i8*, i8** %r12, align 8
  %r12b2i = bitcast i8* %r12b2 to i64*
  %rdi_c2 = load i64, i64* %rdi, align 8
  %stk_slot = getelementptr inbounds i64, i64* %r12b2i, i64 %rdi_c2
  store i64 %rdx_now, i64* %stk_slot, align 8
  %rdi_inc = add i64 %rdi_c2, 1
  store i64 %rdi_inc, i64* %rdi, align 8
  %r8loc = load i64*, i64** %r8p, align 8
  store i64 %rax_next, i64* %r8loc, align 8
  %rsiloc = load i32*, i32** %rsip, align 8
  store i32 1, i32* %rsiloc, align 4
  br label %b1341

b1412:
  %rax_n = load i64, i64* %rax, align 8
  %ne7 = icmp ne i64 %rax_n, 7
  br i1 %ne7, label %b1208, label %b133D

b1421:
  store i64 1, i64* %ebx, align 8
  %space = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 23
  store i8* %space, i8** %r14sp, align 8
  br label %b1430

b1430:
  %ebxv = load i64, i64* %ebx, align 8
  %idxp = sub i64 %ebxv, 1
  %pprev = getelementptr inbounds [16 x i64], [16 x i64]* %path, i64 0, i64 %idxp
  %rdx_loop = load i64, i64* %pprev, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.fmt_zs, i64 0, i64 0
  %sp = load i8*, i8** %r14sp, align 8
  %pc4 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %rdx_loop, i8* %sp)
  %ebx_i = add i64 %ebxv, 1
  store i64 %ebx_i, i64* %ebx, align 8
  %rbp_c = load i64, i64* %rbp, align 8
  %cont = icmp ne i64 %ebx_i, %rbp_c
  br i1 %cont, label %b1430, label %b1450

b1450:
  br label %b1398

b1455:
  %rbx_f = load i8*, i8** %rbx, align 8
  call void @free(i8* %rbx_f)
  %r13_f = load i64*, i64** %r13, align 8
  %r13_f8 = bitcast i64* %r13_f to i8*
  call void @free(i8* %r13_f8)
  %r12_f = load i8*, i8** %r12, align 8
  call void @free(i8* %r12_f)
  %hdr2 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.header, i64 0, i64 0
  %pc5 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr2, i64 0)
  br label %b13AE

b1487:
  call void @__stack_chk_fail()
  unreachable
}