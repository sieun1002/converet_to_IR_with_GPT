; ModuleID = 'pe_section_find.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0(i8* noundef) local_unnamed_addr
declare i32 @sub_140002AC8(i8* noundef, i8* noundef, i64 noundef) local_unnamed_addr

define i8* @sub_140002570(i8* noundef %name) local_unnamed_addr {
entry:
  %len = call i64 @sub_140002AC0(i8* noundef %name)
  %len_ok = icmp ule i64 %len, 8
  br i1 %len_ok, label %mzcheck, label %ret_zero

mzcheck:
  %base_ptr.ld = load i8*, i8** @off_1400043A0, align 8
  %mzptr.bc = bitcast i8* %base_ptr.ld to i16*
  %mzsig = load i16, i16* %mzptr.bc, align 2
  %is_mz = icmp eq i16 %mzsig, 23117
  br i1 %is_mz, label %ntcalc, label %ret_zero

ntcalc:
  %lfanew.ptr = getelementptr inbounds i8, i8* %base_ptr.ld, i64 60
  %lfanew.i32p = bitcast i8* %lfanew.ptr to i32*
  %lfanew32 = load i32, i32* %lfanew.i32p, align 4
  %lfanew64 = sext i32 %lfanew32 to i64
  %nthdr = getelementptr inbounds i8, i8* %base_ptr.ld, i64 %lfanew64
  %pesig.p = bitcast i8* %nthdr to i32*
  %pesig = load i32, i32* %pesig.p, align 4
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %optmagic.p0 = getelementptr inbounds i8, i8* %nthdr, i64 24
  %optmagic.p = bitcast i8* %optmagic.p0 to i16*
  %optmagic = load i16, i16* %optmagic.p, align 2
  %is_pe32p = icmp eq i16 %optmagic, 523
  br i1 %is_pe32p, label %check_num, label %ret_zero

check_num:
  %numsec.p0 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec.p = bitcast i8* %numsec.p0 to i16*
  %numsec16 = load i16, i16* %numsec.p, align 2
  %num_is_zero = icmp eq i16 %numsec16, 0
  br i1 %num_is_zero, label %ret_zero, label %sect_start

sect_start:
  %szopt.p0 = getelementptr inbounds i8, i8* %nthdr, i64 20
  %szopt.p = bitcast i8* %szopt.p0 to i16*
  %szopt16 = load i16, i16* %szopt.p, align 2
  %szopt32 = zext i16 %szopt16 to i32
  %szopt64 = zext i32 %szopt32 to i64
  %sect.off = add i64 %szopt64, 24
  %sect.base = getelementptr inbounds i8, i8* %nthdr, i64 %sect.off
  br label %loop

loop:
  %rbx.cur = phi i8* [ %sect.base, %sect_start ], [ %rbx.next, %loop_cont ]
  %idx.cur = phi i32 [ 0, %sect_start ], [ %idx.next, %loop_cont ]
  %cmpcall = call i32 @sub_140002AC8(i8* noundef %rbx.cur, i8* noundef %name, i64 noundef 8)
  %is_zero = icmp eq i32 %cmpcall, 0
  br i1 %is_zero, label %found, label %loop_cont

loop_cont:
  %numsec16.l = load i16, i16* %numsec.p, align 2
  %numsec32 = zext i16 %numsec16.l to i32
  %idx.next = add i32 %idx.cur, 1
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 40
  %cont = icmp ult i32 %idx.next, %numsec32
  br i1 %cont, label %loop, label %ret_zero

found:
  ret i8* %rbx.cur

ret_zero:
  ret i8* null
}