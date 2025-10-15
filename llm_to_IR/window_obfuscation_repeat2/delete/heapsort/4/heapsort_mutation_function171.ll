; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@off_1400043A0 = external global i8*, align 8
@__imp_VirtualProtect = external global i32 (i8*, i64, i32, i32*)*, align 8

@aUnknownPseudoR = private unnamed_addr constant [56 x i8] c"  Unknown pseudo relocation bit size %d in version %d.\0A\00", align 1
@aDBitPseudoRelo = private unnamed_addr constant [74 x i8] c"%d bit pseudo relocation at %p out of range: supported range is %p .. %p\0A\00", align 1
@aUnknownPseudoR_0 = private unnamed_addr constant [50 x i8] c"  Unknown pseudo relocation protocol version %d.\0A\00", align 1

declare i32 @sub_140002690()
declare void @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001CA0() {
entry:
  %initflag = load i32, i32* @dword_1400070A0, align 4
  %cmp_init = icmp ne i32 %initflag, 0
  br i1 %cmp_init, label %ret, label %do_init

do_init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_140002690()
  %n64 = sext i32 %n to i64
  %mul5 = mul i64 %n64, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %size = and i64 %add15, -16
  call void @sub_1400028E0()
  %endptr = load i8*, i8** @off_1400043B0, align 8
  %startptr = load i8*, i8** @off_1400043C0, align 8
  %endint = ptrtoint i8* %endptr to i64
  %startint = ptrtoint i8* %startptr to i64
  %diff = sub i64 %endint, %startint
  %alloc = alloca i8, i64 %size, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %buflocal = alloca i64, align 8
  %bufptr = bitcast i64* %buflocal to i8*
  store i8* %bufptr, i8** @qword_1400070A8, align 8
  %gt7 = icmp sgt i64 %diff, 7
  br i1 %gt7, label %checkB, label %ret

checkB:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %path_eb8, label %path_d33

path_d33:
  br label %ret

path_eb8:
  br label %ret

ret:
  ret void
}