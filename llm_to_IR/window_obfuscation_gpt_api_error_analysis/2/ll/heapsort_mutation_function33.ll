; ModuleID = 'sub_140002820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002820(i64 %rva, i32 %index) local_unnamed_addr nounwind readonly {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe_sig, label %ret_null

check_pe_sig:
  %lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew32 = load i32, i32* %lfanew.ptr, align 4
  %lfanew = sext i32 %lfanew32 to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %lfanew
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_pe64, label %ret_null

check_pe64:
  %magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 2
  %is.pe64 = icmp eq i16 %magic, 523
  br i1 %is.pe64, label %check_opt_90, label %ret_null

check_opt_90:
  %opt90.ptr.i8 = getelementptr i8, i8* %nt, i64 144
  %opt90.ptr = bitcast i8* %opt90.ptr.i8 to i32*
  %opt90 = load i32, i32* %opt90.ptr, align 4
  %opt90.nz = icmp ne i32 %opt90, 0
  br i1 %opt90.nz, label %load_sections_info, label %ret_null

load_sections_info:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 2
  %numsec.iszero = icmp eq i16 %numsec16, 0
  br i1 %numsec.iszero, label %ret_null, label %calc_sect_bounds

calc_sect_bounds:
  %soh.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %sec.start.off = add i64 %soh64, 24
  %sec.start = getelementptr i8, i8* %nt, i64 %sec.start.off
  %numsec64 = zext i16 %numsec16 to i64
  %totbytes = mul i64 %numsec64, 40
  %sec.end = getelementptr i8, i8* %sec.start, i64 %totbytes
  br label %sect.loop

sect.loop:
  %cur = phi i8* [ %sec.start, %calc_sect_bounds ], [ %next.cur, %sect.advance ]
  %done = icmp eq i8* %cur, %sec.end
  br i1 %done, label %ret_null, label %sect.check

sect.check:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 4
  %vaddr.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %vaddr.ptr = bitcast i8* %vaddr.ptr.i8 to i32*
  %vaddr32 = load i32, i32* %vaddr.ptr, align 4
  %vaddr = zext i32 %vaddr32 to i64
  %rva.lt.vaddr = icmp ult i64 %rva, %vaddr
  br i1 %rva.lt.vaddr, label %sect.advance, label %sect.check.upper

sect.check.upper:
  %vsize = zext i32 %vsize32 to i64
  %vaddr.end = add i64 %vaddr, %vsize
  %rva.lt.end = icmp ult i64 %rva, %vaddr.end
  br i1 %rva.lt.end, label %found.section, label %sect.advance

sect.advance:
  %next.cur = getelementptr i8, i8* %cur, i64 40
  br label %sect.loop

found.section:
  %desc.ptr = getelementptr i8, i8* %base.ptr, i64 %rva
  br label %desc.loop

desc.loop:
  %desc.cur = phi i8* [ %desc.ptr, %found.section ], [ %desc.next, %desc.advance ]
  %idx.cur = phi i32 [ %index, %found.section ], [ %idx.next, %desc.advance ]
  %ts.ptr.i8 = getelementptr i8, i8* %desc.cur, i64 4
  %ts.ptr = bitcast i8* %ts.ptr.i8 to i32*
  %ts = load i32, i32* %ts.ptr, align 4
  %ts.zero = icmp eq i32 %ts, 0
  br i1 %ts.zero, label %check.term.name, label %check.index

check.term.name:
  %name.ptr.i8.t = getelementptr i8, i8* %desc.cur, i64 12
  %name.ptr.t = bitcast i8* %name.ptr.i8.t to i32*
  %name.rva.t = load i32, i32* %name.ptr.t, align 4
  %name.iszero.t = icmp eq i32 %name.rva.t, 0
  br i1 %name.iszero.t, label %ret_null, label %check.index

check.index:
  %idx.pos = icmp sgt i32 %idx.cur, 0
  br i1 %idx.pos, label %desc.advance, label %desc.return

desc.advance:
  %idx.next = add i32 %idx.cur, -1
  %desc.next = getelementptr i8, i8* %desc.cur, i64 20
  br label %desc.loop

desc.return:
  %name.ptr.i8 = getelementptr i8, i8* %desc.cur, i64 12
  %name.ptr = bitcast i8* %name.ptr.i8 to i32*
  %name.rva = load i32, i32* %name.ptr, align 4
  %name.rva64 = zext i32 %name.rva to i64
  %name.va = getelementptr i8, i8* %base.ptr, i64 %name.rva64
  ret i8* %name.va

ret_null:
  ret i8* null
}