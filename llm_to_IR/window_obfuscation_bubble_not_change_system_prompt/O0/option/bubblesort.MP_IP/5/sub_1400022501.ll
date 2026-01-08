; target
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %mz.ptr.cast = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.cast, align 1
  %cmp.mz = icmp eq i16 %mz, 23117
  br i1 %cmp.mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr.cast = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr.cast, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pe.hdr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew64
  %pe.sig.ptr = bitcast i8* %pe.hdr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %cmp.pe = icmp eq i32 %pe.sig, 17744
  br i1 %cmp.pe, label %check_magic, label %ret0

check_magic:
  %opt.magic.ptr0 = getelementptr inbounds i8, i8* %pe.hdr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr0 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %check_sections, label %ret0

check_sections:
  %numsects.ptr0 = getelementptr inbounds i8, i8* %pe.hdr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr0 to i16*
  %numsects = load i16, i16* %numsects.ptr, align 1
  %hassects = icmp ne i16 %numsects, 0
  br i1 %hassects, label %prep_loop, label %ret0

prep_loop:
  %soh.ptr0 = getelementptr inbounds i8, i8* %pe.hdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr0 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %off = sub i64 %rcx.int, %base.int
  %first.sec.base = getelementptr inbounds i8, i8* %pe.hdr, i64 24
  %first.sec = getelementptr inbounds i8, i8* %first.sec.base, i64 %soh64
  %numsects32 = zext i16 %numsects to i32
  %nminus1 = add i32 %numsects32, -1
  %nminus1x5 = mul i32 %nminus1, 5
  %nminus1x5_64 = sext i32 %nminus1x5 to i64
  %bytes.off = mul i64 %nminus1x5_64, 8
  %end.tmp = getelementptr inbounds i8, i8* %first.sec, i64 %bytes.off
  %end.ptr = getelementptr inbounds i8, i8* %end.tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first.sec, %prep_loop ], [ %next, %inc ]
  %done = icmp eq i8* %cur, %end.ptr
  br i1 %done, label %ret0, label %body

body:
  %va.ptr0 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr0 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %off_lt_va = icmp ult i64 %off, %va64
  br i1 %off_lt_va, label %inc, label %check_range

check_range:
  %vs.ptr0 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr0 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %end.range = add i64 %va64, %vs64
  %off_in = icmp ult i64 %off, %end.range
  br i1 %off_in, label %ret0, label %inc

inc:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}