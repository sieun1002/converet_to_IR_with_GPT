; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %count) local_unnamed_addr nounwind {
entry:
  %base.ptrptr = load i8*, i8** @off_1400043A0
  %mz.ptr = bitcast i8* %base.ptrptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %mz_ok, label %ret_null

mz_ok:
  %e_lfanew.p = getelementptr i8, i8* %base.ptrptr, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.p to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p32, align 4
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base.ptrptr, i64 %e_lfanew.z
  %nt.sig.p32 = bitcast i8* %nt to i32*
  %nt.sig = load i32, i32* %nt.sig.p32, align 4
  %is.pe = icmp eq i32 %nt.sig, 17744
  br i1 %is.pe, label %pe_ok, label %ret_null

pe_ok:
  %opt.magic.p = getelementptr i8, i8* %nt, i64 24
  %opt.magic.p16 = bitcast i8* %opt.magic.p to i16*
  %opt.magic = load i16, i16* %opt.magic.p16, align 2
  %is.pe32p = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32p, label %opt_ok, label %ret_null

opt_ok:
  %dir4.p = getelementptr i8, i8* %nt, i64 144
  %dir4.p32 = bitcast i8* %dir4.p to i32*
  %dir4.va = load i32, i32* %dir4.p32, align 4
  %dir4.nz = icmp ne i32 %dir4.va, 0
  br i1 %dir4.nz, label %dir_ok, label %ret_null

dir_ok:
  %numsec.p = getelementptr i8, i8* %nt, i64 6
  %numsec.p16 = bitcast i8* %numsec.p to i16*
  %numsec = load i16, i16* %numsec.p16, align 2
  %numsec.zero = icmp eq i16 %numsec, 0
  br i1 %numsec.zero, label %ret_null, label %have_numsec

have_numsec:
  %soh.p = getelementptr i8, i8* %nt, i64 20
  %soh.p16 = bitcast i8* %soh.p to i16*
  %soh = load i16, i16* %soh.p16, align 2
  %soh.z = zext i16 %soh to i64
  %firstsec.pre = getelementptr i8, i8* %nt, i64 24
  %firstsec = getelementptr i8, i8* %firstsec.pre, i64 %soh.z
  %numsec.z = zext i16 %numsec to i64
  %secs.bytes = mul nuw nsw i64 %numsec.z, 40
  %endsec = getelementptr i8, i8* %firstsec, i64 %secs.bytes
  br label %sec_loop

sec_loop:
  %sec.cur = phi i8* [ %firstsec, %have_numsec ], [ %sec.next, %sec_next ]
  %va.p = getelementptr i8, i8* %sec.cur, i64 12
  %va.p32 = bitcast i8* %va.p to i32*
  %va32 = load i32, i32* %va.p32, align 4
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %sec_next, label %check_size

check_size:
  %vsize.p = getelementptr i8, i8* %sec.cur, i64 8
  %vsize.p32 = bitcast i8* %vsize.p to i32*
  %vsize32 = load i32, i32* %vsize.p32, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %va.end = add i64 %va64, %vsize64
  %in.range = icmp ult i64 %rva, %va.end
  br i1 %in.range, label %section_found, label %sec_next

sec_next:
  %sec.next = getelementptr i8, i8* %sec.cur, i64 40
  %done = icmp eq i8* %sec.next, %endsec
  br i1 %done, label %ret_null, label %sec_loop

section_found:
  %entry.base = getelementptr i8, i8* %base.ptrptr, i64 %rva
  br label %entry_loop

entry_loop:
  %ptr.cur = phi i8* [ %entry.base, %section_found ], [ %ptr.next, %entry_iter ]
  %count.cur = phi i32 [ %count, %section_found ], [ %count.dec, %entry_iter ]
  %fld4.p = getelementptr i8, i8* %ptr.cur, i64 4
  %fld4.p32 = bitcast i8* %fld4.p to i32*
  %fld4 = load i32, i32* %fld4.p32, align 4
  %fldC.p = getelementptr i8, i8* %ptr.cur, i64 12
  %fldC.p32 = bitcast i8* %fldC.p to i32*
  %fld4.nz = icmp ne i32 %fld4, 0
  br i1 %fld4.nz, label %check_count, label %check_terminator

check_terminator:
  %fldC.term = load i32, i32* %fldC.p32, align 4
  %fldC.zero = icmp eq i32 %fldC.term, 0
  br i1 %fldC.zero, label %ret_null, label %check_count

check_count:
  %count.pos = icmp sgt i32 %count.cur, 0
  br i1 %count.pos, label %entry_iter, label %return_success

entry_iter:
  %count.dec = add nsw i32 %count.cur, -1
  %ptr.next = getelementptr i8, i8* %ptr.cur, i64 20
  br label %entry_loop

return_success:
  %ret.rva32 = load i32, i32* %fldC.p32, align 4
  %ret.rva64 = zext i32 %ret.rva32 to i64
  %ret.ptr = getelementptr i8, i8* %base.ptrptr, i64 %ret.rva64
  ret i8* %ret.ptr

ret_null:
  ret i8* null
}