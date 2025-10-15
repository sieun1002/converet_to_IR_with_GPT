; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare dllimport i64 @strlen(i8*)
declare dllimport i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002510(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %ret_null, label %check_mz

ret_null:                                            ; preds = %loop_next, %check_nsec, %check_magic, %pehdr_prep, %check_mz, %entry
  ret i8* null

check_mz:                                            ; preds = %entry
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %pehdr_prep, label %ret_null

pehdr_prep:                                          ; preds = %check_mz
  %e_lfanew_addr = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_addr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew_sext
  %pesig_ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %pesig_ok = icmp eq i32 %pesig, 17744
  br i1 %pesig_ok, label %check_magic, label %ret_null

check_magic:                                         ; preds = %pehdr_prep
  %magic_addr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_addr to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %check_nsec, label %ret_null

check_nsec:                                          ; preds = %check_magic
  %nsec_addr = getelementptr inbounds i8, i8* %pehdr, i64 6
  %nsec_ptr = bitcast i8* %nsec_addr to i16*
  %nsec = load i16, i16* %nsec_ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec, 0
  br i1 %nsec_is_zero, label %ret_null, label %setup_loop

setup_loop:                                          ; preds = %check_nsec
  %soh_addr = getelementptr inbounds i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_addr to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_z = zext i16 %soh to i64
  %sec0_off = add i64 %soh_z, 24
  %sec0 = getelementptr inbounds i8, i8* %pehdr, i64 %sec0_off
  %nsec_z32 = zext i16 %nsec to i32
  br label %loop

loop:                                                ; preds = %loop_next, %setup_loop
  %i = phi i32 [ 0, %setup_loop ], [ %i_next, %loop_next ]
  %cur = phi i8* [ %sec0, %setup_loop ], [ %cur_next, %loop_next ]
  %cmpres = call i32 @strncmp(i8* %cur, i8* %str, i64 8)
  %is_eq = icmp eq i32 %cmpres, 0
  br i1 %is_eq, label %ret_found, label %loop_next

loop_next:                                           ; preds = %loop
  %i_next = add i32 %i, 1
  %cur_next = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i_next, %nsec_z32
  br i1 %cont, label %loop, label %ret_null

ret_found:                                           ; preds = %loop
  ret i8* %cur
}