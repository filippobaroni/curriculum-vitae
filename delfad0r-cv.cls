% Class definition

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{delfad0r-cv}

\RequirePackage{ifthen}
\RequirePackage{kvoptions}

\newboolean{cv@oneside}
\setboolean{cv@oneside}{true}
\DeclareOption{oneside}{\setboolean{cv@oneside}{true}}
\DeclareOption{twoside}{\setboolean{cv@oneside}{false}}

\newboolean{cv@sideheader}
\setboolean{cv@sideheader}{false}
\DeclareOption{sideheader}{\setboolean{cv@sideheader}{true}}
\DeclareOption{topheader}{\setboolean{cv@sideheader}{false}}

\newboolean{cv@photo@show}
\setboolean{cv@photo@show}{false}
\DeclareOption{photo}{\setboolean{cv@photo@show}{true}}
\DeclareOption{nophoto}{\setboolean{cv@photo@show}{false}}


\SetupKeyvalOptions{family=cv,prefix=cv@}
\DeclareStringOption[1cm]{margin}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax
\ProcessKeyvalOptions*
\LoadClass{extarticle}


\RequirePackage{etoolbox}
\AfterEndPreamble{
%\ifbool{cv@sideheader}{}{\vspace*{\cv@headerheight}\vspace*{-3\baselineskip}}
\cv@paracolsetup\begin{paracol}{2}
\ifbool{cv@sideheader}{\cv@makesideheader{}}{\cv@makeheader{}}
\@ifundefinedcolor{sidebar section}{\colorlet{sidebar section}{body section}}{}
\@ifundefinedcolor{sidebar subsection}{\colorlet{sidebar subsection}{body subsection}}{}
\@ifundefinedcolor{sidebar}{\colorlet{sidebar}{body}}{}
\@ifundefinedcolor{sidebar secondary}{\colorlet{sidebar secondary}{body secondary}}{}
\@ifundefinedcolor{sidebar rule}{\colorlet{sidebar rule}{body rule}}{}
\@ifundefinedcolor{sidebar sectionrule}{\colorlet{sidebar sectionrule}{body sectionrule}}{}
}
\AtEndDocument{\end{paracol}}

% Packages
\RequirePackage[margin=\cv@margin,a4paper]{geometry}
\RequirePackage{microtype}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

\RequirePackage[hidelinks]{hyperref}

\RequirePackage[fixed]{fontawesome5}

\RequirePackage{xfp}
\RequirePackage{xstring}

\RequirePackage{tikz}
\usetikzlibrary{positioning}
\usetikzlibrary{fadings}
\usetikzlibrary{math,calc}
\usetikzlibrary{backgrounds}

% Personal info
\def\cv@name{}
\newcommand{\setname}[1]{\def\cv@name{#1}}
\def\cv@description{}
\newcommand{\setdescription}[1]{\def\cv@description{#1}}

% Geometry
\setlength{\parindent}{0cm}

\newlength{\cv@headerheight}
\newcommand{\getheaderheight}{\cv@headerheight}

\newlength{\cv@photo@diameter}
\setlength{\cv@photo@diameter}{3cm}
\newcommand{\setphotodiameter}[1]{\setlength{\cv@photo@diameter}{#1}}

\def \cv@sidebarratio{.3}
\newcommand{\setsidebarratio}[1]{\def\cv@sidebarratio{#1}}

\def\cv@eventlist@ratio{.35}
\newcommand{\seteventlistratio}[1]{\def\cv@eventlist@ratio{#1}}

\newboolean{cv@onlinefetch}
\ifthenelse{\pdfshellescape=1}{\setboolean{cv@onlinefetch}{true}}{\setboolean{cv@onlinefetch}{false}}
\newcommand{\setonlinefetch}[1]{\setboolean{cv@onlinefetch}{#1}}

% Colors
\definecolor{headerbg}{RGB}{150,150,150}
\definecolor{sidebarbg}{RGB}{235,235,235}
\definecolor{bodybg}{RGB}{255,255,255}
\definecolor{header}{RGB}{0,0,0}
\definecolor{body section}{RGB}{0,0,0}
\definecolor{body subsection}{RGB}{0,0,0}
\definecolor{body}{RGB}{0,0,0}
\definecolor{body secondary}{RGB}{80,80,80}
\definecolor{body sectionrule}{RGB}{0,0,0}
\definecolor{body rule}{RGB}{150,150,150}
\definecolor{icons}{RGB}{100,100,100}

% Header
\tikzset{
cv/name/.style={text=header,inner sep=0pt,scale=2,font={\large\bfseries\scshape}},
cv/description/.style={text=header,inner xsep=0pt,font={\large}},
cv/photo/.pic={\fill[black] circle (.5*\cv@photo@diameter);},
cv/header text/.pic={
\node[cv/name,anchor=north west,align=left,text width={.5*(#1)}] (name) at (0,0) {\cv@name};
\node[cv/description,below=.8em of name.south west,align=left,anchor=north west,text width=#1] (description) {\cv@description};
},
cv/header decoration/.code={},
}
\newcommand{\cv@makeheader}{
\nointerlineskip\begin{tikzpicture}[overlay,remember picture]
\ifbool{cv@photo@show}{
\newlength{\w}
\setlength{\w}{\dimexpr\textwidth-\cv@photo@diameter-\cv@margin\relax}
\pic at ($(current page.north west)+(\cv@margin,-\cv@margin)$) {cv/header text=\w};
\path ([yshift=-1em]description.south);
\pic at ($(current page.north east)+(-\cv@margin-.5*\cv@photo@diameter,-.5*\cv@margin-.5*\cv@photo@diameter)$) {cv/photo};
\path ($(current page.north)+(0,-\cv@photo@diameter-\cv@margin)$);
\tikzmath{
coordinate \p, \q;
\p = (description.south);
\py = \py -1em;
\q = (current page.north);
\qy = \qy - \cv@photo@diameter-\cv@margin;
\headerendy = min(\py, \qy);
}
\coordinate (header end) at (0,\headerendy pt);
}{
\pic at ($(current page.north west)+(\cv@margin,-\cv@margin)$) {cv/header text={\textwidth}};
\coordinate[below=1em of description] (header end);
}
\tikzmath{coordinate \p, \q; \p = (current page.north); \q = (header end);\h = \py-\qy;}
\setlength{\cv@headerheight}{\h pt}\global\cv@headerheight=\cv@headerheight
\scoped[on background layer]\fill[headerbg] (current page.north west) rectangle (current page.east|-header end);
\scoped[on background layer]\node[rectangle,fill=headerbg,minimum width=\paperwidth,minimum height=\cv@headerheight,anchor=north] (header) at (current page.north) {};
\tikzset{cv/header decoration}
\end{tikzpicture}
}
\newcommand{\cv@makesideheader}{
\nointerlineskip\begin{tikzpicture}[overlay,remember picture]
\node[rectangle,anchor=north west,minimum width={\dimexpr\columnwidth+\cv@margin+.5\columnsep-.4pt\relax}] (header) at (current page.north west) {};
\ifbool{cv@photo@show}{%
\tikzmath{coordinate \c; \c = (header.north); \photox = \cx; \photoy = \cy - .5 * \cv@margin - .5 * \cv@photo@diameter;}
\pic at(\photox pt,\photoy pt) {cv/photo};
\coordinate (name hook) at (0,{\photoy-.5*\cv@photo@diameter-.5*\cv@margin});
}{
\coordinate (name hook) at ($(current page.north west)+(\cv@margin,-\cv@margin)$);
}
\node[cv/name,anchor=north west,align=left,text width=\columnwidth] (name) at (name hook) {\cv@name};
\node[cv/description,below=.8em of name.south west,align=left,anchor=north west,text width=\columnwidth] (description) {\cv@description};
\coordinate[below=1em of description] (header end);
\scoped[on background layer]\fill[headerbg] (header.north west) rectangle (header.east|-header end);
\tikzmath{coordinate \p, \q; \p = (header); \q = (header end);\h = \py-\qy;}
\setlength{\cv@headerheight}{\h pt}\global\cv@headerheight=\cv@headerheight
\end{tikzpicture}
\vspace*{\cv@headerheight}\vspace*{-3.5\baselineskip}
}

% Body
\newcommand{\cv@paracolsetup}{
\columnratio{\cv@sidebarratio}
\ifbool{cv@oneside}{}{\twosided[pcb]}
\setlength{\columnsep}{1.5\cv@margin}
\backgroundcolor{c[0](10000pt,10000pt)(.5\columnsep,10000pt)}{sidebarbg}
\backgroundcolor{c[1](.5\columnsep,10000pt)(10000pt,10000pt)}{bodybg}
}
\newenvironment{sidebar}{%
\begin{leftcolumn}
\ifbool{cv@sideheader}{}{\vspace*{\cv@headerheight}\vspace*{-3.5\baselineskip}}
\colorlet{main}{sidebar}
\colorlet{secondary}{sidebar secondary}
\colorlet{rule}{sidebar rule}
\colorlet{sectionrule}{sidebar sectionrule}
\colorlet{section}{sidebar section}
\colorlet{subsection}{sidebar subsection}
\color{main}
}{\end{leftcolumn}}
\newenvironment{body}{%
\begin{rightcolumn}
\ifbool{cv@sideheader}{}{\vspace*{\cv@headerheight}\vspace*{-3.5\baselineskip}}
\colorlet{main}{body}
\colorlet{secondary}{body secondary}
\colorlet{rule}{body rule}
\colorlet{sectionrule}{body sectionrule}
\colorlet{section}{body section}
\colorlet{subsection}{body subsection}
\color{main}
}{\end{rightcolumn}}

% Sections
\RequirePackage{titlesec}
\tikzset{
cv/sectionrule/.style={line cap=round,line width=1.5pt,path fading=east,draw=sectionrule},
}
\titleformat{\section}{\Large\bfseries\raggedright\scshape\color{section}}{}{0em}{}[\titleline{\tikz{\draw[cv/sectionrule] (0,0) -- (\linewidth,0);}}]
\titleformat{\subsection}{\large\bfseries\raggedright\color{subsection}}{}{0em}{}
\let\cv@oldsection\section
\renewcommand{\section}[2][]{\cv@oldsection{\ifstrempty{#1}{#2}{\icontext{#1}{#2}}}}

% Icons
\newcommand{\icontext}[2]{\mbox{\parbox[t][.9\baselineskip][t]{1.2\baselineskip}{\centering #1}\hspace{.4\baselineskip}#2}}
\newcommand{\iconlongtext}[2]{\icontext{#1}{\begin{minipage}[t]{\dimexpr\linewidth-1.2\baselineskip}\raggedright#2\end{minipage}}}

\definecolor{gold}{HTML}{FFD700}
\definecolor{silver}{HTML}{C0C0C0}
\definecolor{bronze}{HTML}{CD7F32}
\newcommand{\medal}[2][]{\iconlongtext{\ifstrempty{#1}{\faMedal}{\textcolor{#1}{\faMedal}}}{#2}}

% Infofields
\newcommand{\cv@infofield}[3][]{%
\iconlongtext{\textcolor{icons}{#2}}{\ifstrempty{#1}{#3}{\href{#1}{#3}}}%
\vspace{.2em}\newline%
}
\newcommand{\email}[1]{\cv@infofield[mailto:#1]{\faAt}{#1}}
\newcommand{\phone}[1]{\cv@infofield{\faPhone}{#1}}
\newcommand{\location}[1]{\cv@infofield{\faMapMarker*}{#1}}
\newcommand{\birthdate}[1]{\cv@infofield{\faCalendar}{#1}}
\newcommand{\linkedin}[1]{\cv@infofield[https://www.linkedin.com/in/#1]{\faLinkedin}{\cv@name{} {on LinkedIn}}}
\newcommand{\github}[1]{\cv@infofield[https://github.com/#1]{\faGithub}{#1 {on GitHub}}}
\newcommand{\codeforces}[1]{\cv@infofield[https://codeforces.com/profile/#1]{\faLaptopCode}{\ifbool{cv@onlinefetch}{\input{|"./get_codeforces.py #1"}}{#1} {on Codeforces}}}
\newcommand{\atcoder}[1]{\cv@infofield[https://atcoder.jp/user/#1]{\faLaptopCode}{\ifbool{cv@onlinefetch}{\input{|"./get_atcoder.py #1"}}{#1} {on AtCoder}}}

% Lists
\newcommand{\itemtitle}[1]{\textbf{#1}}
\tikzset{
cv/rule/.style={draw=rule,line width=.5pt,densely dashed,path fading=east}
}

\newboolean{cv@eventlist@first}
\newboolean{cv@eventlist@firstleftitem}
\newenvironment{eventlist}{\setboolean{cv@eventlist@first}{true}}{\vspace{-.6em}}
\newcommand{\cv@eventlist@leftitem}[2]{%
\ifbool{cv@eventlist@firstleftitem}{}{\newline}%
\setboolean{cv@eventlist@firstleftitem}{false}%
{\color{secondary}\iconlongtext{#1}{#2}}%
\vspace{.2em}%
}
\newcommand{\when}[1]{\cv@eventlist@leftitem{\faCalendar}{#1}}
\newcommand{\where}[1]{\cv@eventlist@leftitem{\faMapMarker*}{#1}}
\newcommand{\online}[2][]{\cv@eventlist@leftitem{\faGlobe}{\ifstrempty{#1}{#2}{\href{#1}{#2}}}}
\newcommand{\event}[3]{%
\setboolean{cv@eventlist@firstleftitem}{true}
\ifbool{cv@eventlist@first}{}{\vspace{.5em}\titlerule{\tikz\draw[cv/rule] (0,0) -- (\linewidth,0);}}
\setboolean{cv@eventlist@first}{false}
\begin{minipage}[t]{\dimexpr\cv@eventlist@ratio\linewidth-2em}
\parbox{0pt}{}#1\vspace{.2em}
\end{minipage}\hspace{2em}
\begin{minipage}[t]{\fpeval{1-\cv@eventlist@ratio}\linewidth}
\itemtitle{#2}\ifstrempty{#3}{}{\vspace{.2em}\newline #3\vspace{.5em}}
\end{minipage}
}

\newboolean{cv@referencelist@first}
\newenvironment{referencelist}{\setboolean{cv@referencelist@first}{true}}{\vspace{-.6em}}
\newcommand{\reference}[2]{%
\ifbool{cv@referencelist@first}{}{\vspace{.5em}\titlerule{\tikz\draw[cv/rule] (0,0) -- (\linewidth,0);}}
\setboolean{cv@referencelist@first}{false}
\itemtitle{#1}\vspace{.2em}\newline \begin{minipage}[t]{\columnwidth}#2\vspace{-\baselineskip}\vspace*{.5em}\end{minipage}
}

\newenvironment{fieldlist}{}{\vspace{-\baselineskip}}

\newcommand{\activity}[1]{\cv@infofield{\faCog}{#1}}

\newcommand{\research}[1]{\cv@infofield{\faAtom}{#1}}

% Skills
\tikzset{
skillpie/.pic={
\tikzmath{\a = 90 - #1/100*360;\r=.31;}
\begin{scope}[x={(\baselineskip,0)},y={(0,\baselineskip)}]
\path circle(\r);
\pgfinterruptboundingbox
\draw[icons,line width=1pt,fill=white] circle(.43);
\fill[icons] (0,0) -- (90:\r) arc (90:\a:\r) -- cycle;
\endpgfinterruptboundingbox
\end{scope}
}}

\newcommand{\skilllevel}[3]{\cv@infofield{\tikz\pic{skillpie={#3}};}{\parbox[t]{.4\linewidth}{#1}{\color{secondary}#2}}}



% Final
\RequirePackage{paracol}
\RequirePackage[default]{raleway}
\pagestyle{empty}