; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002790(i8* %ptr) local_unnamed_addr nounwind {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe_sig, label %ret_zero

check_pe_sig:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %nt.ptr = bitcast i8* %nt.ptr.i8 to i32*
  %pe.sig = load i32, i32* %nt.ptr, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret_zero

check_opt_magic:
  %opt.magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 2
  %is_pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret_zero

get_sections:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 2
  %has_sections = icmp ne i16 %numsec, 0
  br i1 %has_sections, label %prep_loop, label %ret_zero

prep_loop:
  %sizeopt.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt = load i16, i16* %sizeopt.ptr, align 2
  %rva.ptrint = ptrtoint i8* %ptr to i64
  %base.ptrint = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rva.ptrint, %base.ptrint
  %sizeopt.zext = zext i16 %sizeopt to i64
  %firstsec.off = add i64 %sizeopt.zext, 24
  %firstsec.ptr = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 %firstsec.off
  %numsec.zext = zext i16 %numsec to i64
  %totbytes = mul nuw i64 %numsec.zext, 40
  %end.ptr = getelementptr inbounds i8, i8* %firstsec.ptr, i64 %totbytes
  br label %loop

loop:
  %cur = phi i8* [ %firstsec.ptr, %prep_loop ], [ %next.cur, %next ]
  %at_end = icmp eq i8* %cur, %end.ptr
  br i1 %at_end, label %ret_zero, label %check_section

check_section:
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize = load i32, i32* %vsize.ptr, align 4
  %vaddr.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %vaddr.ptr = bitcast i8* %vaddr.ptr.i8 to i32*
  %vaddr = load i32, i32* %vaddr.ptr, align 4
  %vaddr.z = zext i32 %vaddr to i64
  %cmp_below = icmp ult i64 %rva, %vaddr.z
  br i1 %cmp_below, label %next, label %check_upper

check_upper:
  %sum32 = add i32 %vaddr, %vsize
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %sum64
  br i1 %in_range, label %found, label %next

next:
  %next.cur = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

found:
  %ch.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 36
  %ch.ptr = bitcast i8* %ch.ptr.i8 to i32*
  %ch = load i32, i32* %ch.ptr, align 4
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res

ret_zero:
  ret i32 0
}