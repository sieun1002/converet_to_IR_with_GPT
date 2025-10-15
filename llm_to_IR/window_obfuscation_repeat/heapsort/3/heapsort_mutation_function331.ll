; ModuleID = 'pe_import_name_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002820(i32 %index) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.z
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret_null

check_opt_magic:
  %opt.magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_64 = icmp eq i16 %opt.magic, 523
  br i1 %is_64, label %load_import_rva, label %ret_null

load_import_rva:
  %import.rva.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 144
  %import.rva.ptr = bitcast i8* %import.rva.ptr.i8 to i32*
  %import.rva = load i32, i32* %import.rva.ptr, align 1
  %has_import = icmp ne i32 %import.rva, 0
  br i1 %has_import, label %load_sections, label %ret_null

load_sections:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %has_secs = icmp ne i16 %numsec, 0
  br i1 %has_secs, label %calc_sec_bounds, label %ret_null

calc_sec_bounds:
  %opt.size.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %opt.size.ptr = bitcast i8* %opt.size.ptr.i8 to i16*
  %opt.size = load i16, i16* %opt.size.ptr, align 1
  %opt.size.z64 = zext i16 %opt.size to i64
  %first.sec.hdr = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %first.sec.hdr2 = getelementptr inbounds i8, i8* %first.sec.hdr, i64 %opt.size.z64
  %numsec.z64 = zext i16 %numsec to i64
  %sec.table.size = mul i64 %numsec.z64, 40
  %end.sec = getelementptr inbounds i8, i8* %first.sec.hdr2, i64 %sec.table.size
  %import.rva.z64 = zext i32 %import.rva to i64
  br label %sec.loop

sec.loop:
  %sec.cur = phi i8* [ %first.sec.hdr2, %calc_sec_bounds ], [ %sec.next, %sec.next.block ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %sec.cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %sec.va.i32 = load i32, i32* %va.ptr, align 1
  %sec.va = zext i32 %sec.va.i32 to i64
  %rva.lt.va = icmp ult i64 %import.rva.z64, %sec.va
  br i1 %rva.lt.va, label %sec.next.block, label %check.in.range

check.in.range:
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %sec.cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %sec.vsize.i32 = load i32, i32* %vsize.ptr, align 1
  %sec.vsize = zext i32 %sec.vsize.i32 to i64
  %sec.end = add i64 %sec.va, %sec.vsize
  %rva.lt.end = icmp ult i64 %import.rva.z64, %sec.end
  br i1 %rva.lt.end, label %found.section, label %sec.next.block

sec.next.block:
  %sec.next = getelementptr inbounds i8, i8* %sec.cur, i64 40
  %done.sections = icmp eq i8* %sec.next, %end.sec
  br i1 %done.sections, label %ret_null, label %sec.loop

found.section:
  %desc.base = getelementptr inbounds i8, i8* %base.ptr, i64 %import.rva.z64
  br label %desc.loop

desc.loop:
  %idx.cur = phi i32 [ %index, %found.section ], [ %idx.next, %step.desc ]
  %desc.cur = phi i8* [ %desc.base, %found.section ], [ %desc.next, %step.desc ]
  %tdstamp.ptr.i8 = getelementptr inbounds i8, i8* %desc.cur, i64 4
  %tdstamp.ptr = bitcast i8* %tdstamp.ptr.i8 to i32*
  %tdstamp = load i32, i32* %tdstamp.ptr, align 1
  %td.nonzero = icmp ne i32 %tdstamp, 0
  br i1 %td.nonzero, label %after.termcheck, label %term.check.name

term.check.name:
  %name.rva.term.ptr.i8 = getelementptr inbounds i8, i8* %desc.cur, i64 12
  %name.rva.term.ptr = bitcast i8* %name.rva.term.ptr.i8 to i32*
  %name.rva.term = load i32, i32* %name.rva.term.ptr, align 1
  %name.zero = icmp eq i32 %name.rva.term, 0
  br i1 %name.zero, label %ret_null, label %after.termcheck

after.termcheck:
  %idx.pos = icmp sgt i32 %idx.cur, 0
  br i1 %idx.pos, label %step.desc, label %return.name

step.desc:
  %idx.next = add nsw i32 %idx.cur, -1
  %desc.next = getelementptr inbounds i8, i8* %desc.cur, i64 20
  br label %desc.loop

return.name:
  %name.rva.ptr.i8 = getelementptr inbounds i8, i8* %desc.cur, i64 12
  %name.rva.ptr = bitcast i8* %name.rva.ptr.i8 to i32*
  %name.rva = load i32, i32* %name.rva.ptr, align 1
  %name.rva.z64 = zext i32 %name.rva to i64
  %name.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %name.rva.z64
  ret i8* %name.ptr

ret_null:
  ret i8* null
}