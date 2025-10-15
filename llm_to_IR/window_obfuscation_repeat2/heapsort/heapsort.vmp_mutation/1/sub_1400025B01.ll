; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400025B0(i8* %rcx) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %p16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %p16, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %chk_pe_sig, label %ret0

chk_pe_sig:
  %p3c = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %p3c32ptr = bitcast i8* %p3c to i32*
  %e_lfanew32 = load i32, i32* %p3c32ptr, align 4
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew
  %pe32ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pe32ptr, align 4
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %chk_magic, label %ret0

chk_magic:
  %magic_ptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic16ptr = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic16ptr, align 2
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %cont, label %ret0

cont:
  %numsec_ptr = getelementptr inbounds i8, i8* %pehdr, i64 6
  %numsec16ptr = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec16ptr, align 2
  %numzero = icmp eq i16 %numsec16, 0
  br i1 %numzero, label %ret0, label %prep

prep:
  %sizeopt_ptr = getelementptr inbounds i8, i8* %pehdr, i64 20
  %sizeopt16ptr = bitcast i8* %sizeopt_ptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt16ptr, align 2
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base.ptr to i64
  %delta = sub i64 %rcx_int, %base_int
  %numsec64 = zext i16 %numsec16 to i64
  %nminus1 = add i64 %numsec64, -1
  %mul5 = mul i64 %nminus1, 5
  %mul40 = mul i64 %mul5, 8
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %add18 = add i64 %sizeopt64, 24
  %secstart = getelementptr inbounds i8, i8* %pehdr, i64 %add18
  %end_off = add i64 %mul40, 40
  %endptr = getelementptr inbounds i8, i8* %secstart, i64 %end_off
  br label %loop

loop:
  %cur = phi i8* [ %secstart, %prep ], [ %next, %inc ]
  %rva_off = getelementptr inbounds i8, i8* %cur, i64 12
  %rva_ptr = bitcast i8* %rva_off to i32*
  %rva32 = load i32, i32* %rva_ptr, align 4
  %rva64 = zext i32 %rva32 to i64
  %cmp1 = icmp ult i64 %delta, %rva64
  br i1 %cmp1, label %inc, label %range

range:
  %vs_off = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_off to i32*
  %vs32 = load i32, i32* %vs_ptr, align 4
  %vs64 = zext i32 %vs32 to i64
  %endval = add i64 %vs64, %rva64
  %cmp2 = icmp ult i64 %delta, %endval
  br i1 %cmp2, label %ret0, label %inc

inc:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %cmpend = icmp ne i8* %next, %endptr
  br i1 %cmpend, label %loop, label %exit

ret0:
  ret i32 0

exit:
  ret i32 0
}