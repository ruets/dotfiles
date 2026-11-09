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
\RequirePackage{listings}
\RequirePackage{lstautogobble}
\RequirePackage{adjustbox}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\usetikzlibrary{calc, babel, positioning, arrows.meta, fit, backgrounds}

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
    pdftitle    = {\@cesititle},
    hypertexnames = false   % évite les « duplicate destination »
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
    \ifdefempty{\@cesisubtitle}{}{%
      {\fontsize{16}{20}\sffamily\bfseries\color{cesiblack}\@cesisubtitle\par}
      \vspace{0.2cm}%
    }

    % Description courte
    \ifdefempty{\@cesidescription}{}{%
      {\fontsize{11}{14}\sffamily\color{cesigray}\@cesidescription\par}%
    }

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
% Outils de rédaction communs aux prosits
% =============================================================

% --- Colonnes de tableaux alignées à gauche (évite les Underfull \hbox)
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{B}[1]{>{\bfseries\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}

% --- Tableau CESI : \begin{cesitable}{spec colonnes}{légende}
%     (toprule/bottomrule automatiques, mettre \midrule après l'en-tête)
\newenvironment{cesitable}[2]{%
  \table[H]\centering\small\renewcommand{\arraystretch}{1.3}%
  \def\cesi@tablecaption{#2}%
  \tabularx{\linewidth}{#1}\toprule}
 {\bottomrule\endtabularx\caption{\cesi@tablecaption}\endtable}

% --- Schéma : \begin{cesischema}{légende} <tikzpicture> \end{cesischema}
%     réduit à la largeur de la page seulement si nécessaire
\newenvironment{cesischema}[1]{%
  \begin{figure}[H]\centering\def\cesi@schemacaption{#1}%
  \begin{adjustbox}{max width=\linewidth}}
 {\end{adjustbox}\caption{\cesi@schemacaption}\end{figure}}

% --- Encadré titré : \begin{encadre}[Constat] ... \end{encadre}
\newenvironment{encadre}[1][À retenir]
  {\begin{infobox}\textbf{#1 :} \ignorespaces}
  {\end{infobox}}

% --- Styles TikZ des schémas
\tikzset{
  bloc/.style   = {draw=cesiblack, fill=white, rounded corners=2pt, align=center,
                  font=\sffamily\footnotesize, minimum height=0.9cm, text width=2.9cm,
                  execute at begin node={\hyphenpenalty=10000\relax}},
  etape/.style  = {bloc, fill=cesilightgray},  % traitement
  cible/.style  = {bloc, fill=cesiyellow},     % résultat, cible
  zone/.style   = {draw=cesimidgray, dashed, rounded corners=4pt, inner sep=6pt},
  titre/.style  = {font=\sffamily\bfseries\scriptsize, text=cesigray},
  fleche/.style = {-{Stealth[length=2.5mm]}, thick, cesiblack},
}
% Ligne de détail dans un bloc : \node[bloc] {HDFS\detail{zone brute}};
\newcommand{\detail}[1]{\\\scriptsize #1}

% --- Code
\lstset{
  basicstyle   = \ttfamily\small,
  keywordstyle = \bfseries,
  frame        = single,
  rulecolor    = \color{cesimidgray},
  breaklines   = true,
  columns      = fullflexible,
  xleftmargin  = 4pt,
  xrightmargin = 4pt,
  autogobble   = true,   % le code peut être indenté dans le .tex
}
\lstdefinelanguage{HiveQL}[]{SQL}{
  morekeywords = {PARTITIONED, CLUSTERED, SORTED, BUCKETS, STORED, ORC,
    PARQUET, TEXTFILE, OVERWRITE, MATERIALIZED, REBUILD, EXTERNAL, LOCATION,
    TBLPROPERTIES, ANALYZE, COMPUTE, STATISTICS, EXPLAIN, DEPENDENCY, OVER},
}

% --- Graphiques pgfplots : \begin{axis}[cesigraph, ybar, ...]
\pgfplotsset{
  cesigraph/.style={
    width=\linewidth, height=7cm,
    axis lines*=left, ymajorgrids, grid style={cesilightgray},
    tick label style={font=\sffamily\footnotesize},
    label style={font=\sffamily\footnotesize},
    legend style={font=\sffamily\footnotesize, draw=none, fill=none,
                  at={(0.5,1.02)}, anchor=south, legend columns=-1},
    /pgf/number format/assume math mode=true,
    bar cycle list/.style={/pgfplots/cycle list={
      {fill=cesimidgray, draw=cesimidgray},
      {fill=cesiyellow,  draw=cesiyellow},
      {fill=cesiblack,   draw=cesiblack},
      {fill=cesigray,    draw=cesigray}}},
  },
}
\tikzset{seuil/.style={dashed, thick, cesiblack}}

% --- Verdicts des hypothèses : \hypothesis{...}{\validee}
\newcommand{\cesibadge}[3]{%
  {\fboxsep=2pt\colorbox{#1}{\color{#2}\sffamily\bfseries\footnotesize\strut #3}}}
\newcommand{\validee}   {\cesibadge{cesiyellow}{cesiblack}{Validée}}
\newcommand{\partielle} {\cesibadge{cesimidgray}{cesiblack}{Partiellement validée}}
\newcommand{\nonvalidee}{\cesibadge{cesiblack}{white}{Non validée}}

% --- N'affiche une sous-partie que si le champ est rempli
\newcommand{\cesi@sisrempli}[2]{%
  \expandafter\ifdefempty\csname @cer#1\endcsname{}%
    {#2{\csname @cer#1\endcsname}}%
}

% =============================================================
% Sections générées automatiquement
% =============================================================
\newcommand{\intro}{%
  \newpage
  \section{Introduction}
  \cesi@sisrempli{philo}{\philo}
  \cesi@sisrempli{keydefs}{\keydefs}
  \cesi@sisrempli{contexte}{\contexte}
  \cesi@sisrempli{problematiques}{\problematiques}
  \cesi@sisrempli{contraintes}{\contraintes}
  \cesi@sisrempli{generalisation}{\generalisation}
  \cesi@sisrempli{livrables}{\livrables}
  \cesi@sisrempli{hypotheses}{\hypotheses}
  \cesi@sisrempli{plan}{\plan}
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
  \cesi@sisrempli{hypotheses}{\validation}
  \cesi@sisrempli{synthese}{\synthese}
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
