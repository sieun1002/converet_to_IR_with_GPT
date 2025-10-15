; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002610(i8* %arg) {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pecheck, label %ret_zero

pecheck:
  %lfaptr = getelementptr i8, i8* %base_ptr, i64 60
  %lfaptr32 = bitcast i8* %lfaptr to i32*
  %lfa = load i32, i32* %lfaptr32, align 1
  %lfa64 = sext i32 %lfa to i64
  %pehdr = getelementptr i8, i8* %base_ptr, i64 %lfa64
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %optcheck, label %ret_zero

optcheck:
  %magicptr = getelementptr i8, i8* %pehdr, i64 24
  %magic16p = bitcast i8* %magicptr to i16*
  %magic = load i16, i16* %magic16p, align 1
  %is_64 = icmp eq i16 %magic, 523
  br i1 %is_64, label %secinfo, label %ret_zero

secinfo:
  %numsecptr = getelementptr i8, i8* %pehdr, i64 6
  %numsec16p = bitcast i8* %numsecptr to i16*
  %numsec16 = load i16, i16* %numsec16p, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_zero, label %cont1

cont1:
  %sohptr = getelementptr i8, i8* %pehdr, i64 20
  %soh16p = bitcast i8* %sohptr to i16*
  %soh16 = load i16, i16* %soh16p, align 1
  %soh64 = zext i16 %soh16 to i64
  %firstSecBase = getelementptr i8, i8* %pehdr, i64 24
  %firstSec = getelementptr i8, i8* %firstSecBase, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %endOff = mul i64 %numsec64, 40
  %endPtr = getelementptr i8, i8* %firstSec, i64 %endOff
  %arg_int = ptrtoint i8* %arg to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %arg_int, %base_int
  br label %loop

loop:
  %cur = phi i8* [ %firstSec, %cont1 ], [ %next, %inc ]
  %vaptr = getelementptr i8, i8* %cur, i64 12
  %va32p = bitcast i8* %vaptr to i32*
  %va32 = load i32, i32* %va32p, align 1
  %va64 = zext i32 %va32 to i64
  %cmp_lower = icmp ult i64 %rva, %va64
  br i1 %cmp_lower, label %inc, label %check_in

check_in:
  %vsizeptr = getelementptr i8, i8* %cur, i64 8
  %vsize32p = bitcast i8* %vsizeptr to i32*
  %vsize32 = load i32, i32* %vsize32p, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %va_plus_size = add i64 %va64, %vsize64
  %inrange = icmp ult i64 %rva, %va_plus_size
  br i1 %inrange, label %found, label %inc

found:
  ret i8* %cur

inc:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endPtr
  br i1 %done, label %ret_zero2, label %loop

ret_zero:
  ret i8* null

ret_zero2:
  ret i8* null
}