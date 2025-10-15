; ModuleID = 'fixed_pe_utils'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002820(i32 %rva, i32 %count) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew64
  %pe.sig.ptr = bitcast i8* %nt to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret_null

check_opt_magic:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_field90, label %ret_null

check_field90:
  %field90.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 144
  %field90.ptr = bitcast i8* %field90.ptr.i8 to i32*
  %field90 = load i32, i32* %field90.ptr, align 1
  %field90.nz = icmp ne i32 %field90, 0
  br i1 %field90.nz, label %check_num_sections, label %ret_null

check_num_sections:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %has_sections = icmp ne i16 %numsec16, 0
  br i1 %has_sections, label %prep_sections, label %ret_null

prep_sections:
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %sect.start.base = getelementptr inbounds i8, i8* %nt, i64 24
  %sect.start = getelementptr inbounds i8, i8* %sect.start.base, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %total.size = mul i64 %numsec64, 40
  %sect.end = getelementptr inbounds i8, i8* %sect.start, i64 %total.size
  br label %section_loop

section_loop:
  %cur.sect = phi i8* [ %sect.start, %prep_sections ], [ %next.sect, %section_next ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur.sect, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 1
  %vs.ptr.i8 = getelementptr inbounds i8, i8* %cur.sect, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs = load i32, i32* %vs.ptr, align 1
  %rva_ge_va = icmp uge i32 %rva, %va
  br i1 %rva_ge_va, label %check_upper, label %section_next

check_upper:
  %va_plus_vs = add i32 %va, %vs
  %rva_lt_end = icmp ult i32 %rva, %va_plus_vs
  br i1 %rva_lt_end, label %found_section, label %section_next

section_next:
  %next.sect = getelementptr inbounds i8, i8* %cur.sect, i64 40
  %done.sections = icmp eq i8* %next.sect, %sect.end
  br i1 %done.sections, label %ret_null, label %section_loop

found_section:
  %rva64 = zext i32 %rva to i64
  %imp.desc.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %rva64
  br label %desc_loop

desc_loop:
  %cur.desc = phi i8* [ %imp.desc.ptr, %found_section ], [ %next.desc, %desc_iter ]
  %cnt = phi i32 [ %count, %found_section ], [ %cnt.next, %desc_iter ]
  %ts.ptr.i8 = getelementptr inbounds i8, i8* %cur.desc, i64 4
  %ts.ptr = bitcast i8* %ts.ptr.i8 to i32*
  %timestamp = load i32, i32* %ts.ptr, align 1
  %ts.nz = icmp ne i32 %timestamp, 0
  br i1 %ts.nz, label %check_count, label %check_name_for_zero

check_name_for_zero:
  %name.ptr.i8.chk = getelementptr inbounds i8, i8* %cur.desc, i64 12
  %name.ptr.chk = bitcast i8* %name.ptr.i8.chk to i32*
  %name.rva.chk = load i32, i32* %name.ptr.chk, align 1
  %name.is.zero = icmp eq i32 %name.rva.chk, 0
  br i1 %name.is.zero, label %ret_null, label %check_count

check_count:
  %cnt.pos = icmp sgt i32 %cnt, 0
  br i1 %cnt.pos, label %desc_iter, label %final_name

desc_iter:
  %cnt.next = add nsw i32 %cnt, -1
  %next.desc = getelementptr inbounds i8, i8* %cur.desc, i64 20
  br label %desc_loop

final_name:
  %name.ptr.i8 = getelementptr inbounds i8, i8* %cur.desc, i64 12
  %name.ptr = bitcast i8* %name.ptr.i8 to i32*
  %name.rva = load i32, i32* %name.ptr, align 1
  %name.rva64 = zext i32 %name.rva to i64
  %name.abs = getelementptr inbounds i8, i8* %base.ptr, i64 %name.rva64
  ret i8* %name.abs

ret_null:
  ret i8* null
}