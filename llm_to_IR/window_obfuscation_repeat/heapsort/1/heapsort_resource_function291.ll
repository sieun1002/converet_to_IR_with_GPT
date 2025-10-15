; ModuleID = 'pe_section_finder'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare dso_local dllimport i64 @strlen(i8*) local_unnamed_addr
declare dso_local dllimport i32 @strncmp(i8*, i8*, i64) local_unnamed_addr

define dso_local i8* @sub_140002570(i8* noundef %str) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %str)
  %too_long = icmp ugt i64 %len, 8
  br i1 %too_long, label %fail, label %load_base

fail:
  ret i8* null

load_base:
  %base = load i8*, i8** @off_1400043A0, align 8
  %dos_ptr = bitcast i8* %base to i16*
  %dos = load i16, i16* %dos_ptr, align 1
  %is_mz = icmp eq i16 %dos, 23117
  br i1 %is_mz, label %read_pe, label %fail

read_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr i8, i8* %base, i64 %e_lfanew
  %pesig_ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %fail

check_opt:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_num, label %fail

check_num:
  %nsec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_is_zero, label %fail, label %setup

setup:
  %optsize_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %optsize_ptr = bitcast i8* %optsize_ptr_i8 to i16*
  %optsize16 = load i16, i16* %optsize_ptr, align 1
  %optsize = zext i16 %optsize16 to i64
  %sect_base_pre = getelementptr i8, i8* %pehdr, i64 24
  %sect_base = getelementptr i8, i8* %sect_base_pre, i64 %optsize
  %nsec = zext i16 %nsec16 to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %setup ], [ %i.next, %cont ]
  %cur = phi i8* [ %sect_base, %setup ], [ %cur.next, %cont ]
  %cmp = call i32 @strncmp(i8* %cur, i8* %str, i64 8)
  %is_match = icmp eq i32 %cmp, 0
  br i1 %is_match, label %success, label %cont

cont:
  %i.next = add i64 %i, 1
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ult i64 %i.next, %nsec
  br i1 %more, label %loop, label %fail

success:
  ret i8* %cur
}