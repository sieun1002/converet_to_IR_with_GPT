; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@aKeyDIndexLd = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

@xmmword_2030 = external constant [4 x i32], align 16
@xmmword_2040 = external constant [4 x i32], align 16
@qword_2050   = external global i64, align 8

@__stack_chk_guard = external thread_local(localexec) global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() local_unnamed_addr {
addr_1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %r12.ptr = alloca i32*, align 8
  %rbx.end = alloca i32*, align 8
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %key = alloca i32, align 4
  %canary.save = alloca i64, align 8
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary.save, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %arr.base.vec = bitcast i32* %arr.base to <4 x i32>*
  %g2030.vec.ptr = bitcast [4 x i32]* @xmmword_2030 to <4 x i32>*
  %g2030.vec = load <4 x i32>, <4 x i32>* %g2030.vec.ptr, align 16
  store <4 x i32> %g2030.vec, <4 x i32>* %arr.base.vec, align 16
  %arr.p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %arr.p4.vec = bitcast i32* %arr.p4 to <4 x i32>*
  %g2040.vec.ptr = bitcast [4 x i32]* @xmmword_2040 to <4 x i32>*
  %g2040.vec = load <4 x i32>, <4 x i32>* %g2040.vec.ptr, align 16
  store <4 x i32> %g2040.vec, <4 x i32>* %arr.p4.vec, align 16
  %arr.p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 12, i32* %arr.p8, align 4
  %q = load i64, i64* @qword_2050, align 8
  %low32 = trunc i64 %q to i32
  %qshr = lshr i64 %q, 32
  %high32 = trunc i64 %qshr to i32
  %k0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 %low32, i32* %k0ptr, align 4
  %k1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 %high32, i32* %k1ptr, align 4
  %k2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2ptr, align 4
  store i32* %k0ptr, i32** %r12.ptr, align 8
  %keys.end = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  store i32* %keys.end, i32** %rbx.end, align 8
  br label %loc_10E0

loc_10E0:                                            ; 0x10e0
  %r12.cur = load i32*, i32** %r12.ptr, align 8
  %key.load = load i32, i32* %r12.cur, align 4
  store i32 %key.load, i32* %key, align 4
  store i64 9, i64* %hi, align 8
  store i64 0, i64* %lo, align 8
  br label %loc_1105

loc_1105:                                            ; 0x1105
  %lo.v = load i64, i64* %lo, align 8
  %hi.v = load i64, i64* %hi, align 8
  %cmp.jb = icmp ult i64 %lo.v, %hi.v
  br i1 %cmp.jb, label %loc_10F0, label %addr_110a

loc_10F0:                                            ; 0x10f0
  %hi.v2 = load i64, i64* %hi, align 8
  %lo.v2 = load i64, i64* %lo, align 8
  %diff = sub i64 %hi.v2, %lo.v2
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %lo.v2
  %mid.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %key.cur = load i32, i32* %key, align 4
  %cmp.jg = icmp sgt i32 %key.cur, %mid.val
  br i1 %cmp.jg, label %loc_1150, label %loc_10F0_sethi

loc_10F0_sethi:
  store i64 %mid, i64* %hi, align 8
  br label %loc_1105

loc_1150:                                            ; 0x1150
  %mid.plus1 = add i64 %mid, 1
  store i64 %mid.plus1, i64* %lo, align 8
  br label %loc_1105

addr_110a:                                           ; 0x110a (fall-through path after cmp at 0x1105)
  %lo.v3 = load i64, i64* %lo, align 8
  %cmp.ja = icmp ugt i64 %lo.v3, 8
  br i1 %cmp.ja, label %loc_1156, label %addr_1112_cmp

addr_1112_cmp:                                       ; 0x1112
  %idx.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %lo.v3
  %at.idx = load i32, i32* %idx.ptr, align 4
  %key.cur2 = load i32, i32* %key, align 4
  %cmp.jnz = icmp ne i32 %key.cur2, %at.idx
  br i1 %cmp.jnz, label %loc_1156, label %loc_1118

loc_1118:                                            ; 0x1118
  %fmt.ok = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDIndexLd, i64 0, i64 0
  %key.arg = load i32, i32* %key, align 4
  %idx.arg = load i64, i64* %lo, align 8
  %call.ok = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ok, i32 %key.arg, i64 %idx.arg)
  br label %loc_1127

loc_1156:                                            ; 0x1156
  %fmt.nf = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %key.arg.nf = load i32, i32* %key, align 4
  %call.nf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.nf, i32 %key.arg.nf)
  br label %loc_1127

loc_1127:                                            ; 0x1127
  %r12.cur2 = load i32*, i32** %r12.ptr, align 8
  %r12.next = getelementptr inbounds i32, i32* %r12.cur2, i64 1
  store i32* %r12.next, i32** %r12.ptr, align 8
  %rbx.end.val = load i32*, i32** %rbx.end, align 8
  %cmp.jnz.loop = icmp ne i32* %r12.next, %rbx.end.val
  br i1 %cmp.jnz.loop, label %loc_10E0, label %addr_1130

addr_1130:                                           ; 0x1130
  %canary.saved = load i64, i64* %canary.save, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %chk = icmp ne i64 %canary.saved, %guard.now
  br i1 %chk, label %loc_116B, label %addr_1140

addr_1140:                                           ; 0x1140
  ret i32 0

loc_116B:                                            ; 0x116b
  call void @___stack_chk_fail()
  unreachable
}