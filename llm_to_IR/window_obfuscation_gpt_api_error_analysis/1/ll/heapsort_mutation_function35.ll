; ModuleID = 'sub_140002920.ll'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct.__crt_locale_data = type opaque

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64 noundef, %struct._iobuf* noundef, i8* noundef, %struct.__crt_locale_data* noundef, i8* noundef)

define dso_local i32 @sub_140002920(%struct._iobuf* noundef %stream, i8* noundef %format, i8* noundef %arglist) local_unnamed_addr #0 {
entry:
  %0 = call i64* @sub_140002A10()
  %1 = load i64, i64* %0, align 8
  %2 = call i32 @__stdio_common_vfprintf(i64 noundef %1, %struct._iobuf* noundef %stream, i8* noundef %format, %struct.__crt_locale_data* noundef null, i8* noundef %arglist)
  ret i32 %2
}

attributes #0 = { nounwind willreturn uwtable "min-legal-vector-width"="0" }