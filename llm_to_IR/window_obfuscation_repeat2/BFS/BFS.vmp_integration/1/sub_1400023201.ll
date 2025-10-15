; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external dso_local global i8*, align 8
@dword_140008260 = external dso_local global i32, align 4
@unk_140007100 = external dso_local global i8, align 1

declare dso_local void @sub_1400F0426(i8*)
declare dso_local i64 @sub_1403EF4AE()
declare dso_local void @loc_1403DA37E(i64)

define dso_local void @sub_140002320() {
entry:
  %0 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400F0426(i8* %0)
  ret void
}