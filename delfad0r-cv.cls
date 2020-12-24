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

\def\cv@eventlist@ratio{.3}
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
\columnratio{.3}
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

% Infofields
\newcommand{\icontext}[2]{\mbox{\parbox[t][.9\baselineskip][t]{1.2\baselineskip}{\centering\textcolor{icons}{#1}}\hspace{.4\baselineskip}#2}}
\newcommand{\cv@infofield}[3][]{%
\icontext{#2}{\ifstrequal{#1}{}{#3}{\href{#1}{#3}}}%
\vspace{.2em}\newline%
}
\newcommand{\email}[1]{\cv@infofield[mailto:#1]{\faAt}{#1}}
\newcommand{\location}[1]{\cv@infofield{\faMapMarker*}{#1}}
\newcommand{\birthdate}[1]{\cv@infofield{\faCalendar}{#1}}

% Lists
\newcommand{\itemtitle}[1]{\textbf{#1}}

\newboolean{cv@eventlist@first}
\newenvironment{eventlist}{\setboolean{cv@eventlist@first}{true}}{}
\newcommand{\when}[1]{\icontext{\faCalendar}{#1}\vspace{.2em}\newline}
\newcommand{\where}[1]{\icontext{\faMapMarker*}{#1}\vspace{.2em}\newline}
\newcommand{\online}[1]{\icontext{\faGlobe}{#1}\vspace{.2em}\newline}
\newcommand{\event}[3]{%
\ifbool{cv@eventlist@first}{}{\vspace{.5em}\titlerule{\tikz\draw[draw=rule,line width=.5pt,densely dashed,path fading=east] (0,0) -- (\linewidth,0);}}
\begin{minipage}[t]{\cv@eventlist@ratio\linewidth}
\parbox{0pt}{}#1\vspace{-\baselineskip}
\end{minipage}
\begin{minipage}[t]{\fpeval{1-\cv@eventlist@ratio}\linewidth}
\itemtitle{#2}\ifstrempty{#3}{}{\vspace{.2em}\newline #3\vspace{.5em}}
\end{minipage}
\setboolean{cv@eventlist@first}{false}
}

% Final
\RequirePackage{paracol}
\RequirePackage[default]{raleway}
\pagestyle{empty}