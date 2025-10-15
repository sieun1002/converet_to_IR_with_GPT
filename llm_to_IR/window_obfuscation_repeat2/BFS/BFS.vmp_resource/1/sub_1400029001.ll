; ModuleID = 'pe_helper'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002900(i32 %ecx) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %dos_magic.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 0
  %dos_magic.ptr = bitcast i8* %dos_magic.ptr.i8 to i16*
  %dos_magic = load i16, i16* %dos_magic.ptr, align 1
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %check_nt, label %ret_null

check_nt:                                         ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe_sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe_sig = load i32, i32* %pe_sig.ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_null

check_optmagic:                                   ; preds = %check_nt
  %opt_magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %opt_magic.ptr = bitcast i8* %opt_magic.ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic.ptr, align 1
  %is_pe64 = icmp eq i16 %opt_magic, 523
  br i1 %is_pe64, label %get_dir_rva, label %ret_null

get_dir_rva:                                      ; preds = %check_optmagic
  %dir_rva.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 144
  %dir_rva.ptr = bitcast i8* %dir_rva.ptr.i8 to i32*
  %dir_rva = load i32, i32* %dir_rva.ptr, align 1
  %dir_is_zero = icmp eq i32 %dir_rva, 0
  br i1 %dir_is_zero, label %ret_null, label %get_numsections

get_numsections:                                  ; preds = %get_dir_rva
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_null, label %calc_sect_base

calc_sect_base:                                   ; preds = %get_numsections
  %sizeofopt.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %sizeofopt.ptr = bitcast i8* %sizeofopt.ptr.i8 to i16*
  %sizeofopt = load i16, i16* %sizeofopt.ptr, align 1
  %sizeofopt.z = zext i16 %sizeofopt to i64
  %sectbase.off = add i64 %sizeofopt.z, 24
  %sect.base = getelementptr inbounds i8, i8* %nt.ptr, i64 %sectbase.off
  %numsec.z32 = zext i16 %numsec to i32
  %nminus1 = add i32 %numsec.z32, -1
  %times5 = mul i32 %nminus1, 5
  %times5.z64 = zext i32 %times5 to i64
  %bytes = mul i64 %times5.z64, 8
  %end.pre = getelementptr inbounds i8, i8* %sect.base, i64 %bytes
  %end.ptr = getelementptr inbounds i8, i8* %end.pre, i64 40
  %rva64 = zext i32 %dir_rva to i64
  br label %section_loop

section_loop:                                     ; preds = %section_next, %calc_sect_base
  %rdx.cur = phi i8* [ %sect.base, %calc_sect_base ], [ %next.rdx, %section_next ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %rdx.cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 1
  %va.z = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva64, %va.z
  br i1 %rva.lt.va, label %section_next, label %check_in_section

section_next:                                     ; preds = %section_loop, %check_in_section
  %next.rdx = getelementptr inbounds i8, i8* %rdx.cur, i64 40
  %cont = icmp ne i8* %end.ptr, %next.rdx
  br i1 %cont, label %section_loop, label %ret_null

check_in_section:                                 ; preds = %section_loop
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %rdx.cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize = load i32, i32* %vsize.ptr, align 1
  %sum.va.vs = add i32 %va, %vsize
  %sum.va.vs.z = zext i32 %sum.va.vs to i64
  %in.sec = icmp ult i64 %rva64, %sum.va.vs.z
  br i1 %in.sec, label %found_section, label %section_next

found_section:                                    ; preds = %check_in_section
  %desc.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %rva64
  br label %desc_loop

desc_loop:                                        ; preds = %desc_advance, %found_section
  %cur.desc = phi i8* [ %desc.ptr, %found_section ], [ %new.desc, %desc_advance ]
  %rem.ecx = phi i32 [ %ecx, %found_section ], [ %new.rem, %desc_advance ]
  %tds.ptr.i8 = getelementptr inbounds i8, i8* %cur.desc, i64 4
  %tds.ptr = bitcast i8* %tds.ptr.i8 to i32*
  %tds = load i32, i32* %tds.ptr, align 1
  %tds.is.zero = icmp eq i32 %tds, 0
  br i1 %tds.is.zero, label %maybe_name_zero, label %after_name_check

maybe_name_zero:                                  ; preds = %desc_loop
  %name.rva.loc.i8 = getelementptr inbounds i8, i8* %cur.desc, i64 12
  %name.rva.loc = bitcast i8* %name.rva.loc.i8 to i32*
  %name.rva.a = load i32, i32* %name.rva.loc, align 1
  %name.zero = icmp eq i32 %name.rva.a, 0
  br i1 %name.zero, label %ret_null, label %after_name_check

after_name_check:                                 ; preds = %maybe_name_zero, %desc_loop
  %cur.desc2 = phi i8* [ %cur.desc, %desc_loop ], [ %cur.desc, %maybe_name_zero ]
  %rem.ecx2 = phi i32 [ %rem.ecx, %desc_loop ], [ %rem.ecx, %maybe_name_zero ]
  %gt.zero = icmp sgt i32 %rem.ecx2, 0
  br i1 %gt.zero, label %desc_advance, label %ret_name

desc_advance:                                     ; preds = %after_name_check
  %new.rem = add i32 %rem.ecx2, -1
  %new.desc = getelementptr inbounds i8, i8* %cur.desc2, i64 20
  br label %desc_loop

ret_name:                                         ; preds = %after_name_check
  %name.rva.loc2.i8 = getelementptr inbounds i8, i8* %cur.desc2, i64 12
  %name.rva.loc2 = bitcast i8* %name.rva.loc2.i8 to i32*
  %name.rva.b = load i32, i32* %name.rva.loc2, align 1
  %name.rva.b.z = zext i32 %name.rva.b to i64
  %name.addr = getelementptr inbounds i8, i8* %base.ptr, i64 %name.rva.b.z
  ret i8* %name.addr

ret_null:                                         ; preds = %maybe_name_zero, %section_next, %get_numsections, %get_dir_rva, %check_optmagic, %check_nt, %entry
  ret i8* null
}