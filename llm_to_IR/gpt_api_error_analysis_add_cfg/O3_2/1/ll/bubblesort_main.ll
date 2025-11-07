; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external global [16 x i8], align 16
@xmmword_2020 = external global [16 x i8], align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb1080:
  %frame = alloca [48 x i8], align 16
  %arrptr = getelementptr inbounds [48 x i8], [48 x i8]* %frame, i64 0, i64 0
  %cookieptr.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %frame, i64 0, i64 40
  %cookieptr = bitcast i8* %cookieptr.i8 to i64*
  %canary0 = call i64 asm "movq %fs:0x28, $0", "=r"()
  store i64 %canary0, i64* %cookieptr, align 8
  ; store first 16 bytes from cs:xmmword_2010
  %p2010 = bitcast [16 x i8]* @xmmword_2010 to <16 x i8>*
  %vec2010 = load <16 x i8>, <16 x i8>* %p2010, align 16
  %arrvec0 = bitcast i8* %arrptr to <16 x i8>*
  store <16 x i8> %vec2010, <16 x i8>* %arrvec0, align 16
  ; store next 16 bytes from cs:xmmword_2020
  %p2020 = bitcast [16 x i8]* @xmmword_2020 to <16 x i8>*
  %vec2020 = load <16 x i8>, <16 x i8>* %p2020, align 16
  %arrptr16 = getelementptr inbounds i8, i8* %arrptr, i64 16
  %arrvec16 = bitcast i8* %arrptr16 to <16 x i8>*
  store <16 x i8> %vec2020, <16 x i8>* %arrvec16, align 16
  ; store dword 4 at offset 0x20
  %arrptr32 = getelementptr inbounds i8, i8* %arrptr, i64 32
  %arr32 = bitcast i8* %arrptr32 to i32*
  store i32 4, i32* %arr32, align 4
  br label %bb10d0

bb10d0:                                             ; rdx=rbx(arr), r8=0, rax=1, rdi=10 (initial pass)
  %rdx0 = phi i8* [ %arrptr, %bb1080 ], [ %arrptr, %bb111c ]
  %n = phi i64 [ 10, %bb1080 ], [ %n_next, %bb111c ]
  %lastSwap0 = phi i64 [ 0, %bb1080 ], [ 0, %bb111c ]
  %i0 = phi i64 [ 1, %bb1080 ], [ 1, %bb111c ]
  br label %bb10e0

bb10e0:
  %i = phi i64 [ %i0, %bb10d0 ], [ %i.next, %bb1101 ]
  %rdx = phi i8* [ %rdx0, %bb10d0 ], [ %rdx.next, %bb1101 ]
  %lastSwap = phi i64 [ %lastSwap0, %bb10d0 ], [ %lastSwap.after, %bb1101 ]
  %p.lo = bitcast i8* %rdx to i32*
  %v0 = load i32, i32* %p.lo, align 4
  %p.hibytes = getelementptr inbounds i8, i8* %rdx, i64 4
  %p.hi = bitcast i8* %p.hibytes to i32*
  %v1 = load i32, i32* %p.hi, align 4
  %cmp.gt = icmp sgt i32 %v0, %v1
  br i1 %cmp.gt, label %bb10f5_swap, label %bb1101

bb10f5_swap:
  store i32 %v1, i32* %p.lo, align 4
  store i32 %v0, i32* %p.hi, align 4
  %lastSwap.swapped = add i64 %i, 0
  br label %bb1101

bb1101:
  %lastSwap.after = phi i64 [ %lastSwap.swapped, %bb10f5_swap ], [ %lastSwap, %bb10e0 ]
  %i.next = add i64 %i, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx, i64 4
  %cont = icmp ne i64 %n, %i.next
  br i1 %cont, label %bb10e0, label %bb110e

bb110e:
  %lastSwap.iszero = icmp eq i64 %lastSwap.after, 0
  br i1 %lastSwap.iszero, label %bb111e, label %bb1113

bb1113:
  %lastSwap.isone = icmp eq i64 %lastSwap.after, 1
  br i1 %lastSwap.isone, label %bb111e, label %bb1119

bb1119:
  %n_next = add i64 %lastSwap.after, 0
  br label %bb111c

bb111c:
  br label %bb10d0

bb111e:
  %endptr = getelementptr inbounds i8, i8* %arrptr, i64 40
  br label %bb1130

bb1130:
  %print.ptr = phi i8* [ %arrptr, %bb111e ], [ %print.next, %bb1148 ]
  %print.i32.ptr = bitcast i8* %print.ptr to i32*
  %print.val = load i32, i32* %print.i32.ptr, align 4
  %fmt.ptr = bitcast i8* @unk_2004 to i8*
  %call.printf = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %print.val)
  %print.next = getelementptr inbounds i8, i8* %print.ptr, i64 4
  %cmp.end = icmp ne i8* %endptr, %print.next
  br i1 %cmp.end, label %bb1148, label %bb114a

bb1148:
  br label %bb1130

bb114a:
  %fmt2.ptr = bitcast i8* @unk_2008 to i8*
  %call.printf2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  %saved.cookie = load i64, i64* %cookieptr, align 8
  %canary1 = call i64 asm "movq %fs:0x28, $0", "=r"()
  %canary.bad = icmp ne i64 %saved.cookie, %canary1
  br i1 %canary.bad, label %bb1178, label %bb116d

bb116d:
  ret i32 0

bb1178:
  call void @___stack_chk_fail()
  unreachable
}