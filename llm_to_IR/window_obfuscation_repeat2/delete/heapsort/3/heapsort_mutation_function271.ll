; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

@off_1400043A0 = external global i8*

define i8* @sub_140002570(i8* noundef %str) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* noundef %str)
  %gt8 = icmp ugt i64 %len, 8
  br i1 %gt8, label %ret_zero, label %load_base

load_base:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %match_mz = icmp eq i16 %mz, 23117
  br i1 %match_mz, label %nt_calc, label %ret_zero

nt_calc:
  %e_off_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_off_ptr32 = bitcast i8* %e_off_ptr to i32*
  %e_off = load i32, i32* %e_off_ptr32, align 1
  %e_off_sext = sext i32 %e_off to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr, i64 %e_off_sext
  %nt_sig_ptr32 = bitcast i8* %nt_hdr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr32, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %op_magic_ptr = getelementptr i8, i8* %nt_hdr, i64 24
  %op_magic_ptr16 = bitcast i8* %op_magic_ptr to i16*
  %op_magic = load i16, i16* %op_magic_ptr16, align 1
  %is_20b = icmp eq i16 %op_magic, 523
  br i1 %is_20b, label %check_numsec, label %ret_zero

check_numsec:
  %numsec_ptr = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr16 = bitcast i8* %numsec_ptr to i16*
  %numsec = load i16, i16* %numsec_ptr16, align 1
  %is_zero = icmp eq i16 %numsec, 0
  br i1 %is_zero, label %ret_zero, label %setup_loop

setup_loop:
  %numsec32 = zext i16 %numsec to i32
  %soh_ptr = getelementptr i8, i8* %nt_hdr, i64 20
  %soh_ptr16 = bitcast i8* %soh_ptr to i16*
  %soh = load i16, i16* %soh_ptr16, align 1
  %soh_zext = zext i16 %soh to i64
  %sect_base0 = getelementptr i8, i8* %nt_hdr, i64 24
  %rbx0 = getelementptr i8, i8* %sect_base0, i64 %soh_zext
  br label %loop

loop:
  %i = phi i32 [ 0, %setup_loop ], [ %i_next, %advance ]
  %rbx_cur = phi i8* [ %rbx0, %setup_loop ], [ %rbx_next, %advance ]
  %call = call i32 @strncmp(i8* noundef %rbx_cur, i8* noundef %str, i64 noundef 8)
  %eq = icmp eq i32 %call, 0
  br i1 %eq, label %found, label %advance

advance:
  %i_next = add i32 %i, 1
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 40
  %cont = icmp ult i32 %i_next, %numsec32
  br i1 %cont, label %loop, label %ret_zero

found:
  br label %ret_rbx

ret_rbx:
  ret i8* %rbx_cur

ret_zero:
  ret i8* null
}