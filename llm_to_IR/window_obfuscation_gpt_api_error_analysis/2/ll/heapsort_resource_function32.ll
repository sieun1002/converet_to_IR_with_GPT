; target: Windows x64 PE
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_1400026D0(i64 %rcx) local_unnamed_addr {
entry:
  %base.loadptr = load i8*, i8** @off_1400043A0, align 8
  %base.mz.ptr = bitcast i8* %base.loadptr to i16*
  %mz = load i16, i16* %base.mz.ptr, align 2
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %chk_pe, label %ret_null

chk_pe:
  %e_lfanew.ptr.byte = getelementptr inbounds i8, i8* %base.loadptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.byte to i32*
  %e_lfanew.32 = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew.64 = sext i32 %e_lfanew.32 to i64
  %nthdr = getelementptr inbounds i8, i8* %base.loadptr, i64 %e_lfanew.64
  %pe.sig.ptr = bitcast i8* %nthdr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 4
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %chk_opt, label %ret_null

chk_opt:
  %opt.magic.ptr.byte = getelementptr inbounds i8, i8* %nthdr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.byte to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 2
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_sections, label %ret_null

load_sections:
  %numsec.ptr.byte = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.byte to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 2
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret_null, label %calc_first

calc_first:
  %soh.ptr.byte = getelementptr inbounds i8, i8* %nthdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.byte to i16*
  %soh16 = load i16, i16* %soh.ptr, align 2
  %soh64 = zext i16 %soh16 to i64
  %first.off = add i64 %soh64, 24
  %first = getelementptr inbounds i8, i8* %nthdr, i64 %first.off
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %n.minus1 = add i64 %numsec64, -1
  %times5 = mul i64 %n.minus1, 5
  %times40 = shl i64 %times5, 3
  %plus40 = add i64 %times40, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %plus40
  br label %loop

loop:
  %curr = phi i8* [ %first, %calc_first ], [ %next, %advance ]
  %rem = phi i64 [ %rcx, %calc_first ], [ %rem.next, %advance ]
  %flag.ptr = getelementptr inbounds i8, i8* %curr, i64 39
  %flag.byte = load i8, i8* %flag.ptr, align 1
  %flag.mask = and i8 %flag.byte, 32
  %flag.set = icmp ne i8 %flag.mask, 0
  br i1 %flag.set, label %match_check, label %advance_pre

match_check:
  %rem.is.zero = icmp eq i64 %rem, 0
  br i1 %rem.is.zero, label %ret_curr, label %dec_rem

ret_curr:
  ret i8* %curr

dec_rem:
  %rem.dec = add i64 %rem, -1
  br label %advance

advance_pre:
  br label %advance

advance:
  %rem.next = phi i64 [ %rem.dec, %dec_rem ], [ %rem, %advance_pre ]
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  %at.end = icmp eq i8* %next, %end
  br i1 %at.end, label %ret_null, label %loop

ret_null:
  ret i8* null
}