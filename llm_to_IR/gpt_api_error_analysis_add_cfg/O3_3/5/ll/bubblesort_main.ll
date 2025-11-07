; ModuleID = 'recovered_from_asm'
target triple = "x86_64-pc-linux-gnu"
; You may adjust datalayout to match your toolchain if needed.

@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@dword_2030   = external global i32, align 4
@unk_2004     = external global [0 x i8]
@unk_2008     = external global [0 x i8]
@__stack_chk_guard = external global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb_1080:
  ; stack frame layout: { [10 x i32] array, i64 canary } to preserve address-based sentinel
  %frame = alloca { [10 x i32], i64 }, align 16
  %arr.slot = getelementptr inbounds { [10 x i32], i64 }, { [10 x i32], i64 }* %frame, i32 0, i32 0
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr.slot, i32 0, i32 0
  %canary.slot = getelementptr inbounds { [10 x i32], i64 }, { [10 x i32], i64 }* %frame, i32 0, i32 1

  ; store initial canary
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8

  ; initialize first 8 ints from external 128-bit constants
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %vptr0 = bitcast i32* %arr.base to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %vptr0, align 16

  %arr.base.plus4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %vptr1 = bitcast i32* %arr.base.plus4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %vptr1, align 16

  ; initialize 9th element with literal 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4

  ; initialize 10th element from an external dword to avoid undefined loads
  %idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  %last.init = load i32, i32* @dword_2030, align 4
  store i32 %last.init, i32* %idx9, align 4

  br label %bb_10D0

bb_10D0: ; 0x10d0
  ; rdi current limit: initially 10, later updated to last-swap index
  %rdi.cur = phi i64 [ 10, %bb_1080 ], [ %r8.to.rdi, %bb_1119 ]
  br label %bb_10E0

bb_10E0: ; 0x10e0
  ; inner pass over adjacent pairs: rax=index (starts at 1), rdx=base+index-1, r8=last swap index
  %rax.phi = phi i64 [ 1, %bb_10D0 ], [ %rax.next, %bb_1101 ]
  %rdx.phi = phi i32* [ %arr.base, %bb_10D0 ], [ %rdx.next, %bb_1101 ]
  %r8.phi  = phi i64  [ 0, %bb_10D0 ], [ %r8.carry, %bb_1101 ]

  %a = load i32, i32* %rdx.phi, align 4
  %rdx.next.elem = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %b = load i32, i32* %rdx.next.elem, align 4
  %cmp.le = icmp sle i32 %a, %b
  br i1 %cmp.le, label %bb_1101, label %bb_10F5

bb_10F5: ; 0x10f5
  ; swap and mark last swap index as current rax
  store i32 %b, i32* %rdx.phi, align 4
  store i32 %a, i32* %rdx.next.elem, align 4
  %r8.new = add i64 %rax.phi, 0
  br label %bb_1101

bb_1101: ; 0x1101
  ; carry r8 across (updated if swap happened)
  %r8.carry = phi i64 [ %r8.phi, %bb_10E0 ], [ %r8.new, %bb_10F5 ]
  ; forward rax/rdx
  %rax.in  = phi i64  [ %rax.phi, %bb_10E0 ], [ %rax.phi, %bb_10F5 ]
  %rdx.in  = phi i32* [ %rdx.phi, %bb_10E0 ], [ %rdx.phi, %bb_10F5 ]

  %rax.next = add i64 %rax.in, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.in, i64 1
  %cmp.rdi.ne = icmp ne i64 %rdi.cur, %rax.next
  br i1 %cmp.rdi.ne, label %bb_10E0, label %bb_110E

bb_110E: ; 0x110e
  ; test r8, r8
  %r8.is.zero = icmp eq i64 %r8.carry, 0
  br i1 %r8.is.zero, label %bb_111E, label %bb_1113

bb_1113: ; 0x1113
  ; cmp r8, 1
  %r8.is.one = icmp eq i64 %r8.carry, 1
  br i1 %r8.is.one, label %bb_111E, label %bb_1119

bb_1119: ; 0x1119
  ; mov rdi, r8 ; restart outer pass with reduced bound
  %r8.to.rdi = add i64 %r8.carry, 0
  br label %bb_10D0

bb_111E: ; 0x111e
  ; setup for printing: r12 = &canary (sentinel end), rbx = base, rbp = fmt1
  %limit.i32p = bitcast i64* %canary.slot to i32*
  %fmt1 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  br label %bb_1130

bb_1130: ; 0x1130
  ; print loop: do { printf_chk(2, fmt1, *rbx++); } while (rbx != r12);
  %rbx.cur = phi i32* [ %arr.base, %bb_111E ], [ %rbx.next, %bb_1130 ]
  %val = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %call.print.elem = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1, i32 %val)
  %cont = icmp ne i32* %limit.i32p, %rbx.next
  br i1 %cont, label %bb_1130, label %bb_114A

bb_114A: ; 0x114a
  ; print trailing text (e.g., newline)
  %call.print.tail = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  ; stack canary check
  %guard.saved = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.bad = icmp ne i64 %guard.saved, %guard.now
  br i1 %guard.bad, label %bb_1178, label %bb_116D

bb_116D: ; 0x116d
  ret i32 0

bb_1178: ; 0x1178
  call void @___stack_chk_fail()
  unreachable
}