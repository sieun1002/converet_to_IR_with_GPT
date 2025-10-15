; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %rcx) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 0
  %mz_ptr = bitcast i8* %mz_ptr_i8 to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew_zext = zext i32 %lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %base_ptr, i64 %lfanew_zext
  %sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %cont, label %ret0

cont:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %secprep

secprep:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh16 to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %delta = sub i64 %rcx_int, %base_int
  %firstsec_pre = getelementptr inbounds i8, i8* %pehdr, i64 24
  %firstsec = getelementptr inbounds i8, i8* %firstsec_pre, i64 %soh_zext
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %totbytes = mul nuw nsw i64 %numsec64, 40
  %endptr = getelementptr inbounds i8, i8* %firstsec, i64 %totbytes
  br label %loop

loop:
  %p_cur = phi i8* [ %firstsec, %secprep ], [ %next, %loop_end ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %p_cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %delta_lt_va = icmp ult i64 %delta, %va64
  br i1 %delta_lt_va, label %loop_end, label %check_range

check_range:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %p_cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %sum32 = add i32 %va, %vs
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %delta, %sum64
  br i1 %inrange, label %ret0, label %loop_end

loop_end:
  %next = getelementptr inbounds i8, i8* %p_cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %finalret, label %loop

finalret:
  br label %ret0

ret0:
  ret i32 0
}