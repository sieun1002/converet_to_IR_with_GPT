; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)
@off_1400043C0 = external global i8*

define i8* @sub_1400021B0(i8* %arg) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %check_mz

check_mz:
  %baseptr = load i8*, i8** @off_1400043C0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %ret_zero

after_mz:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %baseptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr
  %lfanew64 = sext i32 %lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %baseptr, i64 %lfanew64
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_zero

check_optmagic:
  %optmagic_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr_i8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr
  %is_64 = icmp eq i16 %optmagic, 523
  br i1 %is_64, label %check_nsects, label %ret_zero

check_nsects:
  %nsects_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %nsects_ptr = bitcast i8* %nsects_ptr_i8 to i16*
  %nsects16 = load i16, i16* %nsects_ptr
  %is_zero = icmp eq i16 %nsects16, 0
  br i1 %is_zero, label %ret_zero, label %prep_loop

prep_loop:
  %optsize_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 20
  %optsize_ptr = bitcast i8* %optsize_ptr_i8 to i16*
  %optsize16 = load i16, i16* %optsize_ptr
  %optsize64 = zext i16 %optsize16 to i64
  %sec_off = add i64 %optsize64, 24
  %sec_ptr0 = getelementptr inbounds i8, i8* %pehdr, i64 %sec_off
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_cont ]
  %sec_ptr = phi i8* [ %sec_ptr0, %prep_loop ], [ %sec_ptr_next, %loop_cont ]
  %call2 = call i32 @sub_140002708(i8* %sec_ptr, i8* %arg, i32 8)
  %is_zero2 = icmp eq i32 %call2, 0
  br i1 %is_zero2, label %ret_secptr, label %loop_cont

loop_cont:
  %i_next = add i32 %i, 1
  %sec_ptr_next = getelementptr inbounds i8, i8* %sec_ptr, i64 40
  %nsects16_l = load i16, i16* %nsects_ptr
  %nsects32_l = zext i16 %nsects16_l to i32
  %cmp_jb = icmp ult i32 %i_next, %nsects32_l
  br i1 %cmp_jb, label %loop, label %ret_zero

ret_secptr:
  ret i8* %sec_ptr

ret_zero:
  ret i8* null
}