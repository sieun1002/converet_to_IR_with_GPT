; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %p) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %base.as.i16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %base.as.i16, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:
  %p3c = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %p3c.i32p = bitcast i8* %p3c to i32*
  %e_lfanew = load i32, i32* %p3c.i32p, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %nt.i32p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %nt.i32p, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_optmagic, label %ret0

check_optmagic:
  %opt.magic.p = getelementptr inbounds i8, i8* %nt, i64 24
  %opt.magic.p.i16 = bitcast i8* %opt.magic.p to i16*
  %opt.magic = load i16, i16* %opt.magic.p.i16, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_nsects, label %ret0

load_nsects:
  %nsects.p = getelementptr inbounds i8, i8* %nt, i64 6
  %nsects.p.i16 = bitcast i8* %nsects.p to i16*
  %nsects16 = load i16, i16* %nsects.p.i16, align 1
  %nsects32 = zext i16 %nsects16 to i32
  %nsects.iszero = icmp eq i32 %nsects32, 0
  br i1 %nsects.iszero, label %ret0, label %prep_sections

prep_sections:
  %soh.p = getelementptr inbounds i8, i8* %nt, i64 20
  %soh.p.i16 = bitcast i8* %soh.p to i16*
  %soh16 = load i16, i16* %soh.p.i16, align 1
  %opt.start = getelementptr inbounds i8, i8* %nt, i64 24
  %soh64 = zext i16 %soh16 to i64
  %first.sec = getelementptr inbounds i8, i8* %opt.start, i64 %soh64
  %nsects64 = zext i32 %nsects32 to i64
  %table.bytes = mul i64 %nsects64, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.sec, i64 %table.bytes
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %p.int, %base.int
  br label %loop

loop:
  %sec.ptr = phi i8* [ %first.sec, %prep_sections ], [ %next.sec, %loop_inc ]
  %at.end = icmp eq i8* %sec.ptr, %end.ptr
  br i1 %at.end, label %ret0, label %loop_body

loop_body:
  %va.p.i8 = getelementptr inbounds i8, i8* %sec.ptr, i64 12
  %va.p = bitcast i8* %va.p.i8 to i32*
  %va = load i32, i32* %va.p, align 1
  %va64 = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %loop_inc, label %check_in_range

check_in_range:
  %vsize.p.i8 = getelementptr inbounds i8, i8* %sec.ptr, i64 8
  %vsize.p = bitcast i8* %vsize.p.i8 to i32*
  %vsize = load i32, i32* %vsize.p, align 1
  %vsize64 = zext i32 %vsize to i64
  %end.rva = add i64 %va64, %vsize64
  %in.range = icmp ult i64 %rva, %end.rva
  br i1 %in.range, label %found, label %loop_inc

loop_inc:
  %next.sec = getelementptr inbounds i8, i8* %sec.ptr, i64 40
  br label %loop

found:
  %chars.p.i8 = getelementptr inbounds i8, i8* %sec.ptr, i64 36
  %chars.p = bitcast i8* %chars.p.i8 to i32*
  %chars = load i32, i32* %chars.p, align 1
  %chars.not = xor i32 %chars, -1
  %res = lshr i32 %chars.not, 31
  ret i32 %res

ret0:
  ret i32 0
}