; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/DFS_function.ll'
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
@data_125b = external global i8
@data_124d = external global i8
@data_11fa = external global i8
@data_11f0 = external global i8
@data_14ac = external global i8
@data_14a0 = external global i8
@data_127f = external global i8
@data_1273 = external global i8
@data_1242 = external global i8
@data_122e = external global i8
@RSP_2312_40deb5b8 = external global i64
@OF_2077_40deb570 = external global i8
@SF_2073_40deb570 = external global i8
@ZF_2071_40deb570 = external global i8
@AF_2069_40deb570 = external global i8
@PF_2067_40deb570 = external global i8
@CF_2065_40deb570 = external global i8
@RAX_2216_40deb5b8 = external global i64
@RBP_2328_40deb5b8 = external global i64
@RBP_2328_40df2bc0 = external global i64*
@R8_2344_40deb5b8 = external global i64
@RCX_2248_40deb5b8 = external global i64
@RDX_2264_40deb5b8 = external global i64
@RSI_2280_40deb5b8 = external global i64
@RDI_2296_40deb5b8 = external global i64

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_11c9_dfs(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_11c9:
  %0 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %1 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_40deb5b8, align 8, !tbaa !8
  %4 = add i64 %1, -120
  store i64 %4, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %5 = add i64 %1, -80
  %6 = load i64, i64* @RDI_2296_40deb5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %1, -88
  %9 = load i64, i64* @RSI_2280_40deb5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = add i64 %1, -96
  %12 = load i64, i64* @RDX_2264_40deb5b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  %14 = add i64 %1, -104
  %15 = load i64, i64* @RCX_2248_40deb5b8, align 8
  %16 = inttoptr i64 %14 to i64*
  store i64 %15, i64* %16, align 8
  %17 = add i64 %1, -112
  %18 = load i64, i64* @R8_2344_40deb5b8, align 8
  %19 = inttoptr i64 %17 to i64*
  store i64 %18, i64* %19, align 8
  %20 = load i64, i64* %10, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %21 = trunc i64 %20 to i32
  %22 = and i32 %21, 255
  %23 = call i32 @llvm.ctpop.i32(i32 %22) #3, !range !24
  %24 = trunc i32 %23 to i8
  %25 = and i8 %24, 1
  %26 = xor i8 %25, 1
  store i8 %26, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %27 = icmp eq i64 %20, 0
  %28 = zext i1 %27 to i8
  store i8 %28, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %29 = lshr i64 %20, 63
  %30 = trunc i64 %29 to i8
  store i8 %30, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  br i1 %27, label %inst_11fa, label %inst_11f0

inst_14ac:                                        ; preds = %inst_1488, %inst_11fa, %inst_125b
  %31 = phi %struct.Memory* [ %memory, %inst_11fa ], [ %62, %inst_125b ], [ %344, %inst_1488 ]
  %32 = load i64*, i64** @RBP_2328_40df2bc0, align 8
  %33 = load i64, i64* @RBP_2328_40deb5b8, align 8, !tbaa !5
  %34 = load i64, i64* %32, align 8
  store i64 %34, i64* @RBP_2328_40deb5b8, align 8, !tbaa !8
  %35 = add i64 %33, 16
  store i64 %35, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  ret %struct.Memory* %31

inst_12d1:                                        ; preds = %inst_1299, %inst_128f
  %storemerge = phi i64 [ 0, %inst_128f ], [ %234, %inst_1299 ]
  store i64 %storemerge, i64* %223, align 8
  %36 = add i64 %178, -80
  %37 = inttoptr i64 %36 to i64*
  %38 = load i64, i64* %37, align 8
  %39 = icmp ugt i64 %38, %storemerge
  br i1 %39, label %inst_1299, label %inst_12db

inst_145b:                                        ; preds = %inst_138f, %inst_13bb
  %40 = add i64 %storemerge2, 1
  br label %inst_1460

inst_125b:                                        ; preds = %inst_1254, %inst_124d, %inst_120a
  %41 = phi i64 [ %195, %inst_120a ], [ %209, %inst_124d ], [ %221, %inst_1254 ]
  store i64 %184, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %184, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %42 = add i64 %41, 12
  %43 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %44 = add i64 %43, -8
  %45 = inttoptr i64 %44 to i64*
  store i64 %42, i64* %45, align 8
  store i64 %44, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %46 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %177)
  %47 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %48 = add i64 %47, -24
  %49 = inttoptr i64 %48 to i64*
  %50 = load i64, i64* %49, align 8
  store i64 %50, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %50, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %51 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %52 = add i64 %51, -8
  %53 = inttoptr i64 %52 to i64*
  store i64 ptrtoint (i8* @data_1273 to i64), i64* %53, align 8
  store i64 %52, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %54 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %46)
  %55 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %56 = add i64 %55, -16
  %57 = inttoptr i64 %56 to i64*
  %58 = load i64, i64* %57, align 8
  store i64 %58, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %58, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %59 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %60 = add i64 %59, -8
  %61 = inttoptr i64 %60 to i64*
  store i64 ptrtoint (i8* @data_127f to i64), i64* %61, align 8
  store i64 %60, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %62 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %54)
  %63 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %64 = add i64 %63, -104
  %65 = inttoptr i64 %64 to i64*
  %66 = load i64, i64* %65, align 8
  store i64 %66, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %67 = inttoptr i64 %66 to i64*
  store i64 0, i64* %67, align 8
  br label %inst_14ac

inst_1460:                                        ; preds = %inst_1356, %inst_145b
  %storemerge2 = phi i64 [ %322, %inst_1356 ], [ %40, %inst_145b ]
  store i64 %storemerge2, i64* %324, align 8
  %68 = load i64, i64* %37, align 8
  %69 = icmp ugt i64 %68, %storemerge2
  br i1 %69, label %inst_138f, label %inst_146e

inst_146e:                                        ; preds = %inst_13d8, %inst_1460
  %70 = phi i64 [ %.pre4, %inst_13d8 ], [ %68, %inst_1460 ]
  %71 = phi i64 [ %.pre, %inst_13d8 ], [ %storemerge2, %inst_1460 ]
  %.not = icmp eq i64 %71, %70
  br i1 %.not, label %inst_1478, label %inst_147d

inst_11fa:                                        ; preds = %inst_11f0, %inst_11c9
  %72 = load i64, i64* %19, align 8
  store i64 %72, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %73 = inttoptr i64 %72 to i64*
  store i64 0, i64* %73, align 8
  br label %inst_14ac

inst_147d:                                        ; preds = %inst_1478, %inst_12db, %inst_146e
  %74 = load i64, i64* %236, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %75 = trunc i64 %74 to i32
  %76 = and i32 %75, 255
  %77 = call i32 @llvm.ctpop.i32(i32 %76) #3, !range !24
  %78 = trunc i32 %77 to i8
  %79 = and i8 %78, 1
  %80 = xor i8 %79, 1
  store i8 %80, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %81 = icmp eq i64 %74, 0
  %82 = zext i1 %81 to i8
  store i8 %82, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %83 = lshr i64 %74, 63
  %84 = trunc i64 %83 to i8
  store i8 %84, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  br i1 %81, label %inst_1488, label %inst_1356

inst_11f0:                                        ; preds = %inst_11c9
  %85 = load i64, i64* %13, align 8
  %86 = sub i64 %85, %20
  %87 = icmp ult i64 %85, %20
  %88 = zext i1 %87 to i8
  store i8 %88, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %89 = trunc i64 %86 to i32
  %90 = and i32 %89, 255
  %91 = call i32 @llvm.ctpop.i32(i32 %90) #3, !range !24
  %92 = trunc i32 %91 to i8
  %93 = and i8 %92, 1
  %94 = xor i8 %93, 1
  store i8 %94, i8* @PF_2067_40deb570, align 1, !tbaa !25
  %95 = xor i64 %20, %85
  %96 = xor i64 %95, %86
  %97 = trunc i64 %96 to i8
  %98 = lshr i8 %97, 4
  %99 = and i8 %98, 1
  store i8 %99, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %100 = icmp eq i64 %86, 0
  %101 = zext i1 %100 to i8
  store i8 %101, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %102 = lshr i64 %86, 63
  %103 = trunc i64 %102 to i8
  store i8 %103, i8* @SF_2073_40deb570, align 1, !tbaa !28
  %104 = lshr i64 %85, 63
  %105 = xor i64 %29, %104
  %106 = xor i64 %102, %104
  %107 = add nuw nsw i64 %106, %105
  %108 = icmp eq i64 %107, 2
  %109 = zext i1 %108 to i8
  store i8 %109, i8* @OF_2077_40deb570, align 1, !tbaa !29
  br i1 %87, label %inst_120a, label %inst_11fa

inst_120a:                                        ; preds = %inst_11f0
  %110 = shl i64 %20, 2
  store i64 %110, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %111 = lshr i64 %20, 62
  %112 = trunc i64 %111 to i8
  %113 = and i8 %112, 1
  store i8 %113, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %114 = trunc i64 %110 to i32
  %115 = and i32 %114, 252
  %116 = call i32 @llvm.ctpop.i32(i32 %115) #3, !range !24
  %117 = trunc i32 %116 to i8
  %118 = and i8 %117, 1
  %119 = xor i8 %118, 1
  store i8 %119, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %120 = icmp eq i64 %110, 0
  %121 = zext i1 %120 to i8
  store i8 %121, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %122 = lshr i64 %110, 63
  %123 = trunc i64 %122 to i8
  store i8 %123, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  store i64 %110, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %124 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %125 = add i64 %124, -8
  %126 = inttoptr i64 %125 to i64*
  store i64 add (i64 ptrtoint (i8* @data_11f0 to i64), i64 42), i64* %126, align 8
  store i64 %125, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %127 = call %struct.Memory* @ext_10d0__malloc(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %128 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %129 = add i64 %128, -32
  %130 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %131 = inttoptr i64 %129 to i64*
  store i64 %130, i64* %131, align 8
  %132 = add i64 %128, -80
  %133 = inttoptr i64 %132 to i64*
  %134 = load i64, i64* %133, align 8
  %135 = shl i64 %134, 3
  store i64 %135, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %136 = lshr i64 %134, 61
  %137 = trunc i64 %136 to i8
  %138 = and i8 %137, 1
  store i8 %138, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %139 = trunc i64 %135 to i32
  %140 = and i32 %139, 248
  %141 = call i32 @llvm.ctpop.i32(i32 %140) #3, !range !24
  %142 = trunc i32 %141 to i8
  %143 = and i8 %142, 1
  %144 = xor i8 %143, 1
  store i8 %144, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %145 = icmp eq i64 %135, 0
  %146 = zext i1 %145 to i8
  store i8 %146, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %147 = lshr i64 %135, 63
  %148 = trunc i64 %147 to i8
  store i8 %148, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  store i64 %135, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %149 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %150 = add i64 %149, -8
  %151 = inttoptr i64 %150 to i64*
  store i64 ptrtoint (i8* @data_122e to i64), i64* %151, align 8
  store i64 %150, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %152 = call %struct.Memory* @ext_10d0__malloc(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %127)
  %153 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %154 = add i64 %153, -24
  %155 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %156 = inttoptr i64 %154 to i64*
  store i64 %155, i64* %156, align 8
  %157 = add i64 %153, -80
  %158 = inttoptr i64 %157 to i64*
  %159 = load i64, i64* %158, align 8
  %160 = shl i64 %159, 3
  store i64 %160, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %161 = lshr i64 %159, 61
  %162 = trunc i64 %161 to i8
  %163 = and i8 %162, 1
  store i8 %163, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %164 = trunc i64 %160 to i32
  %165 = and i32 %164, 248
  %166 = call i32 @llvm.ctpop.i32(i32 %165) #3, !range !24
  %167 = trunc i32 %166 to i8
  %168 = and i8 %167, 1
  %169 = xor i8 %168, 1
  store i8 %169, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %170 = icmp eq i64 %160, 0
  %171 = zext i1 %170 to i8
  store i8 %171, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %172 = lshr i64 %160, 63
  %173 = trunc i64 %172 to i8
  store i8 %173, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  store i64 %160, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %174 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %175 = add i64 %174, -8
  %176 = inttoptr i64 %175 to i64*
  store i64 ptrtoint (i8* @data_1242 to i64), i64* %176, align 8
  store i64 %175, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %177 = call %struct.Memory* @ext_10d0__malloc(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %152)
  %178 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %179 = add i64 %178, -16
  %180 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %181 = inttoptr i64 %179 to i64*
  store i64 %180, i64* %181, align 8
  %182 = add i64 %178, -32
  %183 = inttoptr i64 %182 to i64*
  %184 = load i64, i64* %183, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %185 = trunc i64 %184 to i32
  %186 = and i32 %185, 255
  %187 = call i32 @llvm.ctpop.i32(i32 %186) #3, !range !24
  %188 = trunc i32 %187 to i8
  %189 = and i8 %188, 1
  %190 = xor i8 %189, 1
  store i8 %190, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %191 = icmp eq i64 %184, 0
  %192 = zext i1 %191 to i8
  store i8 %192, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %193 = lshr i64 %184, 63
  %194 = trunc i64 %193 to i8
  store i8 %194, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %195 = select i1 %191, i64 ptrtoint (i8* @data_125b to i64), i64 ptrtoint (i8* @data_124d to i64)
  br i1 %191, label %inst_125b, label %inst_124d

inst_124d:                                        ; preds = %inst_120a
  %196 = add i64 %178, -24
  %197 = inttoptr i64 %196 to i64*
  %198 = load i64, i64* %197, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %199 = trunc i64 %198 to i32
  %200 = and i32 %199, 255
  %201 = call i32 @llvm.ctpop.i32(i32 %200) #3, !range !24
  %202 = trunc i32 %201 to i8
  %203 = and i8 %202, 1
  %204 = xor i8 %203, 1
  store i8 %204, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %205 = icmp eq i64 %198, 0
  %206 = zext i1 %205 to i8
  store i8 %206, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %207 = lshr i64 %198, 63
  %208 = trunc i64 %207 to i8
  store i8 %208, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %.v = select i1 %205, i64 14, i64 7
  %209 = add i64 %195, %.v
  br i1 %205, label %inst_125b, label %inst_1254

inst_1254:                                        ; preds = %inst_124d
  %210 = load i64, i64* %181, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %211 = trunc i64 %210 to i32
  %212 = and i32 %211, 255
  %213 = call i32 @llvm.ctpop.i32(i32 %212) #3, !range !24
  %214 = trunc i32 %213 to i8
  %215 = and i8 %214, 1
  %216 = xor i8 %215, 1
  store i8 %216, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %217 = icmp eq i64 %210, 0
  %218 = zext i1 %217 to i8
  store i8 %218, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %219 = lshr i64 %210, 63
  %220 = trunc i64 %219 to i8
  store i8 %220, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %.v1 = select i1 %217, i64 7, i64 59
  %221 = add i64 %209, %.v1
  br i1 %217, label %inst_125b, label %inst_128f

inst_128f:                                        ; preds = %inst_1254
  %222 = add i64 %178, -56
  %223 = inttoptr i64 %222 to i64*
  br label %inst_12d1

inst_1299:                                        ; preds = %inst_12d1
  %224 = shl i64 %storemerge, 2
  %225 = load i64, i64* %183, align 8
  %226 = add i64 %224, %225
  %227 = inttoptr i64 %226 to i32*
  store i32 0, i32* %227, align 4
  %228 = load i64, i64* %223, align 8
  %229 = shl i64 %228, 3
  %230 = load i64, i64* %197, align 8
  %231 = add i64 %229, %230
  %232 = inttoptr i64 %231 to i64*
  store i64 0, i64* %232, align 8
  %233 = load i64, i64* %223, align 8
  %234 = add i64 %233, 1
  br label %inst_12d1

inst_12db:                                        ; preds = %inst_12d1
  %235 = add i64 %178, -48
  %236 = inttoptr i64 %235 to i64*
  store i64 0, i64* %236, align 8
  %237 = add i64 %178, -104
  %238 = inttoptr i64 %237 to i64*
  %239 = load i64, i64* %238, align 8
  %240 = inttoptr i64 %239 to i64*
  store i64 0, i64* %240, align 8
  %241 = load i64, i64* %236, align 8
  %242 = add i64 %241, 1
  store i64 %242, i64* %236, align 8
  %243 = shl i64 %241, 3
  %244 = load i64, i64* %181, align 8
  %245 = add i64 %244, %243
  %246 = add i64 %178, -88
  %247 = inttoptr i64 %246 to i64*
  %248 = load i64, i64* %247, align 8
  %249 = inttoptr i64 %245 to i64*
  store i64 %248, i64* %249, align 8
  %250 = load i64, i64* %247, align 8
  %251 = shl i64 %250, 2
  %252 = load i64, i64* %183, align 8
  %253 = add i64 %251, %252
  %254 = inttoptr i64 %253 to i32*
  store i32 1, i32* %254, align 4
  %255 = load i64, i64* %238, align 8
  %256 = inttoptr i64 %255 to i64*
  %257 = load i64, i64* %256, align 8
  %258 = add i64 %257, 1
  store i64 %258, i64* @RCX_2248_40deb5b8, align 8, !tbaa !8
  store i64 %258, i64* %256, align 8
  %259 = shl i64 %257, 3
  %260 = add i64 %178, -96
  %261 = inttoptr i64 %260 to i64*
  %262 = load i64, i64* %261, align 8
  %263 = add i64 %262, %259
  store i64 %263, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %264 = load i64, i64* %247, align 8
  %265 = inttoptr i64 %263 to i64*
  store i64 %264, i64* %265, align 8
  br label %inst_147d

inst_13bb:                                        ; preds = %inst_138f
  %266 = shl i64 %storemerge2, 2
  store i64 %266, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %267 = load i64, i64* %183, align 8
  %268 = add i64 %266, %267
  %269 = inttoptr i64 %268 to i32*
  %270 = load i32, i32* %269, align 4
  %.not3 = icmp eq i32 %270, 0
  br i1 %.not3, label %inst_13d8, label %inst_145b

inst_13d8:                                        ; preds = %inst_13bb
  %271 = shl i64 %297, 3
  %272 = load i64, i64* %197, align 8
  %273 = add i64 %271, %272
  %274 = add i64 %storemerge2, 1
  %275 = inttoptr i64 %273 to i64*
  store i64 %274, i64* %275, align 8
  %276 = load i64, i64* %324, align 8
  %277 = shl i64 %276, 2
  %278 = load i64, i64* %183, align 8
  %279 = add i64 %277, %278
  %280 = inttoptr i64 %279 to i32*
  store i32 1, i32* %280, align 4
  %281 = load i64, i64* %238, align 8
  %282 = inttoptr i64 %281 to i64*
  %283 = load i64, i64* %282, align 8
  %284 = add i64 %283, 1
  store i64 %284, i64* @RCX_2248_40deb5b8, align 8, !tbaa !8
  store i64 %284, i64* %282, align 8
  %285 = shl i64 %283, 3
  %286 = load i64, i64* %261, align 8
  %287 = add i64 %286, %285
  %288 = load i64, i64* %324, align 8
  %289 = inttoptr i64 %287 to i64*
  store i64 %288, i64* %289, align 8
  %290 = load i64, i64* %236, align 8
  %291 = add i64 %290, 1
  store i64 %291, i64* %236, align 8
  %292 = shl i64 %290, 3
  %293 = load i64, i64* %181, align 8
  %294 = add i64 %293, %292
  store i64 %294, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %295 = load i64, i64* %324, align 8
  %296 = inttoptr i64 %294 to i64*
  store i64 %295, i64* %296, align 8
  %.pre = load i64, i64* %324, align 8
  %.pre4 = load i64, i64* %37, align 8
  br label %inst_146e

inst_138f:                                        ; preds = %inst_1460
  %297 = load i64, i64* %317, align 8
  %298 = mul i64 %68, %297
  %299 = add i64 %298, %storemerge2
  %300 = shl i64 %299, 2
  store i64 %300, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %301 = add i64 %178, -72
  %302 = inttoptr i64 %301 to i64*
  %303 = load i64, i64* %302, align 8
  %304 = add i64 %300, %303
  %305 = inttoptr i64 %304 to i32*
  %306 = load i32, i32* %305, align 4
  %307 = icmp eq i32 %306, 0
  br i1 %307, label %inst_145b, label %inst_13bb

inst_1478:                                        ; preds = %inst_146e
  %308 = load i64, i64* %236, align 8
  %309 = add i64 %308, -1
  store i64 %309, i64* %236, align 8
  br label %inst_147d

inst_1356:                                        ; preds = %inst_147d
  %310 = shl i64 %74, 3
  %311 = add i64 %310, -8
  %312 = load i64, i64* %181, align 8
  %313 = add i64 %311, %312
  %314 = inttoptr i64 %313 to i64*
  %315 = load i64, i64* %314, align 8
  %316 = add i64 %178, -8
  %317 = inttoptr i64 %316 to i64*
  store i64 %315, i64* %317, align 8
  %318 = shl i64 %315, 3
  store i64 %318, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %319 = load i64, i64* %197, align 8
  %320 = add i64 %318, %319
  %321 = inttoptr i64 %320 to i64*
  %322 = load i64, i64* %321, align 8
  %323 = add i64 %178, -40
  %324 = inttoptr i64 %323 to i64*
  br label %inst_1460

inst_1488:                                        ; preds = %inst_147d
  %325 = load i64, i64* %183, align 8
  store i64 %325, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %325, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %326 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %327 = add i64 %326, -8
  store i64 %327, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %328 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %177)
  %329 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %330 = add i64 %329, -24
  %331 = inttoptr i64 %330 to i64*
  %332 = load i64, i64* %331, align 8
  store i64 %332, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %332, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %333 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %334 = add i64 %333, -8
  %335 = inttoptr i64 %334 to i64*
  store i64 ptrtoint (i8* @data_14a0 to i64), i64* %335, align 8
  store i64 %334, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %336 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %328)
  %337 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %338 = add i64 %337, -16
  %339 = inttoptr i64 %338 to i64*
  %340 = load i64, i64* %339, align 8
  store i64 %340, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %340, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %341 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %342 = add i64 %341, -8
  %343 = inttoptr i64 %342 to i64*
  store i64 ptrtoint (i8* @data_14ac to i64), i64* %343, align 8
  store i64 %342, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %344 = call %struct.Memory* @ext_1090__free(%struct.State* nonnull @__mcsema_reg_state, i64 undef, %struct.Memory* %336)
  br label %inst_14ac
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_10d0__malloc(%struct.State*, i64, %struct.Memory*) #2

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_1090__free(%struct.State*, i64, %struct.Memory*) #2

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
