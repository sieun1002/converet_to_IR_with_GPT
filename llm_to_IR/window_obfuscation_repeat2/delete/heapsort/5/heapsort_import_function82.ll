; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

@off_1400043B0 = external dso_local global i8*, align 8
@off_1400043C0 = external dso_local global i8*, align 8
@off_1400043A0 = external dso_local global i8*, align 8

declare dso_local i32 @sub_140002690()
declare dso_local i64 @sub_1400028E0(i64)

define dso_local void @sub_140001CA0() {
entry:
  %v0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %v0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %call_sz = call i32 @sub_140002690()
  %sz64 = sext i32 %call_sz to i64
  %mul5 = mul i64 %sz64, 5
  %mul8 = shl i64 %mul5, 3
  %add15 = add i64 %mul8, 15
  %align16 = and i64 %add15, -16
  %probed = call i64 @sub_1400028E0(i64 %align16)
  %stack = alloca i8, i64 %probed, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %stack, i8** @qword_1400070A8, align 8
  %endptr_g = load i8*, i8** @off_1400043B0, align 8
  %startptr_g = load i8*, i8** @off_1400043C0, align 8
  %endint = ptrtoint i8* %endptr_g to i64
  %startint = ptrtoint i8* %startptr_g to i64
  %diff = sub i64 %endint, %startint
  %cmp_len = icmp sgt i64 %diff, 7
  br i1 %cmp_len, label %cont, label %ret

cont:
  %cmp_big = icmp sgt i64 %diff, 11
  br i1 %cmp_big, label %d33, label %eb8

d33:
  br label %ret

eb8:
  br label %ret

ret:
  ret void
}