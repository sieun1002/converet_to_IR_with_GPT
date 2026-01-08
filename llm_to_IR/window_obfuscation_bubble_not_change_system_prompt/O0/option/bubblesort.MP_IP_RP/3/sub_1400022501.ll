target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %dos.mag.ptr = bitcast i8* %base.ptr to i16*
  %dos.mag = load i16, i16* %dos.mag.ptr, align 1
  %is.mz = icmp eq i16 %dos.mag, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.i32p = bitcast i8* %e_lfanew.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32p, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pe.hdr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe.sig.p = bitcast i8* %pe.hdr to i32*
  %pe.sig = load i32, i32* %pe.sig.p, align 1
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %check_optmagic, label %ret0

check_optmagic:
  %opt.magic.p.i8 = getelementptr inbounds i8, i8* %pe.hdr, i64 24
  %opt.magic.p = bitcast i8* %opt.magic.p.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.p, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_counts, label %ret0

load_counts:
  %numsects.p.i8 = getelementptr inbounds i8, i8* %pe.hdr, i64 6
  %numsects.p = bitcast i8* %numsects.p.i8 to i16*
  %numsects.w = load i16, i16* %numsects.p, align 1
  %hassects = icmp ne i16 %numsects.w, 0
  br i1 %hassects, label %setup_loop, label %ret0

setup_loop:
  %soh.p.i8 = getelementptr inbounds i8, i8* %pe.hdr, i64 20
  %soh.p = bitcast i8* %soh.p.i8 to i16*
  %soh.w = load i16, i16* %soh.p, align 1
  %ret.nonzero = zext i16 %soh.w to i32
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %soh.zext64 = zext i16 %soh.w to i64
  %sec.start.off = add i64 %soh.zext64, 24
  %sec.start = getelementptr inbounds i8, i8* %pe.hdr, i64 %sec.start.off
  %nsects.z64 = zext i16 %numsects.w to i64
  %bytes = mul nuw i64 %nsects.z64, 40
  %sec.end = getelementptr inbounds i8, i8* %sec.start, i64 %bytes
  br label %loop

loop:
  %cur.phi = phi i8* [ %sec.start, %setup_loop ], [ %cur.next, %incr ]
  %done = icmp eq i8* %cur.phi, %sec.end
  br i1 %done, label %ret0, label %check_section

check_section:
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur.phi, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %incr, label %check_in_range

check_in_range:
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %cur.phi, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %rva.lt.end = icmp ult i64 %rva, %end64
  br i1 %rva.lt.end, label %ret_nonzero, label %incr

incr:
  %cur.next = getelementptr inbounds i8, i8* %cur.phi, i64 40
  br label %loop

ret_nonzero:
  ret i32 %ret.nonzero

ret0:
  ret i32 0
}