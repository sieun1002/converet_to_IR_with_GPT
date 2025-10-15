; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %p) local_unnamed_addr nounwind {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %dos_magic_ptr = bitcast i8* %base_ptr to i16*
  %e_magic = load i16, i16* %dos_magic_ptr, align 1
  %is_mz = icmp eq i16 %e_magic, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                            ; preds = %entry
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew64
  %nt_sig_ptr = bitcast i8* %nt_ptr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                         ; preds = %check_pe
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret0

check_sections:                                      ; preds = %check_magic
  %num_secs_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %num_secs_ptr = bitcast i8* %num_secs_ptr_i8 to i16*
  %num_secs16 = load i16, i16* %num_secs_ptr, align 1
  %num_secs_zero = icmp eq i16 %num_secs16, 0
  br i1 %num_secs_zero, label %ret0, label %prep_loop

prep_loop:                                           ; preds = %check_sections
  %opt_size_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 1
  %opt_size64 = zext i16 %opt_size16 to i64
  %first_sec_off = add i64 %opt_size64, 24
  %first_sec_ptr = getelementptr i8, i8* %nt_ptr, i64 %first_sec_off
  %num_secs64 = zext i16 %num_secs16 to i64
  %total_size = mul i64 %num_secs64, 40
  %end_ptr = getelementptr i8, i8* %first_sec_ptr, i64 %total_size
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %rva64 = sub i64 %p_int, %base_int
  br label %loop

loop:                                                ; preds = %skip_or_continue, %prep_loop
  %cur_ptr_phi = phi i8* [ %first_sec_ptr, %prep_loop ], [ %next_ptr, %skip_or_continue ]
  %cond_end = icmp eq i8* %cur_ptr_phi, %end_ptr
  br i1 %cond_end, label %ret0, label %check_section

check_section:                                       ; preds = %loop
  %va_ptr_i8 = getelementptr i8, i8* %cur_ptr_phi, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp_rva_va = icmp ult i64 %rva64, %va64
  br i1 %cmp_rva_va, label %skip_or_continue, label %check_end

check_end:                                           ; preds = %check_section
  %vsize_ptr_i8 = getelementptr i8, i8* %cur_ptr_phi, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %cmp_rva_end = icmp ult i64 %rva64, %end64
  br i1 %cmp_rva_end, label %found, label %skip_or_continue

skip_or_continue:                                    ; preds = %check_end, %check_section
  %next_ptr = getelementptr i8, i8* %cur_ptr_phi, i64 40
  br label %loop

found:                                               ; preds = %check_end
  %ch_ptr_i8 = getelementptr i8, i8* %cur_ptr_phi, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch32 = load i32, i32* %ch_ptr, align 1
  %notch = xor i32 %ch32, -1
  %shr = lshr i32 %notch, 31
  ret i32 %shr

ret0:                                                ; preds = %loop, %check_sections, %check_magic, %check_pe, %entry
  ret i32 0
}