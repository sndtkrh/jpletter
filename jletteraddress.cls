%%
%% Copyright (c) 2014 Shin'ya Ueoka <ibenza@i-beam.org>
%%

\NeedsTeXFormat{pLaTeX2e}
\ProvidesClass{jletteraddress}

\LoadClass[]{article}

\usepackage{etoolbox}
\usepackage{plext}
\usepackage{xstring}
\ifx\kanjiskip\undefined\else
  \usepackage{atbegshi}
  \ifx\ucs\undefined
    \ifnum 42146=\euc"A4A2
      \AtBeginShipoutFirst{\special{pdf:tounicode EUC-UCS2}}
    \else
      \AtBeginShipoutFirst{\special{pdf:tounicode 90ms-RKSJ-UCS2}}
    \fi
  \else
    \AtBeginShipoutFirst{\special{pdf:tounicode UTF8-UCS2}}
  \fi
  \usepackage[dvipdfmx]{hyperref}

  %% Set a paper size for dvipdfmx
  \special{papersize=100truemm,148truemm}
\fi

%% Layouts
\setlength{\hoffset}{-1truein}
\setlength{\voffset}{-1truein}
\setlength{\oddsidemargin}{0pt}
\setlength{\evensidemargin}{0pt}
\setlength{\topmargin}{0pt}
\setlength{\topmargin}{0pt}
\setlength{\headheight}{0pt}
\setlength{\headsep}{0pt}
\setlength{\paperwidth}{100truemm}
\setlength{\paperheight}{148truemm}

\setlength{\tabcolsep}{0pt}
\setlength\tabbingsep{0pt}
\setlength{\unitlength}{1truemm} %

%% Sender macros
\def\senderfamilyname#1{\gdef\@senderfamilyname{#1}}
\def\senderlastnames#1{\gdef\@senderlastnames{#1}}
\def\senderpostcode#1{\gdef\@senderpostcode{#1}}
\def\senderaddressa#1{\gdef\@senderaddressa{#1}}
\def\senderaddressb#1{\gdef\@senderaddressb{#1}}
\newlength{\familywidth}
\newlength{\receiverfamilywidth}


%% Make a address-side
\newcommand{\addaddress}[6] {
  % #1 : Receiver family name
  % #2 : Receiver last names
  % #3 : Receiver name suffix
  % #4 : Receiver postcode
  % #5 : Receiver address 1
  % #6 : Receiver address 2
  \clearpage
  \refstepcounter{section}
  \addcontentsline{toc}{section}{#1#2}
  \noindent %
  \begin{picture}(100,148)(0,0)%
    \put(43,136){ %
      \vtop to 8truemm{\vfil\hbox{\fontsize{15pt}{0pt}\selectfont%
        \hbox to 7truemm{\hfil\StrChar{#4}{1}\hfil}%
        \hbox to 7truemm{\hfil\StrChar{#4}{2}\hfil}%
        \hbox to 7truemm{\hfil\StrChar{#4}{3}\hfil}\hskip0.4truemm
        \hbox to 6.8truemm{\hfil\StrChar{#4}{4}\hfil}%
        \hbox to 6.8truemm{\hfil\StrChar{#4}{5}\hfil}%
        \hbox to 6.8truemm{\hfil\StrChar{#4}{6}\hfil}%
        \hbox to 6.8truemm{\hfil\StrChar{#4}{7}\hfil}%
    }\vfil}}
    \put(83,120){\fontsize{15pt}{0pt}\selectfont%
        \parbox<t>[t]{90truemm}{#5}}
    \put(75,120){\fontsize{15pt}{0pt}\selectfont%
        \parbox<t>[t]{90truemm}{\hfil#6}}
    % 受取人氏名
    \IfSubStr{#2}{,}{
      \put(45,120){
        \kanjiskip=.3zw\fontsize{27pt}{0pt}\selectfont%
        \parbox<t>[t]{90truemm}{%
          \settowidth{\receiverfamilywidth}{#1}%
          % 1行目：姓＋最初の名前
          \hfil\makebox[\receiverfamilywidth][l]{#1}\hskip1.1zw\StrBefore{#2}{,}\hskip1zw#3
          % 2行目以降：姓の位置に揃えて字下げ
          % 最初のカンマより後ろを \receiver@rest に取り出す
          \StrBehind{#2}{,}[\receiver@rest]
          \renewcommand*{\do}[1]{\\\hfil\makebox[\receiverfamilywidth][l]{\hphantom{#1}}\hskip0.5zw{##1}\hskip1zw#3}
          \expandafter\docsvlist\expandafter{\receiver@rest}
        }\hfil
      }
    }{
      \put(50,120){\kanjiskip=.3zw\fontsize{27pt}{0pt}\selectfont%
      \parbox<t>[t]{90truemm}{\hfil#1　#2\hskip1zw#3}\hfil}
    }
    % 送り主住所
    \put(30,85){\fontsize{12pt}{0pt}\selectfont%
        \parbox<t>[t]{55truemm}{\@senderaddressa}}
    \put(24,85){\fontsize{12pt}{0pt}\selectfont%
        \parbox<t>[t]{55truemm}{\@senderaddressb}}
    %\put(10,85){\kanjiskip=.3zw
    %  \fontsize{15pt}{0pt}\selectfont%
    %    \parbox<t>[t]{55truemm}{\hfil\@senderfamilyname\hskip1zw\@senderlastnames}\hfil}
    \put(12,85){\kanjiskip=.3zw
      \fontsize{14pt}{0pt}\selectfont%
        \settowidth{\familywidth}{\@senderfamilyname}%
        \parbox<t>[t]{55truemm}{%
          \hfil
          \IfSubStr{\@senderlastnames}{,}{
            % 1行目：姓＋最初の名前
            \@senderfamilyname\hskip1zw\StrBefore{\@senderlastnames}{,}%
            % 2行目以降：姓の位置に揃えて字下げ
            % 最初のカンマより後ろを \sender@rest に取り出す
            \StrBehind{\@senderlastnames}{,}[\sender@rest]
            \renewcommand*{\do}[1]{\\\hfil\makebox[\familywidth][l]{\hphantom{\@senderfamilyname}}\hskip1zw{##1}}
            \expandafter\docsvlist\expandafter{\sender@rest}
          }{
            % 名前が1つだけの場合
            \@senderfamilyname\hskip1zw\@senderlastnames
          }
        }\hfil}
    \put(4.5,25){ %
      \vtop to 6.5truemm{\vfil\hbox{\fontsize{12pt}{0pt}\selectfont%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{1}\hfil}%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{2}\hfil}%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{3}\hfil}\hskip1truemm %
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{4}\hfil}%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{5}\hfil}%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{6}\hfil}%
        \hbox to 4truemm{\hfil\StrChar{\@senderpostcode}{7}\hfil}%
    }\vfil}}
  \end{picture} %
}
