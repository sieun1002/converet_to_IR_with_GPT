; ModuleID = 'pe_section_lookup'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %fail, label %load_base

load_base:
  %baseptr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %nt_offset, label %fail

nt_offset:
  %offs_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %offs_ptr = bitcast i8* %offs_ptr_i8 to i32*
  %off32 = load i32, i32* %offs_ptr, align 1
  %off64 = sext i32 %off32 to i64
  %nt_hdr = getelementptr i8, i8* %baseptr, i64 %off64
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %chk_magic, label %fail

chk_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %chk_numsec, label %fail

chk_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %fail, label %prep_loop

prep_loop:
  %optsize_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %optsize_ptr = bitcast i8* %optsize_ptr_i8 to i16*
  %optsize16 = load i16, i16* %optsize_ptr, align 1
  %optsize64 = zext i16 %optsize16 to i64
  %sec_after_opt = getelementptr i8, i8* %nt_hdr, i64 %optsize64
  %first_sec = getelementptr i8, i8* %sec_after_opt, i64 24
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %prep_loop ], [ %next_sec, %loop_next ]
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_next ]
  %call = call i32 @strncmp(i8* %cur, i8* %str, i64 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %found, label %loop_next

loop_next:
  %i_next = add i32 %i, 1
  %next_sec = getelementptr i8, i8* %cur, i64 40
  %i_next_lt = icmp ult i32 %i_next, %numsec32
  br i1 %i_next_lt, label %loop, label %fail

found:
  ret i8* %cur

fail:
  ret i8* null
}