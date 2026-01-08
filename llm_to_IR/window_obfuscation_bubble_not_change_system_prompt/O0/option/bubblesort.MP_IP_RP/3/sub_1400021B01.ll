; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %call = call i64 @sub_140002700()
  %cmpja = icmp ugt i64 %call, 8
  br i1 %cmpja, label %ret_zero, label %after_len

after_len:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %basei16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %basei16ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %peoff_ptr = getelementptr i8, i8* %baseptr, i64 60
  %peoff_i32ptr = bitcast i8* %peoff_ptr to i32*
  %peoff32 = load i32, i32* %peoff_i32ptr, align 4
  %peoff64 = sext i32 %peoff32 to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %peoff64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_zero

check_optmagic:
  %optmagic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr_i8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr, align 2
  %is_64 = icmp eq i16 %optmagic, 523
  br i1 %is_64, label %check_numsec, label %ret_zero

check_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_zero, label %prep_loop

prep_loop:
  %opt_hdr_size_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %opt_hdr_size_ptr = bitcast i8* %opt_hdr_size_ptr_i8 to i16*
  %opt_hdr_size16 = load i16, i16* %opt_hdr_size_ptr, align 2
  %opt_hdr_size64 = zext i16 %opt_hdr_size16 to i64
  %sec_table_off = add i64 %opt_hdr_size64, 24
  %rbx_init = getelementptr i8, i8* %pehdr, i64 %sec_table_off
  br label %loop

loop:
  %rbx_phi = phi i8* [ %rbx_init, %prep_loop ], [ %rbx_next, %after_call ]
  %i_phi = phi i32 [ 0, %prep_loop ], [ %i_next, %after_call ]
  %call2 = call i32 @sub_140002708(i8* %rbx_phi, i8* %0, i32 8)
  %is_zero = icmp eq i32 %call2, 0
  br i1 %is_zero, label %ret_rbx, label %after_call

after_call:
  %numsec16_2 = load i16, i16* %numsec_ptr, align 2
  %numsec32 = zext i16 %numsec16_2 to i32
  %i_next = add i32 %i_phi, 1
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 40
  %cont = icmp ult i32 %i_next, %numsec32
  br i1 %cont, label %loop, label %ret_zero

ret_rbx:
  ret i8* %rbx_phi

ret_zero:
  ret i8* null
}