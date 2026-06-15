% =============================================================
% cesi.cls — Classe pour Rapports CESI
% =============================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cesi}[Package rapports CESI]

% -------------------------------------------------------------
% Classe de base et dépendances
% -------------------------------------------------------------
\LoadClass[12pt]{article}
\RequirePackage{fontspec}
\RequirePackage{geometry}
\RequirePackage[french]{babel}
\RequirePackage[table]{xcolor}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{microtype}
\RequirePackage{parskip}
\RequirePackage{hyperref}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{mdframed}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{xkeyval}
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{float}
\RequirePackage{tabularx}
\usetikzlibrary{calc}

% =============================================================
% Configuration — cesisetup
% =============================================================
\newcommand{\newcesikey}[3]{%
  \expandafter\newcommand\csname @#1#2\endcsname{#3}%
  \define@key{cesirapport}{#2}{\expandafter\renewcommand\csname @#1#2\endcsname{##1}}%
}

% Métadonnées globales
\newcesikey{cesi}{author}         {Nom Prénom}
\newcesikey{cesi}{promo}          {FISA INFO — 2025–2028}
\newcesikey{cesi}{title}          {Titre du rapport}
\newcesikey{cesi}{subtitle}       {}
\newcesikey{cesi}{description}    {}
\newcesikey{cesi}{typedoc}        {CER}

% Contenu CER
\newcesikey{cer}{philo}           {}
\newcesikey{cer}{keydefs}         {}
\newcesikey{cer}{contexte}        {}
\newcesikey{cer}{problematiques}  {}
\newcesikey{cer}{contraintes}     {}
\newcesikey{cer}{generalisation}  {}
\newcesikey{cer}{livrables}       {}
\newcesikey{cer}{hypotheses}      {}
\newcesikey{cer}{plan}            {}
\newcesikey{cer}{synthese}        {}

\newcommand{\cesisetup}[1]{\setkeys{cesirapport}{#1}}

% -------------------------------------------------------------
% Géométrie
% -------------------------------------------------------------
\geometry{
  a4paper,
  top=2.5cm, bottom=3cm,
  left=2.8cm, right=2.8cm,
  headheight=20pt
}

% -------------------------------------------------------------
% Polices — Inter (proche de la typo CESI)
% -------------------------------------------------------------
\setmainfont{Inter}[
  BoldFont       = Inter Bold,
  ItalicFont     = Inter Italic,
  BoldItalicFont = Inter Bold Italic
]
\setsansfont{Inter}[
  BoldFont       = Inter ExtraBold,
  ItalicFont     = Inter Italic
]

% -------------------------------------------------------------
% Palette de couleurs CESI
% -------------------------------------------------------------
\definecolor{cesiyellow}{HTML}{FAE216}   % jaune signature
\definecolor{cesiblack}{HTML}{000000}    % quasi-noir
\definecolor{cesigray}{HTML}{555555}     % gris texte secondaire
\definecolor{cesilightgray}{HTML}{F5F5F5}% fond boîtes
\definecolor{cesimidgray}{HTML}{AAAAAA}  % en-têtes discrets

% -------------------------------------------------------------
% Hyperliens
% -------------------------------------------------------------
\AtBeginDocument{%
  \hypersetup{
    colorlinks  = true,
    linkcolor   = cesiblack,
    urlcolor    = cesigray,
    pdfauthor   = {\@cesiauthor},
    pdftitle    = {\@cesititle}
  }%
}

% -------------------------------------------------------------
% Titres de sections — style CESI : majuscules, soulignement jaune
% -------------------------------------------------------------

% Commande d'underline jaune épais
\newcommand{\cesirule}{%
  \vspace{2pt}%
  {\color{cesiyellow}\rule{\linewidth}{2.5pt}}%
  \vspace{2pt}%
}

\titleformat{\section}
  {\color{cesiblack}\large\bfseries\sffamily}
  {\thesection.}{0pt}{\quad}
  [\cesirule]

\titleformat{\subsection}
  {\color{cesiblack}\normalsize\bfseries\sffamily}
  {\thesubsection.}{0pt}{\quad}

\titleformat{\subsubsection}
  {\color{cesigray}\normalsize\itshape}
  {\thesubsubsection.}{0pt}{\quad}

\titlespacing{\section}   {0pt}{20pt}{6pt}
\titlespacing{\subsection}{0pt}{12pt}{4pt}
\titlespacing{\subsubsection}{0pt}{8pt}{2pt}

% -------------------------------------------------------------
% En-tête / pied de page
% -------------------------------------------------------------
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Bande jaune en pied, numéro de page
\fancyfoot[L]{%
  \begin{tikzpicture}[overlay, remember picture]
    \fill[cesiyellow]
      ($(current page.south west)+(0,0)$)
      rectangle
      ($(current page.south east)+(0,1cm)$);
  \end{tikzpicture}%
}
\fancyfoot[C]{%
  \vspace{-4pt}%
  \small\bfseries\sffamily\color{cesiblack}\thepage
}
\fancyhead[L]{%
  \small\sffamily\color{cesimidgray}\@cesititle
}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \fancyfoot[L]{%
    \begin{tikzpicture}[overlay, remember picture]
      \fill[cesiyellow]
        ($(current page.south west)+(0,0)$)
        rectangle
        ($(current page.south east)+(0,1cm)$);
    \end{tikzpicture}%
  }%
  \fancyfoot[C]{\small\bfseries\sffamily\color{cesiblack}\thepage}%
}

% -------------------------------------------------------------
% Listes — puce carrée jaune style CESI
% -------------------------------------------------------------
\setlist[itemize]{
  leftmargin = 1.4em,
  itemsep    = 3pt,
  parsep     = 0pt,
  topsep     = 4pt,
  label      = {\color{cesiyellow}\rule[0.3ex]{0.6em}{0.6em}}
}
\setlist[enumerate]{
  leftmargin = 1.6em,
  itemsep    = 3pt,
  parsep     = 0pt,
  topsep     = 4pt
}

% -------------------------------------------------------------
% Boîtes
% infobox  : bordure jaune gauche  (note, point important)
% definbox : fond jaune            (définition, résultat clé)
% -------------------------------------------------------------
\newmdenv[
  linecolor        = cesiyellow,
  linewidth        = 4pt,
  topline          = false,
  rightline        = false,
  bottomline       = false,
  backgroundcolor  = cesilightgray,
  innerleftmargin  = 14pt,
  innerrightmargin = 10pt,
  innertopmargin   = 8pt,
  innerbottommargin= 8pt,
  skipabove        = 10pt,
  skipbelow        = 10pt
]{infobox}

\newmdenv[
  linewidth        = 0pt,
  backgroundcolor  = cesiyellow,
  innerleftmargin  = 14pt,
  innerrightmargin = 14pt,
  innertopmargin   = 10pt,
  innerbottommargin= 10pt,
  skipabove        = 10pt,
  skipbelow        = 10pt
]{yellowbox}

% -------------------------------------------------------------
% Page de titre CESI
% -------------------------------------------------------------
\newcommand{\cesititlepage}{%
  \begin{titlepage}
    \thispagestyle{empty}

    % Bande noire en haut à gauche
    \begin{tikzpicture}[remember picture, overlay]
      \node[
        anchor      = north west,
        fill        = cesiblack,
        text        = white,
        font        = \sffamily\bfseries\small,
        inner xsep  = 40pt,
        inner ysep  = 10pt,
      ] at ($(current page.north west)+(0,-1cm)$)
        {\@cesipromo};
    \end{tikzpicture}

    % Bande jaune sur le côté
    \begin{tikzpicture}[remember picture, overlay]
      \fill[cesiyellow]
        ($(current page.north east)+(0,0)$)
        rectangle
        ($(current page.south east)+(-2.5cm,0)$);
    \end{tikzpicture}

    \vspace{3.8cm}

    % Type de document (ex: RAPPORT, NOTE, MÉMOIRE)
    {\fontsize{10}{12}\sffamily\color{cesigray}\MakeUppercase{\@cesitypedoc\quad — \quad\@cesiauthor}}
    \vspace{0.4cm}

    % Titre principal en grand noir gras
    {\fontsize{30}{35}\sffamily\bfseries\color{cesiblack}\@cesititle\par}
    \vspace{0.5cm}

    % Liseré jaune séparateur
    {\color{cesiyellow}\rule{10cm}{3pt}\par}

    \vspace{0.6cm}

    % Sous-titre
    \ifx\@cesisubtitle\empty\else
      {\fontsize{16}{20}\sffamily\bfseries\color{cesiblack}\@cesisubtitle\par}
      \vspace{0.2cm}
    \fi

    % Description courte
    \ifx\@cesidescription\empty\else
      {\fontsize{11}{14}\sffamily\color{cesigray}\@cesidescription\par}
    \fi

    \vfill

    % Bande noire en bas à gauche
    \begin{tikzpicture}[remember picture, overlay]
      \node[
        anchor      = south east,
        fill        = cesiblack,
        text        = white,
        font        = \sffamily\bfseries\large,
        inner xsep  = 40pt,
        inner ysep  = 10pt,
      ] at ($(current page.south east)+(0,1cm)$)
        {CESI{\color{cesiyellow}\_}};
    \end{tikzpicture}

  \end{titlepage}%
  \setcounter{page}{1}%
}

% =============================================================
% Sections générées automatiquement
% =============================================================
\newcommand{\intro}{%
  \newpage
  \section{Introduction}
  \philo{\@cerphilo}
  \keydefs{\@cerkeydefs}
  \contexte{\@cercontexte}
  \problematiques{\@cerproblematiques}
  \contraintes{\@cercontraintes}
  \generalisation{\@cergeneralisation}
  \livrables{\@cerlivrables}
  \hypotheses{\@cerhypotheses}
  \plan{\@cerplan}
}

\newcommand{\ressources}{%
  \newpage
  \section{Analyse des ressources}
}

\newcommand{\realisation}{%
  \newpage
  \section{Réalisation}
}

\newcommand{\conclusion}{%
  \newpage
  \section{Conclusion}
  \validation{\@cerhypotheses}
  \synthese{\@cersynthese}
}

% =============================================================
% Sous-sections de l'Introduction
% =============================================================
\newcommand{\philo}[1]{%
  \subsection{Philosophie du prosit}
  #1\par
}
\newcommand{\keydefs}[1]{%
  \subsection{Définition des mots clés}
  \begin{itemize}
    #1
  \end{itemize}
}
\newcommand{\keydef}[2]{%
  \item \textbf{#1} : #2
}
\newcommand{\contexte}[1]{%
  \subsection{Contexte}
  #1\par
}
\newcommand{\problematiques}[1]{%
  \subsection{Problématiques}
  \begin{itemize}
    #1
  \end{itemize}
}
\newcommand{\contraintes}[1]{%
  \subsection{Contraintes}
  \begin{itemize}
    #1
  \end{itemize}
}
\newcommand{\generalisation}[1]{%
  \subsection{Généralisation du problème}
  \begin{itemize}
    #1
  \end{itemize}
}
\newcommand{\livrables}[1]{%
  \subsection{Livrables}
  \begin{itemize}
    #1
  \end{itemize}
}
\newcommand{\hypotheses}[1]{%
  \subsection{Hypothèses et pistes de solution}
  \begin{itemize}
    \def\hypothesis##1##2{\item ##1}%
    #1
  \end{itemize}
}
\newcommand{\plan}[1]{%
  \subsection{Plan d'action}
  \begin{enumerate}
    #1
  \end{enumerate}
}

% =============================================================
% Sous-sections de la Conclusion
% =============================================================
\newcommand{\validation}[1]{%
  \subsection{Validation des hypothèses}
  \begin{itemize}
    \def\hypothesis##1##2{\item ##1 : \textbf{##2}}%
    #1
  \end{itemize}
}
\newcommand{\synthese}[1]{%
  \subsection{Synthèse}
  #1\par
}
