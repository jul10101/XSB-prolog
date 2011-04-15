; Script generated by the Inno Setup Script Wizard.
; Double click on this file to run with inno, then build-menu, compile.
; A compiled version of XSB must exist in the location pointed by the MyBaseDir variable below.

#define MyAppName "XSB"
#define MyAppVerName "XSB 3.3.1"
#define MyAppPublisher "XSB"
#define MyAppURL "http://xsb.sourceforge.net/"
#define MyAppUrlName "XSB Web Site.url"

#define XSB_DIR "{reg:HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment,XSB_DIR|{pf}\XSB}"
#define MyBaseDir "C:\XSB"

[Setup]
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
ChangesEnvironment=yes
DefaultDirName={#XSB_DIR}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile={#MyBaseDir}\LICENSE
InfoBeforeFile={#MyBaseDir}\README
OutputBaseFilename=xsb-3.3.1
Compression=lzma
SolidCompression=yes
PrivilegesRequired=none

VersionInfoVersion=3.3.1
VersionInfoCopyright=� The Research Foundation of SUNY, 1986, 1993-2002

AllowRootDirectory=yes
UninstallFilesDir="{userdocs}\XSB uninstaller"

MinVersion=0,5.0

[Types]
Name: "full"; Description: "Full XSB installation (recommended)"
Name: "base"; Description: "Base XSB installation"
Name: "custom"; Description: "Custom XSB installation"; Flags: iscustom

[Components]
Name: "base"; Description: "Base system"; Types: full base custom; Flags: disablenouninstallwarning
Name: "base\sources"; Description: "Base system plus Prolog source files"; Types: full base custom; Flags: disablenouninstallwarning
Name: "documentation"; Description: "Documentation"; Types: full custom; Flags: disablenouninstallwarning
Name: "examples"; Description: "Examples"; Types: full custom; Flags: disablenouninstallwarning
Name: "packages"; Description: "Packages"; Types: full custom; Flags: disablenouninstallwarning

[Tasks]
Name: website; Description: "&Visit {#MyAppName} web site"; Components: base
Name: shortcut; Description: "&Create a desktop shortcut to the XSB folder"; Components: base

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
BeveledLabel=XSB 3.3.1 � The Research Foundation of SUNY, 1986, 1993-2002

[Dirs]
Name: "{userdocs}\XSB uninstaller"

[Files]
Source: "{#MyBaseDir}\bin\*"; Excludes: ".*,CVS"; DestDir: "{app}\bin"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\config\*"; Excludes: ".*,CVS"; DestDir: "{app}\config"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\pthreads\Pre-built\lib\pthreadVSE1.dll"; Excludes: ".*,CVS"; DestDir: "{app}\config\i686-pc-cygwin-mt\bin"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "{#MyBaseDir}\syslib\*.xwam"; Excludes: ".*,CVS"; DestDir: "{app}\syslib"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\cmplib\*.xwam"; Excludes: ".*,CVS"; DestDir: "{app}\cmplib"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\lib\*.xwam"; Excludes: ".*,CVS"; DestDir: "{app}\lib"; Components: base; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "{#MyBaseDir}\syslib\*"; Excludes: ".*,CVS"; DestDir: "{app}\syslib"; Components: base\sources; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\cmplib\*"; Excludes: ".*,CVS"; DestDir: "{app}\cmplib"; Components: base\sources; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\lib\*"; Excludes: ".*,CVS"; DestDir: "{app}\lib"; Components: base\sources; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "{#MyBaseDir}\docs\*"; Excludes: ".*,CVS"; DestDir: "{app}\docs"; Components: documentation; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\examples\*"; Excludes: ".*,CVS"; DestDir: "{app}\examples"; Components: examples; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBaseDir}\packages\*"; Excludes: ".*,CVS"; DestDir: "{app}\packages"; Components: packages; Flags: ignoreversion recursesubdirs createallsubdirs

[INI]
Filename: "{app}\{#MyAppUrlName}"; Section: "InternetShortcut"; Key: "URL"; String: "{#MyAppURL}"; Components: base

[Icons]
Name: "{group}\XSB"; Filename: "{app}\config\i686-pc-cygwin\bin\xsb.exe"; Parameters: ""; Comment: "Runs XSB (GCC-compiled) within a command shell"; WorkingDir: "{userdocs}"; Components: base; Flags: createonlyiffileexists

Name: "{group}\XSB-MT"; Filename: "{app}\config\i686-pc-cygwin-mt\bin\xsb.exe"; Parameters: ""; Comment: "Runs XSB (Multi-threaded; GCC-compiled) within a command shell"; WorkingDir: "{userdocs}"; Components: base; Flags: createonlyiffileexists

Name: "{group}\XSB-MSVC"; Filename: "{app}\config\x86-pc-windows\bin\xsb.exe"; Parameters: ""; Comment: "Runs XSB (MSVC-compiled) within a command shell"; WorkingDir: "{userdocs}"; Components: base; Flags: createonlyiffileexists

Name: "{group}\License"; Filename: "{app}\LICENSE"; Components: base
Name: "{group}\Read Me"; Filename: "{app}\README"; Components: base

Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; Components: base

Name: "{userdesktop}\XSB"; Filename: "{app}"; Components: base; Tasks: shortcut

Name: "{group}\Web Site"; Filename: "{#MyAppUrl}"; Components: base

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "XSB_DIR"; ValueData: "{app}"; Components: base; Flags: deletevalue uninsdeletevalue

[Run]
Filename: "{app}\{#MyAppUrlName}"; Flags: shellexec nowait; Tasks: website

[UninstallDelete]
Type: filesandordirs; Name: "{app}"; Components: base
Type: filesandordirs; Name: "{group}"; Components: base
