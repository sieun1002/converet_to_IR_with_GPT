; ModuleID = 'dijkstra_modular.ll'
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

@RSP_2312_4145c678 = external global i64
@OF_2077_4145c630 = external global i8
@SF_2073_4145c630 = external global i8
@ZF_2071_4145c630 = external global i8
@AF_2069_4145c630 = external global i8
@PF_2067_4145c630 = external global i8
@CF_2065_4145c630 = external global i8
@RAX_2216_4145c678 = external global i64
@RSP_2312_41463c00 = external global i64*
@RCX_2248_4145c678 = external global i64
@RDI_2296_4145c678 = external global i64
@RBP_2328_4145c678 = external global i64
@RDX_2264_4145c660 = external global i32
@RSI_2280_4145c678 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_4013c0_min_index(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_4013c0:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64*, i64** @RSP_2312_41463c00, align 8
  %2 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %3 = add i64 %2, -8
  %4 = getelementptr i64, i64* %1, i32 -1
  store i64 %0, i64* %4, align 8
  store i64 %3, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  store i64 %3, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %5 = sub i64 %3, 8
  %6 = load i64, i64* @RDI_2296_4145c678, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %3, 16
  %9 = load i64, i64* @RSI_2280_4145c678, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %3, 20
  %12 = load i32, i32* @RDX_2264_4145c660, align 4
  %13 = inttoptr i64 %11 to i32*
  store i32 %12, i32* %13, align 4
  %14 = sub i64 %3, 24
  %15 = inttoptr i64 %14 to i32*
  store i32 -1, i32* %15, align 4
  %16 = sub i64 %3, 28
  %17 = inttoptr i64 %16 to i32*
  store i32 2147483647, i32* %17, align 4
  %18 = sub i64 %3, 32
  %19 = inttoptr i64 %18 to i32*
  store i32 0, i32* %19, align 4
  br label %inst_4013e4

inst_4013e4:                                      ; preds = %inst_40142a, %inst_4013c0
  %20 = load i32, i32* %19, align 4
  %21 = load i32, i32* %13, align 4
  %22 = sub i32 %20, %21
  %23 = icmp ugt i32 %21, %20
  %24 = zext i1 %23 to i8
  store i8 %24, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %25 = and i32 %22, 255
  %26 = call i32 @llvm.ctpop.i32(i32 %25) #2, !range !24
  %27 = trunc i32 %26 to i8
  %28 = and i8 %27, 1
  %29 = xor i8 %28, 1
  store i8 %29, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %30 = xor i32 %21, %20
  %31 = xor i32 %30, %22
  %32 = lshr i32 %31, 4
  %33 = trunc i32 %32 to i8
  %34 = and i8 %33, 1
  store i8 %34, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %35 = icmp eq i32 %22, 0
  %36 = zext i1 %35 to i8
  store i8 %36, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %37 = lshr i32 %22, 31
  %38 = trunc i32 %37 to i8
  store i8 %38, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %39 = lshr i32 %20, 31
  %40 = lshr i32 %21, 31
  %41 = xor i32 %40, %39
  %42 = xor i32 %37, %39
  %43 = add nuw nsw i32 %42, %41
  %44 = icmp eq i32 %43, 2
  %45 = zext i1 %44 to i8
  store i8 %45, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %46 = icmp eq i8 %38, 0
  %47 = xor i1 %46, %44
  br i1 %47, label %inst_40143d, label %inst_4013f0

inst_40142a:                                      ; preds = %inst_401416, %inst_401402, %inst_4013f0
  %48 = load i32, i32* %19, align 4
  %49 = add i32 1, %48
  store i32 %49, i32* %19, align 4
  br label %inst_4013e4

inst_40143d:                                      ; preds = %inst_4013e4
  %50 = load i32, i32* %15, align 4
  %51 = zext i32 %50 to i64
  store i64 %51, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %52 = load i64, i64* %4, align 8
  store i64 %52, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %53 = add i64 %2, 8
  store i64 %53, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %memory

inst_4013f0:                                      ; preds = %inst_4013e4
  %54 = load i64, i64* %10, align 8
  %55 = sext i32 %20 to i64
  store i64 %55, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %56 = mul i64 %55, 4
  %57 = add i64 %56, %54
  %58 = inttoptr i64 %57 to i32*
  %59 = load i32, i32* %58, align 4
  %60 = icmp eq i32 %59, 0
  %61 = zext i1 %60 to i8
  %62 = icmp eq i8 %61, 0
  br i1 %62, label %inst_40142a, label %inst_401402

inst_401402:                                      ; preds = %inst_4013f0
  %63 = load i64, i64* %7, align 8
  %64 = add i64 %56, %63
  %65 = inttoptr i64 %64 to i32*
  %66 = load i32, i32* %65, align 4
  %67 = load i32, i32* %17, align 4
  %68 = sub i32 %66, %67
  %69 = lshr i32 %68, 31
  %70 = trunc i32 %69 to i8
  %71 = lshr i32 %66, 31
  %72 = lshr i32 %67, 31
  %73 = xor i32 %72, %71
  %74 = xor i32 %69, %71
  %75 = add nuw nsw i32 %74, %73
  %76 = icmp eq i32 %75, 2
  %77 = icmp eq i8 %70, 0
  %78 = xor i1 %77, %76
  br i1 %78, label %inst_40142a, label %inst_401416

inst_401416:                                      ; preds = %inst_401402
  store i32 %66, i32* %17, align 4
  %79 = load i32, i32* %19, align 4
  store i32 %79, i32* %15, align 4
  br label %inst_40142a
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
