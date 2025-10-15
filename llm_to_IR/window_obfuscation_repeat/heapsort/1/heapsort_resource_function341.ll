; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* noundef %addr) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.i16, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.i32ptr, align 4
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.i64
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt.magic.ptr.byte = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.byte to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 2
  %is_pe32p = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32p, label %load_counts, label %ret0

load_counts:
  %numsec.ptr.byte = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.byte to i16*
  %numsec.i16 = load i16, i16* %numsec.ptr, align 2
  %has_sections = icmp ne i16 %numsec.i16, 0
  br i1 %has_sections, label %prep_sections, label %ret0

prep_sections:
  %soh.ptr.byte = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.byte to i16*
  %soh.i16 = load i16, i16* %soh.ptr, align 2
  %soh.i64 = zext i16 %soh.i16 to i64
  %sec.start.pre = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %sec.start = getelementptr inbounds i8, i8* %sec.start.pre, i64 %soh.i64
  %numsec.i32 = zext i16 %numsec.i16 to i32
  %numsec.i64 = zext i32 %numsec.i32 to i64
  %secs.size = mul i64 %numsec.i64, 40
  %sec.end = getelementptr inbounds i8, i8* %sec.start, i64 %secs.size
  %addr.i64 = ptrtoint i8* %addr to i64
  %base.i64 = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.i64, %base.i64
  br label %loop

loop:
  %cur = phi i8* [ %sec.start, %prep_sections ], [ %next, %loop_next ]
  %at_end = icmp eq i8* %cur, %sec.end
  br i1 %at_end, label %ret0, label %check_section

check_section:
  %va.ptr.byte = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.byte to i32*
  %va.i32 = load i32, i32* %va.ptr, align 4
  %va.i64 = zext i32 %va.i32 to i64
  %before_section = icmp ult i64 %rva, %va.i64
  br i1 %before_section, label %loop_next, label %check_within

check_within:
  %vs.ptr.byte = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.byte to i32*
  %vs.i32 = load i32, i32* %vs.ptr, align 4
  %vs.i64 = zext i32 %vs.i32 to i64
  %endva = add i64 %va.i64, %vs.i64
  %in_section = icmp ult i64 %rva, %endva
  br i1 %in_section, label %found, label %loop_next

loop_next:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

found:
  %chars.ptr.byte = getelementptr inbounds i8, i8* %cur, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.byte to i32*
  %chars = load i32, i32* %chars.ptr, align 4
  %inv = xor i32 %chars, -1
  %res = lshr i32 %inv, 31
  ret i32 %res

ret0:
  ret i32 0
}