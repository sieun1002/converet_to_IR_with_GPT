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

@__mcsema_reg_state = external thread_local(initialexec) global %struct.State
@data_401656 = external global i8
@data_40201d = external global i8
@data_40200d = external global i8
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
@RSI_2280_4145c660 = external global i32
@RDX_2264_4145c678 = external global i64
@RSI_2280_4145c678 = external global i64
@RAX_2216_4145c630 = external global i8
@RDI_2296_41463aa0 = external global i8*

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401640_print_distances(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401640:
  %0 = load i64, i64* @RBP_2328_4145c678, align 8
  %1 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %4 = sub i64 %2, 16
  store i64 %4, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %5 = sub i64 %2, 8
  %6 = load i64, i64* @RDI_2296_4145c678, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 12
  %9 = load i32, i32* @RSI_2280_4145c660, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = inttoptr i64 %4 to i32*
  store i32 0, i32* %11, align 4
  br label %inst_401656

inst_4016af:                                      ; preds = %inst_401677, %inst_401690
  %12 = phi %struct.Memory* [ %112, %inst_401690 ], [ %119, %inst_401677 ]
  %13 = load i64, i64* @RBP_2328_4145c678, align 8
  %14 = sub i64 %13, 16
  %15 = inttoptr i64 %14 to i32*
  %16 = load i32, i32* %15, align 4
  %17 = add i32 1, %16
  store i32 %17, i32* %15, align 4
  br label %inst_401656

inst_401656:                                      ; preds = %inst_4016af, %inst_401640
  %18 = phi %struct.Memory* [ %memory, %inst_401640 ], [ %12, %inst_4016af ]
  %19 = load i64, i64* @RBP_2328_4145c678, align 8
  %20 = sub i64 %19, 16
  %21 = inttoptr i64 %20 to i32*
  %22 = load i32, i32* %21, align 4
  %23 = zext i32 %22 to i64
  store i64 %23, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %24 = sub i64 %19, 12
  %25 = inttoptr i64 %24 to i32*
  %26 = load i32, i32* %25, align 4
  %27 = sub i32 %22, %26
  %28 = lshr i32 %27, 31
  %29 = trunc i32 %28 to i8
  %30 = lshr i32 %22, 31
  %31 = lshr i32 %26, 31
  %32 = xor i32 %31, %30
  %33 = xor i32 %28, %30
  %34 = add nuw nsw i32 %33, %32
  %35 = icmp eq i32 %34, 2
  %36 = icmp eq i8 %29, 0
  %37 = xor i1 %36, %35
  br i1 %37, label %inst_4016c2, label %inst_401662

inst_4016c2:                                      ; preds = %inst_401656
  %38 = load i64*, i64** @RSP_2312_41463c00, align 8
  %39 = load i64, i64* @RSP_2312_4145c678, align 8
  %40 = add i64 16, %39
  %41 = icmp ult i64 %40, %39
  %42 = icmp ult i64 %40, 16
  %43 = or i1 %41, %42
  %44 = zext i1 %43 to i8
  store i8 %44, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %45 = trunc i64 %40 to i32
  %46 = and i32 %45, 255
  %47 = call i32 @llvm.ctpop.i32(i32 %46) #3, !range !24
  %48 = trunc i32 %47 to i8
  %49 = and i8 %48, 1
  %50 = xor i8 %49, 1
  store i8 %50, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %51 = xor i64 16, %39
  %52 = xor i64 %51, %40
  %53 = lshr i64 %52, 4
  %54 = trunc i64 %53 to i8
  %55 = and i8 %54, 1
  store i8 %55, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %56 = icmp eq i64 %40, 0
  %57 = zext i1 %56 to i8
  store i8 %57, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %58 = lshr i64 %40, 63
  %59 = trunc i64 %58 to i8
  store i8 %59, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %60 = lshr i64 %39, 63
  %61 = xor i64 %58, %60
  %62 = add nuw nsw i64 %61, %58
  %63 = icmp eq i64 %62, 2
  %64 = zext i1 %63 to i8
  store i8 %64, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %65 = add i64 %40, 8
  %66 = getelementptr i64, i64* %38, i32 2
  %67 = load i64, i64* %66, align 8
  store i64 %67, i64* @RBP_2328_4145c678, align 8, !tbaa !8
  %68 = add i64 %65, 8
  store i64 %68, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  ret %struct.Memory* %18

inst_401662:                                      ; preds = %inst_401656
  %69 = sub i64 %19, 8
  %70 = inttoptr i64 %69 to i64*
  %71 = load i64, i64* %70, align 8
  store i64 %71, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %72 = sext i32 %22 to i64
  store i64 %72, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %73 = mul i64 %72, 4
  %74 = add i64 %73, %71
  %75 = inttoptr i64 %74 to i32*
  %76 = load i32, i32* %75, align 4
  %77 = sub i32 %76, 2147483647
  %78 = icmp ult i32 %76, 2147483647
  %79 = zext i1 %78 to i8
  store i8 %79, i8* @CF_2065_4145c630, align 1, !tbaa !10
  %80 = and i32 %77, 255
  %81 = call i32 @llvm.ctpop.i32(i32 %80) #3, !range !24
  %82 = trunc i32 %81 to i8
  %83 = and i8 %82, 1
  %84 = xor i8 %83, 1
  store i8 %84, i8* @PF_2067_4145c630, align 1, !tbaa !25
  %85 = xor i32 %76, 2147483647
  %86 = xor i32 %85, %77
  %87 = lshr i32 %86, 4
  %88 = trunc i32 %87 to i8
  %89 = and i8 %88, 1
  store i8 %89, i8* @AF_2069_4145c630, align 1, !tbaa !26
  %90 = icmp eq i32 %77, 0
  %91 = zext i1 %90 to i8
  store i8 %91, i8* @ZF_2071_4145c630, align 1, !tbaa !27
  %92 = lshr i32 %77, 31
  %93 = trunc i32 %92 to i8
  store i8 %93, i8* @SF_2073_4145c630, align 1, !tbaa !28
  %94 = lshr i32 %76, 31
  %95 = xor i32 %92, %94
  %96 = add nuw nsw i32 %95, %94
  %97 = icmp eq i32 %96, 2
  %98 = zext i1 %97 to i8
  store i8 %98, i8* @OF_2077_4145c630, align 1, !tbaa !29
  %99 = icmp eq i8 %91, 0
  %100 = select i1 %99, i64 add (i64 ptrtoint (i8* @data_401656 to i64), i64 58), i64 add (i64 ptrtoint (i8* @data_401656 to i64), i64 33)
  %101 = add i64 %100, 3
  store i64 %23, i64* @RSI_2280_4145c678, align 8, !tbaa !8
  br i1 %99, label %inst_401690, label %inst_401677

inst_401690:                                      ; preds = %inst_401662
  %102 = add i64 %101, 4
  store i64 %71, i64* @RAX_2216_4145c678, align 8, !tbaa !8
  %103 = add i64 %102, 4
  store i64 %72, i64* @RCX_2248_4145c678, align 8, !tbaa !8
  %104 = add i64 %103, 3
  %105 = zext i32 %76 to i64
  store i64 %105, i64* @RDX_2264_4145c678, align 8, !tbaa !8
  %106 = add i64 %104, 10
  store i8* @data_40201d, i8** @RDI_2296_41463aa0, align 8
  %107 = add i64 %106, 2
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %108 = add i64 %107, 5
  %109 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %110 = add i64 %109, -8
  %111 = inttoptr i64 %110 to i64*
  store i64 %108, i64* %111, align 8
  store i64 %110, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %112 = call %struct.Memory* @ext_404060_printf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %18)
  br label %inst_4016af

inst_401677:                                      ; preds = %inst_401662
  %113 = add i64 %101, 10
  store i8* @data_40200d, i8** @RDI_2296_41463aa0, align 8
  %114 = add i64 %113, 2
  store i8 0, i8* @RAX_2216_4145c630, align 1, !tbaa !5
  %115 = add i64 %114, 5
  %116 = load i64, i64* @RSP_2312_4145c678, align 8, !tbaa !5
  %117 = add i64 %116, -8
  %118 = inttoptr i64 %117 to i64*
  store i64 %115, i64* %118, align 8
  store i64 %117, i64* @RSP_2312_4145c678, align 8, !tbaa !8
  %119 = call %struct.Memory* @ext_404060_printf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %18)
  br label %inst_4016af
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_404060_printf(%struct.State*, i64, %struct.Memory*) #2

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline }
attributes #3 = { nounwind }

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
