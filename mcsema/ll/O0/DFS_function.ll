; ModuleID = 'DFS.ll'
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
  %4 = sub i64 %2, 112
  store i64 %4, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %5 = sub i64 %2, 72
  %6 = load i64, i64* @RDI_2296_40deb5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 80
  %9 = load i64, i64* @RSI_2280_40deb5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %2, 88
  %12 = load i64, i64* @RDX_2264_40deb5b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  %14 = sub i64 %2, 96
  %15 = load i64, i64* @RCX_2248_40deb5b8, align 8
  %16 = inttoptr i64 %14 to i64*
  store i64 %15, i64* %16, align 8
  %17 = sub i64 %2, 104
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
  %31 = phi %struct.Memory* [ %memory, %inst_11fa ], [ %66, %inst_125b ], [ %383, %inst_1488 ]
  %32 = load i64*, i64** @RBP_2328_40df2bc0, align 8
  %33 = load i64, i64* @RBP_2328_40deb5b8, align 8, !tbaa !5
  %34 = load i64, i64* %32, align 8
  store i64 %34, i64* @RBP_2328_40deb5b8, align 8, !tbaa !8
  %35 = add i64 %33, 8
  %36 = add i64 %35, 8
  store i64 %36, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  ret %struct.Memory* %31

inst_12d1:                                        ; preds = %inst_1299, %inst_128f
  %37 = load i64, i64* %254, align 8
  %38 = sub i64 %200, 80
  %39 = inttoptr i64 %38 to i64*
  %40 = load i64, i64* %39, align 8
  %41 = icmp ugt i64 %40, %37
  br i1 %41, label %inst_1299, label %inst_12db

inst_145b:                                        ; preds = %inst_138f, %inst_13bb
  %42 = add i64 %72, 1
  store i64 %42, i64* %362, align 8
  br label %inst_1460

inst_125b:                                        ; preds = %inst_1254, %inst_124d, %inst_120a
  %43 = phi i64 [ %218, %inst_120a ], [ %236, %inst_124d ], [ %252, %inst_1254 ]
  %44 = add i64 %43, 4
  store i64 %206, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %45 = add i64 %44, 3
  store i64 %206, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %46 = add i64 %45, 5
  %47 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %48 = add i64 %47, -8
  %49 = inttoptr i64 %48 to i64*
  store i64 %46, i64* %49, align 8
  store i64 %48, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %50 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %199)
  %51 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %52 = sub i64 %51, 24
  %53 = inttoptr i64 %52 to i64*
  %54 = load i64, i64* %53, align 8
  store i64 %54, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %54, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %55 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %56 = add i64 %55, -8
  %57 = inttoptr i64 %56 to i64*
  store i64 ptrtoint (i8* @data_1273 to i64), i64* %57, align 8
  store i64 %56, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %58 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %50)
  %59 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %60 = sub i64 %59, 16
  %61 = inttoptr i64 %60 to i64*
  %62 = load i64, i64* %61, align 8
  store i64 %62, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %62, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %63 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %64 = add i64 %63, -8
  %65 = inttoptr i64 %64 to i64*
  store i64 ptrtoint (i8* @data_127f to i64), i64* %65, align 8
  store i64 %64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %66 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %58)
  %67 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %68 = sub i64 %67, 104
  %69 = inttoptr i64 %68 to i64*
  %70 = load i64, i64* %69, align 8
  store i64 %70, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %71 = inttoptr i64 %70 to i64*
  store i64 0, i64* %71, align 8
  br label %inst_14ac

inst_1460:                                        ; preds = %inst_1356, %inst_145b
  %72 = load i64, i64* %362, align 8
  %73 = load i64, i64* %39, align 8
  %74 = icmp ugt i64 %73, %72
  br i1 %74, label %inst_138f, label %inst_146e

inst_146e:                                        ; preds = %inst_13d8, %inst_1460
  %75 = load i64, i64* %362, align 8
  %76 = load i64, i64* %39, align 8
  %77 = sub i64 %75, %76
  %78 = icmp eq i64 %77, 0
  %79 = zext i1 %78 to i8
  %80 = icmp eq i8 %79, 0
  br i1 %80, label %inst_147d, label %inst_1478

inst_11fa:                                        ; preds = %inst_11f0, %inst_11c9
  %81 = load i64, i64* %19, align 8
  store i64 %81, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %82 = inttoptr i64 %81 to i64*
  store i64 0, i64* %82, align 8
  br label %inst_14ac

inst_147d:                                        ; preds = %inst_1478, %inst_12db, %inst_146e
  %83 = load i64, i64* %267, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %84 = trunc i64 %83 to i32
  %85 = and i32 %84, 255
  %86 = call i32 @llvm.ctpop.i32(i32 %85) #3, !range !24
  %87 = trunc i32 %86 to i8
  %88 = and i8 %87, 1
  %89 = xor i8 %88, 1
  store i8 %89, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %90 = icmp eq i64 %83, 0
  %91 = zext i1 %90 to i8
  store i8 %91, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %92 = lshr i64 %83, 63
  %93 = trunc i64 %92 to i8
  store i8 %93, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %94 = icmp eq i8 %91, 0
  br i1 %94, label %inst_1356, label %inst_1488

inst_11f0:                                        ; preds = %inst_11c9
  %95 = load i64, i64* %13, align 8
  %96 = sub i64 %95, %20
  %97 = icmp ugt i64 %20, %95
  %98 = zext i1 %97 to i8
  store i8 %98, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %99 = trunc i64 %96 to i32
  %100 = and i32 %99, 255
  %101 = call i32 @llvm.ctpop.i32(i32 %100) #3, !range !24
  %102 = trunc i32 %101 to i8
  %103 = and i8 %102, 1
  %104 = xor i8 %103, 1
  store i8 %104, i8* @PF_2067_40deb570, align 1, !tbaa !25
  %105 = xor i64 %20, %95
  %106 = xor i64 %105, %96
  %107 = lshr i64 %106, 4
  %108 = trunc i64 %107 to i8
  %109 = and i8 %108, 1
  store i8 %109, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %110 = icmp eq i64 %96, 0
  %111 = zext i1 %110 to i8
  store i8 %111, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %112 = lshr i64 %96, 63
  %113 = trunc i64 %112 to i8
  store i8 %113, i8* @SF_2073_40deb570, align 1, !tbaa !28
  %114 = lshr i64 %95, 63
  %115 = xor i64 %29, %114
  %116 = xor i64 %112, %114
  %117 = add nuw nsw i64 %116, %115
  %118 = icmp eq i64 %117, 2
  %119 = zext i1 %118 to i8
  store i8 %119, i8* @OF_2077_40deb570, align 1, !tbaa !29
  br i1 %97, label %inst_120a, label %inst_11fa

inst_120a:                                        ; preds = %inst_11f0
  %120 = icmp eq i8 %28, 0
  %121 = select i1 %120, i64 ptrtoint (i8* @data_11f0 to i64), i64 ptrtoint (i8* @data_11fa to i64)
  %122 = add i64 %121, 4
  %123 = add i64 %122, 4
  %124 = add i64 %123, 2
  %125 = add i64 %124, 16
  %126 = icmp eq i8 %98, 0
  %127 = select i1 %126, i64 %124, i64 %125
  %128 = add i64 %127, 4
  %129 = add i64 %128, 4
  %130 = shl i64 %20, 1
  %131 = shl i64 %130, 1
  store i64 %131, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %132 = lshr i64 %130, 63
  %133 = trunc i64 %132 to i8
  store i8 %133, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %134 = trunc i64 %131 to i32
  %135 = and i32 %134, 254
  %136 = call i32 @llvm.ctpop.i32(i32 %135) #3, !range !24
  %137 = trunc i32 %136 to i8
  %138 = and i8 %137, 1
  %139 = xor i8 %138, 1
  store i8 %139, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %140 = icmp eq i64 %131, 0
  %141 = zext i1 %140 to i8
  store i8 %141, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %142 = lshr i64 %131, 63
  %143 = trunc i64 %142 to i8
  store i8 %143, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  %144 = add i64 %129, 3
  store i64 %131, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %145 = add i64 %144, 5
  %146 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %147 = add i64 %146, -8
  %148 = inttoptr i64 %147 to i64*
  store i64 %145, i64* %148, align 8
  store i64 %147, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %149 = call %struct.Memory* @ext_10d0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %memory)
  %150 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %151 = sub i64 %150, 32
  %152 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %153 = inttoptr i64 %151 to i64*
  store i64 %152, i64* %153, align 8
  %154 = sub i64 %150, 80
  %155 = inttoptr i64 %154 to i64*
  %156 = load i64, i64* %155, align 8
  %157 = shl i64 %156, 2
  %158 = shl i64 %157, 1
  store i64 %158, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %159 = lshr i64 %157, 63
  %160 = trunc i64 %159 to i8
  store i8 %160, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %161 = trunc i64 %158 to i32
  %162 = and i32 %161, 254
  %163 = call i32 @llvm.ctpop.i32(i32 %162) #3, !range !24
  %164 = trunc i32 %163 to i8
  %165 = and i8 %164, 1
  %166 = xor i8 %165, 1
  store i8 %166, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %167 = icmp eq i64 %158, 0
  %168 = zext i1 %167 to i8
  store i8 %168, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %169 = lshr i64 %158, 63
  %170 = trunc i64 %169 to i8
  store i8 %170, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  store i64 %158, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %171 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %172 = add i64 %171, -8
  %173 = inttoptr i64 %172 to i64*
  store i64 ptrtoint (i8* @data_122e to i64), i64* %173, align 8
  store i64 %172, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %174 = call %struct.Memory* @ext_10d0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %149)
  %175 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %176 = sub i64 %175, 24
  %177 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %178 = inttoptr i64 %176 to i64*
  store i64 %177, i64* %178, align 8
  %179 = sub i64 %175, 80
  %180 = inttoptr i64 %179 to i64*
  %181 = load i64, i64* %180, align 8
  %182 = shl i64 %181, 2
  %183 = shl i64 %182, 1
  store i64 %183, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  %184 = lshr i64 %182, 63
  %185 = trunc i64 %184 to i8
  store i8 %185, i8* @CF_2065_40deb570, align 1, !tbaa !5
  %186 = trunc i64 %183 to i32
  %187 = and i32 %186, 254
  %188 = call i32 @llvm.ctpop.i32(i32 %187) #3, !range !24
  %189 = trunc i32 %188 to i8
  %190 = and i8 %189, 1
  %191 = xor i8 %190, 1
  store i8 %191, i8* @PF_2067_40deb570, align 1, !tbaa !5
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !5
  %192 = icmp eq i64 %183, 0
  %193 = zext i1 %192 to i8
  store i8 %193, i8* @ZF_2071_40deb570, align 1, !tbaa !5
  %194 = lshr i64 %183, 63
  %195 = trunc i64 %194 to i8
  store i8 %195, i8* @SF_2073_40deb570, align 1, !tbaa !5
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !5
  store i64 %183, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %196 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %197 = add i64 %196, -8
  %198 = inttoptr i64 %197 to i64*
  store i64 ptrtoint (i8* @data_1242 to i64), i64* %198, align 8
  store i64 %197, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %199 = call %struct.Memory* @ext_10d0__malloc(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %174)
  %200 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %201 = sub i64 %200, 16
  %202 = load i64, i64* @RAX_2216_40deb5b8, align 8
  %203 = inttoptr i64 %201 to i64*
  store i64 %202, i64* %203, align 8
  %204 = sub i64 %200, 32
  %205 = inttoptr i64 %204 to i64*
  %206 = load i64, i64* %205, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %207 = trunc i64 %206 to i32
  %208 = and i32 %207, 255
  %209 = call i32 @llvm.ctpop.i32(i32 %208) #3, !range !24
  %210 = trunc i32 %209 to i8
  %211 = and i8 %210, 1
  %212 = xor i8 %211, 1
  store i8 %212, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %213 = icmp eq i64 %206, 0
  %214 = zext i1 %213 to i8
  store i8 %214, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %215 = lshr i64 %206, 63
  %216 = trunc i64 %215 to i8
  store i8 %216, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %217 = icmp eq i8 %214, 0
  %218 = select i1 %217, i64 ptrtoint (i8* @data_124d to i64), i64 ptrtoint (i8* @data_125b to i64)
  br i1 %213, label %inst_125b, label %inst_124d

inst_124d:                                        ; preds = %inst_120a
  %219 = add i64 %218, 5
  %220 = sub i64 %200, 24
  %221 = inttoptr i64 %220 to i64*
  %222 = load i64, i64* %221, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %223 = trunc i64 %222 to i32
  %224 = and i32 %223, 255
  %225 = call i32 @llvm.ctpop.i32(i32 %224) #3, !range !24
  %226 = trunc i32 %225 to i8
  %227 = and i8 %226, 1
  %228 = xor i8 %227, 1
  store i8 %228, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %229 = icmp eq i64 %222, 0
  %230 = zext i1 %229 to i8
  store i8 %230, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %231 = lshr i64 %222, 63
  %232 = trunc i64 %231 to i8
  store i8 %232, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %233 = add i64 %219, 2
  %234 = add i64 %233, 7
  %235 = icmp eq i8 %230, 0
  %236 = select i1 %235, i64 %233, i64 %234
  br i1 %229, label %inst_125b, label %inst_1254

inst_1254:                                        ; preds = %inst_124d
  %237 = add i64 %236, 5
  %238 = load i64, i64* %203, align 8
  store i8 0, i8* @CF_2065_40deb570, align 1, !tbaa !10
  %239 = trunc i64 %238 to i32
  %240 = and i32 %239, 255
  %241 = call i32 @llvm.ctpop.i32(i32 %240) #3, !range !24
  %242 = trunc i32 %241 to i8
  %243 = and i8 %242, 1
  %244 = xor i8 %243, 1
  store i8 %244, i8* @PF_2067_40deb570, align 1, !tbaa !25
  store i8 0, i8* @AF_2069_40deb570, align 1, !tbaa !26
  %245 = icmp eq i64 %238, 0
  %246 = zext i1 %245 to i8
  store i8 %246, i8* @ZF_2071_40deb570, align 1, !tbaa !27
  %247 = lshr i64 %238, 63
  %248 = trunc i64 %247 to i8
  store i8 %248, i8* @SF_2073_40deb570, align 1, !tbaa !28
  store i8 0, i8* @OF_2077_40deb570, align 1, !tbaa !29
  %249 = add i64 %237, 2
  %250 = add i64 %249, 52
  %251 = icmp eq i8 %246, 0
  %252 = select i1 %251, i64 %250, i64 %249
  br i1 %251, label %inst_128f, label %inst_125b

inst_128f:                                        ; preds = %inst_1254
  %253 = sub i64 %200, 56
  %254 = inttoptr i64 %253 to i64*
  store i64 0, i64* %254, align 8
  br label %inst_12d1

inst_1299:                                        ; preds = %inst_12d1
  %255 = mul i64 %37, 4
  %256 = load i64, i64* %205, align 8
  %257 = add i64 %255, %256
  %258 = inttoptr i64 %257 to i32*
  store i32 0, i32* %258, align 4
  %259 = load i64, i64* %254, align 8
  %260 = mul i64 %259, 8
  %261 = load i64, i64* %221, align 8
  %262 = add i64 %260, %261
  %263 = inttoptr i64 %262 to i64*
  store i64 0, i64* %263, align 8
  %264 = load i64, i64* %254, align 8
  %265 = add i64 %264, 1
  store i64 %265, i64* %254, align 8
  br label %inst_12d1

inst_12db:                                        ; preds = %inst_12d1
  %266 = sub i64 %200, 48
  %267 = inttoptr i64 %266 to i64*
  store i64 0, i64* %267, align 8
  %268 = sub i64 %200, 104
  %269 = inttoptr i64 %268 to i64*
  %270 = load i64, i64* %269, align 8
  %271 = inttoptr i64 %270 to i64*
  store i64 0, i64* %271, align 8
  %272 = load i64, i64* %267, align 8
  %273 = add i64 %272, 1
  store i64 %273, i64* %267, align 8
  %274 = mul i64 %272, 8
  %275 = load i64, i64* %203, align 8
  %276 = add i64 %275, %274
  %277 = sub i64 %200, 88
  %278 = inttoptr i64 %277 to i64*
  %279 = load i64, i64* %278, align 8
  %280 = inttoptr i64 %276 to i64*
  store i64 %279, i64* %280, align 8
  %281 = load i64, i64* %278, align 8
  %282 = mul i64 %281, 4
  %283 = load i64, i64* %205, align 8
  %284 = add i64 %282, %283
  %285 = inttoptr i64 %284 to i32*
  store i32 1, i32* %285, align 4
  %286 = load i64, i64* %269, align 8
  %287 = inttoptr i64 %286 to i64*
  %288 = load i64, i64* %287, align 8
  %289 = add i64 %288, 1
  store i64 %289, i64* @RCX_2248_40deb5b8, align 8, !tbaa !8
  store i64 %289, i64* %287, align 8
  %290 = mul i64 %288, 8
  %291 = sub i64 %200, 96
  %292 = inttoptr i64 %291 to i64*
  %293 = load i64, i64* %292, align 8
  %294 = add i64 %293, %290
  store i64 %294, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %295 = load i64, i64* %278, align 8
  %296 = inttoptr i64 %294 to i64*
  store i64 %295, i64* %296, align 8
  br label %inst_147d

inst_13bb:                                        ; preds = %inst_138f
  %297 = mul i64 %72, 4
  store i64 %297, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %298 = load i64, i64* %205, align 8
  %299 = add i64 %297, %298
  %300 = inttoptr i64 %299 to i32*
  %301 = load i32, i32* %300, align 4
  %302 = icmp eq i32 %301, 0
  %303 = zext i1 %302 to i8
  %304 = icmp eq i8 %303, 0
  br i1 %304, label %inst_145b, label %inst_13d8

inst_13d8:                                        ; preds = %inst_13bb
  %305 = mul i64 %331, 8
  %306 = load i64, i64* %221, align 8
  %307 = add i64 %305, %306
  %308 = add i64 1, %72
  %309 = inttoptr i64 %307 to i64*
  store i64 %308, i64* %309, align 8
  %310 = load i64, i64* %362, align 8
  %311 = mul i64 %310, 4
  %312 = load i64, i64* %205, align 8
  %313 = add i64 %311, %312
  %314 = inttoptr i64 %313 to i32*
  store i32 1, i32* %314, align 4
  %315 = load i64, i64* %269, align 8
  %316 = inttoptr i64 %315 to i64*
  %317 = load i64, i64* %316, align 8
  %318 = add i64 %317, 1
  store i64 %318, i64* @RCX_2248_40deb5b8, align 8, !tbaa !8
  store i64 %318, i64* %316, align 8
  %319 = mul i64 %317, 8
  %320 = load i64, i64* %292, align 8
  %321 = add i64 %320, %319
  %322 = load i64, i64* %362, align 8
  %323 = inttoptr i64 %321 to i64*
  store i64 %322, i64* %323, align 8
  %324 = load i64, i64* %267, align 8
  %325 = add i64 %324, 1
  store i64 %325, i64* %267, align 8
  %326 = mul i64 %324, 8
  %327 = load i64, i64* %203, align 8
  %328 = add i64 %327, %326
  store i64 %328, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %329 = load i64, i64* %362, align 8
  %330 = inttoptr i64 %328 to i64*
  store i64 %329, i64* %330, align 8
  br label %inst_146e

inst_138f:                                        ; preds = %inst_1460
  %331 = load i64, i64* %355, align 8
  %332 = zext i64 %331 to i128
  %333 = zext i64 %73 to i128
  %334 = mul i128 %333, %332
  %335 = trunc i128 %334 to i64
  %336 = add i64 %335, %72
  %337 = mul i64 %336, 4
  store i64 %337, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %338 = sub i64 %200, 72
  %339 = inttoptr i64 %338 to i64*
  %340 = load i64, i64* %339, align 8
  %341 = add i64 %337, %340
  %342 = inttoptr i64 %341 to i32*
  %343 = load i32, i32* %342, align 4
  %344 = icmp eq i32 %343, 0
  br i1 %344, label %inst_145b, label %inst_13bb

inst_1478:                                        ; preds = %inst_146e
  %345 = load i64, i64* %267, align 8
  %346 = sub i64 %345, 1
  store i64 %346, i64* %267, align 8
  br label %inst_147d

inst_1356:                                        ; preds = %inst_147d
  %347 = shl i64 %83, 2
  %348 = shl i64 %347, 1
  %349 = sub i64 %348, 8
  %350 = load i64, i64* %203, align 8
  %351 = add i64 %349, %350
  %352 = inttoptr i64 %351 to i64*
  %353 = load i64, i64* %352, align 8
  %354 = sub i64 %200, 8
  %355 = inttoptr i64 %354 to i64*
  store i64 %353, i64* %355, align 8
  %356 = mul i64 %353, 8
  store i64 %356, i64* @RDX_2264_40deb5b8, align 8, !tbaa !8
  %357 = load i64, i64* %221, align 8
  %358 = add i64 %356, %357
  %359 = inttoptr i64 %358 to i64*
  %360 = load i64, i64* %359, align 8
  %361 = sub i64 %200, 40
  %362 = inttoptr i64 %361 to i64*
  store i64 %360, i64* %362, align 8
  br label %inst_1460

inst_1488:                                        ; preds = %inst_147d
  %363 = load i64, i64* %205, align 8
  store i64 %363, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %363, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %364 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %365 = add i64 %364, -8
  %366 = inttoptr i64 %365 to i64*
  store i64 undef, i64* %366, align 8
  store i64 %365, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %367 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %199)
  %368 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %369 = sub i64 %368, 24
  %370 = inttoptr i64 %369 to i64*
  %371 = load i64, i64* %370, align 8
  store i64 %371, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %371, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %372 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %373 = add i64 %372, -8
  %374 = inttoptr i64 %373 to i64*
  store i64 ptrtoint (i8* @data_14a0 to i64), i64* %374, align 8
  store i64 %373, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %375 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %367)
  %376 = load i64, i64* @RBP_2328_40deb5b8, align 8
  %377 = sub i64 %376, 16
  %378 = inttoptr i64 %377 to i64*
  %379 = load i64, i64* %378, align 8
  store i64 %379, i64* @RAX_2216_40deb5b8, align 8, !tbaa !8
  store i64 %379, i64* @RDI_2296_40deb5b8, align 8, !tbaa !8
  %380 = load i64, i64* @RSP_2312_40deb5b8, align 8, !tbaa !5
  %381 = add i64 %380, -8
  %382 = inttoptr i64 %381 to i64*
  store i64 ptrtoint (i8* @data_14ac to i64), i64* %382, align 8
  store i64 %381, i64* @RSP_2312_40deb5b8, align 8, !tbaa !8
  %383 = call %struct.Memory* @ext_1090__free(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %375)
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
