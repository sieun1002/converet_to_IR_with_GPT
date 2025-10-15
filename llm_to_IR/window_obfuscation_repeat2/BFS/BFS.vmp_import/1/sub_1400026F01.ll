; ModuleID = 'pe_section_check'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i64 @sub_1400026F0(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %mz.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew32 = load i32, i32* %lfanew.ptr, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %pehdr = getelementptr i8, i8* %base.ptr, i64 %lfanew64
  %sig.ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %sig.ok = icmp eq i32 %sig, 17744
  br i1 %sig.ok, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %load_sections, label %ret0

load_sections:
  %numsec.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %calc_first_section

calc_first_section:
  %sizeoh.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %sizeoh.ptr = bitcast i8* %sizeoh.ptr.i8 to i16*
  %sizeoh16 = load i16, i16* %sizeoh.ptr, align 1
  %sizeoh64 = zext i16 %sizeoh16 to i64
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %numsec32 = zext i16 %numsec16 to i32
  %edx.minus1 = add i32 %numsec32, 4294967295
  %edx64 = zext i32 %edx.minus1 to i64
  %mul5 = mul i64 %edx64, 5
  %bytes40 = mul i64 %mul5, 8
  %first.base = getelementptr i8, i8* %pehdr, i64 24
  %first.section = getelementptr i8, i8* %first.base, i64 %sizeoh64
  %end.tmp = getelementptr i8, i8* %first.section, i64 %bytes40
  %end = getelementptr i8, i8* %end.tmp, i64 40
  br label %loop

loop:
  %curr = phi i8* [ %first.section, %calc_first_section ], [ %next, %advance ]
  %va.ptr.i8 = getelementptr i8, i8* %curr, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %advance, label %check_upper

check_upper:
  %vs.ptr.i8 = getelementptr i8, i8* %curr, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %rva.lt.upper = icmp ult i64 %rva, %sum64
  br i1 %rva.lt.upper, label %ret0, label %advance

advance:
  %next = getelementptr i8, i8* %curr, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %ret0, label %loop

ret0:
  ret i64 0
}