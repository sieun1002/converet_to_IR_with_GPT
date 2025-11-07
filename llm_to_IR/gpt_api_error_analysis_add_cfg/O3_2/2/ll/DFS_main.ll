; ModuleID = 'reconstructed'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@qword_2028 = external global i64
@__stack_chk_guard = external global i64
@.str_header = private constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_nl = private constant [2 x i8] c"\0A\00"
@.str_fmt = private constant [6 x i8] c"%zu%s\00"

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
bb_10e0:
  %canary.slot = alloca i64, align 8
  %arrF = alloca [64 x i32], align 16
  %visited_ptr = alloca i8*, align 8
  %next_ptr = alloca i8*, align 8
  %stack_ptr = alloca i8*, align 8
  %rdi_var = alloca i64, align 8
  %rbp_var = alloca i64, align 8
  %rdx_var = alloca i64, align 8
  %r8_ptr = alloca i64*, align 8
  %rsi_vis_ptr = alloca i32*, align 8
  %path = alloca [128 x i64], align 16
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8
  %arrF.i8 = bitcast [64 x i32]* %arrF to i8*
  call void @llvm.memset.p0i8.i64(i8* %arrF.i8, i8 0, i64 256, i1 false)
  %a0 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 7
  store i32 1, i32* %a0, align 4
  %a1 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 14
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 19
  store i32 1, i32* %a2, align 4
  %a3 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 22
  store i32 1, i32* %a3, align 4
  %a4 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 29
  store i32 1, i32* %a4, align 4
  %a5 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 33
  store i32 1, i32* %a5, align 4
  %a6 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 37
  store i32 1, i32* %a6, align 4
  %a7 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 39
  store i32 1, i32* %a7, align 4
  %a8 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 41
  store i32 1, i32* %a8, align 4
  %a9 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 47
  store i32 1, i32* %a9, align 4
  %p0 = call i8* @calloc(i64 28, i64 1)
  store i8* %p0, i8** %visited_ptr, align 8
  %p1 = call i8* @calloc(i64 56, i64 1)
  store i8* %p1, i8** %next_ptr, align 8
  %p2 = call i8* @malloc(i64 56)
  store i8* %p2, i8** %stack_ptr, align 8
  %ok0 = icmp ne i8* %p0, null
  %ok1 = icmp ne i8* %p1, null
  %ok01 = and i1 %ok0, %ok1
  br i1 %ok01, label %bb_11d7, label %bb_1455

bb_11d7:                                          ; preds = %bb_10e0
  %ok2 = icmp ne i8* %p2, null
  br i1 %ok2, label %bb_11e0, label %bb_1455

bb_11e0:                                          ; preds = %bb_11d7
  %stack64 = bitcast i8* %p2 to i64*
  store i64 0, i64* %stack64, align 8
  store i64 0, i64* %rdx_var, align 8
  store i64 1, i64* %rbp_var, align 8
  store i64 1, i64* %rdi_var, align 8
  %vis32 = bitcast i8* %p0 to i32*
  store i32 1, i32* %vis32, align 4
  %path0 = getelementptr inbounds [128 x i64], [128 x i64]* %path, i64 0, i64 0
  store i64 0, i64* %path0, align 8
  br label %bb_120d

bb_1208:                                          ; preds = %bb_1341, %bb_1412, %bb_133d
  %stkP = load i8*, i8** %stack_ptr, align 8
  %stk64 = bitcast i8* %stkP to i64*
  %di_now = load i64, i64* %rdi_var, align 8
  %di_dec = add i64 %di_now, -1
  %tos.ptr = getelementptr inbounds i64, i64* %stk64, i64 %di_dec
  %tos = load i64, i64* %tos.ptr, align 8
  store i64 %tos, i64* %rdx_var, align 8
  br label %bb_120d

bb_120d:                                          ; preds = %bb_11e0, %bb_1208
  %rdx_now = load i64, i64* %rdx_var, align 8
  %rcx7 = mul i64 %rdx_now, 7
  %nextP = load i8*, i8** %next_ptr, align 8
  %next64 = bitcast i8* %nextP to i64*
  %r8.gep = getelementptr inbounds i64, i64* %next64, i64 %rdx_now
  store i64* %r8.gep, i64** %r8_ptr, align 8
  %rax0 = load i64, i64* %r8.gep, align 8
  %cmp.ugt6 = icmp ugt i64 %rax0, 6
  br i1 %cmp.ugt6, label %bb_1412, label %bb_1227

bb_1227:                                          ; preds = %bb_120d
  %idx0 = add i64 %rax0, %rcx7
  %arrF.i32 = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx0
  %t0 = load i32, i32* %arrF.i32, align 4
  %t0z = icmp eq i32 %t0, 0
  br i1 %t0z, label %bb_1248, label %bb_1238

bb_1238:                                          ; preds = %bb_1227
  %visP = load i8*, i8** %visited_ptr, align 8
  %vis32b = bitcast i8* %visP to i32*
  %vptr0 = getelementptr inbounds i32, i32* %vis32b, i64 %rax0
  %v0 = load i32, i32* %vptr0, align 4
  %v0z = icmp eq i32 %v0, 0
  br i1 %v0z, label %bb_13ea, label %bb_1248

bb_1248:                                          ; preds = %bb_1238, %bb_1227
  %rdx1 = add i64 %rax0, 1
  %is6 = icmp eq i64 %rax0, 6
  br i1 %is6, label %bb_133d, label %bb_1256

bb_1256:                                          ; preds = %bb_1248
  %idx1 = add i64 %rcx7, %rdx1
  %a1p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx1
  %t1 = load i32, i32* %a1p, align 4
  %t1z = icmp eq i32 %t1, 0
  br i1 %t1z, label %bb_1274, label %bb_1264

bb_1264:                                          ; preds = %bb_1256
  %visP1 = load i8*, i8** %visited_ptr, align 8
  %vis32c = bitcast i8* %visP1 to i32*
  %vptr1 = getelementptr inbounds i32, i32* %vis32c, i64 %rdx1
  %v1 = load i32, i32* %vptr1, align 4
  %v1z = icmp eq i32 %v1, 0
  br i1 %v1z, label %to13f0_rdx1, label %bb_1274

to13f0_rdx1:                                      ; preds = %bb_1264
  store i64 %rdx1, i64* %rdx_var, align 8
  store i32* %vptr1, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_1274:                                          ; preds = %bb_1264, %bb_1256
  %rdx2 = add i64 %rax0, 2
  %is5 = icmp eq i64 %rax0, 5
  br i1 %is5, label %bb_133d, label %bb_1282

bb_1282:                                          ; preds = %bb_1274
  %idx2 = add i64 %rcx7, %rdx2
  %a2p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx2
  %t2 = load i32, i32* %a2p, align 4
  %t2z = icmp eq i32 %t2, 0
  br i1 %t2z, label %bb_12a0, label %bb_1290

bb_1290:                                          ; preds = %bb_1282
  %visP2 = load i8*, i8** %visited_ptr, align 8
  %vis32d = bitcast i8* %visP2 to i32*
  %vptr2 = getelementptr inbounds i32, i32* %vis32d, i64 %rdx2
  %v2 = load i32, i32* %vptr2, align 4
  %v2z = icmp eq i32 %v2, 0
  br i1 %v2z, label %to13f0_rdx2, label %bb_12a0

to13f0_rdx2:                                      ; preds = %bb_1290
  store i64 %rdx2, i64* %rdx_var, align 8
  store i32* %vptr2, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_12a0:                                          ; preds = %bb_1290, %bb_1282
  %rdx3 = add i64 %rax0, 3
  %is4 = icmp eq i64 %rax0, 4
  br i1 %is4, label %bb_133d, label %bb_12ae

bb_12ae:                                          ; preds = %bb_12a0
  %idx3 = add i64 %rcx7, %rdx3
  %a3p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx3
  %t3 = load i32, i32* %a3p, align 4
  %t3z = icmp eq i32 %t3, 0
  br i1 %t3z, label %bb_12cc, label %bb_12bc

bb_12bc:                                          ; preds = %bb_12ae
  %visP3 = load i8*, i8** %visited_ptr, align 8
  %vis32e = bitcast i8* %visP3 to i32*
  %vptr3 = getelementptr inbounds i32, i32* %vis32e, i64 %rdx3
  %v3 = load i32, i32* %vptr3, align 4
  %v3z = icmp eq i32 %v3, 0
  br i1 %v3z, label %to13f0_rdx3, label %bb_12cc

to13f0_rdx3:                                      ; preds = %bb_12bc
  store i64 %rdx3, i64* %rdx_var, align 8
  store i32* %vptr3, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_12cc:                                          ; preds = %bb_12bc, %bb_12ae
  %rdx4 = add i64 %rax0, 4
  %is3 = icmp eq i64 %rax0, 3
  br i1 %is3, label %bb_133d, label %bb_12d6

bb_12d6:                                          ; preds = %bb_12cc
  %idx4 = add i64 %rcx7, %rdx4
  %a4p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx4
  %t4 = load i32, i32* %a4p, align 4
  %t4z = icmp eq i32 %t4, 0
  br i1 %t4z, label %bb_12f4, label %bb_12e4

bb_12e4:                                          ; preds = %bb_12d6
  %visP4 = load i8*, i8** %visited_ptr, align 8
  %vis32f = bitcast i8* %visP4 to i32*
  %vptr4 = getelementptr inbounds i32, i32* %vis32f, i64 %rdx4
  %v4 = load i32, i32* %vptr4, align 4
  %v4z = icmp eq i32 %v4, 0
  br i1 %v4z, label %to13f0_rdx4, label %bb_12f4

to13f0_rdx4:                                      ; preds = %bb_12e4
  store i64 %rdx4, i64* %rdx_var, align 8
  store i32* %vptr4, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_12f4:                                          ; preds = %bb_12e4, %bb_12d6
  %rdx5 = add i64 %rax0, 5
  %is2 = icmp eq i64 %rax0, 2
  br i1 %is2, label %bb_133d, label %bb_12fe

bb_12fe:                                          ; preds = %bb_12f4
  %idx5 = add i64 %rcx7, %rdx5
  %a5p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idx5
  %t5 = load i32, i32* %a5p, align 4
  %t5z = icmp eq i32 %t5, 0
  br i1 %t5z, label %bb_131c, label %bb_130c

bb_130c:                                          ; preds = %bb_12fe
  %visP5 = load i8*, i8** %visited_ptr, align 8
  %vis32g = bitcast i8* %visP5 to i32*
  %vptr5 = getelementptr inbounds i32, i32* %vis32g, i64 %rdx5
  %v5 = load i32, i32* %vptr5, align 4
  %v5z = icmp eq i32 %v5, 0
  br i1 %v5z, label %to13f0_rdx5, label %bb_131c

to13f0_rdx5:                                      ; preds = %bb_130c
  store i64 %rdx5, i64* %rdx_var, align 8
  store i32* %vptr5, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_13ea:                                          ; preds = %bb_1238
  store i64 %rax0, i64* %rdx_var, align 8
  %visP0 = load i8*, i8** %visited_ptr, align 8
  %vis32h = bitcast i8* %visP0 to i32*
  %vptr0b = getelementptr inbounds i32, i32* %vis32h, i64 %rax0
  store i32* %vptr0b, i32** %rsi_vis_ptr, align 8
  br label %bb_13f0

bb_131c:                                          ; preds = %bb_130c, %bb_12fe
  %rax0nz = icmp ne i64 %rax0, 0
  br i1 %rax0nz, label %bb_133d, label %bb_1321

bb_1321:                                          ; preds = %bb_131c
  %idxE0 = add i64 %rcx7, 6
  %aE0p = getelementptr inbounds [64 x i32], [64 x i32]* %arrF, i64 0, i64 %idxE0
  %tE0 = load i32, i32* %aE0p, align 4
  %tE0z = icmp eq i32 %tE0, 0
  br i1 %tE0z, label %bb_133d, label %bb_1329

bb_1329:                                          ; preds = %bb_1321
  %visP6 = load i8*, i8** %visited_ptr, align 8
  %vis32i = bitcast i8* %visP6 to i32*
  %vptr6 = getelementptr inbounds i32, i32* %vis32i, i64 6
  %v6 = load i32, i32* %vptr6, align 4
  store i32* %vptr6, i32** %rsi_vis_ptr, align 8
  store i64 6, i64* %rdx_var, align 8
  %v6z = icmp eq i32 %v6, 0
  br i1 %v6z, label %bb_13f0, label %bb_133d

bb_13f0:                                          ; preds = %to13f0_rdx5, %to13f0_rdx4, %to13f0_rdx3, %to13f0_rdx2, %to13f0_rdx1, %bb_1329, %bb_13ea
  %rdx_new = load i64, i64* %rdx_var, align 8
  %rax_next = add i64 %rdx_new, 1
  %rbp_now = load i64, i64* %rbp_var, align 8
  %path.slot = getelementptr inbounds [128 x i64], [128 x i64]* %path, i64 0, i64 %rbp_now
  store i64 %rdx_new, i64* %path.slot, align 8
  %rbp_inc = add i64 %rbp_now, 1
  store i64 %rbp_inc, i64* %rbp_var, align 8
  %stkP2 = load i8*, i8** %stack_ptr, align 8
  %stk64b = bitcast i8* %stkP2 to i64*
  %di_now2 = load i64, i64* %rdi_var, align 8
  %stkslot = getelementptr inbounds i64, i64* %stk64b, i64 %di_now2
  store i64 %rdx_new, i64* %stkslot, align 8
  %di_inc = add i64 %di_now2, 1
  store i64 %di_inc, i64* %rdi_var, align 8
  %r8p_now = load i64*, i64** %r8_ptr, align 8
  store i64 %rax_next, i64* %r8p_now, align 8
  %vptrN = load i32*, i32** %rsi_vis_ptr, align 8
  store i32 1, i32* %vptrN, align 4
  br label %bb_1341

bb_1412:                                          ; preds = %bb_120d
  %is7 = icmp eq i64 %rax0, 7
  br i1 %is7, label %bb_133d, label %bb_1208

bb_133d:                                          ; preds = %bb_1412, %bb_1329, %bb_1321, %bb_131c, %bb_12f4, %bb_12cc, %bb_12a0, %bb_1274, %bb_1248
  %di_now3 = load i64, i64* %rdi_var, align 8
  %di_sub = add i64 %di_now3, -1
  store i64 %di_sub, i64* %rdi_var, align 8
  br label %bb_1341

bb_1341:                                          ; preds = %bb_13f0, %bb_133d
  %di_chk = load i64, i64* %rdi_var, align 8
  %di_nz = icmp ne i64 %di_chk, 0
  br i1 %di_nz, label %bb_1208, label %bb_134a

bb_134a:                                          ; preds = %bb_1341
  %pv = load i8*, i8** %visited_ptr, align 8
  call void @free(i8* %pv)
  %pn = load i8*, i8** %next_ptr, align 8
  call void @free(i8* %pn)
  %ps = load i8*, i8** %stack_ptr, align 8
  call void @free(i8* %ps)
  %hdrp = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %zero64 = add i64 0, 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdrp, i64 %zero64)
  %rbp_now2 = load i64, i64* %rbp_var, align 8
  %rbp_z = icmp eq i64 %rbp_now2, 0
  br i1 %rbp_z, label %bb_13ae, label %bb_137c

bb_137c:                                          ; preds = %bb_134a
  %p0v = load i64, i64* %path0, align 8
  %fmtp = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %rbp_is1 = icmp eq i64 %rbp_now2, 1
  br i1 %rbp_is1, label %bb_1398, label %bb_1421

bb_1398:                                          ; preds = %bb_1450, %bb_137c
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 1
  %_p0 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtp, i64 %p0v, i8* %empty)
  br label %bb_13ae

bb_1421:                                          ; preds = %bb_137c
  %i0 = add i64 0, 1
  %spc = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 22
  br label %bb_1430

bb_1430:                                          ; preds = %bb_144e, %bb_1421
  %i.phi = phi i64 [ %i0, %bb_1421 ], [ %i.next, %bb_144e ]
  %idxPath = add i64 %i.phi, -1
  %pelem.ptr = getelementptr inbounds [128 x i64], [128 x i64]* %path, i64 0, i64 %idxPath
  %pelem = load i64, i64* %pelem.ptr, align 8
  %_p = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtp, i64 %pelem, i8* %spc)
  %i.next = add i64 %i.phi, 1
  %rbp_now3 = load i64, i64* %rbp_var, align 8
  %cont = icmp ne i64 %i.next, %rbp_now3
  br i1 %cont, label %bb_144e, label %bb_1450

bb_144e:                                          ; preds = %bb_1430
  br label %bb_1430

bb_1450:                                          ; preds = %bb_1430
  br label %bb_1398

bb_1455:                                          ; preds = %bb_11d7, %bb_10e0
  %pvE = phi i8* [ %p0, %bb_10e0 ], [ %p0, %bb_11d7 ]
  %pnE = phi i8* [ %p1, %bb_10e0 ], [ %p1, %bb_11d7 ]
  %psE = phi i8* [ null, %bb_10e0 ], [ %p2, %bb_11d7 ]
  %v.nn = icmp ne i8* %pvE, null
  br i1 %v.nn, label %bb_1455_freev, label %bb_1455_afv

bb_1455_freev:                                    ; preds = %bb_1455
  call void @free(i8* %pvE)
  br label %bb_1455_afv

bb_1455_afv:                                      ; preds = %bb_1455_freev, %bb_1455
  %n.nn = icmp ne i8* %pnE, null
  br i1 %n.nn, label %bb_1455_freen, label %bb_1455_afn

bb_1455_freen:                                    ; preds = %bb_1455_afv
  call void @free(i8* %pnE)
  br label %bb_1455_afn

bb_1455_afn:                                      ; preds = %bb_1455_freen, %bb_1455_afv
  %s.nn = icmp ne i8* %psE, null
  br i1 %s.nn, label %bb_1455_frees, label %bb_146d

bb_1455_frees:                                    ; preds = %bb_1455_afn
  call void @free(i8* %psE)
  br label %bb_146d

bb_146d:                                          ; preds = %bb_1455_frees, %bb_1455_afn
  %hdrpE = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %zeroE = add i64 0, 0
  %_E = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdrpE, i64 %zeroE)
  br label %bb_13ae

bb_13ae:                                          ; preds = %bb_146d, %bb_1398, %bb_134a
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nlp)
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %guard.stored = load i64, i64* %canary.slot, align 8
  %canary.bad = icmp ne i64 %guard.stored, %guard1
  br i1 %canary.bad, label %bb_1487, label %bb_13d8

bb_1487:                                          ; preds = %bb_13ae
  call void @__stack_chk_fail()
  unreachable

bb_13d8:                                          ; preds = %bb_13ae
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)