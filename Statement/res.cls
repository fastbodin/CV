% RESUME DOCUMENT STYLE -- Released 23 Nov 1989
%    for LaTeX version 2.09
% Copyright (C) 1988,1989 by Michael DeCorte

\typeout{Document Style `res' <26 Sep 89>.}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res.sty
%
% \documentstyle{res}
%
% Copyright (c) 1988 by Michael DeCorte
% Permission to copy all or part of this work is granted, provided
% that the copies are not made or distributed for resale, and that
% the copyright notice and this notice are retained.
%
% THIS WORK IS PROVIDED ON AN "AS IS" BASIS.  THE AUTHOR PROVIDES NO
% WARRANTY WHATSOEVER, EITHER EXPRESS OR IMPLIED, REGARDING THE WORK,
% INCLUDING WARRANTIES WITH RESPECT TO ITS MERCHANTABILITY OR FITNESS
% FOR ANY PARTICULAR PURPOSE.
%
% If you make any improvements, I'd like to hear about them.
%
% Michael DeCorte
% P.O. Box 652
% Potsdam NY 13676
% mrd@sun.soe.clarkson.edu
% mrd@clutx.bitnet
%
% Changes for LaTeX2e -- Venkat Krishnamurthy (Aug 7, 2001)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can have multiple style options the legal options ones are:
%
%   centered	the name and address are centered at the top of the
%		page (default)
%
%   line	the name is the left with a horizontal line then 
%		the address to the right
%
%   overlapped	the section titles overlap the body text (default)
%
%   margin	the section titles are to the left of the body text
%		
%   11pt	use 11 point fonts instead of 10 point fonts
%
%   12pt	use 12 point fonts instead of 10 point fonts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   \Resume	prints the word resume but typeset nicely
%
%   \newsectionwidth{dimen}
%		defines the amount of space the labels extend
%		into the left margin.
%		DO NOT TRY to change any of the dimensions
%		yourself.  You will probably confuse the style file.
%
%   \name{text} defines your name
%
%   \address{text}
%		defines your address
%		this can be called twice if you have two addresses
%		use \\'s to indicate where either line breaks or
%		comas should go
%
%   \opening	this prints your name and address at that spot
%		this is not normally needed, as \begin{resume}
%		does this but is provided just in case you need
%		to do something odd
%
%   \begin{resume} ... \end{resume}
%		all of the resume should go inside of this
%		environment
%
%   \section{text}
%		This prints 'text' in the left hand margin.
%		Its exact placement depends on what the style 
%		options has been set to. (overlapped or margin)
%		You should use \\ to start a new line.	If the
%		style option is margin, the \\ is converted
%		to a space.
%		To use this in any of the list environments, put
%		the \section after the \item[] but before the 
%		text.
%		Eg.
%		\begin{itemize}
%		\item\section{text}
%		text
%		\end{itemize}
%
%   \begin{ncolumn}{n} ... \end{ncolumn}
%		creates a tabular environment with n equally
%		spaced columns.  Separate columns by & and
%		end them with \\
%
%   \begin{position} ... \end{position}
%		this is used to print a job description.  There should
%		be only one job description in it.  Information
%		related to the job (such as title, dates...) will
%		be printed.
%
%   \begin{format} ... \end{format}
%		used to change the default format for the position
%		environment.  Within it the recognized commands are:
%		\title{option}
%		\employer{option}
%		\location{option}
%		\dates{option}
%		\body
%		\\
%		where option is one of l,r,c standing for left, right, center.
%		The format will eventually be used to make several
%		tabular environments and you are defining the number of columns
%		and the placement of text within the columns of the tabulars.
%		Each row is terminated by a \\.  Any number of options can 
%		be on a line, they will each be set in their own columns.
%		Any of the options except \body may be left out.
%
%		Eg.
%		\begin{format}
%		\title{l}\employer{r}\\
%		\dates{r}\\
%		\body\\
%		\location{l}\\
%		\end{format}
%
%		In this example the title and employer information
%		are set in 2 columns left justified and right justified
%		respectively.  Then the date is set right justified.
%		Then the body is set.  Then the location is set left
%		justified.
%
% \employer{text}
% \title{text}
% \dates{text}
% \location{text}
%		declare text for the next invocation of the position
%		environment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Glue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionskip	the amount of horizontal before a section
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionwidth	the amount that the section titles go in the
%		left margin
%
% resumewidth	the width of the total resume from the left
%		margin to the right.  Don't use textwidth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sectionfont	the font used to print section titles
%		use \renewcommand to change it
%
% namefont	the font used to print your name
%		use \renewcommand to change it
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THINGS TO DO
%
% add lm,rm options to format style to allow things to be placed
% in the left or right margin respectivly
%
% add capability so that \body doesn't have to be proceeded (followed)
% by a \\ allowing part of the description (eg. location) to be the
% first (last) thing of the body
%
% clean up the list building procedures
%
% write docs to tell people how to use this

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{res}[2000/05/19 v1.4b Resume class]

%\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
%\DeclareOption{12pt}{\renewcommand\@ptsize{2}}

\PassOptionsToClass{11pt,12pt}{article}
\LoadClassWithOptions{article}

\newif\if@line
\newif\if@margin

\DeclareOption{line}{\@linetrue}
\DeclareOption{centered}{\@linefalse}

\DeclareOption{margin}{\@margintrue}
\DeclareOption{overlapped}{\@marginfalse}

\ExecuteOptions{overlapped,centered}
\ProcessOptions\relax

\nofiles	     % resume's don't need .aux files


\newtoks\tabular@text		    % holds the current list being processed
\newtoks\tabular@head		    % holds the head tabular list
\newtoks\tabular@tail		    % holds the tail tabular list
\newtoks\@ta			    % used by \@append
\newtoks\undefined@token\undefined@token={}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is used to print the name and address at the top of
% the page with a hline in between
%
\def\namefont{\large\bf}
\def\@linename{\begingroup
  \def\\{, }
  {\namefont\@name}
  \vskip 2pt
  \fullline
  \vskip 2pt
  % where do you live?
  \@ifundefined{@addressone}{%
    % do nothing
  }{%
    \leavevmode\hbox to \textwidth
      {\hfill\vbox{\hbox{\@addressone}
		   \hbox{\@addresstwo}
		  }%
      }\par
  }
\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADINGS:
% There are two types of headings:
% 1) one with the name centered and the address centered or
%    in the left and right side if there are two address
% 2) one where the name is in the upper left corner 
%    the a line accross the paper
%    then the address all on one line in the right corner
%    the second address will be directly below the first if defined
%
\let\print@name\relax
\def\ds@centered{\ifx\print@name\relax\let\print@name\@printcentername\fi}
\def\ds@line{\ifx\print@name\relax\let\print@name\@linename\fi}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (some of them)
%
% centered name
% overlapped section titles
%
% format is:
%    title	 employer
%    location	 dates
%    body
% with everything in the left of its column

%\input article.sty

\if@line\ds@line\else\ds@centered\fi
\if@margin\ds@margin\else\ds@overlapped\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% typeset resume all nice and pretty
%
\def\Resume{{R\'{e}sum\'{e}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% makes a line of width \textwidth starting at -\hoffset
%
\def\fullline{		% hrules only listen to \hoffset
  \nointerlineskip	% so I have this code	  
  \moveleft\hoffset\vbox{\hrule width\textwidth} 
  \nointerlineskip
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a multiline box.
%
\def\@tablebox#1{\begin{tabular}[t]{@{}l@{\extracolsep{\fill}}}#1\end{tabular}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your name
%
\def\name#1{\def\@name{#1}}

\def\@name{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use this to define your address, this may be called more than once.
%
\let\@addressone\relax
\let\@addresstwo\relax

\def\address#1{
  \@ifundefined{@addressone}{\def\@addressone{#1}}{\def\@addresstwo{#1}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if you want to print your name and address is a slightly
% different format than sugessted, then this can be used
% to place it exactly where you want
%
\def\opening{\def\@opening{}
  \begingroup
  \leftskip=-\hoffset	     % I use leftskip to move things to the left as 
  \advance\textwidth\hoffset % changing hoffset doesn't work. But this
  \hsize=\textwidth	     % doesn't really work as hboxes are rules
			     % are unaffeted
  \let\par=\@@par
  \parindent=0pt
  \parskip=0pt
  \print@name
  \endgroup
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all of the resume goes in the resume environment
%
\newenvironment{resume}{\begingroup
		       \@ifundefined{@opening}{\opening}{}
}{\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULTS: (the rest of them)
%
% centered name
% overlapped section titles
%
% format is:
%    title	 employer
%    location	 dates
%    body
% with everything in the left of its column

\@secpenalty = -500
\topmargin 0pt
\headheight 0pt
\headsep 0pt
\textheight 9in
\parindent 0pt
\topmargin 0in
\oddsidemargin 0pt
\evensidemargin 0pt
\marginparwidth 0pt
\parindent 0pt
\parskip \baselineskip
\setcounter{secnumdepth}{0}
\def\@listI{\leftmargin\leftmargini
\topsep 0pt 
\parskip 0pt
\partopsep 2pt plus 2pt
\parsep 2pt plus 2pt
\itemsep \parsep}

\pagestyle{empty}  % don't want page numbers


\let\section\@@section

