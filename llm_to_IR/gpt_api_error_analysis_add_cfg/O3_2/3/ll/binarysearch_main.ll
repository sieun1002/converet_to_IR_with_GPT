; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2030 = external constant [16 x i8], align 16
@xmmword_2040 = external constant [16 x i8], align 16
@qword_2050   = external constant i64, align 8

@.str_found    = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1)

define i32 @main() {
b1080:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %canary.save = alloca i64, align 8

  %canary.init = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  store i64 %canary.init, i64* %canary.save, align 8

  %kq = load i64, i64* @qword_2050, align 8
  %keys.i64p = bitcast [3 x i32]* %keys to i64*
  store i64 %kq, i64* %keys.i64p, align 8
  %keys.idx2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.idx2, align 4

  %arr.i8 = bitcast [9 x i32]* %arr to i8*
  %src1 = bitcast [16 x i8]* @xmmword_2030 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %arr.i8, i8* nonnull %src1, i64 16, i1 false)

  %arr.idx4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  %arr.idx4.i8 = bitcast i32* %arr.idx4 to i8*
  %src2 = bitcast [16 x i8]* @xmmword_2040 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %arr.idx4.i8, i8* nonnull %src2, i64 16, i1 false)

  %arr.idx8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.idx8, align 4

  %pcur.init = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  %pend = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 3

  br label %b10e0

b10e0:
  %pcur = phi i32* [ %pcur.init, %b1080 ], [ %pcur.next, %b1127 ]
  %key = load i32, i32* %pcur, align 4
  br label %b1105

b1105:
  %low = phi i64 [ 0, %b10e0 ], [ %low.next, %b1150 ], [ %low, %b10f0 ]
  %high = phi i64 [ 9, %b10e0 ], [ %high, %b1150 ], [ %mid, %b10f0 ]
  %cmp.lb = icmp ult i64 %low, %high
  br i1 %cmp.lb, label %b10f0, label %b1105.exit

b10f0:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %half, %low
  %arr.mid.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %mid
  %arr.mid = load i32, i32* %arr.mid.ptr, align 4
  %gt = icmp sgt i32 %key, %arr.mid
  br i1 %gt, label %b1150, label %b1105

b1150:
  %low.next = add i64 %mid, 1
  br label %b1105

b1105.exit:
  %idx.overflow = icmp ugt i64 %low, 8
  br i1 %idx.overflow, label %b1156, label %b1105.check

b1105.check:
  %arr.idx.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %low
  %arr.idx.val = load i32, i32* %arr.idx.ptr, align 4
  %eq = icmp eq i32 %key, %arr.idx.val
  br i1 %eq, label %b1105.found, label %b1156

b1105.found:
  %fmt.found.p = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call.ok = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.found.p, i32 %key, i64 %low)
  br label %b1127

b1156:
  %fmt.nf.p = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %call.nf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.nf.p, i32 %key)
  br label %b1127

b1127:
  %pcur.next = getelementptr inbounds i32, i32* %pcur, i64 1
  %more = icmp ne i32* %pcur.next, %pend
  br i1 %more, label %b10e0, label %b1130

b1130:
  %canary.now = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %canary.stored = load i64, i64* %canary.save, align 8
  %canary.ok = icmp eq i64 %canary.stored, %canary.now
  br i1 %canary.ok, label %b1140, label %b116b

b1140:
  ret i32 0

b116b:
  call void @__stack_chk_fail()
  unreachable
}