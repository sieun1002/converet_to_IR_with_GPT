target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002460(i32 %ecx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mzok = icmp eq i16 %mz, 23117
  br i1 %mzok, label %check_pe, label %ret0

check_pe:
  %lfanewptr.i8 = getelementptr i8, i8* %baseptr, i64 60
  %lfanewptr = bitcast i8* %lfanewptr.i8 to i32*
  %lfanew32 = load i32, i32* %lfanewptr, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %lfanew64
  %pesigptr = bitcast i8* %nthdr to i32*
  %pesig = load i32, i32* %pesigptr, align 1
  %peok = icmp eq i32 %pesig, 17744
  br i1 %peok, label %check_optmagic, label %ret0

check_optmagic:
  %magicptr.i8 = getelementptr i8, i8* %nthdr, i64 24
  %magicptr = bitcast i8* %magicptr.i8 to i16*
  %magic16 = load i16, i16* %magicptr, align 1
  %ismagic = icmp eq i16 %magic16, 523
  br i1 %ismagic, label %load_import_rva, label %ret0

load_import_rva:
  %impdirptr.i8 = getelementptr i8, i8* %nthdr, i64 144
  %impdirptr = bitcast i8* %impdirptr.i8 to i32*
  %impRva32 = load i32, i32* %impdirptr, align 1
  %impRvaZero = icmp eq i32 %impRva32, 0
  br i1 %impRvaZero, label %ret0, label %check_sections

check_sections:
  %numsecptr.i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsecptr = bitcast i8* %numsecptr.i8 to i16*
  %numsec16 = load i16, i16* %numsecptr, align 1
  %numsecZero = icmp eq i16 %numsec16, 0
  br i1 %numsecZero, label %ret0, label %prep_sections

prep_sections:
  %sohptr.i8 = getelementptr i8, i8* %nthdr, i64 20
  %sohptr = bitcast i8* %sohptr.i8 to i16*
  %soh16 = load i16, i16* %sohptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %optbase = getelementptr i8, i8* %nthdr, i64 24
  %firstsec = getelementptr i8, i8* %optbase, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %sections_size = mul i64 %numsec64, 40
  %endsec = getelementptr i8, i8* %firstsec, i64 %sections_size
  %rva64 = zext i32 %impRva32 to i64
  br label %sect_loop

sect_loop:
  %cursec = phi i8* [ %firstsec, %prep_sections ], [ %nextsec, %sect_advance ]
  %va_ptr_i8 = getelementptr i8, i8* %cursec, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %before = icmp ult i64 %rva64, %va64
  br i1 %before, label %sect_advance, label %sect_check_end

sect_check_end:
  %vsize_ptr_i8 = getelementptr i8, i8* %cursec, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %inrange = icmp ult i64 %rva64, %end64
  br i1 %inrange, label %found_section, label %sect_advance

sect_advance:
  %nextsec = getelementptr i8, i8* %cursec, i64 40
  %done = icmp eq i8* %nextsec, %endsec
  br i1 %done, label %ret0, label %sect_loop

found_section:
  %dirptr0 = getelementptr i8, i8* %baseptr, i64 %rva64
  br label %descriptor_loop

descriptor_loop:
  %dirptr = phi i8* [ %dirptr0, %found_section ], [ %nextdesc, %skip_desc ]
  %index = phi i32 [ %ecx, %found_section ], [ %dec, %skip_desc ]
  %tsptr.i8 = getelementptr i8, i8* %dirptr, i64 4
  %tsptr = bitcast i8* %tsptr.i8 to i32*
  %ts = load i32, i32* %tsptr, align 1
  %ts_nonzero = icmp ne i32 %ts, 0
  br i1 %ts_nonzero, label %after_zero_check, label %check_name_zero

check_name_zero:
  %name_rva_ptr_i8 = getelementptr i8, i8* %dirptr, i64 12
  %name_rva_ptr = bitcast i8* %name_rva_ptr_i8 to i32*
  %name_rva32_zchk = load i32, i32* %name_rva_ptr, align 1
  %name_is_zero = icmp eq i32 %name_rva32_zchk, 0
  br i1 %name_is_zero, label %ret0, label %after_zero_check

after_zero_check:
  %gt = icmp sgt i32 %index, 0
  br i1 %gt, label %skip_desc, label %return_name

skip_desc:
  %dec = add i32 %index, -1
  %nextdesc = getelementptr i8, i8* %dirptr, i64 20
  br label %descriptor_loop

return_name:
  %name_rva_ptr2_i8 = getelementptr i8, i8* %dirptr, i64 12
  %name_rva_ptr2 = bitcast i8* %name_rva_ptr2_i8 to i32*
  %name_rva32 = load i32, i32* %name_rva_ptr2, align 1
  %name_rva64 = zext i32 %name_rva32 to i64
  %name_va = getelementptr i8, i8* %baseptr, i64 %name_rva64
  ret i8* %name_va

ret0:
  ret i8* null
}