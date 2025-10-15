; ModuleID = 'pe_section_find'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare dllimport i64 @strlen(i8* noundef)
declare dllimport i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002650(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt_8 = icmp ugt i64 %len, 8
  br i1 %len_gt_8, label %ret_null, label %check_mz

ret_null:
  ret i8* null

check_mz:
  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %have_mz, label %ret_null

have_mz:
  %e_lfanew_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_p = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p, align 4
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew64
  %sig_p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_p, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_p = bitcast i8* %magic_i8 to i16*
  %magic = load i16, i16* %magic_p, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_num, label %ret_null

check_num:
  %num_i8 = getelementptr i8, i8* %nt, i64 6
  %num_p = bitcast i8* %num_i8 to i16*
  %num = load i16, i16* %num_p, align 2
  %num_is_zero = icmp eq i16 %num, 0
  br i1 %num_is_zero, label %ret_null, label %prep_loop

prep_loop:
  %soh_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_p = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_p, align 2
  %soh64 = zext i16 %soh16 to i64
  %off = add i64 %soh64, 24
  %sec0 = getelementptr i8, i8* %nt, i64 %off
  %num32 = zext i16 %num to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i.next, %cont ]
  %cur = phi i8* [ %sec0, %prep_loop ], [ %cur.next, %cont ]
  %cmpret = call i32 @strncmp(i8* %cur, i8* %str, i64 8)
  %eq = icmp eq i32 %cmpret, 0
  br i1 %eq, label %ret_match, label %cont

cont:
  %i.next = add i32 %i, 1
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ult i32 %i.next, %num32
  br i1 %more, label %loop, label %ret_null

ret_match:
  ret i8* %cur
}