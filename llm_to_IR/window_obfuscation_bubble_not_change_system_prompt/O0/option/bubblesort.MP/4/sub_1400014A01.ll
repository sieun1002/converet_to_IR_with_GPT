; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external dso_local global i8*, align 8

declare dso_local void @sub_140001420(i8*)
declare dso_local void @sub_140001450()

define dso_local void @sub_1400014A0() local_unnamed_addr {
entry:
  %rdx_base_ptr = load i8*, i8** @off_1400043B0, align 8
  %q0_ptr = bitcast i8* %rdx_base_ptr to i64*
  %q0_val = load i64, i64* %q0_ptr, align 8
  %eax32_tr = trunc i64 %q0_val to i32
  %is_m1 = icmp eq i32 %eax32_tr, -1
  br i1 %is_m1, label %loc_14F0, label %loc_14B7_prep

loc_14B7_prep:                                    ; preds = %entry
  br label %loc_14B7

loc_14F0:                                          ; preds = %entry
  br label %scan_loop

scan_loop:                                         ; preds = %scan_cont, %loc_14F0
  %index_phi = phi i64 [ 0, %loc_14F0 ], [ %next_index_phi, %scan_cont ]
  %ecx_phi = phi i32 [ 0, %loc_14F0 ], [ %ecx_update, %scan_cont ]
  %next_index_phi = add i64 %index_phi, 1
  %next_scaled_bytes = mul i64 %next_index_phi, 8
  %entry_addr_i8 = getelementptr i8, i8* %rdx_base_ptr, i64 %next_scaled_bytes
  %entry_addr_ptr = bitcast i8* %entry_addr_i8 to i8**
  %entry_val = load i8*, i8** %entry_addr_ptr, align 8
  %has_entry = icmp ne i8* %entry_val, null
  br i1 %has_entry, label %scan_cont, label %loc_14B7

scan_cont:                                         ; preds = %scan_loop
  %ecx_update = trunc i64 %index_phi to i32
  br label %scan_loop

loc_14B7:                                          ; preds = %scan_loop, %loc_14B7_prep
  %ecx_final = phi i32 [ %eax32_tr, %loc_14B7_prep ], [ %ecx_phi, %scan_loop ]
  %is_zero = icmp eq i32 %ecx_final, 0
  br i1 %is_zero, label %loc_14DB, label %loop_setup

loop_setup:                                        ; preds = %loc_14B7
  %ecx_zext = zext i32 %ecx_final to i64
  %scaled_bytes2 = mul i64 %ecx_zext, 8
  %rbx_init = getelementptr i8, i8* %rdx_base_ptr, i64 %scaled_bytes2
  %ecx_minus1 = sub i32 %ecx_final, 1
  %rax1_z = zext i32 %ecx_final to i64
  %ecx_minus1_z = zext i32 %ecx_minus1 to i64
  %rax_sub_res = sub i64 %rax1_z, %ecx_minus1_z
  %scaled_bytes3 = mul i64 %rax_sub_res, 8
  %rsi_tmp = getelementptr i8, i8* %rdx_base_ptr, i64 %scaled_bytes3
  %rsi_init = getelementptr i8, i8* %rsi_tmp, i64 -8
  br label %loop_header

loop_header:                                       ; preds = %loop_continue, %loop_setup
  %rbx_cur = phi i8* [ %rbx_init, %loop_setup ], [ %rbx_next, %loop_continue ]
  %fnptrptr_i8 = bitcast i8* %rbx_cur to i8**
  %fn_i8 = load i8*, i8** %fnptrptr_i8, align 8
  %fn_typed = bitcast i8* %fn_i8 to void ()*
  call void %fn_typed()
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 -8
  %cmp_cont = icmp ne i8* %rbx_next, %rsi_init
  br i1 %cmp_cont, label %loop_continue, label %loc_14DB

loop_continue:                                     ; preds = %loop_header
  br label %loop_header

loc_14DB:                                          ; preds = %loop_header, %loc_14B7
  %fnaddr_i8 = bitcast void ()* @sub_140001450 to i8*
  tail call void @sub_140001420(i8* %fnaddr_i8)
  ret void
}