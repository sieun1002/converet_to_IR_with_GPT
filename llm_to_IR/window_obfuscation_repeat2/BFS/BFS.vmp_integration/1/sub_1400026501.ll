; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002BA0(i8*)
declare i32 @sub_140002BA8(i8*, i8*, i32)

define i8* @sub_140002650(i8* %rcx) {
entry:
  %len = call i64 @sub_140002BA0(i8* %rcx)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %ret_zero, label %check_mz

check_mz:
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_header, label %ret_zero

pe_header:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew
  %sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %opt_magic_ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20B = icmp eq i16 %opt_magic, 523
  br i1 %is_20B, label %check_numsec, label %ret_zero

check_numsec:
  %numsec_ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %ret_zero, label %loop_prep

loop_prep:
  %soh_ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr.i8 to i16*
  %size_opt16 = load i16, i16* %soh_ptr, align 1
  %size_opt = zext i16 %size_opt16 to i64
  %sec_start_tmp = getelementptr i8, i8* %pehdr, i64 %size_opt
  %sec_start = getelementptr i8, i8* %sec_start_tmp, i64 24
  %numsec = zext i16 %numsec16 to i32
  br label %loop_hdr

loop_hdr:
  %i = phi i32 [ 0, %loop_prep ], [ %i.next, %cont_loop ]
  %cur = phi i8* [ %sec_start, %loop_prep ], [ %next_sec, %cont_loop ]
  %call = call i32 @sub_140002BA8(i8* %cur, i8* %rcx, i32 8)
  %is_zero_call = icmp eq i32 %call, 0
  br i1 %is_zero_call, label %ret_cur, label %cont_loop

cont_loop:
  %i.next = add i32 %i, 1
  %next_sec = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i.next, %numsec
  br i1 %cont, label %loop_hdr, label %ret_zero

ret_cur:
  ret i8* %cur

ret_zero:
  ret i8* null
}