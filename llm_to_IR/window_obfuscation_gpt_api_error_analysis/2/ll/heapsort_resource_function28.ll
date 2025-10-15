; ModuleID = 'sub_140002520'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %image, i64 %rva) nounwind readonly {
entry:
  %e_lfanew.ptr = getelementptr i8, i8* %image, i64 60
  %e_lfanew.i32.ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.i32.ptr, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt = getelementptr i8, i8* %image, i64 %e_lfanew.i64
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec.i16 = load i16, i16* %numsec.ptr, align 1
  %numsec.iszero = icmp eq i16 %numsec.i16, 0
  br i1 %numsec.iszero, label %ret_zero, label %has_sections

has_sections:
  %soh.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh.i16 = load i16, i16* %soh.ptr, align 1
  %soh.i64 = zext i16 %soh.i16 to i64
  %hdr.offset = add i64 %soh.i64, 24
  %sec0 = getelementptr i8, i8* %nt, i64 %hdr.offset
  %numsec.i64 = zext i16 %numsec.i16 to i64
  %total.bytes = mul i64 %numsec.i64, 40
  %endptr = getelementptr i8, i8* %sec0, i64 %total.bytes
  br label %loop

loop:
  %cur = phi i8* [ %sec0, %has_sections ], [ %next, %nextblk ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr, align 1
  %va.i64 = zext i32 %va.i32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va.i64
  br i1 %rva_lt_va, label %nextblk, label %check_end

check_end:
  %vs.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs.i32 = load i32, i32* %vs.ptr, align 1
  %endva.i32 = add i32 %va.i32, %vs.i32
  %endva.i64 = zext i32 %endva.i32 to i64
  %rva_lt_end = icmp ult i64 %rva, %endva.i64
  br i1 %rva_lt_end, label %ret_cur, label %nextblk

nextblk:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret_zero, label %loop

ret_zero:
  ret i8* null

ret_cur:
  ret i8* %cur
}