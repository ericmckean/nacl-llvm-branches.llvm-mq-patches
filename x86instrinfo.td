# HG changeset patch
# Parent 2be012649be95f05ca11573379e657a78f4d42e3
# User Jason Kim <jasonwkim@google.com>
diff -r 2be012649be9 -r c669a08ea880 lib/Target/X86/X86InstrInfo.td
--- a/lib/Target/X86/X86InstrInfo.td	Thu Aug 11 18:13:14 2011 -0700
+++ b/lib/Target/X86/X86InstrInfo.td	Thu Aug 11 18:27:36 2011 -0700
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
+def IsNaCl32     : Predicate<"Subtarget->isTargetNaCl32()">, AssemblerPredicate<"ModeNaCl,In32BitMode">;
+def IsNaCl64     : Predicate<"Subtarget->isTargetNaCl64()">, AssemblerPredicate<"ModeNaCl,In64BitMode">;
+def NotNaCl      : Predicate<"!Subtarget->isTargetNaCl()">, AssemblerPredicate<"!ModeNaCl">;
 // @LOCALMOD-END
 def SmallCode    : Predicate<"TM.getCodeModel() == CodeModel::Small">;
 def KernelCode   : Predicate<"TM.getCodeModel() == CodeModel::Kernel">;
