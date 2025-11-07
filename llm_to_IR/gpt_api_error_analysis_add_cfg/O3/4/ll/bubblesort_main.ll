; ModuleID = 'reconstructed_from_asm'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@unk_2004 = external global i8
@unk_2008 = external global i8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %rbx_base = bitcast [10 x i32]* %arr to i32*
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %pvec0 = bitcast i32* %arr0 to <4 x i32>*
  store <4 x i32> %vec1, <4 x i32>* %pvec0, align 16
  %vec2 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %pvec4 = bitcast i32* %arr4 to <4 x i32>*
  store <4 x i32> %vec2, <4 x i32>* %pvec4, align 16
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  br label %loc_10D0

loc_10D0:                                           ; preds = %entry, %set_n_and_jump
  %n = phi i64 [ 10, %entry ], [ %r8_afterpass, %set_n_and_jump ]
  br label %loc_10E0

loc_10E0:                                           ; preds = %loc_10D0, %loc_1101
  %idx = phi i64 [ 1, %loc_10D0 ], [ %idx.inc, %loc_1101 ]
  %rdx.ptr = phi i32* [ %rbx_base, %loc_10D0 ], [ %rdx.next, %loc_1101 ]
  %r8.flag = phi i64 [ 0, %loc_10D0 ], [ %r8.next, %loc_1101 ]
  %a.load = load i32, i32* %rdx.ptr, align 4
  %rdx.plus1 = getelementptr inbounds i32, i32* %rdx.ptr, i64 1
  %b.load = load i32, i32* %rdx.plus1, align 4
  %cmp.le = icmp sle i32 %a.load, %b.load
  br i1 %cmp.le, label %loc_1101, label %swap_block

swap_block:                                         ; preds = %loc_10E0
  store i32 %b.load, i32* %rdx.ptr, align 4
  store i32 %a.load, i32* %rdx.plus1, align 4
  br label %loc_1101

loc_1101:                                           ; preds = %loc_10E0, %swap_block
  %r8.next = phi i64 [ %r8.flag, %loc_10E0 ], [ %idx, %swap_block ]
  %idx.inc = add i64 %idx, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.ptr, i64 1
  %cmp.idx.n = icmp ne i64 %n, %idx.inc
  br i1 %cmp.idx.n, label %loc_10E0, label %after_inner

after_inner:                                        ; preds = %loc_1101
  %r8.nonzero = icmp ne i64 %r8.next, 0
  br i1 %r8.nonzero, label %check_r8_eq1, label %loc_111E

check_r8_eq1:                                       ; preds = %after_inner
  %r8.eq1 = icmp eq i64 %r8.next, 1
  br i1 %r8.eq1, label %loc_111E, label %set_n_and_jump

set_n_and_jump:                                     ; preds = %check_r8_eq1
  %r8_afterpass = add i64 %r8.next, 0
  br label %loc_10D0

loc_111E:                                           ; preds = %after_inner, %check_r8_eq1
  %end.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  %cur.start = add i64 0, 0
  br label %loc_1130

loc_1130:                                           ; preds = %loc_111E, %loc_1130
  %cur = phi i32* [ %rbx_base, %loc_111E ], [ %cur.next, %loc_1130 ]
  %val.load = load i32, i32* %cur, align 4
  %cur.next = getelementptr inbounds i32, i32* %cur, i64 1
  %call.printf.iter = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val.load)
  %cmp.endptr = icmp ne i32* %end.ptr, %cur.next
  br i1 %cmp.endptr, label %loc_1130, label %after_print

after_print:                                        ; preds = %loc_1130
  %call.printf.final = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  %saved.guard = load i64, i64* %canary, align 8
  %now.guard = load i64, i64* @__stack_chk_guard, align 8
  %guard.mismatch = icmp ne i64 %saved.guard, %now.guard
  br i1 %guard.mismatch, label %loc_1178, label %ret

ret:                                                ; preds = %after_print
  ret i32 0

loc_1178:                                           ; preds = %after_print
  call void @___stack_chk_fail()
  unreachable
}