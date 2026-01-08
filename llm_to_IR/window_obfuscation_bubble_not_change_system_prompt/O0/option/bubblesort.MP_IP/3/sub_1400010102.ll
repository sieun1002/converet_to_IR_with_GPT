; ModuleID = 'sub_140001010'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@dword_140007008 = external global i32
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_140004460 = external global i8**
@off_140004490 = external global i8*
@off_1400044A0 = external global i8*

declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32)
declare i8* @sub_140002660()
declare void @sub_140002880(i32, i8*, i8*)
declare void @sub_140001520()
declare void @sub_1400018D0()
declare i8* @sub_140504827(i8*)
declare void @sub_140002790(void ()*)
declare void @sub_140002120()
declare i8* @sub_140002778(i32)
declare i8* @sub_140002700(i8*)
declare i8* @sub_1400027F8(i8*)
declare void @sub_140002780(i8*, i8*)

declare void @nullsub_1()
declare void @sub_140001CB0()
declare void @loc_14000274D()
declare void @loc_1400027B5()

define i32 @sub_140001010() {
entry:
  %stackBase = call i64 asm sideeffect inteldialect "mov eax, 48; mov rax, qword ptr gs:[rax]; mov rax, qword ptr [rax+8]", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %pLockPtr.addr = load i64*, i64** @off_140004470
  %sleep.raw = load i8*, i8** @qword_140008280
  br label %lock_loop

lock_loop:
  %cmpx = cmpxchg i64* %pLockPtr.addr, i64 0, i64 %stackBase monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpx, 0
  %succ = extractvalue { i64, i1 } %cmpx, 1
  br i1 %succ, label %acquired, label %cmp_old

cmp_old:
  %selfhold = icmp eq i64 %old, %stackBase
  br i1 %selfhold, label %reentrant, label %sleep_then

reentrant:
  br label %post_lock

sleep_then:
  %sleep.fn = bitcast i8* %sleep.raw to void (i32)*
  call void %sleep.fn(i32 1000)
  br label %lock_loop

acquired:
  br label %post_lock

post_lock:
  %reent.phi = phi i1 [ true, %reentrant ], [ false, %acquired ]
  %state.ptr = load i32*, i32** @off_140004480
  %state.v1 = load i32, i32* %state.ptr
  %is1 = icmp eq i32 %state.v1, 1
  br i1 %is1, label %state_is_1, label %check_zero

state_is_1:
  %r31 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %r31)
  unreachable

check_zero:
  %state.v2 = load i32, i32* %state.ptr
  %is0 = icmp eq i32 %state.v2, 0
  br i1 %is0, label %init_path, label %set_flag_7004

set_flag_7004:
  store i32 1, i32* @dword_140007004
  br label %after_init

init_path:
  store i32 1, i32* %state.ptr
  call void @sub_1400018D0()
  %cb.ptr = bitcast void ()* @sub_140001CB0 to i8*
  %rax1 = call i8* @sub_140504827(i8* %cb.ptr)
  %dest.slot = load i8**, i8*** @off_140004460
  store i8* %rax1, i8** %dest.slot
  call void @sub_140002790(void ()* @nullsub_1)
  call void @sub_140002120()
  %pA = load i32*, i32** @off_140004430
  store i32 1, i32* %pA
  %pB = load i32*, i32** @off_140004440
  store i32 1, i32* %pB
  %pC = load i32*, i32** @off_140004450
  store i32 1, i32* %pC
  %img.base = load i8*, i8** @off_1400043C0
  %mz.ptr = bitcast i8* %img.base to i16*
  %mz = load i16, i16* %mz.ptr
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe, label %store_ecx0

check_pe:
  %lfanew.ptr = getelementptr i8, i8* %img.base, i32 60
  %lfanew.i8 = bitcast i8* %lfanew.ptr to i32*
  %lfanew = load i32, i32* %lfanew.i8
  %nthdr = getelementptr i8, i8* %img.base, i32 %lfanew
  %sig.ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig.ptr
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_magic, label %store_ecx0

check_magic:
  %om.ptr = getelementptr i8, i8* %nthdr, i32 24
  %om16 = bitcast i8* %om.ptr to i16*
  %magic = load i16, i16* %om16
  %is32 = icmp eq i16 %magic, 267
  %is64 = icmp eq i16 %magic, 523
  br i1 %is32, label %pe32_path, label %maybe64

maybe64:
  br i1 %is64, label %pe64_path, label %store_ecx0

pe32_path:
  %szdir32.ptr = getelementptr i8, i8* %nthdr, i32 116
  %szdir32.i32 = bitcast i8* %szdir32.ptr to i32*
  %szdir32 = load i32, i32* %szdir32.i32
  %hasdir32 = icmp ugt i32 %szdir32, 14
  br i1 %hasdir32, label %read_dir32, label %store_ecx0

read_dir32:
  %cfg32.ptr = getelementptr i8, i8* %nthdr, i32 232
  %cfg32.i32 = bitcast i8* %cfg32.ptr to i32*
  %cfg32 = load i32, i32* %cfg32.i32
  %nz32 = icmp ne i32 %cfg32, 0
  br label %store_ecx_from_flag

pe64_path:
  %szdir64.ptr = getelementptr i8, i8* %nthdr, i32 132
  %szdir64.i32 = bitcast i8* %szdir64.ptr to i32*
  %szdir64 = load i32, i32* %szdir64.i32
  %hasdir64 = icmp ugt i32 %szdir64, 14
  br i1 %hasdir64, label %read_dir64, label %store_ecx0

read_dir64:
  %cfg64.ptr = getelementptr i8, i8* %nthdr, i32 248
  %cfg64.i32 = bitcast i8* %cfg64.ptr to i32*
  %cfg64 = load i32, i32* %cfg64.i32
  %nz64 = icmp ne i32 %cfg64, 0
  br label %store_ecx_from_flag

store_ecx_from_flag:
  %nzphi = phi i1 [ %nz32, %read_dir32 ], [ %nz64, %read_dir64 ]
  %ecx.from.flag = zext i1 %nzphi to i32
  br label %after_pe_check

store_ecx0:
  br label %after_pe_check

after_pe_check:
  %ecx.final = phi i32 [ 0, %store_ecx0 ], [ %ecx.from.flag, %store_ecx_from_flag ]
  store i32 %ecx.final, i32* @dword_140007008
  %flag.ptr = load i32*, i32** @off_140004420
  %r8d = load i32, i32* %flag.ptr
  %r8nz = icmp ne i32 %r8d, 0
  br i1 %r8nz, label %path_1338, label %path_11de

path_11de:
  %rax.2778.a = call i8* @sub_140002778(i32 1)
  br label %path_1347

path_1338:
  %rax.2778.b = call i8* @sub_140002778(i32 2)
  br label %path_1347

path_1347:
  %r13.val = phi i8* [ null, %path_11de ], [ null, %path_1338 ]
  %r12.val = phi i64 [ 0, %path_11de ], [ 0, %path_1338 ]
  %ofs = mul i64 %r12.val, 8
  %elt.ptr.i8 = getelementptr i8, i8* %r13.val, i64 %ofs
  %elt.ptr = bitcast i8* %elt.ptr.i8 to i8**
  store i8* null, i8** %elt.ptr
  %rdx.arg = load i8*, i8** @off_1400044A0
  %rcx.arg = load i8*, i8** @off_140004490
  store i8* %r13.val, i8** @qword_140007018
  call void @sub_140002780(i8* %rcx.arg, i8* %rdx.arg)
  call void @sub_140001520()
  store i32 2, i32* %state.ptr
  br label %after_init

after_init:
  br i1 %reent.phi, label %skip_unlock, label %do_unlock

do_unlock:
  %oldx = atomicrmw xchg i64* %pLockPtr.addr, i64 0 monotonic
  br label %after_unlock

skip_unlock:
  br label %after_unlock

after_unlock:
  %cb.slot = load i8*, i8** @off_1400043F0
  %cb.ptr2 = bitcast i8* %cb.slot to i8**
  %cb.fn.raw = load i8*, i8** %cb.ptr2
  %has.cb = icmp ne i8* %cb.fn.raw, null
  br i1 %has.cb, label %call_cb, label %after_cb

call_cb:
  %cb.fn = bitcast i8* %cb.fn.raw to void (i32, i32, i32)*
  call void %cb.fn(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  %ret.ptr = call i8* @sub_140002660()
  %r8v = load i8*, i8** @qword_140007010
  %ret.ptr.q = bitcast i8* %ret.ptr to i8**
  store i8* %r8v, i8** %ret.ptr.q
  %ecx.call = load i32, i32* @dword_140007020
  %rdx.call = load i8*, i8** @qword_140007018
  call void @sub_140002880(i32 %ecx.call, i8* %rdx.call, i8* %r8v)
  %ecx.chk = load i32, i32* @dword_140007008
  %nz = icmp ne i32 %ecx.chk, 0
  br i1 %nz, label %check_7004, label %do_27a0

do_27a0:
  call void @sub_1400027A0(i32 0)
  unreachable

check_7004:
  %v7004 = load i32, i32* @dword_140007004
  %iszero7004 = icmp eq i32 %v7004, 0
  br i1 %iszero7004, label %call_274D, label %ret_epilogue

call_274D:
  %base.int = ptrtoint void ()* @loc_14000274D to i64
  %plus3 = add i64 %base.int, 3
  %thunk = inttoptr i64 %plus3 to void ()*
  call void %thunk()
  br label %ret_epilogue

ret_epilogue:
  ret i32 0
}