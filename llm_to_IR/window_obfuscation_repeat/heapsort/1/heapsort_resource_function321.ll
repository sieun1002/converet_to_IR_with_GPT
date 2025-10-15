; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %count) nounwind {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %eoff_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %eoff_ptr = bitcast i8* %eoff_ptr_i8 to i32*
  %eoff = load i32, i32* %eoff_ptr, align 1
  %eoff64 = sext i32 %eoff to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %eoff64
  %pesig_ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %optmagic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr_i8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr, align 1
  %is_20b = icmp eq i16 %optmagic, 523
  br i1 %is_20b, label %load_counts, label %ret0

load_counts:
  %nsects_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsects_ptr = bitcast i8* %nsects_ptr_i8 to i16*
  %nsects16 = load i16, i16* %nsects_ptr, align 1
  %nsects_is_zero = icmp eq i16 %nsects16, 0
  br i1 %nsects_is_zero, label %ret0, label %have_sects

have_sects:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt = zext i16 %sizeopt16 to i64
  %firstsect_pre = getelementptr i8, i8* %pehdr, i64 24
  %firstsect = getelementptr i8, i8* %firstsect_pre, i64 %sizeopt
  %nsects32 = zext i16 %nsects16 to i32
  %nsects64 = zext i32 %nsects32 to i64
  %totalbytes = mul nuw i64 %nsects64, 40
  %endptr = getelementptr i8, i8* %firstsect, i64 %totalbytes
  br label %loop

loop:
  %cur = phi i8* [ %firstsect, %have_sects ], [ %next, %loop_tail ]
  %cnt = phi i64 [ %count, %have_sects ], [ %cnt_next, %loop_tail ]
  %char_byte_ptr_i8 = getelementptr i8, i8* %cur, i64 39
  %char_byte = load i8, i8* %char_byte_ptr_i8, align 1
  %flag = and i8 %char_byte, 32
  %flag_set = icmp ne i8 %flag, 0
  br i1 %flag_set, label %flagpath, label %loop_tail

flagpath:
  %cnt_is_zero = icmp eq i64 %cnt, 0
  br i1 %cnt_is_zero, label %ret0, label %dec_and_continue

dec_and_continue:
  %cnt_dec = add i64 %cnt, -1
  br label %loop_tail

loop_tail:
  %cnt_next = phi i64 [ %cnt, %loop ], [ %cnt_dec, %dec_and_continue ]
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}