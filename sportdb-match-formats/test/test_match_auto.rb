# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto.rb


require 'helper'


class TestMatchAuto < MiniTest::Test

  def test_br
    txt= <<TXT
1ª Rodada
29/03/2003 - Sábado
16h00  Guarani       4x2 Vasco          @ Brinco de Ouro
       Atlético-PR   2x0 Grêmio         @ Arena da Baixada

30/03/2003 - Domingo
09h00  Flamengo      1x1 Coritiba       @ Maracanã
16h00  Goiás         2x2 Paysandu       @ Serra Dourada
       Internacional 1x1 Ponte Preta    @ Beira Rio
       Criciúma      2x0 Fluminense     @ Heriberto Hulse
       Juventude     2x2 São Paulo      @ Alfredo Jaconi
       Fortaleza     0x0 Bahia          @ Castelão
       Cruzeiro      2x2 São Caetano    @ Mineirão
       Vitória       1x1 Figueirense    @ Barradão
18h00  Santos        2x2 Paraná         @ Vila Belmiro
       Corinthians   0x3 Atlético-MG    @ Pacaembu

2ª Rodada
05/04/2003 - Sábado
16h00  Fluminense    1x1 Fortaleza      @ Maracanã
       Atlético-MG   0x0 Santos         @ Mineirão
       Coritiba      0x1 Internacional  @ Couto Pereira
18h00  Grêmio        3x1 Guarani        @ Olímpico

06/04/2003 - Domingo
16h00  Bahia         1x2 Flamengo       @ Fonte Nova
       Figueirense   3x3 Corinthians    @ Orlando Scarpelli
       Paysandu      1x2 Vitória        @ Mangueirão
       Ponte Preta   1x0 Juventude      @ Moisés Lucarelli
       Paraná        3x0 Atlético-PR    @ Pinheirão
       São Caetano   3x2 Criciúma       @ Anacleto Campanella
18h00  São Paulo     2x4 Cruzeiro       @ Morumbi
       Vasco         6x4 Goiás          @ São Januário
TXT
   clubs, rounds = parse_auto_conf( txt, lang: 'pt' )

   assert_equal Hash(
     'Guarani'=>2,
     'Vasco'=>2,
     'Atlético-PR'=>2,
     'Grêmio'=>2,
     'Flamengo'=>2,
     'Coritiba'=>2,
     'Goiás'=>2,
     'Paysandu'=>2,
     'Internacional'=>2,
     'Ponte Preta'=>2,
     'Criciúma'=>2,
     'Fluminense'=>2,
     'Juventude'=>2,
     'São Paulo'=>2,
     'Fortaleza'=>2,
     'Bahia'=>2,
     'Cruzeiro'=>2,
     'São Caetano'=>2,
     'Vitória'=>2,
     'Figueirense'=>2,
     'Santos'=>2,
     'Paraná'=>2,
     'Corinthians'=>2,
     'Atlético-MG'=>2 ), clubs

     assert_equal Hash(
       '1ª Rodada' => {count: 1, match_count: 12},
       '2ª Rodada' => {count: 1, match_count: 12} ), rounds
  end


  def test_at
    txt = <<TXT
29. Runde

Sa 7.4.
  16.00   RB Salzburg       2:0   Wacker Innsbruck
  18.30   SV Ried           0:1   Austria Wien
          Kapfenberger SV   2:3   Admira Wacker
          Rapid Wien        2:1   Wr. Neustadt
So 8.4.
  16.00   SV Mattersburg    0:2   Sturm Graz


30. Runde

Sa 14.4.
  16.00   Wr. Neustadt         0:0   Kapfenberger SV
  18.30   Admira Wacker        1:1   Wacker Innsbruck
          Sturm Graz           2:2   RB Salzburg
          SV Ried              2:0   SV Mattersburg
So 15.4.
  16.00   Austria Wien         0:0   Rapid Wien
TXT

  clubs, rounds = parse_auto_conf( txt, lang: 'de' )

    assert_equal Hash(
     'RB Salzburg' => 2,
     'Wacker Innsbruck' => 2,
     'SV Ried' => 2,
     'Austria Wien' => 2,
     'Kapfenberger SV' => 2,
     'Admira Wacker' => 2,
     'Rapid Wien' => 2,
     'Wr. Neustadt' => 2,
     'SV Mattersburg' => 2,
     'Sturm Graz' => 2 ), clubs

    assert_equal Hash(
     '29. Runde' => { count: 1, match_count: 5 },
     '30. Runde' => { count: 1, match_count: 5 } ), rounds
  end

  def test_es
    txt = <<TXT
Jornada 1

18.08.2012   Barcelona  R. Sociedad  5-1
18.08.2012   Levante  Atlético  1-1
18.08.2012   Athletic  Betis  3-5
18.08.2012   Zaragoza  Valladolid  0-1
18.08.2012   R. Madrid  Valencia  1-1
18.08.2012   Celta  Málaga  0-1
18.08.2012   Sevilla  Getafe  2-1
18.08.2012   Mallorca  Espanyol  2-1
18.08.2012   Rayo  Granada  1-0
18.08.2012   Deportivo  Osasuna  2-0


Jornada 2

25.08.2012   Valladolid  Levante  2-0
25.08.2012   Espanyol  Zaragoza  1-2
25.08.2012   Málaga  Mallorca  1-1
25.08.2012   R. Sociedad  Celta  2-1
25.08.2012   Osasuna  Barcelona  1-2
25.08.2012   Valencia  Deportivo  3-3
25.08.2012   Getafe  R. Madrid  2-1
25.08.2012   Granada  Sevilla  1-1
25.08.2012   Betis  Rayo  1-2
25.08.2012   Atlético  Athletic  4-0
TXT

    clubs, rounds = parse_auto_conf( txt, lang: 'es' )

    assert_equal Hash(
 'Barcelona' => 2,
 'R. Sociedad' => 2,
 'Levante' => 2,
 'Atlético' => 2,
 'Athletic' => 2,
 'Betis' => 2,
 'Zaragoza' => 2,
 'Valladolid' => 2,
 'R. Madrid' => 2,
 'Valencia' => 2,
 'Celta' => 2,
 'Málaga' => 2,
 'Sevilla' => 2,
 'Getafe' => 2,
 'Mallorca' => 2,
 'Espanyol' => 2,
 'Rayo' => 2,
 'Granada' => 2,
 'Deportivo' => 2,
 'Osasuna' => 2), clubs

  assert_equal Hash(
   'Jornada 1' => {count: 1, match_count: 10},
   'Jornada 2' => {count: 1, match_count: 10} ), rounds
  end


  def test_fr
    txt = <<TXT
Journée 1

Ven 8. Août
  20h30  Stade de Reims  2-2  Paris SG
Sam 9. Août
  21h00  SC Bastia      3-3  Olympique de Marseille
         Évian TG       0-3  SM Caen
         EA Guingamp    0-2  AS Saint-Étienne
         LOSC Lille     0-0  FC Metz
         Montpellier Hérault SC  0-1  Girondins de Bordeaux
         FC Nantes      1-0  RC Lens
         OGC Nice       3-2  Toulouse FC
Dim 10. Août
  17h00  Olympique Lyonnais  2-0  Stade Rennais FC
  21h00  AS Monaco FC  1-2  FC Lorient

Journée 2

Ven 15. Août
  20h30  SM Caen 0-1 LOSC Lille
Sam 16. Août
  17h00  Paris SG 2-0 SC Bastia
  20h00  RC Lens 0-1 EA Guingamp
         FC Lorient 0-0 OGC Nice
         FC Metz 1-1 FC Nantes
         Stade Rennais FC 6-2 Évian TG
         Toulouse FC 2-1 Olympique Lyonnais
Dim 17. Août
  17h00  Olympique de Marseille 0-2 Montpellier Hérault SC
         AS Saint-Étienne 3-1 Stade de Reims
  21h00  Girondins de Bordeaux 4-1 AS Monaco FC
TXT

    clubs, rounds = parse_auto_conf( txt, lang: 'fr' )

    assert_equal Hash(
 'Stade de Reims' => 2,
 'Paris SG' => 2,
 'SC Bastia' => 2,
 'Olympique de Marseille' => 2,
 'Évian TG' => 2,
 'SM Caen' => 2,
 'EA Guingamp' => 2,
 'AS Saint-Étienne' => 2,
 'LOSC Lille' => 2,
 'FC Metz' => 2,
 'Montpellier Hérault SC' => 2,
 'Girondins de Bordeaux' => 2,
 'FC Nantes' => 2,
 'RC Lens' => 2,
 'OGC Nice' => 2,
 'Toulouse FC' => 2,
 'Olympique Lyonnais' => 2,
 'Stade Rennais FC' => 2,
 'AS Monaco FC' => 2,
 'FC Lorient' => 2), clubs

    assert_equal Hash(
 'Journée 1' => { count: 1, match_count: 10 },
 'Journée 2' => { count: 1, match_count: 10 } ), rounds
  end


  def test_eng
    txt = <<TXT
Matchday 1

Fri, Aug 11
  Arsenal FC               4-3  Leicester City
Sat, Aug 12
  Watford FC               3-3  Liverpool FC
  Chelsea FC               2-3  Burnley FC
  Crystal Palace           0-3  Huddersfield Town
  Everton FC               1-0  Stoke City
  Southampton FC           0-0  Swansea City
  West Bromwich Albion     1-0  AFC Bournemouth
  Brighton & Hove Albion   0-2  Manchester City
Sun, Aug 13
  Newcastle United         0-2  Tottenham Hotspur
  Manchester United        4-0  West Ham United


Matchday 2

Sat, Aug 19
  Swansea City             0-4  Manchester United
  AFC Bournemouth          0-2  Watford FC
  Burnley FC               0-1  West Bromwich Albion
  Leicester City           2-0  Brighton & Hove Albion
  Liverpool FC             1-0  Crystal Palace
  Southampton FC           3-2  West Ham United
  Stoke City               1-0  Arsenal FC
Sun, Aug 20
  Huddersfield Town        1-0  Newcastle United
  Tottenham Hotspur        1-2  Chelsea FC
Mon, Aug 21
  Manchester City          1-1  Everton FC
TXT

    clubs, rounds = parse_auto_conf( txt )

    assert_equal Hash(
 'Arsenal FC'     => 2,
 'Leicester City' => 2,
 'Watford FC'     => 2,
 'Liverpool FC'   => 2,
 'Chelsea FC'     => 2,
 'Burnley FC'     => 2,
 'Crystal Palace' => 2,
 'Huddersfield Town' => 2,
 'Everton FC'     => 2,
 'Stoke City'     => 2,
 'Southampton FC' => 2,
 'Swansea City'   => 2,
 'West Bromwich Albion' => 2,
 'AFC Bournemouth' => 2,
 'Brighton & Hove Albion' => 2,
 'Manchester City'   => 2,
 'Newcastle United'  => 2,
 'Tottenham Hotspur' => 2,
 'Manchester United' => 2,
 'West Ham United'   => 2 ), clubs

    assert_equal Hash(
 'Matchday 1' => { count: 1, match_count: 10},
 'Matchday 2' => { count: 1, match_count: 10} ), rounds


    txt =<<TXT
Round 38

May/22 Aston Villa 1-0 Liverpool
May/22 Bolton 0-2 Manchester City
May/22 Everton 1-0 Chelsea
May/22 Fulham 2-2 Arsenal
May/22 Manchester United 4-2 Blackpool
May/22 Newcastle Utd 3-3 West Brom
May/22 Stoke City 0-1 Wigan
May/22 Tottenham 2-1 Birmingham
May/22 West Ham 0-3 Sunderland
May/22 Wolves 2-3 Blackburn

Round 37

May/17 Manchester City 3-0 Stoke City
May/15 Arsenal 1-2 Aston Villa
May/15 Birmingham 0-2 Fulham
May/15 Liverpool 0-2 Tottenham
May/15 Wigan 3-2 West Ham
May/15 Chelsea 2-2 Newcastle Utd
May/14 Blackburn 1-1 Manchester United
May/14 Blackpool 4-3 Bolton
May/14 Sunderland 1-3 Wolves
May/14 West Brom 1-0 Everton
TXT
    clubs, rounds = parse_auto_conf( txt )

    assert_equal Hash(
  'Aston Villa' => 2,
  'Liverpool' => 2,
  'Bolton' => 2,
  'Manchester City' => 2,
  'Everton' => 2,
  'Chelsea' => 2,
  'Fulham' => 2,
  'Arsenal' => 2,
  'Manchester United' => 2,
  'Blackpool' => 2,
  'Newcastle Utd' => 2,
  'West Brom' => 2,
  'Stoke City'=> 2,
  'Wigan' => 2,
  'Tottenham' => 2,
  'Birmingham' => 2,
  'West Ham' => 2,
  'Sunderland' => 2,
  'Wolves' => 2,
  'Blackburn' => 2), clubs

    assert_equal Hash(
     'Round 38' => { count: 1, match_count: 10 },
     'Round 37' => { count: 1, match_count: 10 } ), rounds
  end   # method test_parse

end  # class TestMatchAuto
