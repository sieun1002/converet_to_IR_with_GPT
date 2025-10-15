; ModuleID = 'pe_section_scan'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_1400027B0(i64 %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew_zext = zext i32 %lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %baseptr, i64 %lfanew_zext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %load_sections, label %ret0

load_sections:
  %nsec_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 1
  %nsec_nonzero = icmp ne i16 %nsec16, 0
  br i1 %nsec_nonzero, label %have_sections, label %ret0

have_sections:
  %nsec32 = zext i16 %nsec16 to i32
  %nsec64 = zext i32 %nsec32 to i64
  %sizeopthdr_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 20
  %sizeopthdr_ptr = bitcast i8* %sizeopthdr_ptr_i8 to i16*
  %sizeopthdr16 = load i16, i16* %sizeopthdr_ptr, align 1
  %sizeopthdr64 = zext i16 %sizeopthdr16 to i64
  %sec_first_pre = getelementptr inbounds i8, i8* %pehdr, i64 24
  %sec_first = getelementptr inbounds i8, i8* %sec_first_pre, i64 %sizeopthdr64
  %nsec_bytes_mul = mul nuw i64 %nsec64, 40
  %sec_end = getelementptr inbounds i8, i8* %sec_first, i64 %nsec_bytes_mul
  br label %loop

loop:
  %sec_cur = phi i8* [ %sec_first, %have_sections ], [ %sec_next, %loop_tail ]
  %rcx_var = phi i64 [ %rcx, %have_sections ], [ %rcx_next, %loop_tail ]
  %charbyte_ptr = getelementptr inbounds i8, i8* %sec_cur, i64 39
  %charbyte = load i8, i8* %charbyte_ptr, align 1
  %mask = and i8 %charbyte, 32
  %bit_set = icmp ne i8 %mask, 0
  br i1 %bit_set, label %check_rcx, label %loop_tail

check_rcx:
  %rcx_is_zero = icmp eq i64 %rcx_var, 0
  br i1 %rcx_is_zero, label %ret0, label %decrement

decrement:
  %rcx_dec = add i64 %rcx_var, -1
  br label %loop_tail

loop_tail:
  %rcx_next = phi i64 [ %rcx_var, %loop ], [ %rcx_dec, %decrement ]
  %sec_next = getelementptr inbounds i8, i8* %sec_cur, i64 40
  %done = icmp eq i8* %sec_next, %sec_end
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}