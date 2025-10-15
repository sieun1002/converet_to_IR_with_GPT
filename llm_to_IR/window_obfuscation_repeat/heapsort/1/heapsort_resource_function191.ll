; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"
; A reasonable MSVC x64 datalayout
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; Globals observed in the disassembly
@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

@off_1400043A0 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8

; Import Address Table pointer for VirtualProtect (kernel32)
@__imp_VirtualProtect = external dso_local global i32 (i8*, i64, i32, i32*)*

; External functions that may be referenced in related code paths
declare dso_local i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

; Stub implementations for helpers referenced by the disassembly
define dso_local i64 @sub_140002690() local_unnamed_addr {
entry:
  ret i64 0
}

define dso_local void @sub_1400028E0(i64 noundef %size) local_unnamed_addr {
entry:
  ret void
}

define dso_local void @sub_140001B30(i8* noundef %ptr) local_unnamed_addr {
entry:
  ret void
}

define dso_local void @sub_140001AD0(i8* noundef %msg) local_unnamed_addr {
entry:
  ret void
}

; Main function from the provided disassembly (implemented as a safe stub)
define dso_local void @sub_140001CA0() local_unnamed_addr {
entry:
  ret void
}