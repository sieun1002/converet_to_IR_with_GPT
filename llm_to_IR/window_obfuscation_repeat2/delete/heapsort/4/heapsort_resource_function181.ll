; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i8* null, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)

declare i64 @VirtualQuery(i8*, i8*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %0) {
entry:
  %buf = alloca [48 x i8], align 8
  %1 = load i32, i32* @dword_1400070A4, align 4
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %preloop, label %loc_140001C60

preloop:
  %3 = load i8*, i8** @qword_1400070A8, align 8
  %4 = getelementptr i8, i8* %3, i64 24
  br label %loc_140001B60

loc_140001B60:
  %5 = phi i8* [ %4, %preloop ], [ %15, %loc_140001B7B ]
  %6 = phi i32 [ 0, %preloop ], [ %14, %loc_140001B7B ]
  %7 = bitcast i8* %5 to i8**
  %8 = load i8*, i8** %7, align 8
  %9 = ptrtoint i8* %0 to i64
  %10 = ptrtoint i8* %8 to i64
  %11 = icmp ult i64 %9, %10
  br i1 %11, label %loc_140001B7B, label %loc_140001B68

loc_140001B68:
  %12 = getelementptr i8, i8* %5, i64 8
  %13 = bitcast i8* %12 to i8**
  %14load = load i8*, i8** %13, align 8
  %14ptr = getelementptr i8, i8* %14load, i64 8
  %14cast = bitcast i8* %14ptr to i32*
  %14val = load i32, i32* %14cast, align 4
  %14z = zext i32 %14val to i64
  %sum = add i64 %10, %14z
  %inrange = icmp ult i64 %9, %sum
  br i1 %inrange, label %loc_140001C05, label %loc_140001B7B

loc_140001B7B:
  %14 = add i32 %6, 1
  %15 = getelementptr i8, i8* %5, i64 40
  %16 = icmp ne i32 %14, %1
  br i1 %16, label %loc_140001B60, label %loc_140001B88

loc_140001C60:
  br label %loc_140001B88

loc_140001B88:
  %count.sel = phi i32 [ 0, %loc_140001C60 ], [ %1, %loc_140001B7B ]
  %17 = call i8* @sub_140002610(i8* %0)
  %18 = icmp eq i8* %17, null
  br i1 %18, label %loc_140001C82, label %loc_after_rdi

loc_140001C82:
  %fmt3 = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3, i8* %0)
  br label %loc_140001C05

loc_after_rdi:
  %19 = sext i32 %count.sel to i64
  %20 = mul nsw i64 %19, 5
  %21 = shl i64 %20, 3
  %22 = load i8*, i8** @qword_1400070A8, align 8
  %entryptr = getelementptr i8, i8* %22, i64 %21
  %off20 = getelementptr i8, i8* %entryptr, i64 32
  %off20p = bitcast i8* %off20 to i8**
  store i8* %17, i8** %off20p, align 8
  %off0 = bitcast i8* %entryptr to i32*
  store i32 0, i32* %off0, align 4
  %23 = call i8* @sub_140002750()
  %rdi_plus_c = getelementptr i8, i8* %17, i64 12
  %rdi_plus_c_i32 = bitcast i8* %rdi_plus_c to i32*
  %offC = load i32, i32* %rdi_plus_c_i32, align 4
  %offC64 = sext i32 %offC to i64
  %target = getelementptr i8, i8* %23, i64 %offC64
  %buf_i8 = bitcast [48 x i8]* %buf to i8*
  %off18 = getelementptr i8, i8* %entryptr, i64 24
  %off18p = bitcast i8* %off18 to i8**
  store i8* %target, i8** %off18p, align 8
  %vq = call i64 @VirtualQuery(i8* %target, i8* %buf_i8, i64 48)
  %vqz = icmp eq i64 %vq, 0
  br i1 %vqz, label %loc_140001C67, label %after_vq

loc_140001C67:
  %rdi_plus_8 = getelementptr i8, i8* %17, i64 8
  %rdi_plus_8_i32 = bitcast i8* %rdi_plus_8 to i32*
  %bytes = load i32, i32* %rdi_plus_8_i32, align 4
  %fmt2 = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %off18r = getelementptr i8, i8* %entryptr, i64 24
  %off18rp = bitcast i8* %off18r to i8**
  %addrstored = load i8*, i8** %off18rp, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2, i32 %bytes, i8* %addrstored)
  br label %loc_140001C05

after_vq:
  %prot_ptr_i8 = getelementptr i8, i8* %buf_i8, i64 36
  %prot_ptr = bitcast i8* %prot_ptr_i8 to i32*
  %prot = load i32, i32* %prot_ptr, align 4
  %sub4 = add i32 %prot, -4
  %mask1 = and i32 %sub4, -5
  %iszero1 = icmp eq i32 %mask1, 0
  br i1 %iszero1, label %loc_140001BFE, label %test2

test2:
  %sub64 = add i32 %prot, -64
  %mask2 = and i32 %sub64, -65
  %nz = icmp ne i32 %mask2, 0
  br i1 %nz, label %loc_140001C10, label %loc_140001BFE

loc_140001C10:
  %is_ro = icmp eq i32 %prot, 2
  %newprot = select i1 %is_ro, i32 4, i32 64
  %baseaddrp = bitcast i8* %buf_i8 to i8**
  %baseaddr = load i8*, i8** %baseaddrp, align 8
  %rs_ptr_i8 = getelementptr i8, i8* %buf_i8, i64 24
  %rs_ptr = bitcast i8* %rs_ptr_i8 to i64*
  %rs = load i64, i64* %rs_ptr, align 8
  %off8p = getelementptr i8, i8* %entryptr, i64 8
  %off8pp = bitcast i8* %off8p to i8**
  store i8* %baseaddr, i8** %off8pp, align 8
  %off16 = getelementptr i8, i8* %entryptr, i64 16
  %off16p = bitcast i8* %off16 to i64*
  store i64 %rs, i64* %off16p, align 8
  %oldprot_ptr = bitcast i8* %entryptr to i32*
  %vp = call i32 @VirtualProtect(i8* %baseaddr, i64 %rs, i32 %newprot, i32* %oldprot_ptr)
  %ok = icmp ne i32 %vp, 0
  br i1 %ok, label %loc_140001BFE, label %vp_fail

vp_fail:
  %gle = call i32 @GetLastError()
  %fmt1 = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1, i32 %gle)
  br label %loc_140001C60

loc_140001BFE:
  %24 = load i32, i32* @dword_1400070A4, align 4
  %25 = add i32 %24, 1
  store i32 %25, i32* @dword_1400070A4, align 4
  br label %loc_140001C05

loc_140001C05:
  ret void
}