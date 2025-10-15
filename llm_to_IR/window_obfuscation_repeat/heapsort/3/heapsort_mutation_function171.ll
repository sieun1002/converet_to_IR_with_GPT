; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)
declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8* noundef)
declare i32 @sub_140001AD0(i8* noundef, ...)

@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*, align 8

@dword_1400070A0 = internal global i32 0, align 4
@dword_1400070A4 = internal global i32 0, align 4
@qword_1400070A8 = internal global i8* null, align 8

@off_1400043B0 = internal global i8* null, align 8
@off_1400043C0 = internal global i8* null, align 8
@off_1400043A0 = internal global i8* null, align 8

@aUnknownPseudoR = private unnamed_addr constant [38 x i8] c"Unknown pseudo relocation bit size %d\00", align 1
@aDBitPseudoRelo = private unnamed_addr constant [44 x i8] c"%d bit pseudo relocation at %p out of range\00", align 1
@aUnknownPseudoR_0 = private unnamed_addr constant [46 x i8] c"Unknown pseudo relocation protocol version %d\00", align 1

define void @sub_140001CA0() {
entry:
  %v0 = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %v0, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %t0 = call i32 @sub_140002690()
  %t1 = sext i32 %t0 to i64
  %t2 = call i64 @sub_1400028E0()
  %start = load i8*, i8** @off_1400043C0, align 8
  %end = load i8*, i8** @off_1400043B0, align 8
  %cmp = icmp ugt i8* %end, %start
  br i1 %cmp, label %process, label %ret

process:
  %fmtptr = getelementptr inbounds [38 x i8], [38 x i8]* @aUnknownPseudoR, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @sub_140001AD0(i8* %fmtptr, i32 8)
  %vp_gptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %vp_isnull = icmp eq i32 (i8*, i64, i32, i32*)* %vp_gptr, null
  br i1 %vp_isnull, label %ret, label %callvp

callvp:
  %oldprot = alloca i32, align 4
  store i32 0, i32* %oldprot, align 4
  %vres = call i32 %vp_gptr(i8* null, i64 0, i32 0, i32* %oldprot)
  br label %ret

ret:
  ret void
}