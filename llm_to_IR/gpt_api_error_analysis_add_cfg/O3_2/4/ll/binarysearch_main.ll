; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external constant <4 x i32>, align 16
@xmmword_2040 = external constant <4 x i32>, align 16
@qword_2050   = external constant i64, align 8
@__stack_chk_guard = external global i64

@.str.found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.nf    = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
BB1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %canary.slot = alloca i64, align 8

  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2030, align 16
  %arr.vec0.ptr = bitcast [9 x i32]* %arr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arr.vec0.ptr, align 16

  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2040, align 16
  %arr.i32.4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr.vec1.ptr = bitcast i32* %arr.i32.4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arr.vec1.ptr, align 16

  %arr.i32.8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.i32.8, align 4

  %q = load i64, i64* @qword_2050, align 8
  %low32 = trunc i64 %q to i32
  %q.shr32 = lshr i64 %q, 32
  %high32 = trunc i64 %q.shr32 to i32

  %keys.0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %keys.1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  %keys.2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 %low32,  i32* %keys.0, align 4
  store i32 %high32, i32* %keys.1, align 4
  store i32 -5,      i32* %keys.2, align 4

  %keys.end = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3
  br label %BB10E0

BB10E0:                                             ; 0x10E0
  %r12.cur = phi i32* [ %keys.0, %BB1080 ], [ %r12.next, %BB1127 ]
  %key.load = load i32, i32* %r12.cur, align 4
  br label %BB1105

BB10F0:                                             ; 0x10F0
  %tmp.sub = sub i64 %rdx.cur, %rcx.cur
  %tmp.shr = lshr i64 %tmp.sub, 1
  %mid = add i64 %tmp.shr, %rcx.cur
  %mid.elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %mid.val = load i32, i32* %mid.elem.ptr, align 4
  %cmp.sgt = icmp sgt i32 %key.load, %mid.val
  br i1 %cmp.sgt, label %BB1150, label %BB1105.update

BB1105:                                             ; 0x1105
  %rcx.cur = phi i64 [ 0, %BB10E0 ], [ %rcx.cur, %BB1105.update ], [ %rcx.plus1, %BB1150 ]
  %rdx.cur = phi i64 [ 9, %BB10E0 ], [ %mid, %BB1105.update ], [ %rdx.cur, %BB1150 ]
  %cmp.rcx.rdx = icmp ult i64 %rcx.cur, %rdx.cur
  br i1 %cmp.rcx.rdx, label %BB10F0, label %BB110A

BB1105.update:
  br label %BB1105

BB1150:                                             ; 0x1150
  %rcx.plus1 = add i64 %mid, 1
  br label %BB1105

BB110A:
  %edx.copy = add i32 %key.load, 0
  %out.of.range = icmp ugt i64 %rcx.cur, 8
  br i1 %out.of.range, label %BB1156, label %BB110A.cmp

BB110A.cmp:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %rcx.cur
  %elem.val = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %edx.copy, %elem.val
  br i1 %eq, label %BB1118, label %BB1156

BB1118:                                             ; found
  %fmt.found.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.found, i64 0, i64 0
  %call.found = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.found.ptr, i32 %edx.copy, i64 %rcx.cur)
  br label %BB1127

BB1156:                                             ; 0x1156 not found
  %fmt.nf.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.nf, i64 0, i64 0
  %call.nf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.nf.ptr, i32 %edx.copy)
  br label %BB1127

BB1127:                                             ; 0x1127
  %r12.sel = phi i32* [ %r12.cur, %BB1118 ], [ %r12.cur, %BB1156 ]
  %r12.next = getelementptr inbounds i32, i32* %r12.sel, i64 1
  %more = icmp ne i32* %r12.next, %keys.end
  br i1 %more, label %BB10E0, label %BB1130

BB1130:
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %guard.ok = icmp eq i64 %guard1, %guard.saved
  br i1 %guard.ok, label %BB1140, label %BB116B

BB116B:                                             ; 0x116B
  call void @__stack_chk_fail()
  unreachable

BB1140:                                             ; 0x1140
  ret i32 0
}