; ModuleID = 'pe_resolver'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002820(i32 %count, i64 %rva) local_unnamed_addr {
entry:
  %imgbase.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %imgbase.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_pe, label %ret_null

check_pe:                                         ; preds = %entry
  %lfanew.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 60
  %lfanew.p32 = bitcast i8* %lfanew.ptr to i32*
  %lfanew = load i32, i32* %lfanew.p32, align 1
  %lfanew.z = zext i32 %lfanew to i64
  %nthdr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %lfanew.z
  %pesig.p32 = bitcast i8* %nthdr to i32*
  %pesig = load i32, i32* %pesig.p32, align 1
  %pe.ok = icmp eq i32 %pesig, 17744
  br i1 %pe.ok, label %check_magic, label %ret_null

check_magic:                                      ; preds = %check_pe
  %magic.ptr = getelementptr inbounds i8, i8* %nthdr, i64 24
  %magic.p16 = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.p16, align 1
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %check_field90, label %ret_null

check_field90:                                    ; preds = %check_magic
  %f90.ptr = getelementptr inbounds i8, i8* %nthdr, i64 144
  %f90.p32 = bitcast i8* %f90.ptr to i32*
  %f90 = load i32, i32* %f90.p32, align 1
  %f90.zero = icmp eq i32 %f90, 0
  br i1 %f90.zero, label %ret_null, label %get_num_sec

get_num_sec:                                      ; preds = %check_field90
  %nosec.ptr = getelementptr inbounds i8, i8* %nthdr, i64 6
  %nosec.p16 = bitcast i8* %nosec.ptr to i16*
  %nosec = load i16, i16* %nosec.p16, align 1
  %has.sections = icmp ne i16 %nosec, 0
  br i1 %has.sections, label %calc_first_section, label %ret_null

calc_first_section:                               ; preds = %get_num_sec
  %soh.ptr = getelementptr inbounds i8, i8* %nthdr, i64 20
  %soh.p16 = bitcast i8* %soh.ptr to i16*
  %soh = load i16, i16* %soh.p16, align 1
  %soh.z = zext i16 %soh to i64
  %tmp.sec = getelementptr inbounds i8, i8* %nthdr, i64 24
  %sec.first = getelementptr inbounds i8, i8* %tmp.sec, i64 %soh.z
  %nosec.z64 = zext i16 %nosec to i64
  %span = mul i64 %nosec.z64, 40
  %sec.end = getelementptr inbounds i8, i8* %sec.first, i64 %span
  br label %sec.loop

sec.loop:                                         ; preds = %sec.advance, %calc_first_section
  %sec.cur = phi i8* [ %sec.first, %calc_first_section ], [ %sec.next, %sec.advance ]
  %at.end = icmp eq i8* %sec.cur, %sec.end
  br i1 %at.end, label %ret_null, label %sec.check

sec.check:                                        ; preds = %sec.loop
  %va.ptr = getelementptr inbounds i8, i8* %sec.cur, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va = load i32, i32* %va.p32, align 1
  %va.z = zext i32 %va to i64
  %rva.lt.start = icmp ult i64 %rva, %va.z
  br i1 %rva.lt.start, label %sec.advance, label %sec.maybe

sec.maybe:                                        ; preds = %sec.check
  %vs.ptr = getelementptr inbounds i8, i8* %sec.cur, i64 8
  %vs.p32 = bitcast i8* %vs.ptr to i32*
  %vs = load i32, i32* %vs.p32, align 1
  %vs.z = zext i32 %vs to i64
  %end = add i64 %va.z, %vs.z
  %rva.in = icmp ult i64 %rva, %end
  br i1 %rva.in, label %found.in.section, label %sec.advance

sec.advance:                                      ; preds = %sec.maybe, %sec.check
  %sec.next = getelementptr inbounds i8, i8* %sec.cur, i64 40
  br label %sec.loop

found.in.section:                                 ; preds = %sec.maybe
  %rva.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %rva
  br label %imp.loop

imp.loop:                                         ; preds = %imp.dec, %found.in.section
  %cur.imp = phi i8* [ %rva.ptr, %found.in.section ], [ %cur.next, %imp.dec ]
  %ecx.phi = phi i32 [ %count, %found.in.section ], [ %ecx.next, %imp.dec ]
  %fld4.ptr = getelementptr inbounds i8, i8* %cur.imp, i64 4
  %fld4.p32 = bitcast i8* %fld4.ptr to i32*
  %fld4 = load i32, i32* %fld4.p32, align 1
  %fld4.is.zero = icmp eq i32 %fld4, 0
  br i1 %fld4.is.zero, label %imp.check.name, label %imp.cont

imp.check.name:                                   ; preds = %imp.loop
  %namechk.ptr = getelementptr inbounds i8, i8* %cur.imp, i64 12
  %namechk.p32 = bitcast i8* %namechk.ptr to i32*
  %namechk = load i32, i32* %namechk.p32, align 1
  %name.is.zero = icmp eq i32 %namechk, 0
  br i1 %name.is.zero, label %ret_null, label %imp.cont

imp.cont:                                         ; preds = %imp.check.name, %imp.loop
  %ecx.pos = icmp sgt i32 %ecx.phi, 0
  br i1 %ecx.pos, label %imp.dec, label %imp.finalize

imp.dec:                                          ; preds = %imp.cont
  %ecx.next = add i32 %ecx.phi, -1
  %cur.next = getelementptr inbounds i8, i8* %cur.imp, i64 20
  br label %imp.loop

imp.finalize:                                     ; preds = %imp.cont
  %name.ptr = getelementptr inbounds i8, i8* %cur.imp, i64 12
  %name.p32 = bitcast i8* %name.ptr to i32*
  %name = load i32, i32* %name.p32, align 1
  %name.z = zext i32 %name to i64
  %ret.ptr = getelementptr inbounds i8, i8* %imgbase.ptr, i64 %name.z
  ret i8* %ret.ptr

ret_null:                                         ; preds = %imp.check.name, %sec.loop, %get_num_sec, %check_field90, %check_magic, %check_pe, %entry
  ret i8* null
}