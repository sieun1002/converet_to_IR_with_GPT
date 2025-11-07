; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <2 x i64>, align 16
@xmmword_2020 = external constant <2 x i64>, align 16
@unk_2004 = external constant [0 x i8]
@unk_2008 = external constant [0 x i8]
@__stack_chk_guard = external thread_local global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
loc_1080:
  %buf = alloca [48 x i8], align 16
  %buf.base = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0

  ; load canary guard and save to stack frame (offset 40)
  %guard.init = load i64, i64* @__stack_chk_guard
  %p0.vec = bitcast i8* %buf.base to <2 x i64>*
  %v1 = load <2 x i64>, <2 x i64>* @xmmword_2010, align 16
  store <2 x i64> %v1, <2 x i64>* %p0.vec, align 16
  %p16 = getelementptr inbounds i8, i8* %buf.base, i64 16
  %p16.vec = bitcast i8* %p16 to <2 x i64>*
  %v2 = load <2 x i64>, <2 x i64>* @xmmword_2020, align 16
  store <2 x i64> %v2, <2 x i64>* %p16.vec, align 16
  %p32 = getelementptr inbounds i8, i8* %buf.base, i64 32
  %p32.i32 = bitcast i8* %p32 to i32*
  store i32 4, i32* %p32.i32, align 4
  %p40 = getelementptr inbounds i8, i8* %buf.base, i64 40
  %p40.i64 = bitcast i8* %p40 to i64*
  store i64 %guard.init, i64* %p40.i64, align 8

  %rdi.init = add i64 0, 10
  br label %loc_10D0

loc_10D0:
  %rdi.cur = phi i64 [ %rdi.init, %loc_1080 ], [ %r8.endpass, %loc_1119 ]
  %rdx.init = bitcast i8* %buf.base to i8*
  %r8.init = add i64 0, 0
  %rax.init = add i64 0, 1
  br label %loc_10E0

loc_10E0:
  %rax.cur = phi i64 [ %rax.init, %loc_10D0 ], [ %rax.next, %loc_1101_loop_back ]
  %rdx.cur = phi i8* [ %rdx.init, %loc_10D0 ], [ %rdx.next, %loc_1101_loop_back ]
  %r8.cur = phi i64 [ %r8.init, %loc_10D0 ], [ %r8.pass, %loc_1101_loop_back ]
  %rdi.cur.l = phi i64 [ %rdi.cur, %loc_10D0 ], [ %rdi.cur.h, %loc_1101_loop_back ]

  %p.i32 = bitcast i8* %rdx.cur to i32*
  %val.lo = load i32, i32* %p.i32, align 4
  %p.hi = getelementptr inbounds i32, i32* %p.i32, i64 1
  %val.hi = load i32, i32* %p.hi, align 4

  %cmp.le = icmp sle i32 %val.lo, %val.hi
  br i1 %cmp.le, label %loc_1101, label %loc_10F5

loc_10F5:
  %r8.new = add i64 %rax.cur, 0
  store i32 %val.hi, i32* %p.i32, align 4
  store i32 %val.lo, i32* %p.hi, align 4
  br label %loc_1101

loc_1101:
  %r8.pass = phi i64 [ %r8.cur, %loc_10E0 ], [ %r8.new, %loc_10F5 ]
  %rdi.cur.h = phi i64 [ %rdi.cur.l, %loc_10E0 ], [ %rdi.cur.l, %loc_10F5 ]
  %rax.next = add i64 %rax.cur, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.cur, i64 4
  %cmp.iter = icmp ne i64 %rdi.cur.h, %rax.next
  br i1 %cmp.iter, label %loc_1101_loop_back, label %loc_1101_endcheck

loc_1101_loop_back:
  br label %loc_10E0

loc_1101_endcheck:
  %t0 = icmp eq i64 %r8.pass, 0
  br i1 %t0, label %loc_111E, label %loc_1113

loc_1113:
  %t1 = icmp eq i64 %r8.pass, 1
  br i1 %t1, label %loc_111E, label %loc_1119

loc_1119:
  %r8.endpass = add i64 %r8.pass, 0
  br label %loc_10D0

loc_111E:
  %endptr = getelementptr inbounds i8, i8* %buf.base, i64 40
  %fmt.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  br label %loc_1130

loc_1130:
  %rbx.cur = phi i8* [ %buf.base, %loc_111E ], [ %rbx.next, %loc_1130 ]
  %rbx.i32 = bitcast i8* %rbx.cur to i32*
  %val.print = load i32, i32* %rbx.i32, align 4
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 4
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val.print)
  %cmp.rbx = icmp ne i8* %endptr, %rbx.next
  br i1 %cmp.rbx, label %loc_1130, label %loc_114A

loc_114A:
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %stored = load i64, i64* %p40.i64, align 8
  %guard.now = load i64, i64* @__stack_chk_guard
  %canary.bad = icmp ne i64 %stored, %guard.now
  br i1 %canary.bad, label %loc_1178, label %ret

ret:
  ret i32 0

loc_1178:
  call void @___stack_chk_fail()
  unreachable
}