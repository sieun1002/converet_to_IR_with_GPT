; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %p) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mzval = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mzval, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 1
  %e_lfanew_zext = zext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_zext
  %sigptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %magic_ptr = getelementptr i8, i8* %nthdr, i64 24
  %magic_ptr16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_ptr16, align 1
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %get_sections, label %ret0

get_sections:                                     ; preds = %check_magic
  %nos_ptr = getelementptr i8, i8* %nthdr, i64 6
  %nos_ptr16 = bitcast i8* %nos_ptr to i16*
  %nos16 = load i16, i16* %nos_ptr16, align 1
  %nos_is_zero = icmp eq i16 %nos16, 0
  br i1 %nos_is_zero, label %ret0, label %cont_sections

cont_sections:                                    ; preds = %get_sections
  %soh_ptr = getelementptr i8, i8* %nthdr, i64 20
  %soh_ptr16 = bitcast i8* %soh_ptr to i16*
  %soh16 = load i16, i16* %soh_ptr16, align 1
  %soh_zext = zext i16 %soh16 to i64
  %sect_start_pre = getelementptr i8, i8* %nthdr, i64 24
  %sect_start = getelementptr i8, i8* %sect_start_pre, i64 %soh_zext
  %nos_zext32 = zext i16 %nos16 to i32
  %nos_zext64 = zext i32 %nos_zext32 to i64
  %size_mul = mul nuw nsw i64 %nos_zext64, 40
  %sect_end = getelementptr i8, i8* %sect_start, i64 %size_mul
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %offset = sub i64 %p_int, %base_int
  br label %loop

loop:                                             ; preds = %cont, %cont_sections
  %cur = phi i8* [ %sect_start, %cont_sections ], [ %next, %cont ]
  %end = phi i8* [ %sect_end, %cont_sections ], [ %sect_end, %cont ]
  %va_ptr = getelementptr i8, i8* %cur, i64 12
  %va_ptr32 = bitcast i8* %va_ptr to i32*
  %va = load i32, i32* %va_ptr32, align 1
  %va_zext = zext i32 %va to i64
  %lt = icmp ult i64 %offset, %va_zext
  br i1 %lt, label %cont, label %check_range

cont:                                             ; preds = %check_range, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %end_loop, label %loop

check_range:                                      ; preds = %loop
  %vs_ptr = getelementptr i8, i8* %cur, i64 8
  %vs_ptr32 = bitcast i8* %vs_ptr to i32*
  %vs = load i32, i32* %vs_ptr32, align 1
  %vs_zext = zext i32 %vs to i64
  %sum = add i64 %va_zext, %vs_zext
  %inrange = icmp ult i64 %offset, %sum
  br i1 %inrange, label %ret0, label %cont

end_loop:                                         ; preds = %cont
  ret i32 0

ret0:                                             ; preds = %check_range, %cont_sections, %check_magic, %check_pe, %entry
  ret i32 0
}