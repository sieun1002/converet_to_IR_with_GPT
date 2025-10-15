; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_1400026D0(i64 %rcx_param) {
entry:
  %base_ptr_ptr = load i8*, i8** @off_1400043A0, align 8
  %base_word_ptr = bitcast i8* %base_ptr_ptr to i16*
  %mz = load i16, i16* %base_word_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr_ptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew_sext = sext i32 %lfanew to i64
  %pehdr_ptr = getelementptr i8, i8* %base_ptr_ptr, i64 %lfanew_sext
  %sig_ptr = bitcast i8* %pehdr_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:                                        ; preds = %check_pe
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_opt64 = icmp eq i16 %magic, 523
  br i1 %is_opt64, label %sections, label %ret0

sections:                                         ; preds = %check_opt
  %nos_ptr_i8 = getelementptr i8, i8* %pehdr_ptr, i64 6
  %nos_ptr = bitcast i8* %nos_ptr_i8 to i16*
  %nos16 = load i16, i16* %nos_ptr, align 1
  %nos_zero = icmp eq i16 %nos16, 0
  br i1 %nos_zero, label %ret0, label %compute_hdr

compute_hdr:                                      ; preds = %sections
  %opt_off_i8 = getelementptr i8, i8* %pehdr_ptr, i64 20
  %opt_sz_ptr16 = bitcast i8* %opt_off_i8 to i16*
  %opt_sz16 = load i16, i16* %opt_sz_ptr16, align 1
  %opt_sz_zext = zext i16 %opt_sz16 to i64
  %sections_base_pre = getelementptr i8, i8* %pehdr_ptr, i64 24
  %rax_init = getelementptr i8, i8* %sections_base_pre, i64 %opt_sz_zext
  %nos32 = zext i16 %nos16 to i32
  %edx_sub1 = add i32 %nos32, 4294967295
  %edx_times4 = mul i32 %edx_sub1, 4
  %edx_times5 = add i32 %edx_sub1, %edx_times4
  %edx_times5_sext = sext i32 %edx_times5 to i64
  %rdx_offset = mul i64 %edx_times5_sext, 8
  %rax_plus28 = getelementptr i8, i8* %rax_init, i64 40
  %end_ptr = getelementptr i8, i8* %rax_plus28, i64 %rdx_offset
  br label %loop

loop:                                             ; preds = %advance, %compute_hdr
  %rax_curr = phi i8* [ %rax_init, %compute_hdr ], [ %rax_next, %advance ]
  %rcx_curr = phi i64 [ %rcx_param, %compute_hdr ], [ %rcx_next, %advance ]
  %char_ptr_i8 = getelementptr i8, i8* %rax_curr, i64 39
  %char_byte = load i8, i8* %char_ptr_i8, align 1
  %and = and i8 %char_byte, 32
  %is_zero = icmp eq i8 %and, 0
  br i1 %is_zero, label %advance, label %check_rcx

check_rcx:                                        ; preds = %loop
  %is_rcx_zero = icmp eq i64 %rcx_curr, 0
  br i1 %is_rcx_zero, label %ret0, label %do_decr

do_decr:                                          ; preds = %check_rcx
  %rcx_dec = add i64 %rcx_curr, -1
  br label %advance

advance:                                          ; preds = %do_decr, %loop
  %rcx_next = phi i64 [ %rcx_curr, %loop ], [ %rcx_dec, %do_decr ]
  %rax_next = getelementptr i8, i8* %rax_curr, i64 40
  %done = icmp eq i8* %end_ptr, %rax_next
  br i1 %done, label %ret0, label %loop

ret0:                                             ; preds = %advance, %check_rcx, %sections, %check_opt, %check_pe, %entry
  ret i32 0
}