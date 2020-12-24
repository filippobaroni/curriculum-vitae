% Class definition

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{delfad0r-cv}

\RequirePackage{ifthen}
\RequirePackage{kvoptions}

\newboolean{cv@oneside}
\setboolean{cv@oneside}{true}
\DeclareOption{oneside}{\setboolean{cv@oneside}{true}}
\DeclareOption{twoside}{\setboolean{cv@oneside}{false}}


\SetupKeyvalOptions{family=cv,prefix=cv@}
\DeclareStringOption[1.5cm]{margin}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*
\ProcessKeyvalOptions*
\LoadClass{article}


\RequirePackage{etoolbox}
\AfterEndPreamble{
\vspace*{\cv@headerheight}
\vspace*{-2\baselineskip}
\cv@paracolsetup\begin{paracol}{2}
\cv@makeheader{}
}
\AtEndDocument{\end{paracol}}

% Packages
\RequirePackage[margin=\cv@margin,a4paper]{geometry}
\RequirePackage{microtype}
\RequirePackage[T1]{fontenc}

\RequirePackage[hidelinks]{hyperref}

\RequirePackage[fixed]{fontawesome5}

\RequirePackage{xfp}

\RequirePackage{tikz}
\usetikzlibrary{positioning}
\usetikzlibrary{fadings}

% Personal info
\def\cv@name{}
\newcommand{\setname}[1]{\def\cv@name{#1}}
\def\cv@title{}
\newcommand{\settitle}[1]{\def\cv@title{#1}}

% Geometry
\setlength{\parindent}{0cm}

\newlength{\cv@headerheight}
\setlength{\cv@headerheight}{4cm}
\newcommand{\setheaderheight}[1]{\setlength{\cv@headerheight}{#1}}

\def \cv@sidebarratio{.3}
\newcommand{\setsidebarratio}[1]{\def\cv@sidebarratio{#1}}

\def\cv@eventlist@ratio{.35}
\newcommand{\seteventlistratio}[1]{\def\cv@eventlist@ratio{#1}}

% Colors
\colorlet{header}{gray}
\colorlet{sidebar}{gray!20}
\colorlet{body}{white}
\colorlet{section}{black}
\colorlet{subsection}{black}
\colorlet{sectionrule}{blue!50!black}
\colorlet{rule}{gray}
\colorlet{icons}{blue}

% Header
\newcommand{\cv@makeheader}{
\nointerlineskip\begin{tikzpicture}[overlay,remember picture]
\node[fill=header,rectangle,anchor=north,minimum width=\paperwidth,minimum height={\cv@headerheight}] (header) at (current page.north) {};
\node[right={\cv@margin} of header.north,anchor=west,align=left,inner xsep=0pt] (name) at (header.west) {\cv@name\\\cv@title};
\end{tikzpicture}
}

% Body
\newcommand{\cv@paracolsetup}{
\columnratio{\cv@sidebarratio}
\ifbool{cv@oneside}{}{\twosided[pcb]}
\setlength{\columnsep}{1.5cm}
\backgroundcolor{c[0](10000pt,10000pt)(.5\columnsep,10000pt)}{sidebar}
\backgroundcolor{c[1](.5\columnsep,10000pt)(10000pt,10000pt)}{body}
}
\newenvironment{sidebar}{\begin{leftcolumn}}{\end{leftcolumn}}
\newenvironment{body}{\begin{rightcolumn}}{\end{rightcolumn}}

% Sections
\RequirePackage{titlesec}
\titleformat{\section}{\Large\bfseries\raggedright\scshape\color{section}}{}{0em}{}[\titleline{\tikz{\draw[line width=1pt,path fading=east,draw=sectionrule] (0,0) -- (\linewidth,0);}}]
\titleformat{\subsection}{\large\bfseries\raggedright\color{subsection}}{}{0em}{}

% Icons
\newcommand{\icontext}[2]{\mbox{\parbox[t][.9\baselineskip][t]{1.2\baselineskip}{\centering\textcolor{icons}{#1}}\hspace{.4\baselineskip}#2}}
\newcommand{\iconlongtext}[2]{\icontext{#1}{\begin{minipage}[t]{\dimexpr\linewidth-1.2\baselineskip}\raggedright#2\end{minipage}}}

\definecolor{gold}{HTML}{FFD700}
\definecolor{silver}{HTML}{C0C0C0}
\definecolor{bronze}{HTML}{CD7F32}
\newcommand{\medal}[2][]{\iconlongtext{\ifstrempty{#1}{\faMedal}{\textcolor{#1}{\faMedal}}}{#2}}

% Infofields
\newcommand{\cv@infofield}[3][]{%
\iconlongtext{#2}{\ifstrempty{#1}{#3}{\href{#1}{#3}}}%
\vspace{.2em}\newline%
}
\newcommand{\email}[1]{\cv@infofield[mailto:#1]{\faAt}{#1}}
\newcommand{\location}[1]{\cv@infofield{\faMapMarker*}{#1}}
\newcommand{\birthdate}[1]{\cv@infofield{\faCalendar}{#1}}

% Lists
\newcommand{\itemtitle}[1]{\textbf{#1}}

\newboolean{cv@eventlist@first}
\newboolean{cv@eventlist@firstleftitem}
\newenvironment{eventlist}{\setboolean{cv@eventlist@first}{true}}{}
\newcommand{\cv@eventlist@leftitem}[2]{%
\ifbool{cv@eventlist@firstleftitem}{}{\newline}%
\setboolean{cv@eventlist@firstleftitem}{false}%
\iconlongtext{#1}{#2}%
\vspace{.2em}%
}
\newcommand{\when}[1]{\cv@eventlist@leftitem{\faCalendar}{#1}}
\newcommand{\where}[1]{\cv@eventlist@leftitem{\faMapMarker*}{#1}}
\newcommand{\online}[1]{\cv@eventlist@leftitem{\faGlobe}{#1}}
\newcommand{\event}[3]{%
\setboolean{cv@eventlist@firstleftitem}{true}
\ifbool{cv@eventlist@first}{}{\vspace{.5em}\titlerule{\tikz\draw[draw=rule,line width=.5pt,densely dashed,path fading=east] (0,0) -- (\linewidth,0);}}
\begin{minipage}[t]{\dimexpr\cv@eventlist@ratio\linewidth-1em}
\parbox{0pt}{}#1\vspace{.5em}
\end{minipage}\hspace{1em}
\begin{minipage}[t]{\fpeval{1-\cv@eventlist@ratio}\linewidth}
\itemtitle{#2}\ifstrempty{#3}{}{\vspace{.2em}\newline #3\vspace{.5em}}
\end{minipage}
\setboolean{cv@eventlist@first}{false}
}

% Misc

% Final
\RequirePackage{paracol}
\RequirePackage[default]{raleway}
\pagestyle{empty}