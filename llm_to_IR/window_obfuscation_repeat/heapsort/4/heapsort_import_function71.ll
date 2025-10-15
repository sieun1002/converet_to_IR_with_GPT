; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A4 = global i32 0
@qword_1400070A8 = external global i8*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = private constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8*, i8*, i32)
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %addr) {
entry:
  %count.load = load i32, i32* @dword_1400070A4
  %has.entries = icmp sgt i32 %count.load, 0
  br i1 %has.entries, label %loop.setup, label %noentries

loop.setup:
  %baseptr.load = load i8*, i8** @qword_1400070A8
  %startptr.base = getelementptr i8, i8* %baseptr.load, i64 24
  br label %loop

loop:
  %i.phi = phi i32 [ 0, %loop.setup ], [ %i.next, %loop.next ]
  %i.zext = zext i32 %i.phi to i64
  %entry.off = mul i64 %i.zext, 40
  %cur.ptr = getelementptr i8, i8* %startptr.base, i64 %entry.off
  %cur.as.ptrptr = bitcast i8* %cur.ptr to i8**
  %start.load = load i8*, i8** %cur.as.ptrptr
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %start.load to i64
  %before.start = icmp ult i64 %addr.int, %start.int
  br i1 %before.start, label %loop.next, label %checkrange

checkrange:
  %p.loc = getelementptr i8, i8* %cur.ptr, i64 8
  %p.as.ptrptr = bitcast i8* %p.loc to i8**
  %p.load = load i8*, i8** %p.as.ptrptr
  %p.plus8 = getelementptr i8, i8* %p.load, i64 8
  %size.ptr = bitcast i8* %p.plus8 to i32*
  %size.load = load i32, i32* %size.ptr
  %size.z = zext i32 %size.load to i64
  %end.int = add i64 %start.int, %size.z
  %in.range = icmp ult i64 %addr.int, %end.int
  br i1 %in.range, label %ret, label %loop.next

loop.next:
  %i.next = add i32 %i.phi, 1
  %cont = icmp slt i32 %i.next, %count.load
  br i1 %cont, label %loop, label %postloop

noentries:
  br label %postloop

ret:
  ret void

postloop:
  %info.call = call i8* @sub_140002610(i8* %addr)
  %info.null = icmp eq i8* %info.call, null
  br i1 %info.null, label %error_no_image_section, label %have_info

have_info:
  %count.load.2 = load i32, i32* @dword_1400070A4
  %count.z.2 = zext i32 %count.load.2 to i64
  %entry.off.2 = mul i64 %count.z.2, 40
  %baseptr.load.2 = load i8*, i8** @qword_1400070A8
  %entry.base = getelementptr i8, i8* %baseptr.load.2, i64 %entry.off.2
  %field20.ptr = getelementptr i8, i8* %entry.base, i64 32
  %field20.as.ptrptr = bitcast i8* %field20.ptr to i8**
  store i8* %info.call, i8** %field20.as.ptrptr, align 8
  %dword0.ptr = bitcast i8* %entry.base to i32*
  store i32 0, i32* %dword0.ptr, align 4
  %base.calc = call i8* @sub_140002750()
  %size2.ptr = getelementptr i8, i8* %info.call, i64 12
  %size2.as.i32 = bitcast i8* %size2.ptr to i32*
  %size2.load = load i32, i32* %size2.as.i32
  %size2.z = zext i32 %size2.load to i64
  %end.ptr = getelementptr i8, i8* %base.calc, i64 %size2.z
  %field18.ptr = getelementptr i8, i8* %entry.base, i64 24
  %field18.as.ptrptr = bitcast i8* %field18.ptr to i8**
  store i8* %end.ptr, i8** %field18.as.ptrptr, align 8
  %mbi.alloc = alloca [48 x i8], align 8
  %mbi.as.i8 = bitcast [48 x i8]* %mbi.alloc to i8*
  %vq.res = call i64 @sub_14001FAD3(i8* %end.ptr, i8* %mbi.as.i8, i32 48)
  %vq.ok = icmp ne i64 %vq.res, 0
  br i1 %vq.ok, label %after_query, label %vquery_fail

vquery_fail:
  %baseptr.load.3 = load i8*, i8** @qword_1400070A8
  %entry.abs = getelementptr i8, i8* %baseptr.load.3, i64 %entry.off.2
  %field18.ptr.2 = getelementptr i8, i8* %entry.abs, i64 24
  %field18.as.ptrptr.2 = bitcast i8* %field18.ptr.2 to i8**
  %r8.load = load i8*, i8** %field18.as.ptrptr.2, align 8
  %size4.ptr = getelementptr i8, i8* %info.call, i64 8
  %size4.as.i32 = bitcast i8* %size4.ptr to i32*
  %size4.load = load i32, i32* %size4.as.i32
  %fmt.vq = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq, i32 %size4.load, i8* %r8.load)
  br label %ret

after_query:
  %old.count = load i32, i32* @dword_1400070A4
  %new.count = add i32 %old.count, 1
  store i32 %new.count, i32* @dword_1400070A4
  ret void

error_no_image_section:
  %fmt.noimg = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.noimg, i8* %addr)
  ret void
}