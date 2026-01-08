target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_1400023D0(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                            ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.i64
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %after_pe, label %ret0

after_pe:                                            ; preds = %check_pe
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_pep = icmp eq i16 %opt.magic, 523
  br i1 %is_pep, label %get_section_count, label %ret0

get_section_count:                                   ; preds = %after_pe
  %numsects.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects.i16 = load i16, i16* %numsects.ptr, align 1
  %numsects.i32 = zext i16 %numsects.i16 to i32
  %numzero = icmp eq i32 %numsects.i32, 0
  br i1 %numzero, label %ret0, label %cont1

cont1:                                               ; preds = %get_section_count
  %szopt.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %szopt.ptr = bitcast i8* %szopt.ptr.i8 to i16*
  %szopt.i16 = load i16, i16* %szopt.ptr, align 1
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %numsects.minus1 = add i32 %numsects.i32, -1
  %numsects.minus1.z = zext i32 %numsects.minus1 to i64
  %times5 = mul i64 %numsects.minus1.z, 5
  %szopt.i64 = zext i16 %szopt.i16 to i64
  %first.sec.base = getelementptr i8, i8* %nt.ptr, i64 24
  %first.sec = getelementptr i8, i8* %first.sec.base, i64 %szopt.i64
  %times40 = shl i64 %times5, 3
  %end.off.tmp = add i64 %times40, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %end.off.tmp
  br label %loop

loop:                                                ; preds = %inc, %cont1
  %cur.sec = phi i8* [ %first.sec, %cont1 ], [ %next.sec, %inc ]
  %va.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr, align 1
  %va.i64 = zext i32 %va.i32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va.i64
  br i1 %rva_lt_va, label %inc, label %check_end_in_section

check_end_in_section:                                ; preds = %loop
  %vsize.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize.ptr, align 1
  %end.i32 = add i32 %va.i32, %vsize.i32
  %end.i64 = zext i32 %end.i32 to i64
  %inrange = icmp ult i64 %rva, %end.i64
  br i1 %inrange, label %found, label %inc

inc:                                                 ; preds = %check_end_in_section, %loop
  %next.sec = getelementptr i8, i8* %cur.sec, i64 40
  %cont = icmp ne i8* %next.sec, %end.ptr
  br i1 %cont, label %loop, label %ret0

found:                                               ; preds = %check_end_in_section
  %chars.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.i8 to i32*
  %chars = load i32, i32* %chars.ptr, align 1
  %notchars = xor i32 %chars, -1
  %res = lshr i32 %notchars, 31
  ret i32 %res

ret0:                                                ; preds = %inc, %after_pe, %check_pe, %entry, %get_section_count
  ret i32 0
}