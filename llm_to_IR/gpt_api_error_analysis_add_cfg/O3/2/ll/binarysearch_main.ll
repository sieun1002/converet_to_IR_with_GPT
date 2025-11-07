; ModuleID = 'binary_search_main'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str_index = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@qword_2050 = external global i64
@__stack_chk_guard = external global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
bb_1080:                                             ; 0x1080
  %guard = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %r12 = alloca i32*, align 8
  %rbx = alloca i32*, align 8
  %key = alloca i32, align 4
  %gload = load i64, i64* @__stack_chk_guard, align 8
  store i64 %gload, i64* %guard, align 8
  %arr.vec0.ptr = bitcast [9 x i32]* %arr to <4 x i32>*
  store <4 x i32> <i32 -128, i32 -64, i32 -32, i32 -16>, <4 x i32>* %arr.vec0.ptr, align 16
  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr.vec1.ptr = bitcast i32* %arr.idx4 to <4 x i32>*
  store <4 x i32> <i32 -15, i32 -10, i32 -7, i32 -6>, <4 x i32>* %arr.vec1.ptr, align 16
  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 -5, i32* %arr.idx8, align 4
  %q = load i64, i64* @qword_2050, align 8
  %low32 = trunc i64 %q to i32
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 %low32, i32* %keys0, align 4
  %q.shr = lshr i64 %q, 32
  %high32 = trunc i64 %q.shr to i32
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 %high32, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  store i32* %keys0, i32** %r12, align 8
  %keys.end = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  store i32* %keys.end, i32** %rbx, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  br label %bb_10e0

bb_10e0:                                             ; 0x10E0
  %r12.cur = load i32*, i32** %r12, align 8
  %keyload = load i32, i32* %r12.cur, align 4
  store i32 %keyload, i32* %key, align 4
  br label %bb_1105

bb_10f0:                                             ; 0x10F0
  %rcx_in_10f0 = phi i64 [ %rcx_phi, %bb_1105 ]
  %rdx_in_10f0 = phi i64 [ %rdx_phi, %bb_1105 ]
  %diff = sub i64 %rdx_in_10f0, %rcx_in_10f0
  %shr = lshr i64 %diff, 1
  %mid = add i64 %shr, %rcx_in_10f0
  %mid.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %mid
  %arr.mid.val = load i32, i32* %mid.ptr, align 4
  %key.val.f0 = load i32, i32* %key, align 4
  %cmp.jg = icmp sgt i32 %key.val.f0, %arr.mid.val
  br i1 %cmp.jg, label %bb_1150, label %bb_10f0_else

bb_10f0_else:
  br label %bb_1105

bb_1150:                                             ; 0x1150
  %rdx_in_1150 = phi i64 [ %rdx_in_10f0, %bb_10f0 ]
  %mid_in_1150 = phi i64 [ %mid, %bb_10f0 ]
  %rcx.new = add i64 %mid_in_1150, 1
  br label %bb_1105

bb_1105:                                             ; 0x1105
  %rcx_phi = phi i64 [ 0, %bb_10e0 ], [ %rcx.new, %bb_1150 ], [ %rcx_in_10f0, %bb_10f0_else ]
  %rdx_phi = phi i64 [ 9, %bb_10e0 ], [ %rdx_in_1150, %bb_1150 ], [ %mid, %bb_10f0_else ]
  %cond.jb = icmp ult i64 %rcx_phi, %rdx_phi
  br i1 %cond.jb, label %bb_10f0, label %bb_1105_post

bb_1105_post:
  %cond.ja = icmp ugt i64 %rcx_phi, 8
  br i1 %cond.ja, label %bb_1156, label %bb_check_equal

bb_check_equal:
  %arr.idx.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %rcx_phi
  %arr.idx.val = load i32, i32* %arr.idx.ptr, align 4
  %key.val.cmp = load i32, i32* %key, align 4
  %eq = icmp eq i32 %key.val.cmp, %arr.idx.val
  br i1 %eq, label %bb_found, label %bb_1156

bb_found:
  %fmt.index.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_index, i64 0, i64 0
  %key.for.print = load i32, i32* %key, align 4
  %call.printf.ok = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.index.ptr, i32 %key.for.print, i64 %rcx_phi)
  br label %bb_1127

bb_1156:                                             ; 0x1156
  %fmt.nf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %key.for.nf = load i32, i32* %key, align 4
  %call.printf.nf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.nf.ptr, i32 %key.for.nf)
  br label %bb_1127

bb_1127:                                             ; 0x1127
  %r12.cur2 = load i32*, i32** %r12, align 8
  %r12.next = getelementptr inbounds i32, i32* %r12.cur2, i64 1
  store i32* %r12.next, i32** %r12, align 8
  %rbx.end = load i32*, i32** %rbx, align 8
  %cmp.rbx.r12 = icmp ne i32* %rbx.end, %r12.next
  br i1 %cmp.rbx.r12, label %bb_10e0, label %bb_1130

bb_1130:                                             ; 0x1130
  %guard.saved = load i64, i64* %guard, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.eq = icmp eq i64 %guard.saved, %guard.now
  br i1 %guard.eq, label %bb_1140, label %bb_116b

bb_1140:                                             ; 0x1140
  ret i32 0

bb_116b:                                             ; 0x116B
  call void @___stack_chk_fail()
  unreachable
}