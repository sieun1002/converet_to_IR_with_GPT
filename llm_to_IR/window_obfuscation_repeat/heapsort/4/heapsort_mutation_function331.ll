; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002820(i32 %index) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_is_null = icmp eq i8* %baseptr, null
  br i1 %base_is_null, label %ret_null, label %check_mz

check_mz:
  %mzp = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzp, align 1
  %mzok = icmp eq i16 %mz, 23117
  br i1 %mzok, label %check_pe_sig, label %ret_null

check_pe_sig:
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 1
  %lf64 = sext i32 %e_lfanew to i64
  %nthdr_ptr = getelementptr i8, i8* %baseptr, i64 %lf64
  %sig_ptr = bitcast i8* %nthdr_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %peok = icmp eq i32 %sig, 17744
  br i1 %peok, label %check_opt, label %ret_null

check_opt:
  %opt_magic_ptr8 = getelementptr i8, i8* %nthdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %read_import_rva, label %ret_null

read_import_rva:
  %imp_rva_ptr8 = getelementptr i8, i8* %nthdr_ptr, i64 144
  %imp_rva_ptr = bitcast i8* %imp_rva_ptr8 to i32*
  %imp_rva = load i32, i32* %imp_rva_ptr, align 1
  %imp_rva_zero = icmp eq i32 %imp_rva, 0
  br i1 %imp_rva_zero, label %ret_null, label %check_sections

check_sections:
  %numsec_ptr8 = getelementptr i8, i8* %nthdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_zero, label %ret_null, label %calc_sec_ptr

calc_sec_ptr:
  %szopt_ptr8 = getelementptr i8, i8* %nthdr_ptr, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr8 to i16*
  %szopt16 = load i16, i16* %szopt_ptr, align 1
  %szopt32 = zext i16 %szopt16 to i64
  %sect_base = getelementptr i8, i8* %nthdr_ptr, i64 24
  %sections = getelementptr i8, i8* %sect_base, i64 %szopt32
  %numsec64 = zext i16 %numsec to i64
  %bytes_sections = mul nuw i64 %numsec64, 40
  %sections_end = getelementptr i8, i8* %sections, i64 %bytes_sections
  %rva64 = zext i32 %imp_rva to i64
  br label %loop

loop:
  %cur = phi i8* [ %sections, %calc_sec_ptr ], [ %next, %loop_cont ]
  %va_ptr8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr8 to i32*
  %sec_va = load i32, i32* %va_ptr, align 1
  %sec_va64 = zext i32 %sec_va to i64
  %rva_ge_va = icmp uge i64 %rva64, %sec_va64
  br i1 %rva_ge_va, label %check_hi, label %loop_cont

check_hi:
  %vsize_ptr8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize to i64
  %end_va = add i64 %sec_va64, %vsize64
  %inrange = icmp ult i64 %rva64, %end_va
  br i1 %inrange, label %found_section, label %loop_cont

loop_cont:
  %next = getelementptr i8, i8* %cur, i64 40
  %continue = icmp ne i8* %next, %sections_end
  br i1 %continue, label %loop, label %ret_null

found_section:
  %impdir_ptr = getelementptr i8, i8* %baseptr, i64 %rva64
  br label %desc_loop

desc_loop:
  %curdesc = phi i8* [ %impdir_ptr, %found_section ], [ %nextdesc, %desc_iter ]
  %i = phi i32 [ %index, %found_section ], [ %i_next, %desc_iter ]
  %tm_ptr8 = getelementptr i8, i8* %curdesc, i64 4
  %tm_ptr = bitcast i8* %tm_ptr8 to i32*
  %tm = load i32, i32* %tm_ptr, align 1
  %tm_zero = icmp eq i32 %tm, 0
  br i1 %tm_zero, label %check_name_nonzero, label %check_index

check_name_nonzero:
  %name_rva_ptr8_a = getelementptr i8, i8* %curdesc, i64 12
  %name_rva_ptr_a = bitcast i8* %name_rva_ptr8_a to i32*
  %name_rva_a = load i32, i32* %name_rva_ptr_a, align 1
  %name_zero = icmp eq i32 %name_rva_a, 0
  br i1 %name_zero, label %ret_null, label %check_index

check_index:
  %i_pos = icmp sgt i32 %i, 0
  br i1 %i_pos, label %desc_iter, label %return_name

desc_iter:
  %i_next = add nsw i32 %i, -1
  %nextdesc = getelementptr i8, i8* %curdesc, i64 20
  br label %desc_loop

return_name:
  %name_rva_ptr8 = getelementptr i8, i8* %curdesc, i64 12
  %name_rva_ptr = bitcast i8* %name_rva_ptr8 to i32*
  %name_rva = load i32, i32* %name_rva_ptr, align 1
  %name_rva64 = zext i32 %name_rva to i64
  %name_ptr = getelementptr i8, i8* %baseptr, i64 %name_rva64
  ret i8* %name_ptr

ret_null:
  ret i8* null
}