# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_auto_mu.rb


require 'helper'


class TestMatchAutoMu < MiniTest::Test

  def test_mauritius
    txt = <<TXT
Preliminary Round
Mon Jun 22
  Pointe-aux-Sables Mates      3-4  AS Port-Louis 2000              @ St. François Xavier Stadium, Port Louis

Quarterfinals
Wed Jun 24
  Rivière du Rempart           3-1 pen (1-1) La Cure Sylvester      @ Auguste Vollaire Stadium, Central Flacq
  Chamarel SC                  3-4           Petite Rivière Noire   @ Germain Comarmond Stadium, Bambous
Thu Jun 25
  Pamplemousses                2-0  AS Port-Louis 2000              @ Auguste Vollaire Stadium, Central Flacq
Sat Jun 27
  Savanne SC                   3-6  Entente Boulet Rouge            @ Anjalay Stadium, Mapou

Semifinals
Wed Jul 15
  Rivière du Rempart           2-3  Petite Rivière Noire            @  New George V Stadium, Curepipe
  Entente Boulet Rouge         0-2  Pamplemousses                   @  Germain Comarmond Stadium, Bambous

Final
Sun Jul 19
  Petite Rivière Noire         2-0  Pamplemousses                   @ New George V Stadium, Curepipe
TXT

    clubs, rounds = parse_auto_conf( txt )

    assert_equal Hash(
     'Pointe-aux-Sables Mates' => 1,
     'AS Port-Louis 2000'      => 2,
     'Rivière du Rempart'      => 2,
     'La Cure Sylvester'       => 1,
     'Chamarel SC'             => 1,
     'Petite Rivière Noire'    => 3,
     'Pamplemousses'           => 3,
     'Savanne SC'              => 1,
     'Entente Boulet Rouge'    => 2), clubs

    assert_equal Hash(
 'Preliminary Round' => {count: 1, match_count: 1},
 'Quarterfinals'     => {count: 1, match_count: 4},
 'Semifinals'        => {count: 1, match_count: 2},
 'Final'             => {count: 1, match_count: 1} ), rounds
  end

end  # class TestMatchAutoMu
