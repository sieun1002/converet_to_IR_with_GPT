; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

declare i64 @sub_140002AC0()
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %param) {
entry:
  %call0 = call i64 @sub_140002AC0()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %mzcheck

ret_zero:
  ret i8* null

mzcheck:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %ismz = icmp eq i16 %mz, 23117
  br i1 %ismz, label %pehdr_calc, label %ret_zero

pehdr_calc:
  %o3c = getelementptr i8, i8* %baseptr, i64 60
  %o3c32p = bitcast i8* %o3c to i32*
  %e_lfanew = load i32, i32* %o3c32p, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sigp = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigp, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magicp_i8 = getelementptr i8, i8* %pehdr, i64 24
  %magicp = bitcast i8* %magicp_i8 to i16*
  %magic = load i16, i16* %magicp, align 1
  %is_64 = icmp eq i16 %magic, 523
  br i1 %is_64, label %check_numsecs, label %ret_zero

check_numsecs:
  %numsp_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsp = bitcast i8* %numsp_i8 to i16*
  %nums16 = load i16, i16* %numsp, align 1
  %is_zero = icmp eq i16 %nums16, 0
  br i1 %is_zero, label %ret_zero, label %calc_first_sect

calc_first_sect:
  %szopthdr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %szopthdr_p = bitcast i8* %szopthdr_i8 to i16*
  %sz16 = load i16, i16* %szopthdr_p, align 1
  %sz64 = zext i16 %sz16 to i64
  %after_filehdr = getelementptr i8, i8* %pehdr, i64 24
  %first_sect = getelementptr i8, i8* %after_filehdr, i64 %sz64
  %numsecs32 = zext i16 %nums16 to i32
  br label %loop

loop:
  %sectptr = phi i8* [ %first_sect, %calc_first_sect ], [ %next_sect, %cont ]
  %idx = phi i32 [ 0, %calc_first_sect ], [ %next_idx, %cont ]
  %callchk = call i32 @sub_140002AC8(i8* %sectptr, i8* %param, i32 8)
  %match = icmp eq i32 %callchk, 0
  br i1 %match, label %ret_found, label %cont

cont:
  %next_idx = add i32 %idx, 1
  %next_sect = getelementptr i8, i8* %sectptr, i64 40
  %more = icmp ult i32 %next_idx, %numsecs32
  br i1 %more, label %loop, label %ret_zero

ret_found:
  ret i8* %sectptr
}