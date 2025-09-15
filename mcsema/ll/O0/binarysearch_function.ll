; ModuleID = 'binarysearch.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu-elf"

%struct.State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint64v8_t }
%struct.uint64v8_t = type { [8 x i64] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [4 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.Memory = type opaque

@RSP_2312_4102a5b8 = external global i64
@OF_2077_4102a570 = external global i8
@SF_2073_4102a570 = external global i8
@ZF_2071_4102a570 = external global i8
@AF_2069_4102a570 = external global i8
@PF_2067_4102a570 = external global i8
@CF_2065_4102a570 = external global i8
@RAX_2216_4102a5b8 = external global i64
@RBP_2328_4102a5b8 = external global i64
@RDI_2296_4102a5b8 = external global i64
@RSI_2280_4102a5b8 = external global i64
@RDX_2264_4102a5b8 = external global i64
@RSP_2312_41031bc0 = external global i64*
@RDX_2264_4102a5a0 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1169_binary_search(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1169:
  %0 = load i32, i32* @RDX_2264_4102a5a0, align 4
  %1 = load i64, i64* @RBP_2328_4102a5b8, align 8
  %2 = load i64*, i64** @RSP_2312_41031bc0, align 8
  %3 = load i64, i64* @RSP_2312_4102a5b8, align 8, !tbaa !5
  %4 = add i64 %3, -8
  %5 = getelementptr i64, i64* %2, i32 -1
  store i64 %1, i64* %5, align 8
  store i64 %4, i64* @RSP_2312_4102a5b8, align 8, !tbaa !8
  store i64 %4, i64* @RBP_2328_4102a5b8, align 8, !tbaa !8
  %6 = sub i64 %4, 40
  %7 = load i64, i64* @RDI_2296_4102a5b8, align 8
  %8 = inttoptr i64 %6 to i64*
  store i64 %7, i64* %8, align 8
  %9 = sub i64 %4, 48
  %10 = load i64, i64* @RSI_2280_4102a5b8, align 8
  %11 = inttoptr i64 %9 to i64*
  store i64 %10, i64* %11, align 8
  %12 = sub i64 %4, 52
  %13 = inttoptr i64 %12 to i32*
  store i32 %0, i32* %13, align 4
  %14 = sub i64 %4, 24
  %15 = inttoptr i64 %14 to i64*
  store i64 0, i64* %15, align 8
  %16 = load i64, i64* %11, align 8
  %17 = sub i64 %4, 16
  %18 = inttoptr i64 %17 to i64*
  store i64 %16, i64* %18, align 8
  br label %inst_11d7

inst_120b:                                        ; preds = %inst_11eb, %inst_11e1
  store i64 -1, i64* @RAX_2216_4102a5b8, align 8, !tbaa !8
  br label %inst_1212

inst_1212:                                        ; preds = %inst_1205, %inst_120b
  %19 = load i64, i64* %5, align 8
  store i64 %19, i64* @RBP_2328_4102a5b8, align 8, !tbaa !8
  %20 = add i64 %3, 8
  store i64 %20, i64* @RSP_2312_4102a5b8, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_11d7:                                        ; preds = %inst_11c1, %inst_11cf, %inst_1169
  %21 = load i64, i64* %15, align 8
  %22 = load i64, i64* %18, align 8
  %23 = icmp ugt i64 %22, %21
  br i1 %23, label %inst_118e, label %inst_11e1

inst_11cf:                                        ; preds = %inst_118e
  store i64 %27, i64* %18, align 8
  br label %inst_11d7

inst_11c1:                                        ; preds = %inst_118e
  %24 = add i64 1, %27
  store i64 %24, i64* %15, align 8
  br label %inst_11d7

inst_118e:                                        ; preds = %inst_11d7
  %25 = sub i64 %22, %21
  %26 = lshr i64 %25, 1
  %27 = add i64 %26, %21
  %28 = sub i64 %4, 8
  %29 = inttoptr i64 %28 to i64*
  store i64 %27, i64* %29, align 8
  %30 = mul i64 %27, 4
  store i64 %30, i64* @RDX_2264_4102a5b8, align 8, !tbaa !8
  %31 = load i64, i64* %8, align 8
  %32 = add i64 %30, %31
  %33 = inttoptr i64 %32 to i32*
  %34 = load i32, i32* %33, align 4
  %35 = load i32, i32* %13, align 4
  %36 = sub i32 %35, %34
  %37 = icmp eq i32 %36, 0
  %38 = lshr i32 %36, 31
  %39 = trunc i32 %38 to i8
  %40 = lshr i32 %35, 31
  %41 = lshr i32 %34, 31
  %42 = xor i32 %40, %41
  %43 = xor i32 %38, %40
  %44 = add nuw nsw i32 %43, %42
  %45 = icmp eq i32 %44, 2
  %46 = icmp ne i8 %39, 0
  %47 = xor i1 %46, %45
  %48 = or i1 %37, %47
  br i1 %48, label %inst_11cf, label %inst_11c1

inst_11e1:                                        ; preds = %inst_11d7
  %49 = lshr i64 %21, 63
  %50 = load i64, i64* %11, align 8
  %51 = sub i64 %21, %50
  %52 = icmp ugt i64 %50, %21
  %53 = zext i1 %52 to i8
  store i8 %53, i8* @CF_2065_4102a570, align 1, !tbaa !10
  %54 = trunc i64 %51 to i32
  %55 = and i32 %54, 255
  %56 = call i32 @llvm.ctpop.i32(i32 %55) #2, !range !24
  %57 = trunc i32 %56 to i8
  %58 = and i8 %57, 1
  %59 = xor i8 %58, 1
  store i8 %59, i8* @PF_2067_4102a570, align 1, !tbaa !25
  %60 = xor i64 %50, %21
  %61 = xor i64 %60, %51
  %62 = lshr i64 %61, 4
  %63 = trunc i64 %62 to i8
  %64 = and i8 %63, 1
  store i8 %64, i8* @AF_2069_4102a570, align 1, !tbaa !26
  %65 = icmp eq i64 %51, 0
  %66 = zext i1 %65 to i8
  store i8 %66, i8* @ZF_2071_4102a570, align 1, !tbaa !27
  %67 = lshr i64 %51, 63
  %68 = trunc i64 %67 to i8
  store i8 %68, i8* @SF_2073_4102a570, align 1, !tbaa !28
  %69 = lshr i64 %50, 63
  %70 = xor i64 %69, %49
  %71 = xor i64 %67, %49
  %72 = add nuw nsw i64 %71, %70
  %73 = icmp eq i64 %72, 2
  %74 = zext i1 %73 to i8
  store i8 %74, i8* @OF_2077_4102a570, align 1, !tbaa !29
  %75 = icmp eq i8 %53, 0
  br i1 %75, label %inst_120b, label %inst_11eb

inst_11eb:                                        ; preds = %inst_11e1
  %76 = mul i64 %21, 4
  store i64 %76, i64* @RDX_2264_4102a5b8, align 8, !tbaa !8
  %77 = load i64, i64* %8, align 8
  %78 = add i64 %76, %77
  %79 = inttoptr i64 %78 to i32*
  %80 = load i32, i32* %79, align 4
  %81 = load i32, i32* %13, align 4
  %82 = sub i32 %81, %80
  %83 = icmp ult i32 %81, %80
  %84 = zext i1 %83 to i8
  store i8 %84, i8* @CF_2065_4102a570, align 1, !tbaa !10
  %85 = and i32 %82, 255
  %86 = call i32 @llvm.ctpop.i32(i32 %85) #2, !range !24
  %87 = trunc i32 %86 to i8
  %88 = and i8 %87, 1
  %89 = xor i8 %88, 1
  store i8 %89, i8* @PF_2067_4102a570, align 1, !tbaa !25
  %90 = xor i32 %81, %80
  %91 = xor i32 %90, %82
  %92 = lshr i32 %91, 4
  %93 = trunc i32 %92 to i8
  %94 = and i8 %93, 1
  store i8 %94, i8* @AF_2069_4102a570, align 1, !tbaa !26
  %95 = icmp eq i32 %82, 0
  %96 = zext i1 %95 to i8
  store i8 %96, i8* @ZF_2071_4102a570, align 1, !tbaa !27
  %97 = lshr i32 %82, 31
  %98 = trunc i32 %97 to i8
  store i8 %98, i8* @SF_2073_4102a570, align 1, !tbaa !28
  %99 = lshr i32 %81, 31
  %100 = lshr i32 %80, 31
  %101 = xor i32 %99, %100
  %102 = xor i32 %97, %99
  %103 = add nuw nsw i32 %102, %101
  %104 = icmp eq i32 %103, 2
  %105 = zext i1 %104 to i8
  store i8 %105, i8* @OF_2077_4102a570, align 1, !tbaa !29
  %106 = icmp eq i8 %96, 0
  br i1 %106, label %inst_120b, label %inst_1205

inst_1205:                                        ; preds = %inst_11eb
  store i64 %21, i64* @RAX_2216_4102a5b8, align 8, !tbaa !8
  br label %inst_1212
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!"base.helper.semantics"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"long", !6, i64 0}
!10 = !{!11, !6, i64 2065}
!11 = !{!"_ZTS5State", !6, i64 16, !12, i64 2064, !6, i64 2080, !13, i64 2088, !15, i64 2112, !17, i64 2208, !18, i64 2480, !19, i64 2608, !20, i64 2736, !6, i64 2760, !6, i64 2768, !21, i64 3280}
!12 = !{!"_ZTS10ArithFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!13 = !{!"_ZTS8Segments", !14, i64 0, !6, i64 2, !14, i64 4, !6, i64 6, !14, i64 8, !6, i64 10, !14, i64 12, !6, i64 14, !14, i64 16, !6, i64 18, !14, i64 20, !6, i64 22}
!14 = !{!"short", !6, i64 0}
!15 = !{!"_ZTS12AddressSpace", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88}
!16 = !{!"_ZTS3Reg", !6, i64 0}
!17 = !{!"_ZTS3GPR", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88, !9, i64 96, !16, i64 104, !9, i64 112, !16, i64 120, !9, i64 128, !16, i64 136, !9, i64 144, !16, i64 152, !9, i64 160, !16, i64 168, !9, i64 176, !16, i64 184, !9, i64 192, !16, i64 200, !9, i64 208, !16, i64 216, !9, i64 224, !16, i64 232, !9, i64 240, !16, i64 248, !9, i64 256, !16, i64 264}
!18 = !{!"_ZTS8X87Stack", !6, i64 0}
!19 = !{!"_ZTS3MMX", !6, i64 0}
!20 = !{!"_ZTS14FPUStatusFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !6, i64 16, !6, i64 17, !6, i64 18, !6, i64 19, !6, i64 20}
!21 = !{!"_ZTS13SegmentCaches", !22, i64 0, !22, i64 16, !22, i64 32, !22, i64 48, !22, i64 64, !22, i64 80}
!22 = !{!"_ZTS13SegmentShadow", !6, i64 0, !23, i64 8, !23, i64 12}
!23 = !{!"int", !6, i64 0}
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
