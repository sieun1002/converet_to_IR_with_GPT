; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@unk_140004000 = private unnamed_addr constant [9 x i8] c"Before:\0A\00", align 1
@unk_140004009 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_14000400D = private unnamed_addr constant [8 x i8] c"After:\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)
@sub_140002960 = alias i32 (i8*, ...), ptr @printf

declare dllimport i32 @putchar(i32)
@sub_140002AF0 = alias i32 (i32), ptr @putchar

define dso_local void @sub_1400018F0() {
entry:
  ret void
}

define dso_local void @sub_140001450(i32* %arr, i64 %count) {
entry:
  %cmp_init = icmp ult i64 %count, 2
  br i1 %cmp_init, label %retblock, label %outer_init

outer_init:
  %i0 = phi i64 [ 0, %entry ], [ %i0.next, %outer_inc2 ]
  %cmp_outer = icmp ult i64 %i0, %count
  br i1 %cmp_outer, label %inner_init, label %retblock

inner_init:
  %j0 = add i64 %i0, 1
  %cmp_inner = icmp ult i64 %j0, %count
  br i1 %cmp_inner, label %inner_body, label %outer_inc

inner_body:
  %gep_i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i0
  %val_i = load i32, i32* %gep_i_ptr, align 4
  %gep_j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j0
  %val_j = load i32, i32* %gep_j_ptr, align 4
  %cmp_swap = icmp slt i32 %val_j, %val_i
  br i1 %cmp_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_j, i32* %gep_i_ptr, align 4
  store i32 %val_i, i32* %gep_j_ptr, align 4
  br label %no_swap

no_swap:
  %j_next = add i64 %j0, 1
  %cmp_inner_next = icmp ult i64 %j_next, %count
  br i1 %cmp_inner_next, label %inner_body_next, label %outer_inc

inner_body_next:
  %gep_i_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i0
  %val_i2 = load i32, i32* %gep_i_ptr2, align 4
  %gep_j_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j_next
  %val_j2 = load i32, i32* %gep_j_ptr2, align 4
  %cmp_swap2 = icmp slt i32 %val_j2, %val_i2
  br i1 %cmp_swap2, label %do_swap2, label %no_swap2

do_swap2:
  store i32 %val_j2, i32* %gep_i_ptr2, align 4
  store i32 %val_i2, i32* %gep_j_ptr2, align 4
  br label %no_swap2

no_swap2:
  %j_next2 = add i64 %j_next, 1
  %cmp_inner_next2 = icmp ult i64 %j_next2, %count
  br i1 %cmp_inner_next2, label %inner_body3, label %outer_inc

inner_body3:
  %gep_i_ptr3 = getelementptr inbounds i32, i32* %arr, i64 %i0
  %val_i3 = load i32, i32* %gep_i_ptr3, align 4
  %gep_j_ptr3 = getelementptr inbounds i32, i32* %arr, i64 %j_next2
  %val_j3 = load i32, i32* %gep_j_ptr3, align 4
  %cmp_swap3 = icmp slt i32 %val_j3, %val_i3
  br i1 %cmp_swap3, label %do_swap3, label %no_swap3

do_swap3:
  store i32 %val_j3, i32* %gep_i_ptr3, align 4
  store i32 %val_i3, i32* %gep_j_ptr3, align 4
  br label %no_swap3

no_swap3:
  %j_next3 = add i64 %j_next2, 1
  %cmp_inner_next3 = icmp ult i64 %j_next3, %count
  br i1 %cmp_inner_next3, label %inner_loop, label %outer_inc

inner_loop:
  %j_phi = phi i64 [ %j_next3, %no_swap3 ], [ %j_inc_loop, %inner_loop ]
  %gep_i_ptr_loop = getelementptr inbounds i32, i32* %arr, i64 %i0
  %val_i_loop = load i32, i32* %gep_i_ptr_loop, align 4
  %gep_j_ptr_loop = getelementptr inbounds i32, i32* %arr, i64 %j_phi
  %val_j_loop = load i32, i32* %gep_j_ptr_loop, align 4
  %cmp_swap_loop = icmp slt i32 %val_j_loop, %val_i_loop
  br i1 %cmp_swap_loop, label %do_swap_loop, label %no_swap_loop

do_swap_loop:
  store i32 %val_j_loop, i32* %gep_i_ptr_loop, align 4
  store i32 %val_i_loop, i32* %gep_j_ptr_loop, align 4
  br label %no_swap_loop

no_swap_loop:
  %j_inc_loop = add i64 %j_phi, 1
  %cmp_inner_cont = icmp ult i64 %j_inc_loop, %count
  br i1 %cmp_inner_cont, label %inner_loop, label %outer_inc

outer_inc:
  %i_next = add i64 %i0, 1
  %cmp_outer_cont = icmp ult i64 %i_next, %count
  br i1 %cmp_outer_cont, label %outer_continue, label %retblock

outer_continue:
  %i0.next = phi i64 [ %i_next, %outer_inc ]
  %j_seed = add i64 %i0.next, 1
  %cmp_seed = icmp ult i64 %j_seed, %count
  br i1 %cmp_seed, label %inner_body_seed, label %outer_inc2

inner_body_seed:
  %gep_i_ptr_s = getelementptr inbounds i32, i32* %arr, i64 %i0.next
  %val_i_s = load i32, i32* %gep_i_ptr_s, align 4
  %gep_j_ptr_s = getelementptr inbounds i32, i32* %arr, i64 %j_seed
  %val_j_s = load i32, i32* %gep_j_ptr_s, align 4
  %cmp_swap_s = icmp slt i32 %val_j_s, %val_i_s
  br i1 %cmp_swap_s, label %do_swap_s, label %no_swap_s

do_swap_s:
  store i32 %val_j_s, i32* %gep_i_ptr_s, align 4
  store i32 %val_i_s, i32* %gep_j_ptr_s, align 4
  br label %no_swap_s

no_swap_s:
  %j_next_s = add i64 %j_seed, 1
  %cmp_inner_s = icmp ult i64 %j_next_s, %count
  br i1 %cmp_inner_s, label %inner_loop2, label %outer_inc2

inner_loop2:
  %j_phi2 = phi i64 [ %j_next_s, %no_swap_s ], [ %j_inc2, %inner_loop2 ]
  %gep_i_ptr_l2 = getelementptr inbounds i32, i32* %arr, i64 %i0.next
  %val_i_l2 = load i32, i32* %gep_i_ptr_l2, align 4
  %gep_j_ptr_l2 = getelementptr inbounds i32, i32* %arr, i64 %j_phi2
  %val_j_l2 = load i32, i32* %gep_j_ptr_l2, align 4
  %cmp_swap_l2 = icmp slt i32 %val_j_l2, %val_i_l2
  br i1 %cmp_swap_l2, label %do_swap_l2, label %no_swap_l2

do_swap_l2:
  store i32 %val_j_l2, i32* %gep_i_ptr_l2, align 4
  store i32 %val_i_l2, i32* %gep_j_ptr_l2, align 4
  br label %no_swap_l2

no_swap_l2:
  %j_inc2 = add i64 %j_phi2, 1
  %cmp_inner_cont2 = icmp ult i64 %j_inc2, %count
  br i1 %cmp_inner_cont2, label %inner_loop2, label %outer_inc2

outer_inc2:
  br label %outer_init

retblock:
  ret void
}

define dso_local i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @sub_1400018F0()
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 4
  store i64 9, i64* %count, align 8
  %fmt_before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @unk_140004000, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @sub_140002960(i8* %fmt_before_ptr)
  store i64 0, i64* %i, align 8
  br label %print_loop

print_loop:
  %i_val = load i64, i64* %i, align 8
  %count_val = load i64, i64* %count, align 8
  %cmp = icmp ult i64 %i_val, %count_val
  br i1 %cmp, label %print_body, label %after_first_loop

print_body:
  %elem_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i_val
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt_num_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call_num = call i32 (i8*, ...) @sub_140002960(i8* %fmt_num_ptr, i32 %elem)
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %print_loop

after_first_loop:
  %newline_call1 = call i32 @sub_140002AF0(i32 10)
  %arr_base_ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %count_for_sort = load i64, i64* %count, align 8
  call void @sub_140001450(i32* %arr_base_ptr, i64 %count_for_sort)
  %fmt_after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @unk_14000400D, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @sub_140002960(i8* %fmt_after_ptr)
  store i64 0, i64* %j, align 8
  br label %print_loop2

print_loop2:
  %j_val = load i64, i64* %j, align 8
  %count_val2 = load i64, i64* %count, align 8
  %cmp2 = icmp ult i64 %j_val, %count_val2
  br i1 %cmp2, label %print_body2, label %after_second_loop

print_body2:
  %elem_ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j_val
  %elem2 = load i32, i32* %elem_ptr2, align 4
  %fmt_num_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_140004009, i64 0, i64 0
  %call_num2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_num_ptr2, i32 %elem2)
  %j_next = add i64 %j_val, 1
  store i64 %j_next, i64* %j, align 8
  br label %print_loop2

after_second_loop:
  %newline_call2 = call i32 @sub_140002AF0(i32 10)
  ret i32 0
}