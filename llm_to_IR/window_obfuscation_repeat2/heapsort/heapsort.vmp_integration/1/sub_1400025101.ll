; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002A60()
declare i32 @sub_140002A68(i8*, i8*, i32)

define i8* @sub_140002510(i8* %0) {
entry:
  %call = call i64 @sub_140002A60()
  %cmp = icmp ugt i64 %call, 8
  br i1 %cmp, label %fail, label %check_mz

check_mz:                                          ; preds = %entry
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %have_dos, label %fail

have_dos:                                          ; preds = %check_mz
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_i32p = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32p, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sigp = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigp, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:                                       ; preds = %have_dos
  %magic_ptr = getelementptr i8, i8* %nt, i64 24
  %magic_p16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_p16, align 2
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %check_sections_nonzero, label %fail

check_sections_nonzero:                            ; preds = %check_magic
  %numsec_ptr = getelementptr i8, i8* %nt, i64 6
  %numsec_p16 = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec_p16, align 2
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %fail, label %prepare_loop

prepare_loop:                                      ; preds = %check_sections_nonzero
  %sizeopt_ptr = getelementptr i8, i8* %nt, i64 20
  %sizeopt_p16 = bitcast i8* %sizeopt_ptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt_p16, align 2
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %first_opt = getelementptr i8, i8* %nt, i64 24
  %sect_start = getelementptr i8, i8* %first_opt, i64 %sizeopt64
  %limit = zext i16 %numsec16 to i32
  br label %loop

loop:                                              ; preds = %loop_continue, %prepare_loop
  %i = phi i32 [ 0, %prepare_loop ], [ %i.next, %loop_continue ]
  %rbx_ptr = phi i8* [ %sect_start, %prepare_loop ], [ %rbx_next, %loop_continue ]
  %call2 = call i32 @sub_140002A68(i8* %rbx_ptr, i8* %0, i32 8)
  %is_zero = icmp eq i32 %call2, 0
  br i1 %is_zero, label %found, label %loop_continue

loop_continue:                                     ; preds = %loop
  %i.next = add nuw nsw i32 %i, 1
  %rbx_next = getelementptr i8, i8* %rbx_ptr, i64 40
  %cont = icmp ult i32 %i.next, %limit
  br i1 %cont, label %loop, label %fail

found:                                             ; preds = %loop
  ret i8* %rbx_ptr

fail:                                              ; preds = %loop_continue, %check_sections_nonzero, %check_magic, %have_dos, %check_mz, %entry
  ret i8* null
}