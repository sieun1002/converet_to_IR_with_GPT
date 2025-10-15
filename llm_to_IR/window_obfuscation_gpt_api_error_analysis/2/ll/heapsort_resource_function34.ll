target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* %addr) {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i64 = ptrtoint i8* %base to i64
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_sext
  %sigptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %optmagic_ptr = getelementptr inbounds i8, i8* %nt, i64 24
  %optmagic_i16ptr = bitcast i8* %optmagic_ptr to i16*
  %optmagic = load i16, i16* %optmagic_i16ptr, align 1
  %is_pe32plus = icmp eq i16 %optmagic, 523
  br i1 %is_pe32plus, label %load_counts, label %ret0

load_counts:
  %numsecs_ptr = getelementptr inbounds i8, i8* %nt, i64 6
  %numsecs_i16ptr = bitcast i8* %numsecs_ptr to i16*
  %numsecs16 = load i16, i16* %numsecs_i16ptr, align 1
  %numsecs_is_zero = icmp eq i16 %numsecs16, 0
  br i1 %numsecs_is_zero, label %ret0, label %compute_headers

compute_headers:
  %soh_ptr = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_i16ptr = bitcast i8* %soh_ptr to i16*
  %soh16 = load i16, i16* %soh_i16ptr, align 1
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %first_sec_pre = getelementptr inbounds i8, i8* %nt, i64 24
  %first_sec = getelementptr inbounds i8, i8* %first_sec_pre, i64 %soh64
  %numsecs32 = zext i16 %numsecs16 to i32
  %numsecs64 = zext i32 %numsecs32 to i64
  %sections_size = mul i64 %numsecs64, 40
  %end_sec = getelementptr inbounds i8, i8* %first_sec, i64 %sections_size
  %addr_i64 = ptrtoint i8* %addr to i64
  %rva64 = sub i64 %addr_i64, %base_i64
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %compute_headers ], [ %next, %loop_continue ]
  %vaddr_ptr_pre = getelementptr inbounds i8, i8* %cur, i64 12
  %vaddr_ptr = bitcast i8* %vaddr_ptr_pre to i32*
  %vaddr32 = load i32, i32* %vaddr_ptr, align 1
  %vaddr64 = zext i32 %vaddr32 to i64
  %is_below = icmp ult i64 %rva64, %vaddr64
  br i1 %is_below, label %loop_continue, label %check_within

check_within:
  %vsize_ptr_pre = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_pre to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %end32 = add i32 %vaddr32, %vsize32
  %end64 = zext i32 %end32 to i64
  %in_range = icmp ult i64 %rva64, %end64
  br i1 %in_range, label %found, label %loop_continue

loop_continue:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_sec
  br i1 %done, label %ret0, label %loop

found:
  %char_ptr_pre = getelementptr inbounds i8, i8* %cur, i64 36
  %char_ptr = bitcast i8* %char_ptr_pre to i32*
  %chars = load i32, i32* %char_ptr, align 1
  %notchars = xor i32 %chars, -1
  %res = lshr i32 %notchars, 31
  ret i32 %res

ret0:
  ret i32 0
}