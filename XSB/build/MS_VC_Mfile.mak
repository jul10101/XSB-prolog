#   MS_VC_Mfile.mak:  Makefile to compile XSB on Windows using VC++ NMAKE
#   Generated automatically from MS_VC_Mfile.in by configure.
#
# Usage:
#   NMAKE /f "MS_VC_Mfile.mak" CFG="option" [DLL="yes"] [ORACLE="yes"] [SITE_LIBS="addl libs"]
#
# Where: CFG = release | debug
#    	 DLL = yes: build as a DLL
#        ORACLE=yes: build with support for Oracle
#        SITE_LIBS=<...> : additional loader libraries (required for Oracle)
#
# Note: Specifying any non-zero string for DLL and ORACLE means "yes"!
#

!IF "$(CFG)" == ""
CFG=release
!ENDIF 

!IF "$(CFG)" != "release" && "$(CFG)" != "debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "MS_VC_Mfile.mak" CFG="debug"
!MESSAGE 
!MESSAGE Possible choices for configuration (CFG) are:
!MESSAGE 
!MESSAGE "release"
!MESSAGE "debug"
!MESSAGE ""  (defaults to "release")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(DLL)" != "yes" && "$(DLL)" != "no" && "$(DLL)" != ""
!MESSAGE Invalid macro DLL="$(DLL)" specified.
!MESSAGE This macro controls whether you want XSB to be built as a DLL.
!MESSAGE For example:
!MESSAGE 
!MESSAGE NMAKE /f "MS_VC_Mfile.mak" CFG="debug" DLL="yes"
!MESSAGE 
!MESSAGE Possible choices for the DLL macro are:
!MESSAGE 
!MESSAGE "yes"
!MESSAGE "no"
!MESSAGE ""
!MESSAGE 
!ERROR An invalid value for the DLL macro specified.
!ENDIF 

!IF "$(ORACLE)" != "yes" && "$(ORACLE)" != "no" && "$(ORACLE)" != ""
!MESSAGE Invalid macro ORACLE="$(ORACLE)" specified.
!MESSAGE This macro controls whether you want XSB to be built
!MESSAGE with support for ORACLE. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MS_VC_Mfile.mak" CFG="release" && ORACLE="yes"
!MESSAGE 
!MESSAGE Possible choices for the ORACLE macro are:
!MESSAGE 
!MESSAGE "yes"
!MESSAGE "no"
!MESSAGE ""
!MESSAGE 
!ERROR An invalid value for the ORACLE macro specified.
!ENDIF 

!IF "$(DLL)" == ""
DLL=no
!ENDIF
!IF "$(ORACLE)" == ""
ORACLE=no
!ENDIF

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

################################################################################
# Begin Project
CPP=cl.exe

# Assume we are running NMAKE in the emu directory
!IF  "$(DLL)" == "yes"
# Put DLL in the saved.o directory
OUTDIR=..\config\sparc-sun-solaris2.6\saved.o
!ELSE
OUTDIR=..\config\sparc-sun-solaris2.6\bin
!ENDIF

INTDIR=.

!IF  "$(ORACLE)" == "yes"
ORACLE_FLAG=/D "ORACLE"
ORACLE=MSG=with Oracle support
!IF  "$(SITE_LIBS)" == ""
!MESSAGE Oracle libraries must be specified, if building XSB with support for Oracle
!MESSAGE Usage:
!ERROR NMAKE /f "MS_VC_Mfile.mak" CFG="..." ORACLE=yes SITE_LIBS="oracle libs"
!ENDIF
!ENDIF

!IF "$(DLL)" == "yes"
ALL : "$(OUTDIR)\xsb.dll"
!ELSE
ALL : "$(OUTDIR)\xsb.exe"
!ENDIF

SOCKET_LIBRARY=wsock32.lib

CLEAN : 
	-@erase "$(INTDIR)\auxlry.obj"
	-@erase "$(INTDIR)\biassert.obj"
	-@erase "$(INTDIR)\builtin.obj"
	-@erase "$(INTDIR)\cinterf.obj"
	-@erase "$(INTDIR)\cutils.obj"
	-@erase "$(INTDIR)\debug.obj"
	-@erase "$(INTDIR)\dis.obj"
	-@erase "$(INTDIR)\dynload.obj"
	-@erase "$(INTDIR)\emuloop.obj"
	-@erase "$(INTDIR)\findall.obj"
	-@erase "$(INTDIR)\function.obj"
	-@erase "$(INTDIR)\hash.obj"
	-@erase "$(INTDIR)\heap.obj"
	-@erase "$(INTDIR)\inst.obj"
	-@erase "$(INTDIR)\init.obj"
	-@erase "$(INTDIR)\io_builtins.obj"
	-@erase "$(INTDIR)\loader.obj"
	-@erase "$(INTDIR)\load_seg.obj"
	-@erase "$(INTDIR)\memory.obj"
	-@erase "$(INTDIR)\orastuff.obj"
	-@erase "$(INTDIR)\psc.obj"
	-@erase "$(INTDIR)\residual.obj"
	-@erase "$(INTDIR)\scc.obj"
	-@erase "$(INTDIR)\self_orientation.obj"
	-@erase "$(INTDIR)\slgdelay.obj"
	-@erase "$(INTDIR)\subp.obj"
	-@erase "$(INTDIR)\system.obj"
	-@erase "$(INTDIR)\token.obj"
	-@erase "$(INTDIR)\trace.obj"
	-@erase "$(INTDIR)\tries.obj"
	-@erase "$(INTDIR)\tr_utils.obj"
	-@erase "$(INTDIR)\xmain.obj"
	-@erase "$(INTDIR)\xpathname.obj"
	-@erase "$(INTDIR)\xsb_odbc.obj"
	-@erase "$(INTDIR)\xsberror.obj"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_OBJS=$(INTDIR)/
CPP_SBRS=
LINK32=link.exe
LINK32_OBJS= \
	"$(INTDIR)/auxlry.obj" \
	"$(INTDIR)/builtin.obj" \
	"$(INTDIR)/biassert.obj" \
	"$(INTDIR)/cinterf.obj" \
	"$(INTDIR)/cutils.obj" \
	"$(INTDIR)/debug.obj" \
	"$(INTDIR)/dis.obj" \
	"$(INTDIR)/dynload.obj" \
	"$(INTDIR)/emuloop.obj" \
	"$(INTDIR)/findall.obj" \
	"$(INTDIR)/function.obj" \
	"$(INTDIR)/hash.obj" \
	"$(INTDIR)/heap.obj" \
	"$(INTDIR)/init.obj" \
	"$(INTDIR)/inst.obj" \
	"$(INTDIR)/io_builtins.obj" \
	"$(INTDIR)/loader.obj" \
	"$(INTDIR)/load_seg.obj" \
	"$(INTDIR)/memory.obj" \
	"$(INTDIR)/psc.obj" \
	"$(INTDIR)/residual.obj" \
	"$(INTDIR)/self_orientation.obj" \
	"$(INTDIR)/slgdelay.obj" \
	"$(INTDIR)/subp.obj" \
	"$(INTDIR)/scc.obj" \
	"$(INTDIR)/system.obj" \
	"$(INTDIR)/token.obj" \
	"$(INTDIR)/trace.obj" \
	"$(INTDIR)/tries.obj" \
	"$(INTDIR)/tr_utils.obj" \
	"$(INTDIR)/xpathname.obj" \
	"$(INTDIR)/xsb_odbc.obj" \
	"$(INTDIR)/xsberror.obj"

# DLLs don't use xmain.c
!IF  "$(DLL)" == "no"
LINK32_OBJS=$(LINK32_OBJS) $(INTDIR)/xmain.obj
!ENDIF

# Oracle requires one additional file
!IF "$(ORACLE)" == "yes"
LINK32_OBJS=$(LINK32_OBJS) $(INTDIR)/orastuff.obj
!ENDIF

!IF  "$(CFG)" == "release"  &&  "$(DLL)" == "no"
!MESSAGE Building XSB executable in Release mode $(ORACLE_MSG)

CPP_PROJ=/nologo /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE"\
 $ORACLE_FLAG /Fp"$(INTDIR)/xsb.pch" /YX /Fo"$(INTDIR)/" /c 

LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib $(SOCKET_LIBRARY) "$(SITE_LIBS)" /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/xsb.pdb" /machine:I386 \
 /out:"$(OUTDIR)/xsb.exe" 


!ELSEIF  "$(CFG)" == "debug"  &&  "$(DLL)" == "no"
!MESSAGE Building XSB executable in Debug mode $(ORACLE_MSG)

CPP_PROJ=/nologo /MLd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /D "DEBUG" $ORACLE_FLAG\
  /Fp"$(INTDIR)/xsb.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib $(SOCKET_LIBRARY) "$(SITE_LIBS)" /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/xsb.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)\xsb.exe" 


!ELSEIF "$(CFG)" == "release" && "$(DLL)" == "yes"
!MESSAGE Building XSB as a DLL in Release mode $(ORACLE_MSG)

CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
  /D "XSB_DLL" $ORACLE_FLAG /Fp"$(INTDIR)/xsb.pch" /YX /Fo"$(INTDIR)/" /c 
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib $(SOCKET_LIBRARY) "$(SITE_LIBS)" /nologo /subsystem:windows /dll /incremental:no\
 /pdb:"$(OUTDIR)/xsb.pdb" /machine:I386 /out:"$(OUTDIR)/xsb.dll"\
 /implib:"$(OUTDIR)/xsb.lib" 

!ELSEIF "$(CFG)" == "debug" &&  "$(DLL)" == "yes"
!MESSAGE Building XSB as a DLL in Debug mode $(ORACLE_MSG)

CPP_PROJ=/nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "DEBUG" $ORACLE_FLAG /D "XSB_DLL" /Fp"$(INTDIR)/xsb.pch" /YX\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 

LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib $(SOCKET_LIBRARY) "$(SITE_LIBS)" /nologo /subsystem:windows /dll /incremental:yes\
 /pdb:"$(OUTDIR)/xsb.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)\xsb.dll"\
 /implib:"$(OUTDIR)/xsb.lib"	 

!ENDIF 


"$(OUTDIR)\xsb.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

"$(OUTDIR)\xsb.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  


################################################################################
# Begin Source File

SOURCE=$(INTDIR)\xsberror.c
DEP_CPP_XSBER=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\basictypes.h"\
	


"$(INTDIR)\xsberror.obj" : $(SOURCE) $(DEP_CPP_XSBER) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)

# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\xsb_odbc.c
DEP_CPP_XSB_O=\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\xsb_odbc.obj" : $(SOURCE) $(DEP_CPP_XSB_O) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\xpathname.c
DEP_CPP_XPATH=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\xpathname.obj" : $(SOURCE) $(DEP_CPP_XPATH) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\tries.c
DEP_CPP_TRIES=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_tries.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	

"$(INTDIR)\tries.obj" : $(SOURCE) $(DEP_CPP_TRIES) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\trace.c
DEP_CPP_TRACE=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\trace.obj" : $(SOURCE) $(DEP_CPP_TRACE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\tr_utils.c
DEP_CPP_TR_UT=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_tries.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\switch.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	

"$(INTDIR)\tr_utils.obj" : $(SOURCE) $(DEP_CPP_TR_UT) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\system.c
DEP_CPP_SYSTE=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\msyscall.h"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	

"$(INTDIR)\system.obj" : $(SOURCE) $(DEP_CPP_SYSTE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\subp.c
DEP_CPP_SUBP_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\token.h"\
	{$(INTDIR)}"\sig.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\unify.i"\
	{$(INTDIR)}"\sp_unify.i"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\subp.obj" : $(SOURCE) $(DEP_CPP_SUBP_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\slgdelay.c
DEP_CPP_SLGDE=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\subinst.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	

"$(INTDIR)\slgdelay.obj" : $(SOURCE) $(DEP_CPP_SLGDE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\self_orientation.c
DEP_CPP_SELF_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	

"$(INTDIR)\self_orientation.obj" : $(SOURCE) $(DEP_CPP_SELF_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\scc.c
DEP_CPP_SCC_C=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\scc.obj" : $(SOURCE) $(DEP_CPP_SCC_C) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\residual.c
DEP_CPP_RESID=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_residual.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\residual.obj" : $(SOURCE) $(DEP_CPP_RESID) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\psc.c
DEP_CPP_PSC_C=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\hash.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\psc.obj" : $(SOURCE) $(DEP_CPP_PSC_C) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\memory.c
DEP_CPP_MEMOR=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\memory.obj" : $(SOURCE) $(DEP_CPP_MEMOR) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\load_seg.c
DEP_CPP_LOAD_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\load_seg.obj" : $(SOURCE) $(DEP_CPP_LOAD_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\io_builtins.c
DEP_CPP_IO_BU=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\token.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\load_seg.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\switch.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\io_builtins.obj" : $(SOURCE) $(DEP_CPP_IO_BU) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\inst.c
DEP_CPP_INST_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\subinst.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\inst.obj" : $(SOURCE) $(DEP_CPP_INST_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\init.c
DEP_CPP_INIT_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\hash.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\load_seg.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\init.obj" : $(SOURCE) $(DEP_CPP_INIT_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\heap.c
DEP_CPP_HEAP_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\heap.obj" : $(SOURCE) $(DEP_CPP_HEAP_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\hash.c
DEP_CPP_HASH_=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\hash.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\hash.obj" : $(SOURCE) $(DEP_CPP_HASH_) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\function.c
DEP_CPP_FUNCT=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\function.obj" : $(SOURCE) $(DEP_CPP_FUNCT) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\findall.c
DEP_CPP_FINDA=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\basictypes.h"\
	

"$(INTDIR)\findall.obj" : $(SOURCE) $(DEP_CPP_FINDA) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\emuloop.c
DEP_CPP_EMULO=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\sig.h"\
	{$(INTDIR)}"\emudef.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\subinst.h"\
	{$(INTDIR)}"\scc.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\cut.h"\
	{$(INTDIR)}"\tr_delay.h"\
	{$(INTDIR)}"\tr_code.i"\
	{$(INTDIR)}"\schedrev.i"\
	{$(INTDIR)}"\wfs.i"\
	{$(INTDIR)}"\slginsts.i"\
	{$(INTDIR)}"\tc_insts.i"\
	{$(INTDIR)}"\unify.i"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	{$(INTDIR)}"\complete.i"\
	{$(INTDIR)}"\debugs\debug_tries.h"\
	

"$(INTDIR)\emuloop.obj" : $(SOURCE) $(DEP_CPP_EMULO) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\dynload.c
DEP_CPP_DYNLO=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\dyncoff.i"\
	{$(INTDIR)}"\dynelf.i"\
	{$(INTDIR)}"\dynaout.i"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\flags.h"\
	

"$(INTDIR)\dynload.obj" : $(SOURCE) $(DEP_CPP_DYNLO) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\dis.c
DEP_CPP_DIS_C=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\hash.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\dis.obj" : $(SOURCE) $(DEP_CPP_DIS_C) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\debug.c
DEP_CPP_DEBUG=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\debug.obj" : $(SOURCE) $(DEP_CPP_DEBUG) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\cutils.c
DEP_CPP_CUTIL=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\cutils.obj" : $(SOURCE) $(DEP_CPP_CUTIL) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\cinterf.c
DEP_CPP_CINTE=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\emuloop.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\self_orientation.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	

"$(INTDIR)\cinterf.obj" : $(SOURCE) $(DEP_CPP_CINTE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\builtin.c
DEP_CPP_BUILT=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INCLUDE)}"\sys\types.h"\
	{$(INCLUDE)}"\sys\stat.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\hash.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\deref.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\load_seg.h"\
	{$(INTDIR)}"\binding.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\token.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\subinst.h"\
	{$(INTDIR)}"\sig.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\switch.h"\
	{$(INTDIR)}"\trassert.h"\
	{$(INTDIR)}"\dynload.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\residual.h"\
	{$(INTDIR)}"\oracle.h"\
	{$(INTDIR)}"\xsb_odbc.h"\
	{$(INTDIR)}"\bineg.i"\
	{$(INTDIR)}"\std_pred.i"\
	{$(INTDIR)}"\oracle.i"\
	{$(INTDIR)}"\xsb_odbc.i"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\slgdelay.h"\
	

"$(INTDIR)\builtin.obj" : $(SOURCE) $(DEP_CPP_BUILT) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\biassert.c
DEP_CPP_BIASS=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\debugs\debug.h"\
	{$(INTDIR)}"\debugs\debug_biassert.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\cinterf.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\register.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\inst.h"\
	{$(INTDIR)}"\token.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\load_seg.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\choice.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\tr_utils.h"\
	{$(INTDIR)}"\switch.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\debugs\debug_kostis.h"\
	{$(INTDIR)}"\slgdelay.h"\
	{$(INTDIR)}"\debugs\debug_delay.h"\
	

"$(INTDIR)\biassert.obj" : $(SOURCE) $(DEP_CPP_BIASS) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\auxlry.c
DEP_CPP_AUXLR=\
	"$(INTDIR)\configs\config.h"\
	

"$(INTDIR)\auxlry.obj" : $(SOURCE) $(DEP_CPP_AUXLR) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\token.c
DEP_CPP_TOKEN=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\token.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\subp.h"\
	{$(INTDIR)}"\register.h"\
	

"$(INTDIR)\token.obj" : $(SOURCE) $(DEP_CPP_TOKEN) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
################################################################################
# Begin Source File

SOURCE=$(INTDIR)\loader.c
DEP_CPP_LOADE=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\auxlry.h"\
	{$(INTDIR)}"\psc.h"\
	{$(INTDIR)}"\loader.h"\
	{$(INTDIR)}"\flags.h"\
	{$(INTDIR)}"\cell.h"\
	{$(INTDIR)}"\load_seg.h"\
	{$(INTDIR)}"\tries.h"\
	{$(INTDIR)}"\xmacro.h"\
	{$(INTDIR)}"\xsberror.h"\
	{$(INTDIR)}"\dynload.h"\
	{$(INTDIR)}"\slgdelay.h"\
	

"$(INTDIR)\loader.obj" : $(SOURCE) $(DEP_CPP_LOADE) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File

################################################################################
# Begin Source File

SOURCE=$(INTDIR)\xmain.c
DEP_CPP_XMAIN=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INCLUDE)}"\sys\TYPES.H"\
	{$(INCLUDE)}"\sys\STAT.H"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\emuloop.h"\
	{$(INTDIR)}"\self_orientation.h"\
	

"$(INTDIR)\xmain.obj" : $(SOURCE) $(DEP_CPP_XMAIN) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File

################################################################################
# Begin Source File

SOURCE=$(INTDIR)\orastuff.c
DEP_CPP_XMAIN=\
	{$(INTDIR)}"\configs\config.h"\
	{$(INTDIR)}"\configs\special.h"\
	{$(INTDIR)}"\basictypes.h"\
	{$(INTDIR)}"\orastuff.h"\
	{$(INTDIR)}"\cell.h"\
	

"$(INTDIR)\orastuff.obj" : $(SOURCE) $(DEP_CPP_XMAIN) "$(INTDIR)"
   $(CPP) $(CPP_PROJ) $(SOURCE)


# End Source File
