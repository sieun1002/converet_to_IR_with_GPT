; ModuleID = 'dijkstra_single_func.ll'
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
@data_40113f = external global i8
@data_402014 = external global i8
@data_402004 = external global i8
@RSP_2312_91fb638 = external global i64
@OF_2077_91fb5f0 = external global i8
@SF_2073_91fb5f0 = external global i8
@ZF_2071_91fb5f0 = external global i8
@AF_2069_91fb5f0 = external global i8
@PF_2067_91fb5f0 = external global i8
@CF_2065_91fb5f0 = external global i8
@RAX_2216_91fb638 = external global i64
@RSP_2312_9202c00 = external global i64*
@RCX_2248_91fb638 = external global i64
@RSI_2280_91fb638 = external global i64
@RDX_2264_91fb638 = external global i64
@RBP_2328_91fb638 = external global i64
@RDI_2296_9202aa0 = external global i8*
@RDI_2296_91fb638 = external global i64
@RAX_2216_91fb5f0 = external global i8
@RSI_2280_91fb620 = external global i32
@RDX_2264_91fb620 = external global i32

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_401120_dijkstra(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_401120:
  %0 = load i64, i64* @RBP_2328_91fb638, align 8
  %1 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_91fb638, align 8, !tbaa !8
  %4 = sub i64 %2, 848
  store i64 %4, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %5 = sub i64 %2, 8
  %6 = load i64, i64* @RDI_2296_91fb638, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 12
  %9 = load i32, i32* @RSI_2280_91fb620, align 4
  %10 = inttoptr i64 %8 to i32*
  store i32 %9, i32* %10, align 4
  %11 = sub i64 %2, 16
  %12 = load i32, i32* @RDX_2264_91fb620, align 4
  %13 = inttoptr i64 %11 to i32*
  store i32 %12, i32* %13, align 4
  %14 = sub i64 %2, 820
  %15 = inttoptr i64 %14 to i32*
  store i32 0, i32* %15, align 4
  br label %inst_40113f

inst_401388:                                      ; preds = %inst_401248, %inst_40119f
  %16 = phi %struct.Memory* [ %41, %inst_40119f ], [ %41, %inst_401248 ]
  %17 = select i1 %56, i64 add (i64 ptrtoint (i8* @data_40113f to i64), i64 585), i64 add (i64 ptrtoint (i8* @data_40113f to i64), i64 116)
  %18 = add i64 %17, 10
  %19 = sub i64 %2, 844
  %20 = inttoptr i64 %19 to i32*
  store i32 0, i32* %20, align 4
  br label %inst_401392

inst_401392:                                      ; preds = %inst_4013fa, %inst_401388
  %21 = phi %struct.Memory* [ %16, %inst_401388 ], [ %100, %inst_4013fa ]
  %22 = load i64, i64* @RBP_2328_91fb638, align 8
  %23 = sub i64 %22, 844
  %24 = inttoptr i64 %23 to i32*
  %25 = load i32, i32* %24, align 4
  %26 = zext i32 %25 to i64
  store i64 %26, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %27 = sub i64 %22, 12
  %28 = inttoptr i64 %27 to i32*
  %29 = load i32, i32* %28, align 4
  %30 = sub i32 %25, %29
  %31 = lshr i32 %30, 31
  %32 = trunc i32 %31 to i8
  %33 = lshr i32 %25, 31
  %34 = lshr i32 %29, 31
  %35 = xor i32 %34, %33
  %36 = xor i32 %31, %33
  %37 = add nuw nsw i32 %36, %35
  %38 = icmp eq i32 %37, 2
  %39 = icmp eq i8 %32, 0
  %40 = xor i1 %39, %38
  br i1 %40, label %inst_401413, label %inst_4013a1

inst_40119f:                                      ; preds = %inst_40136f, %inst_401186
  %41 = phi %struct.Memory* [ %memory, %inst_401186 ], [ %41, %inst_40136f ]
  %42 = load i32, i32* %113, align 4
  %43 = load i32, i32* %10, align 4
  %44 = sub i32 %43, 1
  %45 = zext i32 %44 to i64
  store i64 %45, i64* @RCX_2248_91fb638, align 8, !tbaa !8
  %46 = sub i32 %42, %44
  %47 = lshr i32 %46, 31
  %48 = trunc i32 %47 to i8
  %49 = lshr i32 %42, 31
  %50 = lshr i32 %44, 31
  %51 = xor i32 %50, %49
  %52 = xor i32 %47, %49
  %53 = add nuw nsw i32 %52, %51
  %54 = icmp eq i32 %53, 2
  %55 = icmp eq i8 %48, 0
  %56 = xor i1 %55, %54
  br i1 %56, label %inst_401388, label %inst_4011b3

inst_40122f:                                      ; preds = %inst_40120f, %inst_4011f5, %inst_4011e0
  %57 = load i32, i32* %132, align 4
  %58 = add i32 1, %57
  store i32 %58, i32* %132, align 4
  br label %inst_4011d1

inst_40113f:                                      ; preds = %inst_40114e, %inst_401120
  %59 = load i32, i32* %15, align 4
  %60 = load i32, i32* %10, align 4
  %61 = sub i32 %59, %60
  %62 = lshr i32 %61, 31
  %63 = trunc i32 %62 to i8
  %64 = lshr i32 %59, 31
  %65 = lshr i32 %60, 31
  %66 = xor i32 %65, %64
  %67 = xor i32 %62, %64
  %68 = add nuw nsw i32 %67, %66
  %69 = icmp eq i32 %68, 2
  %70 = icmp eq i8 %63, 0
  %71 = xor i1 %70, %69
  br i1 %71, label %inst_401186, label %inst_40114e

inst_4011d1:                                      ; preds = %inst_4011b3, %inst_40122f
  %72 = load i32, i32* %132, align 4
  %73 = load i32, i32* %10, align 4
  %74 = sub i32 %72, %73
  %75 = lshr i32 %74, 31
  %76 = trunc i32 %75 to i8
  %77 = lshr i32 %72, 31
  %78 = lshr i32 %73, 31
  %79 = xor i32 %78, %77
  %80 = xor i32 %75, %77
  %81 = add nuw nsw i32 %80, %79
  %82 = icmp eq i32 %81, 2
  %83 = icmp eq i8 %76, 0
  %84 = xor i1 %83, %82
  br i1 %84, label %inst_401248, label %inst_4011e0

inst_401356:                                      ; preds = %inst_40131b, %inst_4012d8, %inst_4012c0, %inst_4012ab, %inst_401285
  %85 = load i32, i32* %169, align 4
  %86 = add i32 1, %85
  store i32 %86, i32* %169, align 4
  br label %inst_401276

inst_401276:                                      ; preds = %inst_40125a, %inst_401356
  %87 = load i32, i32* %169, align 4
  %88 = load i32, i32* %10, align 4
  %89 = sub i32 %87, %88
  %90 = lshr i32 %89, 31
  %91 = trunc i32 %90 to i8
  %92 = lshr i32 %87, 31
  %93 = lshr i32 %88, 31
  %94 = xor i32 %93, %92
  %95 = xor i32 %90, %92
  %96 = add nuw nsw i32 %95, %94
  %97 = icmp eq i32 %96, 2
  %98 = icmp eq i8 %91, 0
  %99 = xor i1 %98, %97
  br i1 %99, label %inst_40136f, label %inst_401285

inst_4013fa:                                      ; preds = %inst_4013b9, %inst_4013d5
  %100 = phi %struct.Memory* [ %292, %inst_4013d5 ], [ %299, %inst_4013b9 ]
  %101 = load i64, i64* @RBP_2328_91fb638, align 8
  %102 = sub i64 %101, 844
  %103 = inttoptr i64 %102 to i32*
  %104 = load i32, i32* %103, align 4
  %105 = add i32 1, %104
  store i32 %105, i32* %103, align 4
  br label %inst_401392

inst_401186:                                      ; preds = %inst_40113f
  %106 = load i32, i32* %13, align 4
  %107 = sext i32 %106 to i64
  %108 = mul i64 %107, 4
  %109 = add i64 %2, -416
  %110 = add i64 %109, %108
  %111 = inttoptr i64 %110 to i32*
  store i32 0, i32* %111, align 4
  %112 = sub i64 %2, 824
  %113 = inttoptr i64 %112 to i32*
  store i32 0, i32* %113, align 4
  br label %inst_40119f

inst_40114e:                                      ; preds = %inst_40113f
  %114 = sext i32 %59 to i64
  %115 = mul i64 %114, 4
  %116 = add i64 %2, -416
  %117 = add i64 %116, %115
  %118 = inttoptr i64 %117 to i32*
  store i32 2147483647, i32* %118, align 4
  %119 = load i32, i32* %15, align 4
  %120 = sext i32 %119 to i64
  %121 = mul i64 %120, 4
  %122 = add i64 %2, -816
  %123 = add i64 %122, %121
  %124 = inttoptr i64 %123 to i32*
  store i32 0, i32* %124, align 4
  %125 = load i32, i32* %15, align 4
  %126 = add i32 1, %125
  store i32 %126, i32* %15, align 4
  br label %inst_40113f

inst_4011b3:                                      ; preds = %inst_40119f
  %127 = sub i64 %2, 828
  %128 = inttoptr i64 %127 to i32*
  store i32 -1, i32* %128, align 4
  %129 = sub i64 %2, 832
  %130 = inttoptr i64 %129 to i32*
  store i32 2147483647, i32* %130, align 4
  %131 = sub i64 %2, 836
  %132 = inttoptr i64 %131 to i32*
  store i32 0, i32* %132, align 4
  br label %inst_4011d1

inst_401248:                                      ; preds = %inst_4011d1
  %133 = load i32, i32* %128, align 4
  %134 = sub i32 %133, -1
  %135 = icmp eq i32 %134, 0
  %136 = zext i1 %135 to i8
  %137 = icmp eq i8 %136, 0
  br i1 %137, label %inst_40125a, label %inst_401388

inst_4011e0:                                      ; preds = %inst_4011d1
  %138 = sext i32 %72 to i64
  %139 = mul i64 %138, 4
  %140 = add i64 %2, -816
  %141 = add i64 %140, %139
  %142 = inttoptr i64 %141 to i32*
  %143 = load i32, i32* %142, align 4
  %144 = icmp eq i32 %143, 0
  %145 = zext i1 %144 to i8
  %146 = icmp eq i8 %145, 0
  br i1 %146, label %inst_40122f, label %inst_4011f5

inst_4011f5:                                      ; preds = %inst_4011e0
  %147 = add i64 %109, %139
  %148 = inttoptr i64 %147 to i32*
  %149 = load i32, i32* %148, align 4
  %150 = load i32, i32* %130, align 4
  %151 = sub i32 %149, %150
  %152 = lshr i32 %151, 31
  %153 = trunc i32 %152 to i8
  %154 = lshr i32 %149, 31
  %155 = lshr i32 %150, 31
  %156 = xor i32 %155, %154
  %157 = xor i32 %152, %154
  %158 = add nuw nsw i32 %157, %156
  %159 = icmp eq i32 %158, 2
  %160 = icmp eq i8 %153, 0
  %161 = xor i1 %160, %159
  br i1 %161, label %inst_40122f, label %inst_40120f

inst_40120f:                                      ; preds = %inst_4011f5
  store i32 %149, i32* %130, align 4
  %162 = load i32, i32* %132, align 4
  store i32 %162, i32* %128, align 4
  br label %inst_40122f

inst_40125a:                                      ; preds = %inst_401248
  %163 = sext i32 %133 to i64
  %164 = mul i64 %163, 4
  %165 = add i64 %2, -816
  %166 = add i64 %165, %164
  %167 = inttoptr i64 %166 to i32*
  store i32 1, i32* %167, align 4
  %168 = sub i64 %2, 840
  %169 = inttoptr i64 %168 to i32*
  store i32 0, i32* %169, align 4
  br label %inst_401276

inst_40136f:                                      ; preds = %inst_401276
  %170 = load i32, i32* %113, align 4
  %171 = add i32 1, %170
  store i32 %171, i32* %113, align 4
  br label %inst_40119f

inst_401285:                                      ; preds = %inst_401276
  %172 = load i64, i64* %7, align 8
  %173 = load i32, i32* %128, align 4
  %174 = sext i32 %173 to i64
  %175 = zext i64 %174 to i128
  %176 = mul i128 400, %175
  %177 = trunc i128 %176 to i64
  %178 = add i64 %177, %172
  %179 = sext i32 %87 to i64
  %180 = mul i64 %179, 4
  %181 = add i64 %180, %178
  %182 = inttoptr i64 %181 to i32*
  %183 = load i32, i32* %182, align 4
  %184 = icmp eq i32 %183, 0
  br i1 %184, label %inst_401356, label %inst_4012ab

inst_4012ab:                                      ; preds = %inst_401285
  %185 = add i64 %165, %180
  %186 = inttoptr i64 %185 to i32*
  %187 = load i32, i32* %186, align 4
  %188 = icmp eq i32 %187, 0
  %189 = zext i1 %188 to i8
  %190 = icmp eq i8 %189, 0
  br i1 %190, label %inst_401356, label %inst_4012c0

inst_4012c0:                                      ; preds = %inst_4012ab
  %191 = mul i64 %174, 4
  %192 = add i64 %109, %191
  %193 = inttoptr i64 %192 to i32*
  %194 = load i32, i32* %193, align 4
  %195 = sub i32 %194, 2147483647
  %196 = icmp eq i32 %195, 0
  br i1 %196, label %inst_401356, label %inst_4012d8

inst_4012d8:                                      ; preds = %inst_4012c0
  %197 = add i64 %109, %180
  %198 = inttoptr i64 %197 to i32*
  %199 = load i32, i32* %198, align 4
  store i64 %178, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  store i64 %179, i64* @RSI_2280_91fb638, align 8, !tbaa !8
  %200 = add i32 %183, %194
  %201 = sub i32 %199, %200
  %202 = icmp eq i32 %201, 0
  %203 = lshr i32 %201, 31
  %204 = trunc i32 %203 to i8
  %205 = lshr i32 %199, 31
  %206 = lshr i32 %200, 31
  %207 = xor i32 %206, %205
  %208 = xor i32 %203, %205
  %209 = add nuw nsw i32 %208, %207
  %210 = icmp eq i32 %209, 2
  %211 = icmp ne i8 %204, 0
  %212 = xor i1 %211, %210
  %213 = or i1 %202, %212
  br i1 %213, label %inst_401356, label %inst_40131b

inst_40131b:                                      ; preds = %inst_4012d8
  store i64 %179, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  store i32 %200, i32* %198, align 4
  br label %inst_401356

inst_401413:                                      ; preds = %inst_401392
  %214 = load i64*, i64** @RSP_2312_9202c00, align 8
  %215 = load i64, i64* @RSP_2312_91fb638, align 8
  %216 = add i64 848, %215
  %217 = icmp ult i64 %216, %215
  %218 = icmp ult i64 %216, 848
  %219 = or i1 %217, %218
  %220 = zext i1 %219 to i8
  store i8 %220, i8* @CF_2065_91fb5f0, align 1, !tbaa !10
  %221 = trunc i64 %216 to i32
  %222 = and i32 %221, 255
  %223 = call i32 @llvm.ctpop.i32(i32 %222) #3, !range !24
  %224 = trunc i32 %223 to i8
  %225 = and i8 %224, 1
  %226 = xor i8 %225, 1
  store i8 %226, i8* @PF_2067_91fb5f0, align 1, !tbaa !25
  %227 = xor i64 848, %215
  %228 = xor i64 %227, %216
  %229 = lshr i64 %228, 4
  %230 = trunc i64 %229 to i8
  %231 = and i8 %230, 1
  store i8 %231, i8* @AF_2069_91fb5f0, align 1, !tbaa !26
  %232 = icmp eq i64 %216, 0
  %233 = zext i1 %232 to i8
  store i8 %233, i8* @ZF_2071_91fb5f0, align 1, !tbaa !27
  %234 = lshr i64 %216, 63
  %235 = trunc i64 %234 to i8
  store i8 %235, i8* @SF_2073_91fb5f0, align 1, !tbaa !28
  %236 = lshr i64 %215, 63
  %237 = xor i64 %234, %236
  %238 = add nuw nsw i64 %237, %234
  %239 = icmp eq i64 %238, 2
  %240 = zext i1 %239 to i8
  store i8 %240, i8* @OF_2077_91fb5f0, align 1, !tbaa !29
  %241 = add i64 %216, 8
  %242 = getelementptr i64, i64* %214, i32 106
  %243 = load i64, i64* %242, align 8
  store i64 %243, i64* @RBP_2328_91fb638, align 8, !tbaa !8
  %244 = add i64 %241, 8
  store i64 %244, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  ret %struct.Memory* %21

inst_4013a1:                                      ; preds = %inst_401392
  %245 = add i64 %18, 6
  %246 = add i64 %245, 3
  %247 = add i64 %246, 6
  %248 = add i64 %247, 7
  %249 = sext i32 %25 to i64
  store i64 %249, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %250 = add i64 %248, 11
  %251 = mul i64 %249, 4
  %252 = add i64 %22, -416
  %253 = add i64 %252, %251
  %254 = inttoptr i64 %253 to i32*
  %255 = load i32, i32* %254, align 4
  %256 = sub i32 %255, 2147483647
  %257 = icmp ult i32 %255, 2147483647
  %258 = zext i1 %257 to i8
  store i8 %258, i8* @CF_2065_91fb5f0, align 1, !tbaa !10
  %259 = and i32 %256, 255
  %260 = call i32 @llvm.ctpop.i32(i32 %259) #3, !range !24
  %261 = trunc i32 %260 to i8
  %262 = and i8 %261, 1
  %263 = xor i8 %262, 1
  store i8 %263, i8* @PF_2067_91fb5f0, align 1, !tbaa !25
  %264 = xor i32 %255, 2147483647
  %265 = xor i32 %264, %256
  %266 = lshr i32 %265, 4
  %267 = trunc i32 %266 to i8
  %268 = and i8 %267, 1
  store i8 %268, i8* @AF_2069_91fb5f0, align 1, !tbaa !26
  %269 = icmp eq i32 %256, 0
  %270 = zext i1 %269 to i8
  store i8 %270, i8* @ZF_2071_91fb5f0, align 1, !tbaa !27
  %271 = lshr i32 %256, 31
  %272 = trunc i32 %271 to i8
  store i8 %272, i8* @SF_2073_91fb5f0, align 1, !tbaa !28
  %273 = lshr i32 %255, 31
  %274 = xor i32 %271, %273
  %275 = add nuw nsw i32 %274, %273
  %276 = icmp eq i32 %275, 2
  %277 = zext i1 %276 to i8
  store i8 %277, i8* @OF_2077_91fb5f0, align 1, !tbaa !29
  %278 = add i64 %250, 6
  %279 = add i64 %278, 28
  %280 = icmp eq i8 %270, 0
  %281 = select i1 %280, i64 %279, i64 %278
  %282 = add i64 %281, 6
  store i64 %26, i64* @RSI_2280_91fb638, align 8, !tbaa !8
  br i1 %280, label %inst_4013d5, label %inst_4013b9

inst_4013d5:                                      ; preds = %inst_4013a1
  %283 = add i64 %282, 7
  store i64 %249, i64* @RAX_2216_91fb638, align 8, !tbaa !8
  %284 = add i64 %283, 7
  %285 = zext i32 %255 to i64
  store i64 %285, i64* @RDX_2264_91fb638, align 8, !tbaa !8
  %286 = add i64 %284, 10
  store i8* @data_402014, i8** @RDI_2296_9202aa0, align 8
  %287 = add i64 %286, 2
  store i8 0, i8* @RAX_2216_91fb5f0, align 1, !tbaa !5
  %288 = add i64 %287, 5
  %289 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %290 = add i64 %289, -8
  %291 = inttoptr i64 %290 to i64*
  store i64 %288, i64* %291, align 8
  store i64 %290, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %292 = call %struct.Memory* @ext_404040_printf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %21)
  br label %inst_4013fa

inst_4013b9:                                      ; preds = %inst_4013a1
  %293 = add i64 %282, 10
  store i8* @data_402004, i8** @RDI_2296_9202aa0, align 8
  %294 = add i64 %293, 2
  store i8 0, i8* @RAX_2216_91fb5f0, align 1, !tbaa !5
  %295 = add i64 %294, 5
  %296 = load i64, i64* @RSP_2312_91fb638, align 8, !tbaa !5
  %297 = add i64 %296, -8
  %298 = inttoptr i64 %297 to i64*
  store i64 %295, i64* %298, align 8
  store i64 %297, i64* @RSP_2312_91fb638, align 8, !tbaa !8
  %299 = call %struct.Memory* @ext_404040_printf(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %21)
  br label %inst_4013fa
}

; Function Attrs: noinline
declare hidden %struct.Memory* @ext_404040_printf(%struct.State*, i64, %struct.Memory*) #2

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
