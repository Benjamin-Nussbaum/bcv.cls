%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A class for typesetting resumes and curricula vitarum,
% having boxed/block section titles in several styles.
%
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bcv}[2025/10/02 Benjamin Nussbaum's CV/resume class]
% ------------------------------------------------------------------------------
% Class options
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% ------------------------------------------------------------------------------
% Contact info commands and title formatting
\newcommand{\name}[2]{
	\newcommand\@name{#1~#2}
	% Helpful to break these up to auto-bold in publications section
	\newcommand\@namepartgiven{#1}
	\newcommand\@namepartfamily{#2}
}
\newcommand{\email}[1]{\newcommand\@email{\href{mailto:#1}{#1}}}
\newcommand{\website}[1]{\newcommand\@website{\href{https://#1}{#1}}}
\newcommand{\github}[1]{\newcommand\@github{\href{https://github.com/#1}{github.com/#1}}}
\newcommand{\orcid}[1]{\newcommand\@orcid{\href{https://orcid.org/#1}{orcid.org/#1}}}

\renewcommand{\@maketitle}
{
	\centerline{\bfseries\Huge\@name}
	\vspace{1.5ex}
	\centerline{%
		\ifdef{\@email}{\@email~|~}{}%
		\ifdef{\@website}{\@website~|~}{}%
		\ifdef{\@github}{\@github~|~}{}%
		\ifdef{\@orcid}{\@orcid}{}%
	}
}

% ------------------------------------------------------------------------------
% General packages and page formatting
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[margin=0.5in]{geometry}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}
\RequirePackage[svgnames]{xcolor}
\RequirePackage[calcwidth,compact,explicit,bf,sf]{titlesec}
\RequirePackage[hidelinks]{hyperref}

\input{glyphtounicode}
\pdfgentounicode=1

\raggedright
\raggedbottom
\pagenumbering{gobble}
% \setlength{\parskip}{3pt}
% \setlength{\tabcolsep}{0in}

\renewcommand{\labelitemi}{$\vcenter{\hbox{\small{$\bullet$}}}$}
\setlist{topsep=0pt, itemsep=-2pt, leftmargin=12pt}

% ------------------------------------------------------------------------------
% Publications
\RequirePackage[
	bibstyle=publist,
	backend=biber,
	sorting=rymd,
	maxbibnames=99,
	defernumbers=true,
	% giveninits=true,
	url=false,
	plauthorhandling=highlight,
	nameorder=given-family,
	% plnumbering=global-descending,
	hlyear=false,
	% marginyear=true,
]{biblatex}
\DeclareSortingTemplate{rymd}{
	\sort[direction=descending]{\field{sortyear}\field{year}}
	\sort[direction=descending]{\field{month}}
	\sort[direction=descending]{\field{day}}
	\sort{\field{author}}
}

% Descending reference numbering
% https://tex.stackexchange.com/a/22770
% % Count total number of entries in each refsection
% \AtDataInput{%
%   \csnumgdef{entrycount:\therefsection}{%
%     \csuse{entrycount:\therefsection}+1}}

% % Print the labelnumber as the total number of entries in the
% % current refsection, minus the actual labelnumber, plus one
% \DeclareFieldFormat{labelnumber}{\mkbibdesc{#1}}
% \renewrobustcmd*{\mkbibdesc}[1]{%
%   \number\numexpr\csuse{entrycount:\therefsection}+1-#1\relax}

% https://tex.stackexchange.com/a/424775
% print url if no doi
\renewbibmacro*{doi+eprint+url}{%
	\printfield{doi}%
	\newunit\newblock%
	\iftoggle{bbx:eprint}{%
		\usebibmacro{eprint}%
	}{}%
	\newunit\newblock%
	\iffieldundef{doi}{%
		\usebibmacro{url+urldate}}%
	{}%
}

\plauthorname{\@namepartfamily}

% \newcommand{\@mkbibname}[1]{
%     \ifthenelse{
%         \equal{\@namepartgiven}{\namepartgiven}
%         \AND \equal{\@namepartfamily}{\namepartfamily}
%     }{
%         \mkbibbold{#1}{#1}
%     }
% }
% \let\mkbibnamegiven\@mkbibname
% \let\mkbibnamefamily\@mkbibname
% ------------------------------------------------------------------------------
% Section title boxes

% Set up section title boxes
\newlength{\@titleboxborderwidth}
\setlength{\@titleboxborderwidth}{2pt}
\definecolor{outercolor}{gray}{0.75}
\definecolor{innercolor}{gray}{0.95}

\RequirePackage[skins]{tcolorbox}
\newcommand*{\@titlebox}[1]
{
	\begin{tcolorbox}
		[
			enhanced,
			sharp corners,
			boxsep=0pt,
			boxrule=\@titleboxborderwidth,
			colframe=outercolor,
			colback=innercolor,
			% borderline={0.4pt}{\@titleboxborderwidth}{black}
		]
		\bf\sffamily\large\vphantom{p\^{E}}#1
	\end{tcolorbox}
}

\titleformat{\section}[block]{}{}{0pt}
{
	\@titlebox{#1}
}
\titlespacing{\section}{0pt}{*-1.5}{*-5}

% ------------------------------------------------------------------------------
% CV items
%
% A `\cvitem` takes four arguments. I use them as follows:
%   1. Position title or degree name    (Bachelor of Science in <major>)
%   2. Institution name                 (University of <wherever>)
%   3. Institution location             (City, State/Province[, country])
%   4. Duration                         (start year--end year)
%
% Note that the starred version of the command can provide alternate formatting

\newcommand*{\cvitem}{\vspace{1.5ex}\@ifstar\@cvitem\@@cvitem}

% Starred
\newcommand*{\@cvitem}[4]{\textbf{#1}, #2#3\hfill#4}

% Unstarred
\newcommand*{\@@cvitem}[4]{\textbf{#1}, #2 --- #3\hfill#4}
