# HG changeset patch
# Parent 31f6e972848a1dd64af316307ee72181a03abc61
# User Jason Kim <jasonwkim@google.com>

diff -r 31f6e972848a lib/Target/X86/X86InstrInfo.cpp
--- a/lib/Target/X86/X86InstrInfo.cpp	Fri Aug 12 00:13:44 2011 -0700
+++ b/lib/Target/X86/X86InstrInfo.cpp	Fri Aug 12 00:15:11 2011 -0700
@@ -309,7 +309,7 @@
      { X86::MOVDQArr,    X86::MOVDQAmr,        0, 16, true,    true },
     { X86::VMOVAPDYrr,    X86::VMOVAPDYmr,    0, 32, true,    true },
     { X86::VMOVAPSYrr,    X86::VMOVAPSYmr,    0, 32, true,    true },
-    { X86::VMOVDQAYrr,    X86::VMOVDQAYmr,    0, 32  true,    true },
+    { X86::VMOVDQAYrr,    X86::VMOVDQAYmr,    0, 32,  true,    true },
     { X86::MOVPDI2DIrr,   X86::MOVPDI2DImr,   0, 0,  true,    true },
     { X86::MOVPQIto64rr,  X86::MOVPQI2QImr,   0, 0,  true,    true },
     { X86::MOVSDto64rr,   X86::MOVSDto64mr,   0, 0,  true,    true },
diff -r 31f6e972848a lib/Target/X86/X86InstrInfo.td
--- a/lib/Target/X86/X86InstrInfo.td	Fri Aug 12 00:13:44 2011 -0700
+++ b/lib/Target/X86/X86InstrInfo.td	Fri Aug 12 00:15:11 2011 -0700
@@ -488,10 +488,11 @@
 def NotWin64     : Predicate<"!Subtarget->isTargetWin64()">;
 // @LOCALMOD-BEGIN
 // FIXME: Lift IsNaCl to share with ARM
-def IsNaCl       : Predicate<"Subtarget->isTargetNaCl()">, AssemblerPredicate;
-def IsNaCl32     : Predicate<"Subtarget->isTargetNaCl32()">, AssemblerPredicate;
-def IsNaCl64     : Predicate<"Subtarget->isTargetNaCl64()">, AssemblerPredicate;
-def NotNaCl      : Predicate<"!Subtarget->isTargetNaCl()">, AssemblerPredicate;
+include "llvm/Target/nativeclient.td"
+def IsNaCl       : Predicate<"Subtarget->isTargetNaCl()">, AssemblerPredicate<"ModeNaCl">;
+def IsNaCl32     : Predicate<"Subtarget->isTargetNaCl32()">, AssemblerPredicate<"ModeNaCl,!Mode64Bit">;
+def IsNaCl64     : Predicate<"Subtarget->isTargetNaCl64()">, AssemblerPredicate<"ModeNaCl,Mode64Bit">;
+def NotNaCl      : Predicate<"!Subtarget->isTargetNaCl()">, AssemblerPredicate<"!ModeNaCl">;
 // @LOCALMOD-END
 def SmallCode    : Predicate<"TM.getCodeModel() == CodeModel::Small">;
 def KernelCode   : Predicate<"TM.getCodeModel() == CodeModel::Kernel">;
diff -r 31f6e972848a lib/Target/X86/X86Subtarget.h
--- a/lib/Target/X86/X86Subtarget.h	Fri Aug 12 00:13:44 2011 -0700
+++ b/lib/Target/X86/X86Subtarget.h	Fri Aug 12 00:15:11 2011 -0700
@@ -111,6 +111,11 @@
   /// TargetTriple - What processor and OS we're targeting.
   Triple TargetTriple;
 
+  // @LOCALMOD-START
+  /// InNaClMode - True if we are in Native Client mode
+  bool InNaClMode;
+  // @LOCALMOD-END
+
 private:
   /// In64BitMode - True if compiling for 64-bit, false for 32-bit.
   bool In64BitMode;
diff -r 31f6e972848a lib/Target/X86/X86TargetObjectFile.cpp
--- a/lib/Target/X86/X86TargetObjectFile.cpp	Fri Aug 12 00:13:44 2011 -0700
+++ b/lib/Target/X86/X86TargetObjectFile.cpp	Fri Aug 12 00:15:11 2011 -0700
@@ -56,7 +56,7 @@
 // Without this the linker defined symbols __fini_array_start and
 // __fini_array_end do not have useful values. c.f.:
 // http://code.google.com/p/nativeclient/issues/detail?id=805
-void X86_NaClELFTargetObjectFile::Initialize(MCContext &Ctx,
+void X86_NaClElfTargetObjectFile::Initialize(MCContext &Ctx,
                                              const TargetMachine &TM) {
   TargetLoweringObjectFileELF::Initialize(Ctx, TM);
   if (TM.getSubtarget<X86Subtarget>().isTargetNaCl()) {
diff -r 31f6e972848a lib/Target/X86/X86TargetObjectFile.h
--- a/lib/Target/X86/X86TargetObjectFile.h	Fri Aug 12 00:13:44 2011 -0700
+++ b/lib/Target/X86/X86TargetObjectFile.h	Fri Aug 12 00:15:11 2011 -0700
@@ -37,7 +37,7 @@
 class X86_NaClElfTargetObjectFile : public TargetLoweringObjectFileELF {
 public:
   virtual void Initialize(MCContext &Ctx, const TargetMachine &TM);
-}
+};
 // @LOCALMOD-END
 
 } // end namespace llvm
