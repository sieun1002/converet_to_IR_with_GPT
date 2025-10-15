; ModuleID = 'sub_140002570'
source_filename = "sub_140002570.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* noundef %name) {
entry:
  %len = call i64 @strlen(i8* noundef %name)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %fail, label %check_dos

fail:
  ret i8* null

check_dos:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %get_nt, label %fail

get_nt:
  %e_lfanew_p8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_p32 = bitcast i8* %e_lfanew_p8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %sig_p32 = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_p32, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %magic_p8 = getelementptr i8, i8* %nt, i64 24
  %magic_p16 = bitcast i8* %magic_p8 to i16*
  %magic = load i16, i16* %magic_p16, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %fail

check_sections:
  %nsec_p8 = getelementptr i8, i8* %nt, i64 6
  %nsec_p16 = bitcast i8* %nsec_p8 to i16*
  %nsec16 = load i16, i16* %nsec_p16, align 1
  %nsec_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_zero, label %fail, label %setup_loop

setup_loop:
  %soh_p8 = getelementptr i8, i8* %nt, i64 20
  %soh_p16 = bitcast i8* %soh_p8 to i16*
  %soh16 = load i16, i16* %soh_p16, align 1
  %soh64 = zext i16 %soh16 to i64
  %sect_base_tmp = getelementptr i8, i8* %nt, i64 24
  %sect_base = getelementptr i8, i8* %sect_base_tmp, i64 %soh64
  br label %loop

loop:
  %i = phi i32 [ 0, %setup_loop ], [ %i_next, %loop_cont ]
  %sect = phi i8* [ %sect_base, %setup_loop ], [ %sect_next, %loop_cont ]
  %cmpres = call i32 @strncmp(i8* noundef %sect, i8* noundef %name, i64 noundef 8)
  %match = icmp eq i32 %cmpres, 0
  br i1 %match, label %found, label %loop_cont

found:
  ret i8* %sect

loop_cont:
  %nsec32 = zext i16 %nsec16 to i32
  %i_next = add i32 %i, 1
  %sect_next = getelementptr i8, i8* %sect, i64 40
  %more = icmp ult i32 %i_next, %nsec32
  br i1 %more, label %loop, label %fail
}