; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %p) {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %base_mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %base_mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %ptr3C = getelementptr i8, i8* %base_ptr, i64 60
  %offset32ptr = bitcast i8* %ptr3C to i32*
  %offset32 = load i32, i32* %offset32ptr, align 1
  %offset64 = sext i32 %offset32 to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %offset64
  %nt_sig_ptr = bitcast i8* %nt to i32*
  %pe_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %optmagic_ptr8 = getelementptr i8, i8* %nt, i64 24
  %optmagic_ptr16 = bitcast i8* %optmagic_ptr8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr16, align 1
  %is_peplus = icmp eq i16 %optmagic, 523
  br i1 %is_peplus, label %sections, label %ret0

sections:
  %numsec_ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr16 = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr16, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont1

cont1:
  %soh_ptr8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr16 = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr16, align 1
  %soh64 = zext i16 %soh16 to i64
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %diff = sub i64 %p_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %edx_sub = sub i32 %numsec32, 1
  %edx64 = zext i32 %edx_sub to i64
  %tmp4 = mul i64 %edx64, 5
  %start = getelementptr i8, i8* %nt, i64 %soh64
  %start2 = getelementptr i8, i8* %start, i64 24
  %mul8 = mul i64 %tmp4, 8
  %plus = add i64 %mul8, 40
  %end = getelementptr i8, i8* %start2, i64 %plus
  br label %loop

loop:
  %cur = phi i8* [ %start2, %cont1 ], [ %next, %loop2 ]
  %va_ptr8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr32 = bitcast i8* %va_ptr8 to i32*
  %vaddr = load i32, i32* %va_ptr32, align 1
  %vaddr64 = zext i32 %vaddr to i64
  %cmp1 = icmp ult i64 %diff, %vaddr64
  br i1 %cmp1, label %loop2, label %after_cmp1

after_cmp1:
  %size_ptr8 = getelementptr i8, i8* %cur, i64 8
  %size_ptr32 = bitcast i8* %size_ptr8 to i32*
  %size = load i32, i32* %size_ptr32, align 1
  %sum32 = add i32 %vaddr, %size
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %diff, %sum64
  br i1 %cmp2, label %ret0, label %loop2

loop2:
  %next = getelementptr i8, i8* %cur, i64 40
  %cond = icmp ne i8* %next, %end
  br i1 %cond, label %loop, label %done

done:
  ret i32 0

ret0:
  ret i32 0
}