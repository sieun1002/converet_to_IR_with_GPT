; ModuleID = 'fixed_pe_helper'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %idx) nounwind {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %chk_pe, label %ret_null

chk_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew64
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %chk_magic, label %ret_null

chk_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %chk_exports, label %ret_null

chk_exports:
  %expdir.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 144
  %expdir.ptr = bitcast i8* %expdir.ptr.i8 to i32*
  %expdir = load i32, i32* %expdir.ptr, align 1
  %has_expdir = icmp ne i32 %expdir, 0
  br i1 %has_expdir, label %chk_sections, label %ret_null

chk_sections:
  %nsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr.i8 to i16*
  %nsec16 = load i16, i16* %nsec.ptr, align 1
  %has_sections = icmp ne i16 %nsec16, 0
  br i1 %has_sections, label %calc_first_sec, label %ret_null

calc_first_sec:
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %first_sec.base = getelementptr i8, i8* %nt.ptr, i64 24
  %first_sec = getelementptr i8, i8* %first_sec.base, i64 %soh64
  %nsec64 = zext i16 %nsec16 to i64
  %nsec_minus1 = add i64 %nsec64, -1
  %bytes_last_offset = mul i64 %nsec_minus1, 40
  %last_sec_end.base = getelementptr i8, i8* %first_sec, i64 %bytes_last_offset
  %last_sec_end = getelementptr i8, i8* %last_sec_end.base, i64 40
  br label %sec_loop

sec_loop:
  %cur.sec = phi i8* [ %first_sec, %calc_first_sec ], [ %next.sec, %inc_sec ]
  %va.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %inc_sec, label %check_in_sec

check_in_sec:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %rva_in = icmp ult i64 %rva, %sum64
  br i1 %rva_in, label %found_sec, label %inc_sec

inc_sec:
  %next.sec = getelementptr i8, i8* %cur.sec, i64 40
  %more = icmp ne i8* %next.sec, %last_sec_end
  br i1 %more, label %sec_loop, label %ret_null

found_sec:
  %p_in_image = getelementptr i8, i8* %base.ptr, i64 %rva
  br label %entry_loop

entry_loop:
  %p.cur = phi i8* [ %p_in_image, %found_sec ], [ %p.next, %entry_step ]
  %idx.cur = phi i32 [ %idx, %found_sec ], [ %idx.dec, %entry_step ]
  %field4.ptr.i8 = getelementptr i8, i8* %p.cur, i64 4
  %field4.ptr = bitcast i8* %field4.ptr.i8 to i32*
  %field4 = load i32, i32* %field4.ptr, align 1
  %field4_is_zero = icmp eq i32 %field4, 0
  br i1 %field4_is_zero, label %check_fieldC, label %after_check_nonempty

check_fieldC:
  %fieldC.ptr.i8 = getelementptr i8, i8* %p.cur, i64 12
  %fieldC.ptr = bitcast i8* %fieldC.ptr.i8 to i32*
  %fieldC_val0 = load i32, i32* %fieldC.ptr, align 1
  %fieldC_zero = icmp eq i32 %fieldC_val0, 0
  br i1 %fieldC_zero, label %ret_null, label %after_check_nonempty

after_check_nonempty:
  %has_more = icmp sgt i32 %idx.cur, 0
  br i1 %has_more, label %entry_step, label %finalize

entry_step:
  %idx.dec = add i32 %idx.cur, -1
  %p.next = getelementptr i8, i8* %p.cur, i64 20
  br label %entry_loop

finalize:
  %fieldC.ptr2.i8 = getelementptr i8, i8* %p.cur, i64 12
  %fieldC.ptr2 = bitcast i8* %fieldC.ptr2.i8 to i32*
  %fieldC_val = load i32, i32* %fieldC.ptr2, align 1
  %fieldC64 = zext i32 %fieldC_val to i64
  %ret.ptr = getelementptr i8, i8* %base.ptr, i64 %fieldC64
  ret i8* %ret.ptr

ret_null:
  ret i8* null
}