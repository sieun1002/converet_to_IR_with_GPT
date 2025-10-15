; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002690() {
entry:
  %gptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %gptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_i8 = getelementptr inbounds i8, i8* %gptr, i64 60
  %e_lfanew_p = bitcast i8* %e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_p, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %gptr, i64 %e_lfanew64
  %sigp = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigp, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic_i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic_p = bitcast i8* %magic_i8 to i16*
  %magic = load i16, i16* %magic_p, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %read_sections, label %ret0

read_sections:
  %ns_i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %ns_p = bitcast i8* %ns_i8 to i16*
  %ns = load i16, i16* %ns_p, align 1
  %ns_z = zext i16 %ns to i32
  ret i32 %ns_z

ret0:
  ret i32 0
}