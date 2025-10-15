; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_1400029C0(i8*, i8*)
declare void @sub_140002920(i8*, i8*, i8*)
declare void @abort() noreturn

define void @sub_140001AD0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %fmt.addr = alloca i8*, align 8
  %args = alloca [3 x i8*], align 8
  store i8* %rcx, i8** %fmt.addr, align 8
  %args.0.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 0
  store i8* %rdx, i8** %args.0.ptr, align 8
  %args.1.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 1
  store i8* %r8, i8** %args.1.ptr, align 8
  %args.2.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 2
  store i8* %r9, i8** %args.2.ptr, align 8
  %arglist.ptr = bitcast i8** %args.0.ptr to i8*
  %iob1 = call i8* @__acrt_iob_func(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(i8* %iob1, i8* %strptr)
  %iob2 = call i8* @__acrt_iob_func(i32 2)
  %fmt = load i8*, i8** %fmt.addr, align 8
  call void @sub_140002920(i8* %iob2, i8* %fmt, i8* %arglist.ptr)
  call void @abort()
  unreachable
}