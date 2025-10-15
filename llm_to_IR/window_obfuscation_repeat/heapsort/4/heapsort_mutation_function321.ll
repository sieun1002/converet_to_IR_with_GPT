; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* %addr) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16_ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

ret0:
  ret i32 0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_64 = icmp eq i16 %opt_magic, 523
  br i1 %is_64, label %load_hdr, label %ret0

load_hdr:
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %load_sizes

load_sizes:
  %soh_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %firstsec = getelementptr i8, i8* %pehdr, i64 24
  %firstsec2 = getelementptr i8, i8* %firstsec, i64 %soh64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %secsz64 = mul i64 %numsec64, 40
  %endsec = getelementptr i8, i8* %firstsec2, i64 %secsz64
  %addr_i64 = ptrtoint i8* %addr to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %addr_i64, %base_i64
  br label %loop

loop:
  %cur = phi i8* [ %firstsec2, %load_sizes ], [ %next, %loop_next ]
  %done = icmp eq i8* %cur, %endsec
  br i1 %done, label %not_found, label %process

process:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_next, label %check_upper

check_upper:
  %vs_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 4
  %vs64 = zext i32 %vs to i64
  %va_plus_vs = add i64 %va64, %vs64
  %rva_lt_end = icmp ult i64 %rva, %va_plus_vs
  br i1 %rva_lt_end, label %found, label %loop_next

loop_next:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

not_found:
  ret i32 0

found:
  %ch_ptr_i8 = getelementptr i8, i8* %cur, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 4
  %msb2 = lshr i32 %ch, 31
  %res = xor i32 %msb2, 1
  ret i32 %res
}