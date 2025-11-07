; ModuleID = 'main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = private constant <4 x i32> <i32 9, i32 1, i32 8, i32 3>, align 16
@xmmword_2020 = private constant <4 x i32> <i32 7, i32 5, i32 2, i32 6>, align 16
@str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@__stack_chk_guard = external global i64

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry_1080:
  %arr = alloca [10 x i32], align 16
  %guard.addr = alloca i64, align 8
  %arr_i32ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %vecptr0 = bitcast i32* %arr_i32ptr to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 16
  %elem4 = getelementptr inbounds i32, i32* %arr_i32ptr, i64 4
  %vecptr1 = bitcast i32* %elem4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 16
  %elem8 = getelementptr inbounds i32, i32* %arr_i32ptr, i64 8
  store i32 4, i32* %elem8, align 4
  %elem9 = getelementptr inbounds i32, i32* %arr_i32ptr, i64 9
  store i32 0, i32* %elem9, align 4
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %guard.addr, align 8
  %rbx_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %limitVar = alloca i64, align 8
  store i64 10, i64* %limitVar, align 8
  br label %loc_10D0

loc_10D0:                                         ; preds = %bb_1119, %entry_1080
  %limit_in = load i64, i64* %limitVar, align 8
  br label %loc_10E0

loc_10E0:                                         ; preds = %loc_1101, %loc_10D0
  %rax_curr = phi i64 [ 1, %loc_10D0 ], [ %rax_next, %loc_1101 ]
  %rdx_curr = phi i32* [ %rbx_base, %loc_10D0 ], [ %rdx_next, %loc_1101 ]
  %r8_curr = phi i64 [ 0, %loc_10D0 ], [ %r8_after, %loc_1101 ]
  %a = load i32, i32* %rdx_curr, align 4
  %nextptr = getelementptr inbounds i32, i32* %rdx_curr, i64 1
  %b = load i32, i32* %nextptr, align 4
  %cmp_le = icmp sle i32 %a, %b
  br i1 %cmp_le, label %no_swap_10E0, label %swap_10E0

swap_10E0:                                        ; preds = %loc_10E0
  store i32 %b, i32* %rdx_curr, align 4
  store i32 %a, i32* %nextptr, align 4
  br label %loc_1101

no_swap_10E0:                                     ; preds = %loc_10E0
  br label %loc_1101

loc_1101:                                         ; preds = %no_swap_10E0, %swap_10E0
  %r8_after = phi i64 [ %r8_curr, %no_swap_10E0 ], [ %rax_curr, %swap_10E0 ]
  %rax_next = add i64 %rax_curr, 1
  %rdx_next = getelementptr inbounds i32, i32* %rdx_curr, i64 1
  %limit_now = load i64, i64* %limitVar, align 8
  %cmp_jnz = icmp ne i64 %limit_now, %rax_next
  br i1 %cmp_jnz, label %loc_10E0, label %bb_110e

bb_110e:                                          ; preds = %loc_1101
  %r8_is_zero = icmp eq i64 %r8_after, 0
  br i1 %r8_is_zero, label %loc_111E, label %bb_1113

bb_1113:                                          ; preds = %bb_110e
  %r8_is_one = icmp eq i64 %r8_after, 1
  br i1 %r8_is_one, label %loc_111E, label %bb_1119

bb_1119:                                          ; preds = %bb_1113
  store i64 %r8_after, i64* %limitVar, align 8
  br label %loc_10D0

loc_111E:                                         ; preds = %bb_1113, %bb_110e
  %base_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end_ptr = getelementptr inbounds i32, i32* %base_ptr, i64 10
  br label %loc_1130

loc_1130:                                         ; preds = %loc_1130, %loc_111E
  %iter = phi i32* [ %base_ptr, %loc_111E ], [ %iter_next, %loc_1130 ]
  %val = load i32, i32* %iter, align 4
  %fmt1_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @str_d, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt1_ptr, i32 %val)
  %iter_next = getelementptr inbounds i32, i32* %iter, i64 1
  %cont = icmp ne i32* %iter_next, %end_ptr
  br i1 %cont, label %loc_1130, label %after_print_loop

after_print_loop:                                  ; preds = %loc_1130
  %fmt2_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @str_nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2_ptr)
  %guard_end = load i64, i64* @__stack_chk_guard
  %guard_saved2 = load i64, i64* %guard.addr, align 8
  %canary_mismatch = icmp ne i64 %guard_saved2, %guard_end
  br i1 %canary_mismatch, label %loc_1178, label %ret_ok

ret_ok:                                           ; preds = %after_print_loop
  ret i32 0

loc_1178:                                         ; preds = %after_print_loop
  call void @__stack_chk_fail()
  unreachable
}